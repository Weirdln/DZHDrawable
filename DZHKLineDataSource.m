//
//  DZHKLineDataSource.m
//  DZHDrawable
//
//  Created by Duanwwu on 14-6-30.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHKLineDataSource.h"
#import "UIColor+RGB.h"
#import "DZHKLineDrawing.h"
#import "DZHAxisYDrawing.h"
#import "DZHAxisXDrawing.h"
#import "DZHRectangleDrawing.h"
#import "DZHKLineValueFormatter.h"
#import "DZHKLineDateFormatter.h"
#import "DZHKLineContainer.h"
#import "DZHAxisEntity.h"
#import "DZHCandleEntity.h"
#import "DZHBarEntity.h"

@interface DZHKLineDataSource ()

@property (nonatomic, retain) NSMutableArray *volumes;

@property (nonatomic, retain) NSMutableArray *klineX;

@property (nonatomic, retain) NSMutableArray *klineY;

@property (nonatomic, retain) NSMutableArray *klineItem;

@end

@implementation DZHKLineDataSource
{
    DZHKLineDateFormatter           *_dateFormatter;
    DZHKLineValueFormatter          *_valueFormatter;
    UIColor                         *_positiveColor;
    UIColor                         *_negativeColor;
    UIColor                         *_crossColor;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.grouping                   = [NSMutableArray array];
        self.kLineWidth                 = 2.;
        self.kLinePadding               = 2.;
        self.minTickCount               = 4;
        self.maxTickCount               = 4;
        self.maxScale                   = 5.;
        self.minScale                   = 1.;
        self.scale                      = 1.;
        _dateFormatter                  = [[DZHKLineDateFormatter alloc] init];
        _valueFormatter                 = [[DZHKLineValueFormatter alloc] init];
        
        _positiveColor                  = [[UIColor colorFromRGB:0xf92a27] retain];
        _negativeColor                  = [[UIColor colorFromRGB:0x2b9826] retain];
        _crossColor                     = [[UIColor grayColor] retain];
    }
    return self;
}

- (void)dealloc
{
    [_dateFormatter release];
    [_valueFormatter release];
    
    [_positiveColor release];
    [_negativeColor release];
    [_crossColor release];
    
    [_grouping release];
    [_klines release];
    [super dealloc];
}

- (void)setKlines:(NSArray *)klines
{
    if (_klines != klines)
    {
        [_klines release];
        _klines                             = [klines retain];
        
        [_grouping removeAllObjects];
        int idx                             = 0;
        
        DZHKLineEntity *lastEntity;
        for (DZHKLineEntity *entity in _klines)
        {
            if (idx != 0)
                [self decisionGroupIfNeedWithPreEntity:lastEntity curEntity:entity index:idx];
            
            lastEntity          = entity;
            idx ++;
        }
    }
}

- (CGFloat)_getKLineWidth
{
    return roundf(_kLineWidth * _scale);
}

- (CGFloat)_getKlinePadding
{
    return _kLinePadding;
}

#pragma mark - DZHDrawingDataSource

- (NSArray *)datasForDrawing:(id<DZHDrawing>)drawing
{
    switch (drawing.tag)
    {
        case DrawingTagsKLineX:
            return [self axisXDatasForDrawing:drawing];
        case DrawingTagsKLineY:
            return [self axisYDatasForDrawing:drawing];
        case DrawingTagsKLineItem:
            return [self kLineDatasForDrawing:drawing];
        case DrawingTagsVolumeX:
            return [self axisXDatasForDrawing:drawing];
        case DrawingTagsVolumeY:
            return [self axisYDatasForVolumeDrawing:drawing];
        case DrawingTagsVolumeItem:
            return [self volumeDatasForVolumeDrawing:drawing];
        default:
            return nil;
    }
}

@end

#pragma mark - abstract

@implementation DZHKLineDataSource (Base)

- (void)prepareWithKLineRect:(CGRect)rect
{
    [self calculateStartAndEndIndexAtRect:rect];
    [self calculateMaxAndMinDataFromIndex:_startIndex toIndex:_endIndex];
}

- (void)calculateStartAndEndIndexAtRect:(CGRect)rect
{
    CGFloat kWidth              = [self _getKLineWidth];    //k线实体宽度
    CGFloat kPadding            = [self _getKlinePadding];  //k线间距
    CGFloat space               = kWidth + kPadding;
    self.startIndex             = MAX((rect.origin.x - kPadding - _kLineOffset)/space , 0);
    self.endIndex               = MIN((CGRectGetMaxX(rect) - kPadding - _kLineOffset)/space , [_klines count] - 1);
}

