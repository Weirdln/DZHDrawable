//
//  DZHCandleStickDataSource.m
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-7.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHKLineDataProvider.h"
#import "DZHMACalculator.h"
#import "DZHMAModel.h"
#import "DZHKLineDateFormatter.h"
#import "DZHKLineValueFormatter.h"
#import "DZHDrawingItemModel.h"
#import "DZHKLineTypeStrategy.h"
#import "DZHAxisEntity.h"
#import "DZHDataProviderContext.h"
#import "DZHDrawingUtil.h"
#import "UIColor+RGB.h"

@interface DZHKLineDataProvider ()

@property (nonatomic, retain) NSArray *MAModels;

@property (nonatomic, retain) NSArray *MACalculators;

@property (nonatomic, retain) NSArray *MACycle;

@property (nonatomic, retain) NSMutableArray *grouping;

@property (nonatomic) NSInteger maxPrice;

@property (nonatomic) NSInteger minPrice;

@property (nonatomic) NSInteger minTickCount;/**y轴刻度最少个数*/

@property (nonatomic) NSInteger maxTickCount;/**y轴刻度最多个数*/

@end

@implementation DZHKLineDataProvider
{
    DZHKLineDateFormatter           *_dateFormatter;
    DZHKLineValueFormatter          *_valueFormatter;
    DZHKLineTypeStrategy            *_kTypeStrategy;
    
    UIColor                         *_positiveColor;
    UIColor                         *_negativeColor;
    UIColor                         *_crossColor;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.minTickCount               = 4;
        self.maxTickCount               = 4;
        
        _dateFormatter                  = [[DZHKLineDateFormatter alloc] init];
        _valueFormatter                 = [[DZHKLineValueFormatter alloc] init];
        self.grouping                   = [NSMutableArray array];
        _kTypeStrategy                  = [[DZHKLineTypeStrategy alloc] init];
        
        _positiveColor                  = [[UIColor colorFromRGB:0xf92a27] retain];
        _negativeColor                  = [[UIColor colorFromRGB:0x2b9826] retain];
        _crossColor                     = [[UIColor grayColor] retain];
    }
    return self;
}

- (void)dealloc
{
    [_MAModels release];
    [_MACalculators release];
    [_MACycle release];
    [_grouping release];
    
    [_dateFormatter release];
    [_valueFormatter release];
    [_kTypeStrategy release];
    
    [_positiveColor release];
    [_negativeColor release];
    [_crossColor release];
    [super dealloc];
}

- (void)setMAConfigs:(NSDictionary *)config
{
    if (_MAConfigs != config)
    {
        [_MAConfigs release];
        _MAConfigs                  = [config retain];
        
        NSMutableArray *maCals      = [NSMutableArray array];
        NSMutableArray *models      = [NSMutableArray array];
        NSMutableArray *cycle       = [NSMutableArray array];
        
        [config enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, UIColor *color, BOOL *stop) {
            
            [cycle addObject:key];
            
            int cycle                       = [key intValue];
            DZHMACalculator *cal            = [[DZHMACalculator alloc] initWithMACycle:cycle];
            DZHMAModel *model               = [[DZHMAModel alloc] initWithMACycle:cycle];
            model.color                     = color;
            
            [maCals addObject:cal];
            [models addObject:model];
            
            
            [cal release];
            [model release];
        }];
        
        self.MACalculators          = maCals;
        self.MAModels               = models;
        self.MACycle                = cycle;
    }
}

