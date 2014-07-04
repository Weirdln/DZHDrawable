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
#import "DZHFillBarEntity.h"
#import "DZHMACalculator.h"
#import "DZHMACurveDrawing.h"
#import "DZHDrawingUtil.h"
#import "DZHMAModel.h"
#import "DZHVolumeMACalculator.h"
#import "DZHKLineTypeStrategy.h"

@interface DZHKLineDataSource ()

@property (nonatomic, retain) NSMutableArray *volumes;

@property (nonatomic, retain) NSMutableArray *klineX;

@property (nonatomic, retain) NSMutableArray *klineY;

@property (nonatomic, retain) NSMutableArray *klineItem;

@property (nonatomic, assign) CGFloat barWidth;//k线实体、成交量柱宽度

@property (nonatomic, retain) NSArray *MAModels;

@property (nonatomic, retain) NSArray *MACalculators;

@property (nonatomic, retain) NSArray *volumeMAModels;

@property (nonatomic, retain) NSArray *volumeMACalculators;

@property (nonatomic, retain) NSArray *MACycle;

@end

@implementation DZHKLineDataSource
{
    DZHKLineDateFormatter           *_dateFormatter;
    DZHKLineValueFormatter          *_valueFormatter;
    UIColor                         *_positiveColor;
    UIColor                         *_negativeColor;
    UIColor                         *_crossColor;
    DZHKLineTypeStrategy            *_strategy;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.grouping                   = [NSMutableArray array];
        self.kLineWidth                 = 2.;
        self.kLinePadding               = 1.;
        self.minTickCount               = 4;
        self.maxTickCount               = 4;
        self.maxScale                   = 5.;
        self.minScale                   = .5;
        self.scale                      = 1.;
        _dateFormatter                  = [[DZHKLineDateFormatter alloc] init];
        _valueFormatter                 = [[DZHKLineValueFormatter alloc] init];
        
        _positiveColor                  = [[UIColor colorFromRGB:0xf92a27] retain];
        _negativeColor                  = [[UIColor colorFromRGB:0x2b9826] retain];
        _crossColor                     = [[UIColor grayColor] retain];
        
        _strategy                       = [[DZHKLineTypeStrategy alloc] init];
    }
    return self;
}

- (void)setMAConfigs:(NSDictionary *)config
{
    if (_MAConfigs != config)
    {
        [_MAConfigs release];
        _MAConfigs                  = [config retain];
        
        NSMutableArray *maCals      = [NSMutableArray array];
        NSMutableArray *volCals     = [NSMutableArray array];
        NSMutableArray *models      = [NSMutableArray array];
        NSMutableArray *volModels   = [NSMutableArray array];
        NSMutableArray *cycle       = [NSMutableArray array];
        
        [config enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, UIColor *color, BOOL *stop) {
            
            [cycle addObject:key];
            
            int cycle                       = [key intValue];
            DZHMACalculator *cal            = [[DZHMACalculator alloc] initWithMACycle:cycle];
            DZHMAModel *model               = [[DZHMAModel alloc] initWithMACycle:cycle];
            model.color                     = color;
            
            DZHVolumeMACalculator *volCal   = [[DZHVolumeMACalculator alloc] initWithMACycle:cycle];
            DZHMAModel *volModel            = [[DZHMAModel alloc] initWithMACycle:cycle];
            volModel.color                  = color;
            
            [maCals addObject:cal];
            [models addObject:model];
            
            [volCals addObject:volCal];
            [volModels addObject:volModel];
            
            [cal release];
            [model release];
            [volCal release];
            [volModel release];
        }];
        
        self.MACalculators          = maCals;
        self.volumeMACalculators    = volCals;
        self.MAModels               = models;
        self.volumeMAModels         = volModels;
        self.MACycle                = cycle;
    }
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
    
    //MA相关数据
    [_MAConfigs release];
    [_MACycle release];
    [_MAModels release];
    [_MACalculators release];
    [_volumeMAModels release];
    [_volumeMACalculators release];
    
    [_strategy release];
    
    [super dealloc];
}