- (void)calculateMaxAndMinDataFromIndex:(NSInteger)from toIndex:(NSInteger)to
{
    NSInteger max                     = NSIntegerMin;
    NSInteger min                     = NSIntegerMax;
    NSInteger vol                     = NSIntegerMin;
    
    for (NSInteger i = from; i <= to; i++)
    {
        DZHKLineEntity *entity  = [_klines objectAtIndex:i];
        
        if (entity.high > max)
            max        = entity.high;
        
        if (entity.low < min)
            min        = entity.low;
        
        if (entity.vol > vol)
            vol        = entity.vol;
    }
    
    self.maxPrice                       = max;
    self.minPrice                       = min;
    self.maxVol                         = vol;
}

- (CGFloat)totalKLineWidth
{
    CGFloat kLineWidth          = [self _getKLineWidth];
    CGFloat kLinePadding        = [self _getKlinePadding];
    return [self.klines count] * (kLineWidth + kLinePadding) + kLinePadding;
}

- (CGFloat)kLineLocationForIndex:(NSUInteger)index
{
    CGFloat kWidth              = [self _getKLineWidth];    //k线实体宽度
    CGFloat kPadding            = [self _getKlinePadding];  //k线间距
    CGFloat space               = kWidth + kPadding;
    return _kLineOffset + kPadding + index * space;
}

- (CGFloat)kLineCenterLocationForIndex:(NSUInteger)index
{
    CGFloat kWidth              = [self _getKLineWidth];    //k线实体宽度
    CGFloat kPadding            = [self _getKlinePadding];  //k线间距
    CGFloat space               = kWidth + kPadding;
    return _kLineOffset + kPadding + index * space + kWidth * .5;
}

- (NSUInteger)nearIndexForLocation:(CGFloat)position
{
    CGFloat kWidth              = [self _getKLineWidth];    //k线实体宽度
    CGFloat kPadding            = [self _getKlinePadding];  //k线间距
    CGFloat space               = kWidth + kPadding;
    CGFloat index               = (position - kPadding - _kLineOffset) / space;
    return MIN(index, [_klines count] - 1);
}

@end

@implementation DZHKLineDataSource (Color)

- (UIColor *)corlorForType:(KLineType)type
{
    switch (type) {
        case KLineTypePositive:
            return _positiveColor;
        case KLineTypeNegative:
            return _negativeColor;
        case KLineTypeCross:
            return _crossColor;
        default:
            return nil;
    }
}

@end

@implementation DZHKLineDataSource (AxisX)

- (NSArray *)axisXDatasForDrawing:(id<DZHDrawing>)drawing
{
    int interval        = MAX(1, roundf(1.4f / self.scale));
    return [self groupsFromIndex:_startIndex toIndex:_endIndex monthInterval:interval];
}

- (void)decisionGroupIfNeedWithPreEntity:(DZHKLineEntity *)preEntity curEntity:(DZHKLineEntity *)curEntity index:(int)index
{
    int preMonth        = [_dateFormatter yearMonthOfDate:preEntity.date];
    int curMonth        = [_dateFormatter yearMonthOfDate:curEntity.date];
    
    if (preMonth != curMonth)//如果当前数据跟上一个数据不在一个月，则进行分组
    {
        [self.grouping addObject:[NSString stringWithFormat:@"%d%d",curEntity.date,index]];
    }
}

- (NSArray *)groupsFromIndex:(NSInteger)from toIndex:(NSInteger)to monthInterval:(int)interval
{
    NSParameterAssert(interval >= 1);
    
    NSMutableArray *datas           = [NSMutableArray array];
    
    NSInteger count                 = [self.grouping count];
    int mode                        = count % interval;
    int startIndex                  = mode == 0 ? 0 : mode + 1;
    
    for (int i = startIndex; i <count; i += interval)
    {
        NSString *str               = [_grouping objectAtIndex:i];
        int index                   = [[str substringFromIndex:8] intValue];
        
        if (index >= from && index <= to)
        {
            CGFloat x               = [self kLineCenterLocationForIndex:index];
            int date                = [[str substringToIndex:8] intValue];
            
            DZHAxisEntity *entity   = [[DZHAxisEntity alloc] init];
            entity.location         = CGPointMake(x, 0.);
            entity.labelText        = [_dateFormatter stringForObjectValue:@(date)];
            [datas addObject:entity];
            [entity release];
        }
        
        if (index > to)
            break;
        
    }
    return datas;
}

@end

@implementation DZHKLineDataSource (AxisY)

- (NSArray *)axisYDatasForDrawing:(id<DZHDrawing>)drawing
{
    NSInteger tickCount,strip;
    
    [self adjustMaxIfNeed:&tickCount strip:&strip];
    
    NSMutableArray *datas           = [NSMutableArray array];
    
    for (int i = 0; i <= tickCount; i++)
    {
        NSInteger value             = _minPrice + strip * i;
        CGFloat y                   = [drawing coordYWithValue:value max:_maxPrice min:_minPrice];
        
        DZHAxisEntity *entity       = [[DZHAxisEntity alloc] init];
        entity.location             = CGPointMake(.0, y);
        entity.labelText            = [_valueFormatter stringForObjectValue:@(value)];
        [datas addObject:entity];
        [entity release];
    }
    return datas;
}

