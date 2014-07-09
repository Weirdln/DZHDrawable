//
//  DZHKDJDataProvider.m
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-8.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHKDJDataProvider.h"
#import "DZHKDJCalculator.h"
#import "DZHDrawingItemModel.h"
#import "DZHAxisEntity.h"
#import "DZHDrawingUtil.h"
#import "DZHMAModel.h"

@interface DZHKDJDataProvider ()

@property (nonatomic) int max;
@property (nonatomic) int min;

@end

@implementation DZHKDJDataProvider
{
    DZHMAModel                          *_kModel;
    DZHMAModel                          *_dModel;
    DZHMAModel                          *_jModel;
}

@synthesize context             = _context;
@synthesize colorProvider       = _colorProvider;

- (instancetype)init
{
    if (self = [super init])
    {
        _kdjCal                         = [[DZHKDJCalculator alloc] initWithKDay:3 DDay:3 rsvDay:9];
        
        _kModel                         = [[DZHMAModel alloc] initWithMACycle:3];
        _kModel.notBezier               = YES;
        
        _dModel                         = [[DZHMAModel alloc] initWithMACycle:3];
        _dModel.notBezier               = YES;
        
        _jModel                         = [[DZHMAModel alloc] initWithMACycle:3];
        _jModel.notBezier               = YES;
    }
    return self;
}

- (void)dealloc
{
    [_kdjCal release];
    
    [_kModel release];
    [_dModel release];
    [_jModel release];
    
    [super dealloc];
}

#pragma mark - DZHDataProviderProtocol

- (void)setupPropertyWhenTravelLastData:(DZHDrawingItemModel *)lastData currentData:(DZHDrawingItemModel *)curData index:(NSInteger)index
{
    if (lastData == nil)    //遍历起始，重置数据
    {
        [_kdjCal travelerBeginAtIndex:index];
    }
    [_kdjCal travelerWithLastData:lastData currentData:curData index:index];
}

- (void)setupMaxAndMinWhenTravelLastData:(DZHDrawingItemModel *)lastData currentData:(DZHDrawingItemModel *)data index:(NSInteger)index
{
    int max                     = MAX(MAX(data.K, data.D), data.J);
    int min                     = MIN(MIN(data.K, data.D), data.J);
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
    entity.labelText            = [NSString stringWithFormat:@"%d",_min];
    entity.notDrawLine          = YES;
    [datas addObject:entity];
    [entity release];
    
    entity                      = [[DZHAxisEntity alloc] init];
    entity.location             = CGPointMake(.0, round(bottom - (bottom - top) * .5));
    entity.labelText            = [NSString stringWithFormat:@"%.0f",roundf((_max + _min) * .5)];
    entity.dashLengths          = @[@3.f,@2.f];
    [datas addObject:entity];
    [entity release];
    
    entity                      = [[DZHAxisEntity alloc] init];
    entity.location             = CGPointMake(.0, top);
    entity.labelText            = [NSString stringWithFormat:@"%d",_max];
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
    NSInteger count         = endIndex - startIndex + 1;
    
    DZHDrawingItemModel *entity;
    
    CGPoint *kPoints     = malloc(sizeof(CGPoint) * count);
    CGPoint *dPoints     = malloc(sizeof(CGPoint) * count);
    CGPoint *jPoints     = malloc(sizeof(CGPoint) * count);
    for (NSInteger i = 0,j = startIndex; i < count; i ++,j++)
    {
        entity              = [klines objectAtIndex:j];
        kPoints[i]       = CGPointMake([context centerLocationForIndex:j], [DZHDrawingUtil locationYForValue:entity.K withMax:_max min:_min top:top bottom:bottom]);
        
        dPoints[i]       = CGPointMake([context centerLocationForIndex:j], [DZHDrawingUtil locationYForValue:entity.D withMax:_max min:_min top:top bottom:bottom]);
        
        jPoints[i]       = CGPointMake([context centerLocationForIndex:j], [DZHDrawingUtil locationYForValue:entity.J withMax:_max min:_min top:top bottom:bottom]);
    }
    
    [_kModel setPoints:kPoints withCount:count];
    [_dModel setPoints:dPoints withCount:count];
    [_jModel setPoints:jPoints withCount:count];
    
    _kModel.color             = [_colorProvider colorForKDJType:KDJLineTypeK];
    _dModel.color             = [_colorProvider colorForKDJType:KDJLineTypeD];
    _jModel.color             = [_colorProvider colorForKDJType:KDJLineTypeJ];
    
    free(kPoints);
    free(dPoints);
    free(jPoints);
    
    return @[_kModel,_dModel,_jModel];
}

@end