- (void)setKlines:(NSArray *)klines
{
    if (_klines != klines)
    {
        [_klines release];
        
        [_grouping removeAllObjects];
        int idx                             = 0;
    
        NSMutableArray *datas               = [[NSMutableArray alloc] init];
        DZHDrawingItemModel *lastModel;
        DZHDrawingItemModel *model;
        
        for (DZHKLineEntity *entity in klines)
        {
            model                           = [[DZHDrawingItemModel alloc] initWithOriginData:entity];
            [datas addObject:model];
            [model release];
            
            if (idx != 0)
                [self decisionGroupIfNeedWithPreDate:lastModel.date curDate:entity.date index:idx];
            
            for (DZHMACalculator *calculator in _MACalculators)
            {
                [calculator travelerWithLastData:lastModel currentData:model index:idx];
            }
            
            for (DZHVolumeMACalculator *calculator in _volumeMACalculators)
            {
                [calculator travelerWithLastData:lastModel currentData:model index:idx];
            }
            
            [_strategy travelerWithLastData:lastModel currentData:model index:idx];
            
            lastModel          = model;
            idx ++;
        }
        
        _klines                             = datas;
    }
}

- (void)setScale:(CGFloat)scale
{
    if (_scale != scale)
    {
        _scale              = scale;
        
        int width           = roundf(_kLineWidth * scale);
        _barWidth           = width % 2 == 0 ? width + 1 : width;
    }
}

- (CGFloat)_getKLineWidth
{
    return _barWidth;
}

- (CGFloat)_getKlinePadding
{
    return _kLinePadding;
}

#pragma mark - DZHDrawingDataSource

