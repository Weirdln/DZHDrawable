//
//  DZHKLineViewController.m
//  DZHDrawable
//
//  Created by Duanwwu on 14-6-27.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHKLineViewController.h"
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

@interface DZHKLineViewController ()<DZHDrawingDelegate,DZHDrawingDataSource,DZHDrawingContainerDelegate,DZHKLineContainerDelegate,UIScrollViewDelegate>

@property (nonatomic, retain) NSArray *klines;

@property (nonatomic, retain) NSMutableArray *grouping;

@property (nonatomic) NSInteger startIndex;

@property (nonatomic) NSInteger endIndex;

@property (nonatomic) NSInteger max;

@property (nonatomic) NSInteger min;

@property (nonatomic) CGFloat scale;//缩放比例

@property (nonatomic) CGFloat minScale;

@property (nonatomic) CGFloat maxScale;

@property (nonatomic) CGFloat kLineWidth; //k线实体宽度

@property (nonatomic) CGFloat kLinePadding; //k线之间间距

@property (nonatomic) NSInteger minTickCount;/**y轴刻度最少个数*/

@property (nonatomic) NSInteger maxTickCount;/**y轴刻度最多个数*/

@property (nonatomic) NSInteger tickCount;/**刻度个数*/

@end

@implementation DZHKLineViewController
{
    DZHKLineDateFormatter           *_dateFormatter;
    DZHKLineValueFormatter          *_valueFormatter;
    DZHKLineContainer               *kLineContainer;
    DZHKLineDrawing                 *klineDrawing;
    
    UIColor                         *positiveColor;
    UIColor                         *negativeColor;
    UIColor                         *crossColor;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.grouping                   = [NSMutableArray array];
        self.kLineWidth                 = 2.;
        self.kLinePadding               = 2.;
        self.minTickCount               = 4;
        self.maxTickCount               = 4;
        self.scale                      = 1.;
        self.maxScale                   = 3.;
        self.minScale                   = .5;
        _dateFormatter                  = [[DZHKLineDateFormatter alloc] init];
        _valueFormatter                 = [[DZHKLineValueFormatter alloc] init];
        
        positiveColor                   = [UIColor colorFromRGB:0xf92a27];
        negativeColor                   = [UIColor colorFromRGB:0x2b9826];
        crossColor                      = [UIColor grayColor];
    }
    return self;
}