- (void)adjustMaxIfNeed:(NSInteger *)tickCount strip:(NSInteger *)strip
{
    NSInteger maxValue      = self.maxPrice;
    NSInteger min           = self.minPrice;
    
    NSInteger count         = [self tickCountWithMax:maxValue min:min strip:strip];
    
    while (count == NSIntegerMax)
    {
        maxValue ++;
        count               = [self tickCountWithMax:maxValue min:min strip:strip];
    }
    
    *tickCount              = count;
    self.maxPrice           = maxValue;
}

- (NSInteger)tickCountWithMax:(NSInteger)max min:(NSInteger)min strip:(NSInteger *)strip
{
    NSInteger v               = max - min;
    for (NSInteger i = _maxTickCount - 1; i >= _minTickCount - 1; i--)
    {
        if (v % i == 0)
        {
            *strip      = v / i;
            return i;
        }
    }
    return NSIntegerMax;
}

@end

@implementation DZHKLineDataSource (KLine)

- (NSArray *)kLineDatasForDrawing:(id<DZHDrawing>)drawing
{
    NSInteger max               = self.maxPrice;
    NSInteger min               = self.minPrice;
    NSUInteger startIndex       = self.startIndex;   //绘制起始点
    NSUInteger endIndex         = self.endIndex;     //绘制结束点
    CGFloat kWidth              = [self _getKLineWidth];
    NSArray *klines             = self.klines;
    NSMutableArray *datas       = [NSMutableArray array];
    
    CGFloat open,close,high,low,x,center;
    CGRect fillRect;
    DZHKLineEntity *entity;
    DZHCandleEntity *candle;
    
    for (NSUInteger i = startIndex; i <= endIndex; i++)
    {
        entity                  = [klines objectAtIndex:i];
        
        open                    = [drawing coordYWithValue:entity.open max:max min:min];
        close                   = [drawing coordYWithValue:entity.close max:max min:min];
        high                    = [drawing coordYWithValue:entity.high max:max min:min];
        low                     = [drawing coordYWithValue:entity.low max:max min:min];
        
        x                       = [self kLineLocationForIndex:i];
        fillRect                = CGRectMake(x, MIN(open, close), kWidth, MAX(ABS(open - close), 1.));
        center                  = CGRectGetMidX(fillRect);
        
        candle                  = [[DZHCandleEntity alloc] init];
        candle.fillRect         = fillRect;
        candle.high             = CGPointMake(center, high);
        candle.low              = CGPointMake(center, low);
        candle.color            = [self corlorForType:entity.type];
        [datas addObject:candle];
        [candle release];
    }
    return datas;
}

@end

@implementation DZHKLineDataSource (VolumeAxisY)

- (NSArray *)axisYDatasForVolumeDrawing:(id<DZHDrawing>)drawing
{
    NSMutableArray *datas           = [NSMutableArray array];
    
    CGRect frame                = drawing.virtualFrame;
    DZHAxisEntity *entity       = [[DZHAxisEntity alloc] init];
    entity.location             = CGPointMake(.0, CGRectGetMaxY(frame));
    entity.labelText            = @"万手";
    [datas addObject:entity];
    [entity release];
    
    entity                      = [[DZHAxisEntity alloc] init];
    entity.location             = CGPointMake(.0, CGRectGetMinY(frame));
    entity.labelText            = [NSString stringWithFormat:@"%.1f",(float)self.maxVol/10000];
    [datas addObject:entity];
    [entity release];
    
    return datas;
}

@end

@implementation DZHKLineDataSource (Volume)

- (NSArray *)volumeDatasForVolumeDrawing:(id<DZHDrawing>)drawing
{
    NSUInteger startIndex       = self.startIndex;   //绘制起始点
    NSUInteger endIndex         = self.endIndex;     //绘制结束点
    CGFloat kWidth              = [self _getKLineWidth];
    NSArray *klines             = self.klines;
    NSMutableArray *datas       = [NSMutableArray array];
    
    CGFloat vol,low,x;
    DZHKLineEntity *entity;
    DZHBarEntity *barEntity;
    
    CGRect frame                = drawing.virtualFrame;
    
    for (NSUInteger i = startIndex; i <= endIndex; i++)
    {
        entity                  = [klines objectAtIndex:i];
        vol                     = [drawing coordYWithValue:entity.vol max:_maxVol min:0];
        low                     = CGRectGetMaxY(frame);
        x                       = [self kLineLocationForIndex:i];
        
        barEntity               = [[DZHBarEntity alloc] init];
        barEntity.barRect       = CGRectMake(x, vol, kWidth, MAX(ABS(low - vol), 1.));
        barEntity.color         = [self corlorForType:entity.type];
        [datas addObject:barEntity];
        [barEntity release];
    }
    return datas;
}

@end