- (NSArray *)datasForDrawing:(id<DZHDrawing>)drawing inRect:(CGRect)rect
{
    switch (drawing.tag)
    {
        case DrawingTagsKLineX:
            return [self axisXDatasForDrawing:drawing inRect:rect];
        case DrawingTagsKLineY:
            return [self axisYDatasForDrawing:drawing inRect:rect];
        case DrawingTagsKLineItem:
            return [self kLineDatasForDrawing:drawing inRect:rect];
        case DrawingTagsVolumeX:
            return [self axisXDatasForDrawing:drawing inRect:rect];
        case DrawingTagsVolumeY:
            return [self axisYDatasForVolumeDrawing:drawing inRect:rect];
        case DrawingTagsVolumeItem:
            return [self volumeDatasForVolumeDrawing:drawing inRect:rect];
        case DrawingTagsMa:
            return [self maDatasForMaDrawing:drawing inRect:rect];
        case DrawingTagsVolumeMa:
            return [self volumeMADatasForMaDrawing:drawing inRect:rect];
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
    self.startIndex             = MAX(ceilf((rect.origin.x - kPadding - _kLineOffset)/space), 0);
    self.endIndex               = MIN((CGRectGetMaxX(rect) - kPadding - _kLineOffset)/space - 1, [_klines count] - 1);
}

- (void)calculateMaxAndMinDataFromIndex:(NSInteger)from toIndex:(NSInteger)to
{
    DZHDrawingItemModel *entity         = [_klines lastObject];
    NSInteger max                       = entity.high;
    NSInteger min                       = entity.low;
    NSInteger vol                       = entity.volume;
    
    for (NSInteger i = from; i <= to; i++)
    {
        entity                          = [_klines objectAtIndex:i];
        
        if (entity.high > max)
            max                         = entity.high;
        
        if (entity.low < min)
            min                         = entity.low;
        
        if (entity.volume > vol)
            vol                         = entity.volume;
        
        for (NSNumber *cycle in _MACycle)
        {
            int ma                      = [entity MAWithCycle:[cycle intValue]];
            int volMA                   = [entity volumeMAWithCycle:[cycle intValue]];
            
            if (ma > 0)
            {
                if (ma > max)
                    max                     = ma;
                
                if (ma < min)
                    min                     = ma;
            }

            if (volMA > 0 && volMA > vol)
                vol                     = volMA;
        }
    }
    
    self.maxPrice                       = max;
    self.minPrice                       = min;
    self.maxVol                         = vol;
}

- (CGFloat)kItemWidth
{
    return [self _getKlinePadding] + [self _getKLineWidth];
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

- (CGFloat)nearTimesLocationForLocation:(CGFloat)position
{
    CGFloat kWidth              = [self _getKLineWidth];    //k线实体宽度
    CGFloat kPadding            = [self _getKlinePadding];  //k线间距
    CGFloat space               = kWidth + kPadding;
    CGFloat index               = (position - kPadding - _kLineOffset) / space;
    
    return roundf(index) * space + kPadding + _kLineOffset;
}

- (NSInteger)MAStartIndexWithIndex:(NSInteger)index cycle:(int)cycle
{
    return index < cycle - 1 ? cycle - 1 : index;
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

- (NSArray *)axisXDatasForDrawing:(id<DZHDrawing>)drawing inRect:(CGRect)rect
{
    int interval        = MAX(1, roundf(1.4f / self.scale));
    return [self groupsFromIndex:_startIndex toIndex:_endIndex monthInterval:interval];
}

- (void)decisionGroupIfNeedWithPreDate:(int)preDate curDate:(int)curDate index:(int)index
{
    int preMonth        = [_dateFormatter yearMonthOfDate:preDate];
    int curMonth        = [_dateFormatter yearMonthOfDate:curDate];
    
    if (preMonth != curMonth)//如果当前数据跟上一个数据不在一个月，则进行分组
    {
        [self.grouping addObject:[NSString stringWithFormat:@"%d%d",curDate,index]];
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

- (NSArray *)axisYDatasForDrawing:(id<DZHDrawing>)drawing inRect:(CGRect)rect
{
    NSInteger tickCount,strip;
    
    if (_maxPrice == _minPrice)
        [self adjustMinIfNeed:&tickCount strip:&strip];
    else
        [self adjustMaxIfNeed:&tickCount strip:&strip];
    
    NSMutableArray *datas           = [NSMutableArray array];
    
    CGFloat bottom                  = CGRectGetMaxY(rect);
    CGFloat top                     = CGRectGetMinY(rect);
    
    for (int i = 0; i <= tickCount; i++)
    {
        NSInteger value             = _minPrice + strip * i;
        CGFloat y                   = [DZHDrawingUtil locationYForValue:value withMax:_maxPrice min:_minPrice top:top bottom:bottom];
        
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

- (void)adjustMinIfNeed:(NSInteger *)tickCount strip:(NSInteger *)strip
{
    *tickCount              = _maxTickCount - 1;
    NSInteger min           = 0;
    NSInteger t             = 1000;
    do
    {
        t                   *= .1;
        min                 = _maxPrice - *tickCount * t;
    } while (min < 0);
    
    self.minPrice           = min;
    *strip                  = t;
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

- (NSArray *)kLineDatasForDrawing:(id<DZHDrawing>)drawing inRect:(CGRect)rect
{
    NSInteger max               = self.maxPrice;
    NSInteger min               = self.minPrice;
    NSUInteger startIndex       = self.startIndex;   //绘制起始点
    NSUInteger endIndex         = self.endIndex;     //绘制结束点
    CGFloat kWidth              = [self _getKLineWidth];
    NSArray *klines             = self.klines;
    NSMutableArray *datas       = [NSMutableArray array];
    
    CGFloat bottom              = CGRectGetMaxY(rect);
    CGFloat top                 = CGRectGetMinY(rect);
    CGFloat open,close,high,low,x,center;
    CGRect barRect;
    DZHDrawingItemModel *entity;
    
    for (NSUInteger i = startIndex; i <= endIndex; i++)
    {
        entity                  = [klines objectAtIndex:i];
        
        open                    = [DZHDrawingUtil locationYForValue:entity.open withMax:max min:min top:top bottom:bottom];
        close                   = [DZHDrawingUtil locationYForValue:entity.close withMax:max min:min top:top bottom:bottom];
        high                    = [DZHDrawingUtil locationYForValue:entity.high withMax:max min:min top:top bottom:bottom];
        low                     = [DZHDrawingUtil locationYForValue:entity.low withMax:max min:min top:top bottom:bottom];
        
        x                       = [self kLineLocationForIndex:i];
        barRect                 = CGRectMake(x, MIN(open, close), kWidth, MAX(ABS(open - close), 1.));
        
//        if (i == endIndex && CGRectGetMaxX(barRect) > CGRectGetMaxX(rect)) //最后一根k线部分超出范围
//        {
//            self.endIndex       -= 1; //调整起始绘制点，后面相关的绘制都会受到影响，如均线
//            continue;
//        }
//        else if (i == startIndex && CGRectGetMinX(barRect) < CGRectGetMinX(rect))   //第一根k线部分超出范围
//        {
//            self.startIndex     += 1; //调整结束绘制点，后面相关的绘制都会受到影响，如均线
//            continue;
//        }
        
        center                  = floorf(CGRectGetMidX(barRect));
        entity.solidRect        = barRect;
        entity.stickRect        = CGRectMake(center, high, 1., low - high);
        entity.stickColor       = [self corlorForType:entity.type];
        [datas addObject:entity];
    }
    return datas;
}

@end

@implementation DZHKLineDataSource (VolumeAxisY)

- (NSArray *)axisYDatasForVolumeDrawing:(id<DZHDrawing>)drawing inRect:(CGRect)rect
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

- (NSArray *)volumeDatasForVolumeDrawing:(id<DZHDrawing>)drawing inRect:(CGRect)rect
{
    NSUInteger startIndex       = self.startIndex;   //绘制起始点
    NSUInteger endIndex         = self.endIndex;     //绘制结束点
    CGFloat kWidth              = [self _getKLineWidth];
    NSArray *klines             = self.klines;
    NSMutableArray *datas       = [NSMutableArray array];
    CGFloat bottom              = CGRectGetMaxY(rect);
    CGFloat top                 = CGRectGetMinY(rect);
    
    CGFloat vol,x;
    DZHDrawingItemModel *entity;
    
    for (NSUInteger i = startIndex; i <= endIndex; i++)
    {
        entity                  = [klines objectAtIndex:i];
        vol                     = [DZHDrawingUtil locationYForValue:entity.volume withMax:_maxVol min:0 top:top bottom:bottom];
        x                       = [self kLineLocationForIndex:i];
        
        entity.volumeRect       = CGRectMake(x, vol, kWidth, MAX(ABS(bottom - vol), 1.));
        entity.volumeColor      = [self corlorForType:entity.type];
        [datas addObject:entity];
    }
    return datas;
}

@end

@implementation DZHKLineDataSource (MA)

- (NSArray *)maDatasForMaDrawing:(id<DZHDrawing>)drawing inRect:(CGRect)rect
{
    NSUInteger startIndex       = self.startIndex;   //绘制起始点
    NSUInteger endIndex         = self.endIndex;     //绘制结束点
    NSArray *klines             = self.klines;
    CGFloat bottom              = CGRectGetMaxY(rect);
    CGFloat top                 = CGRectGetMinY(rect);
    NSMutableArray *datas       = [NSMutableArray array];
    
    DZHDrawingItemModel *entity;
    
    for (DZHMAModel *model in _MAModels)
    {
        NSInteger begin         = [self MAStartIndexWithIndex:startIndex cycle:model.cycle];
        NSInteger count         = endIndex - begin + 1;
        
        if (count <= 0)
            continue;
        [datas addObject:model];
        
        CGPoint *points         = malloc(sizeof(CGPoint) * count);
        for (NSInteger i = 0,j = begin; i < count; i ++,j++)
        {
            entity              = [klines objectAtIndex:j];
            points[i]           = CGPointMake([self kLineCenterLocationForIndex:j], [DZHDrawingUtil locationYForValue:[entity MAWithCycle:model.cycle] withMax:_maxPrice min:_minPrice top:top bottom:bottom]);
        }
        [model setPoints:points withCount:count];
        free(points);
    }
    
    return datas;
}

@end

@implementation DZHKLineDataSource (VolumeMA)

- (NSArray *)volumeMADatasForMaDrawing:(id<DZHDrawing>)drawing inRect:(CGRect)rect
{
    NSUInteger startIndex       = self.startIndex;   //绘制起始点
    NSUInteger endIndex         = self.endIndex;     //绘制结束点
    NSArray *klines             = self.klines;
    CGFloat bottom              = CGRectGetMaxY(rect);
    CGFloat top                 = CGRectGetMinY(rect);
    NSMutableArray *datas       = [NSMutableArray array];
    
    DZHDrawingItemModel *entity;
    
    for (DZHMAModel *model in _volumeMAModels)
    {
        NSInteger begin         = [self MAStartIndexWithIndex:startIndex cycle:model.cycle];
        NSInteger count         = endIndex - begin + 1;
        
        if (count <= 0)
            continue;
        [datas addObject:model];
        
        CGPoint *points         = malloc(sizeof(CGPoint) * count);
        for (NSInteger i = 0,j = begin; i < count; i ++,j++)
        {
            entity              = [klines objectAtIndex:j];
            points[i]           = CGPointMake([self kLineCenterLocationForIndex:j], [DZHDrawingUtil locationYForValue:[entity volumeMAWithCycle:model.cycle] withMax:_maxVol min:0 top:top bottom:bottom]);
        }
        [model setPoints:points withCount:count];
        free(points);
    }
    
    return datas;
}

@end
