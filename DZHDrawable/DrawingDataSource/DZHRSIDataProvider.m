//
//  DZHRSIDataProvider.m
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-9.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHRSIDataProvider.h"
#import "DZHRSICalculator.h"
#import "DZHMAModel.h"
#import "DZHDrawingItemModel.h"
#import "DZHAxisEntity.h"
#import "DZHDrawingUtil.h"

@interface DZHRSIDataProvider ()

@property (nonatomic) int max;
@property (nonatomic) int min;
@property (nonatomic, retain) NSArray *rsiModels;

@end

@implementation DZHRSIDataProvider
{
    DZHMAModel                  *_rsi1Model;
    DZHMAModel                  *_rsi2Model;
    DZHMAModel                  *_rsi3Model;
}

@synthesize context             = _context;
@synthesize colorProvider       = _colorProvider;

- (instancetype)init
{
    if (self = [super init])
    {
        _rsiCal                         = [[DZHRSICalculator alloc] initWithRSI1:6 RSI2:12 RSI3:24];
        
        _rsi1Model                      = [[DZHMAModel alloc] initWithMACycle:6];
        _rsi1Model.notBezier            = YES;
        
        _rsi2Model                      = [[DZHMAModel alloc] initWithMACycle:12];
        _rsi2Model.notBezier            = YES;
        
        _rsi3Model                      = [[DZHMAModel alloc] initWithMACycle:24];
        _rsi3Model.notBezier            = YES;
        
        self.max                        = 10000;
        self.min                        = 0;
        self.rsiModels                  = @[_rsi1Model,_rsi2Model,_rsi3Model];
    }
    return self;
}

- (void)dealloc
{
    [_rsiCal release];
    
    [_rsi1Model release];
    [_rsi2Model release];
    [_rsi3Model release];
    
    [super dealloc];
}

#pragma mark - DZHDataProviderProtocol

- (void)setupPropertyWhenTravelLastData:(DZHDrawingItemModel *)lastData currentData:(DZHDrawingItemModel *)curData index:(NSInteger)index
{
    if (lastData == nil)    //遍历起始，重置数据
    {
        [_rsiCal travelerBeginAtIndex:index];
    }
    [_rsiCal travelerWithLastData:lastData currentData:curData index:index];
}

- (void)setupMaxAndMinWhenTravelLastData:(DZHDrawingItemModel *)lastData currentData:(DZHDrawingItemModel *)data index:(NSInteger)index
{
    
}

- (NSArray *)axisYDatasWithContext:(id<DZHDataProviderContextProtocol>)context top:(CGFloat)top bottom:(CGFloat)bottom
{
    NSMutableArray *datas       = [NSMutableArray array];
    
    DZHAxisEntity *entity       = [[DZHAxisEntity alloc] init];
    entity.location             = CGPointMake(.0, bottom);
    entity.labelText            = @"0";
    entity.notDrawLine          = YES;
    [datas addObject:entity];
    [entity release];
    
    entity                      = [[DZHAxisEntity alloc] init];
    entity.location             = CGPointMake(.0, round(bottom - (bottom - top) * .5));
    entity.labelText            = @"50";
    entity.dashLengths          = @[@3.f,@2.f];
    [datas addObject:entity];
    [entity release];
    
    entity                      = [[DZHAxisEntity alloc] init];
    entity.location             = CGPointMake(.0, top);
    entity.labelText            = @"100";
    entity.notDrawLine          = YES;
    [datas addObject:entity];
    [entity release];
    
    return datas;
}

- (NSArray *)itemDatasWithContext:(id<DZHDataProviderContextProtocol>)context top:(CGFloat)top bottom:(CGFloat)bottom
{
    return nil;
}

- (NSArray *)extendDatasWithContext:(id<DZHDataProviderContextProtocol>)context top:(CGFloat)top bottom:(CGFloat)bottom
{
    NSUInteger startIndex   = context.fromIndex;
    NSUInteger endIndex     = context.toIndex;
    NSArray *klines         = context.datas;
    NSMutableArray *datas   = [NSMutableArray array];
    DZHDrawingItemModel *entity;
    
    int idx                 = 0;
    for (DZHMAModel *model in _rsiModels)
    {
        NSInteger begin     = [self beginOfIndex:startIndex indexCycle:model.cycle];
        NSInteger count     = endIndex - begin + 1;
        
        if (count <= 0)
            continue;
        [datas addObject:model];
        
        CGPoint *points     = malloc(sizeof(CGPoint) * count);
        for (NSInteger i = 0,j = begin; i < count; i ++,j++)
        {
            entity          = [klines objectAtIndex:j];
            
            int value;
            if (idx == 0)
                value       = entity.RSI1;
            else if (idx == 1)
                value       = entity.RSI2;
            else
                value       = entity.RSI3;
            
            points[i]       = CGPointMake([context centerLocationForIndex:j], [DZHDrawingUtil locationYForValue:value withMax:_max min:_min top:top bottom:bottom]);
        }
        [model setPoints:points withCount:count];
        model.color         = [_colorProvider colorForRSIType:idx];
        free(points);
        
        idx ++;
    }
    
    return datas;
    
//    CGPoint *points1        = malloc(sizeof(CGPoint) * count);
//    CGPoint *points2        = malloc(sizeof(CGPoint) * count);
//    CGPoint *points3        = malloc(sizeof(CGPoint) * count);
//    for (NSInteger i = 0,j = startIndex; i < count; i ++,j++)
//    {
//        entity              = [klines objectAtIndex:j];
//        points1[i]          = CGPointMake([context centerLocationForIndex:j], [DZHDrawingUtil locationYForValue:entity.RSI1 withMax:_max min:_min top:top bottom:bottom]);
//        
//        points2[i]          = CGPointMake([context centerLocationForIndex:j], [DZHDrawingUtil locationYForValue:entity.RSI2 withMax:_max min:_min top:top bottom:bottom]);
//        
//        points3[i]          = CGPointMake([context centerLocationForIndex:j], [DZHDrawingUtil locationYForValue:entity.RSI3 withMax:_max min:_min top:top bottom:bottom]);
//    }
//    
//    [_rsi1Model setPoints:points1 withCount:count];
//    [_rsi2Model setPoints:points2 withCount:count];
//    [_rsi3Model setPoints:points3 withCount:count];
//    
//    _rsi1Model.color             = [_colorProvider colorForKDJType:KDJLineTypeK];
//    _rsi2Model.color             = [_colorProvider colorForKDJType:KDJLineTypeD];
//    _rsi3Model.color             = [_colorProvider colorForKDJType:KDJLineTypeJ];
//    
//    free(points1);
//    free(points2);
//    free(points3);
//    
//    return @[_rsi1Model,_rsi2Model,_rsi3Model];
}

@end