- (void)decisionGroupIfNeedWithPreDate:(int)preDate curDate:(int)curDate index:(NSInteger)index
{
    int preMonth        = [_dateFormatter yearMonthOfDate:preDate];
    int curMonth        = [_dateFormatter yearMonthOfDate:curDate];
    
    if (preMonth != curMonth)//如果当前数据跟上一个数据不在一个月，则进行分组
    {
        [self.grouping addObject:[NSString stringWithFormat:@"%d%ld",curDate,index]];
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
            CGFloat x               = [_context centerLocationForIndex:index];
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

- (NSInteger)MAStartIndexWithIndex:(NSInteger)index cycle:(int)cycle
{
    return index < cycle - 1 ? cycle - 1 : index;
}

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

#pragma mark - DZHDataProviderProtocol

- (void)setupPropertyWhenTravelLastData:(DZHDrawingItemModel *)lastData currentData:(DZHDrawingItemModel *)curData index:(NSInteger)index
{
    if (lastData == nil) //遍历起始，重置数据
    {
        [_grouping removeAllObjects];
        for (DZHMACalculator *calculator in _MACalculators)
        {
            [calculator travelerBeginAtIndex:index];
        }
    }
    else
        [self decisionGroupIfNeedWithPreDate:lastData.date curDate:curData.date index:index];
    
    for (DZHMACalculator *calculator in _MACalculators)
    {
        [calculator travelerWithLastData:lastData currentData:curData index:index];
    }
    
    [_kTypeStrategy travelerWithLastData:lastData currentData:curData index:index];
}

- (void)setupStartAndEndIndexInRect:(CGRect)rect withParameter:(id<DZHDataProviderContextProtocol>)context
{
    self.context                = context;
    [context calculateFromAndToIndexWithRect:rect];
}

- (void)setupMaxAndMinBegin:(DZHDrawingItemModel *)data
{
    _maxPrice                   = data.high;
    _minPrice                   = data.low;
    
    for (NSNumber *cycle in _MACycle)
    {
        int ma                      = [data MAWithCycle:[cycle intValue]];
        
        if (ma > 0)
        {
            if (ma > _maxPrice)
                _maxPrice                     = ma;
            
            if (ma < _minPrice)
                _minPrice                     = ma;
        }
    }
}

- (void)setupMaxAndMinWhenTravelData:(DZHDrawingItemModel *)data
{
    if (data.high > _maxPrice)
        _maxPrice                         = data.high;
    
    if (data.low < _minPrice)
        _minPrice                         = data.low;
    
    for (NSNumber *cycle in _MACycle)
    {
        int ma                      = [data MAWithCycle:[cycle intValue]];
        
        if (ma > 0)
        {
            if (ma > _maxPrice)
                _maxPrice                     = ma;
            
            if (ma < _minPrice)
                _minPrice                     = ma;
        }
    }
}

- (void)setupMaxAndMinWhenTravelLastData:(DZHDrawingItemModel *)lastData currentData:(DZHDrawingItemModel *)data index:(NSInteger)index
{
    if (lastData == nil)
    {
        _maxPrice                   = data.high;
        _minPrice                   = data.low;
    }
    else
    {
        if (data.high > _maxPrice)
            _maxPrice               = data.high;
        
        if (data.low < _minPrice)
            _minPrice               = data.low;
    }
    
    for (NSNumber *cycle in _MACycle)
    {
        int ma                      = [data MAWithCycle:[cycle intValue]];
        
        if (ma > 0)
        {
            if (ma > _maxPrice)
                _maxPrice           = ma;
            
            if (ma < _minPrice)
                _minPrice           = ma;
        }
    }
}

- (NSArray *)axisXDatasWithParameter:(id<DZHDataProviderContextProtocol>)context top:(CGFloat)top bottom:(CGFloat)bottom
{
    int interval        = MAX(1, roundf(1.4f / _context.scale));
    return [self groupsFromIndex:context.fromIndex toIndex:context.toIndex monthInterval:interval];
}

- (NSArray *)axisYDatasWithParameter:(id<DZHDataProviderContextProtocol>)context top:(CGFloat)top bottom:(CGFloat)bottom
{
    NSInteger tickCount,strip;
    
    if (_maxPrice == _minPrice)
        [self adjustMinIfNeed:&tickCount strip:&strip];
    else
        [self adjustMaxIfNeed:&tickCount strip:&strip];
    
    NSMutableArray *datas           = [NSMutableArray array];
    
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

- (NSArray *)itemDatasWithParameter:(id<DZHDataProviderContextProtocol>)context top:(CGFloat)top bottom:(CGFloat)bottom
{
    NSInteger max               = self.maxPrice;
    NSInteger min               = self.minPrice;
    NSArray *klines             = context.datas;
    NSMutableArray *datas       = [NSMutableArray array];
    
    CGFloat open,close,high,low,x,center;
    CGRect barRect;
    DZHDrawingItemModel *entity;
    
    for (NSUInteger i = context.fromIndex; i <= context.toIndex; i++)
    {
        entity                  = [klines objectAtIndex:i];
        
        open                    = [DZHDrawingUtil locationYForValue:entity.open withMax:max min:min top:top bottom:bottom];
        close                   = [DZHDrawingUtil locationYForValue:entity.close withMax:max min:min top:top bottom:bottom];
        high                    = [DZHDrawingUtil locationYForValue:entity.high withMax:max min:min top:top bottom:bottom];
        low                     = [DZHDrawingUtil locationYForValue:entity.low withMax:max min:min top:top bottom:bottom];
        
        x                       = [context locationForIndex:i];
        barRect                 = CGRectMake(x, MIN(open, close), context.itemWidth, MAX(ABS(open - close), 1.));
        
        center                  = floorf(CGRectGetMidX(barRect));
        entity.solidRect        = barRect;
        entity.stickRect        = CGRectMake(center, high, 1., low - high);
        entity.stickColor       = [self corlorForType:entity.type];
        [datas addObject:entity];
    }
    return datas;
}

- (NSArray *)extendDatasWithParameter:(id<DZHDataProviderContextProtocol>)context top:(CGFloat)top bottom:(CGFloat)bottom
{
    NSUInteger startIndex       = context.fromIndex;   //绘制起始点
    NSUInteger endIndex         = context.toIndex;     //绘制结束点
    NSArray *klines             = context.datas;
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
            points[i]           = CGPointMake([context centerLocationForIndex:j], [DZHDrawingUtil locationYForValue:[entity MAWithCycle:model.cycle] withMax:_maxPrice min:_minPrice top:top bottom:bottom]);
        }
        [model setPoints:points withCount:count];
        free(points);
    }
    
    return datas;
}

@end
