//
//  DZHMACDDataProvider.m
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-8.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHMACDDataProvider.h"
#import "DZHMACDCalculator.h"
#import "DZHDrawingItemModel.h"
#import "DZHAxisEntity.h"
#import "DZHKLineValueFormatter.h"
#import "DZHDrawingUtil.h"
#import "DZHMAModel.h"

@interface DZHMACDDataProvider ()

@property (nonatomic) int max;
@property (nonatomic) int min;

@end

@implementation DZHMACDDataProvider
{
    DZHKLineValueFormatter              *_valueFormatter;
    DZHMAModel                          *_fast;
    DZHMAModel                          *_slow;
}

@synthesize context         = _context;
@synthesize colorProvider   = _colorProvider;

- (id)init
{
    if (self = [super init])
    {
        _macdCal                        = [[DZHMACDCalculator alloc] initWithEMAFastDay:12 slowDay:26 difDay:9];
        _valueFormatter                 = [[DZHKLineValueFormatter alloc] init];
        
        _fast                           = [[DZHMAModel alloc] initWithMACycle:12];
        _slow                           = [[DZHMAModel alloc] initWithMACycle:26];
    }
    return self;
}

- (void)dealloc
{
    [_macdCal release];
    [_valueFormatter release];
    [super dealloc];
}

#pragma mark - DZHDataProviderProtocol

- (void)setupPropertyWhenTravelLastData:(DZHDrawingItemModel *)lastData currentData:(DZHDrawingItemModel *)curData index:(NSInteger)index
{
    if (lastData == nil)    //遍历起始，重置数据
    {
        [_macdCal travelerBeginAtIndex:index];
    }
    [_macdCal travelerWithLastData:lastData currentData:curData index:index];
}

- (void)setupMaxAndMinWhenTravelLastData:(DZHDrawingItemModel *)lastData currentData:(DZHDrawingItemModel *)data index:(NSInteger)index
{
    int max                     = MAX(MAX(data.DIF, data.DEA), data.MACD);
    int min                     = MIN(MIN(data.DIF, data.DEA), data.MACD);
    if (lastData == nil)
    {
        self.max                = max;
        self.min                = min;
    }
    else
    {
        if (_max < max)
            self.max            = max;
        
        if (_min > min)
        {
            self.min            = min;
        }
    }
}

- (NSArray *)axisYDatasWithContext:(id<DZHDataProviderContextProtocol>)context top:(CGFloat)top bottom:(CGFloat)bottom
{
    NSMutableArray *datas       = [NSMutableArray array];
    
    DZHAxisEntity *entity       = [[DZHAxisEntity alloc] init];
    entity.location             = CGPointMake(.0, bottom);
    entity.labelText            = [_valueFormatter stringForObjectValue:@(_min)];
    entity.notDrawLine          = YES;
    [datas addObject:entity];
    [entity release];
    
    entity                      = [[DZHAxisEntity alloc] init];
    entity.location             = CGPointMake(.0, round(bottom - (bottom - top) * .5));
    entity.labelText            = [_valueFormatter stringForObjectValue:@(roundf((_max + _min) * .5))];
    entity.dashLengths          = @[@3.f,@2.f];
    [datas addObject:entity];
    [entity release];
    
    entity                      = [[DZHAxisEntity alloc] init];
    entity.location             = CGPointMake(.0, top);
    entity.labelText            = [_valueFormatter stringForObjectValue:@(_max)];
    entity.notDrawLine          = YES;
    [datas addObject:entity];
    [entity release];
    
    return datas;
}

- (NSArray *)itemDatasWithContext:(id<DZHDataProviderContextProtocol>)context top:(CGFloat)top bottom:(CGFloat)bottom
{
    NSUInteger startIndex       = context.fromIndex;
    NSUInteger endIndex         = context.toIndex;
    NSArray *klines             = context.datas;
    NSMutableArray *datas       = [NSMutableArray array];
    
    CGFloat macd,x;
    DZHDrawingItemModel *entity;
    
    CGFloat y0                  = [DZHDrawingUtil locationYForValue:0 withMax:_max min:_min top:top bottom:bottom];
    
    for (NSUInteger i = startIndex; i <= endIndex; i++)
    {
        entity                  = [klines objectAtIndex:i];
        MACDType type           = entity.MACD > 0 ? MACDTypePositive : MACDTypeNegative;
        macd                    = [DZHDrawingUtil locationYForValue:entity.MACD withMax:_max min:_min top:top bottom:bottom];
        
        x                       = [context centerLocationForIndex:i];
        entity.barRect          = CGRectMake(x, macd, 1., y0 - macd);
        entity.barFillColor     = [_colorProvider colorForMACDType:type];
        [datas addObject:entity];
    }
    return datas;
}

- (NSArray *)extendDatasWithContext:(id<DZHDataProviderContextProtocol>)context top:(CGFloat)top bottom:(CGFloat)bottom
{
    NSUInteger startIndex   = context.fromIndex;
    NSUInteger endIndex     = context.toIndex;
    NSArray *klines         = context.datas;
    NSInteger count         = endIndex - startIndex + 1;
    
    DZHDrawingItemModel *entity;
    
    CGPoint *fastPoints     = malloc(sizeof(CGPoint) * count);
    CGPoint *slowPoints     = malloc(sizeof(CGPoint) * count);
    for (NSInteger i = 0,j = startIndex; i < count; i ++,j++)
    {
        entity              = [klines objectAtIndex:j];
        fastPoints[i]       = CGPointMake([context centerLocationForIndex:j], [DZHDrawingUtil locationYForValue:entity.DIF withMax:_max min:_min top:top bottom:bottom]);
        
        slowPoints[i]       = CGPointMake([context centerLocationForIndex:j], [DZHDrawingUtil locationYForValue:entity.DEA withMax:_max min:_min top:top bottom:bottom]);
    }
    
    [_fast setPoints:fastPoints withCount:count];
    [_slow setPoints:slowPoints withCount:count];
    
    _fast.color             = [_colorProvider colorForMACDLineType:MACDLineTypeFast];
    _slow.color             = [_colorProvider colorForMACDLineType:MACDLineTypeSlow];
    
    free(fastPoints);
    free(slowPoints);
    
    return @[_fast,_slow];
}

@end