- (void)dealloc
{
    [_dateFormatter release];
    [_valueFormatter release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    NSString *resource          = [[NSBundle mainBundle] resourcePath];
    NSData *unarchiveData       = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/klines.data",resource]];
    NSMutableArray *datas       = [NSKeyedUnarchiver unarchiveObjectWithData:unarchiveData];
    
    NSMutableArray *klines      = [NSMutableArray array];
    [klines addObjectsFromArray:datas];
    [klines addObjectsFromArray:datas];
    [klines addObjectsFromArray:datas];
    [klines addObjectsFromArray:datas];
    
    self.view.backgroundColor   = [UIColor whiteColor];

    kLineContainer                      = [[DZHKLineContainer alloc] initWithFrame:CGRectMake(10., 10., 300., 400)];
    kLineContainer.backgroundColor      = [UIColor colorFromRGB:0x0e1014];
    kLineContainer.delegate             = self;
    kLineContainer.kLineDelegate        = self;
    kLineContainer.containerDelegate    = self;
    [self.view addSubview:kLineContainer];
    
    UIColor *lineColor                  = [UIColor colorFromRGB:0x1e2630];
    UIColor *labelColor                 = [UIColor colorFromRGB:0x707880];
    
    //画外层框
    DZHRectangleDrawing *rectDrawing    = [[DZHRectangleDrawing alloc] init];
    rectDrawing.lineColor               = lineColor;
    [kLineContainer addDrawing:rectDrawing atVirtualRect:CGRectMake(20., .0, 260., 160.)];
    
    //画x轴的直线
    DZHAxisXDrawing *axisXDrawing       = [[DZHAxisXDrawing alloc] init];
    axisXDrawing.dataSource             = self;
    axisXDrawing.labelColor             = labelColor;
    axisXDrawing.lineColor              = lineColor;
    axisXDrawing.labelFont              = [UIFont systemFontOfSize:10.];
    axisXDrawing.labelSpace             = 20.;
    [kLineContainer addDrawing:axisXDrawing atVirtualRect:CGRectMake(20., .0, 260., 180.)];
    
    //画y轴的直线
    DZHAxisYDrawing *axisYDrawing       = [[DZHAxisYDrawing alloc] init];
    axisYDrawing.dataSource             = self;
    axisYDrawing.delegate               = self;
    axisYDrawing.labelFont              = [UIFont systemFontOfSize:10.];
    axisYDrawing.labelColor             = labelColor;
    axisYDrawing.lineColor              = lineColor;
    axisYDrawing.labelSpace             = 20.;
    [kLineContainer addDrawing:axisYDrawing atVirtualRect:CGRectMake(.0, 5., 280., 150.)];
    
    //画k线
    klineDrawing                        = [[DZHKLineDrawing alloc] init];
    klineDrawing.delegate               = self;
    klineDrawing.dataSource             = self;
    [klineDrawing setColor:[UIColor colorFromRGB:0xf92a27] forType:KLineTypePositive];
    [klineDrawing setColor:[UIColor colorFromRGB:0x2b9826] forType:KLineTypeNegative];
    [klineDrawing setColor:[UIColor grayColor] forType:KLineTypeCross];
    [kLineContainer addDrawing:klineDrawing atVirtualRect:CGRectMake(20., 5., 260., 150.)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *resource          = [[NSBundle mainBundle] resourcePath];
    NSData *unarchiveData       = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/klines.data",resource]];
    NSMutableArray *datas       = [NSKeyedUnarchiver unarchiveObjectWithData:unarchiveData];
    
    NSMutableArray *klines      = [NSMutableArray array];
    [klines addObjectsFromArray:datas];
    [klines addObjectsFromArray:datas];
    [klines addObjectsFromArray:datas];
    [klines addObjectsFromArray:datas];
    self.klines              = klines;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setKlines:(NSArray *)klines
{
    if (_klines != klines)
    {
        [_klines release];
        _klines                             = [klines retain];
        
        CGFloat width                   = [self totalKLineWidth];
        [self changeScrollContainerContentSize:CGSizeMake(width, 0)];
        
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
    return _kLineWidth * _scale;
}

- (CGFloat)_getKlinePadding
{
    return _kLinePadding * _scale;
}

- (void)_getKLineMaxPrice:(NSInteger *)maxPrice minPrice:(NSInteger *)minPrice fromIndex:(NSInteger)from toIndex:(NSInteger)to
{
    NSInteger max                     = NSIntegerMin;
    NSInteger min                     = NSIntegerMax;
    
    for (NSInteger i = from; i <= to; i++)
    {
        DZHKLineEntity *entity  = [_klines objectAtIndex:i];
        
        if (entity.high > max)
            max        = entity.high;
        
        if (entity.low < min)
            min        = entity.low;
    }
    
    *minPrice                           = min;
    *maxPrice                           = max;
}

#pragma mark - DZHDrawingDataSource

- (NSArray *)datasForDrawing:(id<DZHDrawing>)drawing
{
    if ([drawing isKindOfClass:[DZHAxisXDrawing class]])
    {
        return [self groupsFromIndex:_startIndex toIndex:_endIndex monthInterval:2];
    }
    else if ([drawing isKindOfClass:[DZHAxisYDrawing class]])
    {
        NSInteger tickCount,strip;
        
        [self prepareAndAdjustMaxIfNeed:&tickCount strip:&strip];
        
        NSMutableArray *datas       = [NSMutableArray array];
        
        for (int i = 0; i <= tickCount; i++)
        {
            NSInteger value             = self.min + strip * i;
            CGFloat y                   = [drawing coordYWithValue:value max:_max min:_min];
            
            DZHAxisEntity *entity   = [[DZHAxisEntity alloc] init];
            entity.location         = CGPointMake(.0, y);
            entity.labelText        = [_valueFormatter stringForObjectValue:@(value)];
            [datas addObject:entity];
            [entity release];
        }
        return datas;
    }
    else if ([drawing isKindOfClass:[DZHKLineDrawing class]])
    {
        return [self candleDatas];
    }
    return nil;
}

- (void)prepareAndAdjustMaxIfNeed:(NSInteger *)tickCount strip:(NSInteger *)strip
{
    NSInteger maxValue    = self.max;
    NSInteger min         = self.min;
    
    NSInteger count = [self _tickCountWithMax:maxValue min:min strip:strip];
    
    while (count == NSIntegerMax)
    {
        maxValue ++;
        count       = [self _tickCountWithMax:maxValue min:min strip:strip];
    }
    
    *tickCount      = count;
    self.max        = maxValue;
}

- (NSInteger)_tickCountWithMax:(NSInteger)max min:(NSInteger)min strip:(NSInteger *)strip
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

- (void)changeScrollContainerContentSize:(CGSize)size
{
    CGFloat oldContentWidth     = kLineContainer.contentSize.width;
    CGFloat newContentWidth     = size.width;
    
    CGRect frame                = kLineContainer.frame;
    kLineContainer.contentSize  = CGSizeMake(newContentWidth, frame.size.height);
    
    [kLineContainer scrollRectToVisible:CGRectMake(newContentWidth - oldContentWidth - frame.size.width, .0, frame.size.width, frame.size.height) animated:NO];
}

#pragma mark - DZHDrawingContainerDelegate

- (void)prepareContainerDrawing:(id<DZHDrawingContainer>)drawing rect:(CGRect)rect
{
    CGRect realRect         = [drawing realRectForVirtualRect:klineDrawing.virtualFrame currentRect:rect];
    [self needDrawKLinesInRect:realRect startIndex:&_startIndex endIndex:&_endIndex];
    [self calculateMaxPrice:&_max minPrice:&_min fromIndex:_startIndex toIndex:_endIndex];
}

#pragma mark -  DZHKLineContainerDelegate

- (CGFloat)scaledOfkLineContainer:(DZHKLineContainer *)container
{
    return self.scale;
}

- (void)kLineContainer:(DZHKLineContainer *)container scaled:(CGFloat)scale
{
    CGRect frame                = container.frame;
    CGFloat centerPosition      = container.contentOffset.x + frame.size.width * .5;
    NSUInteger index            = [self nearIndexForLocation:centerPosition];
    
    if (scale > _maxScale)
        self.scale              = _maxScale;
    else if (scale < _minScale)
        self.scale              = _minScale;
    else
        self.scale              = scale;
    
    CGFloat newPosition         = [self kLineLocationForIndex:index];
    container.contentSize       = CGSizeMake([self totalKLineWidth], frame.size.height);
    
    [container scrollRectToVisible:CGRectMake(newPosition - frame.size.width * .5, .0, frame.size.width, frame.size.height) animated:NO];
    
//    CGRect frame                = container.frame;
//    CGFloat oldScale            = self.scale;
//    CGPoint offset              = container.contentOffset;
//    if (scale > _maxScale)
//        self.scale              = _maxScale;
//    else if (scale < _minScale)
//        self.scale              = _minScale;
//    else
//        self.scale              = scale;
//    
//    CGFloat diff                = (self.scale - oldScale) * container.contentSize.width;
//    NSLog(@"%f",diff);
//    
//    [container scrollRectToVisible:CGRectMake(MIN(offset.x + diff, 0), .0, frame.size.width, frame.size.height) animated:NO];
}

- (void)kLineContainer:(DZHKLineContainer *)container longPressLocation:(CGPoint)point state:(UIGestureRecognizerState)state
{
    NSUInteger index    = [self indexForLocation:point.x];
    if (index == NSUIntegerMax)
    {
        NSLog(@"无对应K线数据");
    }
    else
    {
        DZHKLineEntity *entity  = [_klines objectAtIndex:index];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [scrollView setNeedsDisplay];
}

@end

#pragma mark - abstract

@implementation DZHKLineViewController (Abstract)

- (void)needDrawKLinesInRect:(CGRect)rect startIndex:(NSInteger *)startIndex endIndex:(NSInteger *)endIndex
{
    CGFloat kWidth              = [self _getKLineWidth];    //k线实体宽度
    CGFloat kPadding            = [self _getKlinePadding];  //k线间距
    CGFloat space               = kWidth + kPadding;
    CGFloat start               = klineDrawing.virtualFrame.origin.x;
    *startIndex                 = MAX((rect.origin.x - kPadding - start)/space , 0);
    *endIndex                   = MIN((CGRectGetMaxX(rect) - kPadding - start)/space , [_klines count] - 1);
}

- (void)calculateMaxPrice:(NSInteger *)maxPrice minPrice:(NSInteger *)minPrice fromIndex:(NSInteger)from toIndex:(NSInteger)to
{
    NSInteger max                     = NSIntegerMin;
    NSInteger min                     = NSIntegerMax;
    
    for (NSInteger i = from; i <= to; i++)
    {
        DZHKLineEntity *entity  = [_klines objectAtIndex:i];
        
        if (entity.high > max)
            max        = entity.high;
        
        if (entity.low < min)
            min        = entity.low;
    }
    
    *minPrice                           = min;
    *maxPrice                           = max;
}

- (CGFloat)totalKLineWidth
{
    CGFloat kLineWidth          = [self _getKLineWidth];
    CGFloat kLinePadding        = [self _getKlinePadding];
    CGFloat mainWidth           = [self.klines count] * (kLineWidth + kLinePadding) + kLinePadding;
    
    return mainWidth + kLineContainer.frame.size.width - klineDrawing.virtualFrame.size.width;
}

- (CGFloat)kLineLocationForIndex:(NSUInteger)index
{
    CGFloat kWidth              = [self _getKLineWidth];    //k线实体宽度
    CGFloat kPadding            = [self _getKlinePadding];  //k线间距
    CGFloat space               = kWidth + kPadding;
    return klineDrawing.virtualFrame.origin.x + kPadding + index * space;
}

- (CGFloat)kLineCenterLocationForIndex:(NSUInteger)index
{
    CGFloat kWidth              = [self _getKLineWidth];    //k线实体宽度
    CGFloat kPadding            = [self _getKlinePadding];  //k线间距
    CGFloat space               = kWidth + kPadding;
    return klineDrawing.virtualFrame.origin.x + kPadding + index * space + kWidth * .5;
}

- (NSUInteger)indexForLocation:(CGFloat)position
{
    CGFloat kWidth              = [self _getKLineWidth];    //k线实体宽度
    CGFloat kPadding            = [self _getKlinePadding];  //k线间距
    CGFloat space               = kWidth + kPadding;
    CGFloat v                   = (position - kPadding - klineDrawing.virtualFrame.origin.x) / space ;
    int mode                    = ((int)(v * 100)) %100;
    int scale                   = kWidth / space * 100;
    return mode > scale ? NSUIntegerMax : v;
}

- (NSUInteger)nearIndexForLocation:(CGFloat)position
{
    CGFloat kWidth              = [self _getKLineWidth];    //k线实体宽度
    CGFloat kPadding            = [self _getKlinePadding];  //k线间距
    CGFloat space               = kWidth + kPadding;
    CGFloat index               = (position - kPadding - klineDrawing.virtualFrame.origin.x) / space;
    return index;
}

@end

@implementation DZHKLineViewController (Group)

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

@implementation DZHKLineViewController (KLineData)

- (NSArray *)candleDatas
{
    NSInteger max               = self.max;
    NSInteger min               = self.min;
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
        
        open                    = [klineDrawing coordYWithValue:entity.open max:max min:min];
        close                   = [klineDrawing coordYWithValue:entity.close max:max min:min];
        high                    = [klineDrawing coordYWithValue:entity.high max:max min:min];
        low                     = [klineDrawing coordYWithValue:entity.low max:max min:min];
        
        x                       = [self kLineLocationForIndex:i];
        fillRect                = CGRectMake(x, MIN(open, close), kWidth, MAX(ABS(open - close), 1.));
        center                  = CGRectGetMidX(fillRect);
        
        candle                  = [[DZHCandleEntity alloc] init];
        candle.fillRect         = fillRect;
        candle.high             = CGPointMake(center, high);
        candle.low              = CGPointMake(center, low);
        candle.kLineType        = entity.type;
        [datas addObject:candle];
        [candle release];
    }
    return datas;
}

@end

