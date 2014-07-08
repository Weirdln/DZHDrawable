//
//  DZHVolumeDataprovider.m
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-7.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHVolumeDataProvider.h"
#import "DZHVolumeMACalculator.h"
#import "DZHMAModel.h"
#import "DZHDrawingItemModel.h"
#import "DZHAxisEntity.h"
#import "DZHDrawingUtil.h"
#import "DZHVolumeTypeStrategy.h"

@interface DZHVolumeDataProvider ()

@property (nonatomic, retain) NSArray *volumeMAModels;

@property (nonatomic, retain) NSArray *volumeMACalculators;

@property (nonatomic, retain) NSArray *MACycle;

@property (nonatomic) int maxVolume;

@end

@implementation DZHVolumeDataProvider
{
    DZHVolumeTypeStrategy            *_volTypeStrategy;
}

@synthesize context         = _context;
@synthesize colorProvider   = _colorProvider;

- (id)init
{
    if (self = [super init])
    {
        _volTypeStrategy        = [[DZHVolumeTypeStrategy alloc] init];
        
        self.MACycle            = @[@(KLineCycleFive),@(KLineCycleTen),@(KLineCycleTwenty),@(KLineCycleThirty)];
    }
    return self;
}

- (void)dealloc
{
    [_volumeMAModels release];
    [_volumeMACalculators release];
    [_MACycle release];
    
    [super dealloc];
}

- (void)setMACycle:(NSArray *)MACycle
{
    if (_MACycle != MACycle)
    {
        [_MACycle release];
        _MACycle                            = [MACycle retain];
        
        NSMutableArray *volCals             = [NSMutableArray array];
        NSMutableArray *volModels           = [NSMutableArray array];
        for (NSNumber *cycle in MACycle)
        {
            int v                           = [cycle intValue];
            DZHVolumeMACalculator *volCal   = [[DZHVolumeMACalculator alloc] initWithMACycle:v];
            [volCals addObject:volCal];
            [volCal release];
            
            DZHMAModel *model               = [[DZHMAModel alloc] initWithMACycle:v];
            [volModels addObject:model];
            [model release];
        }
        self.volumeMACalculators            = volCals;
        self.volumeMAModels                 = volModels;
    }
}

- (NSInteger)MAStartIndexWithIndex:(NSInteger)index cycle:(int)cycle
{
    return index < cycle - 1 ? cycle - 1 : index;
}

#pragma mark - DZHDataProviderProtocol

- (void)setupPropertyWhenTravelLastData:(DZHDrawingItemModel *)lastData currentData:(DZHDrawingItemModel *)curData index:(NSInteger)index
{
    if (lastData == nil)    //遍历起始，重置数据
    {
        for (DZHVolumeMACalculator *calculator in _volumeMACalculators)
        {
            [calculator travelerBeginAtIndex:index];
        }
    }
    
    for (DZHVolumeMACalculator *calculator in _volumeMACalculators)
    {
        [calculator travelerWithLastData:lastData currentData:curData index:index];
    }
    
    [_volTypeStrategy travelerWithLastData:lastData currentData:curData index:index];
}

- (void)setupMaxAndMinWhenTravelLastData:(DZHDrawingItemModel *)lastData currentData:(DZHDrawingItemModel *)data index:(NSInteger)index
{
    if (lastData == nil)
        _maxVolume                          = data.volume;
    else if (data.volume > _maxVolume)
        _maxVolume                          = data.volume;
    
    for (NSNumber *cycle in _MACycle)
    {
        int volMA                           = [data volumeMAWithCycle:[cycle intValue]];
        
        if (volMA > _maxVolume)
            _maxVolume                      = volMA;
    }
}

- (NSArray *)axisYDatasWithContext:(id<DZHDataProviderContextProtocol>)context top:(CGFloat)top bottom:(CGFloat)bottom
{
    NSMutableArray *datas       = [NSMutableArray array];
    
    DZHAxisEntity *entity       = [[DZHAxisEntity alloc] init];
    entity.location             = CGPointMake(.0, bottom);
    entity.labelText            = @"万手";
    entity.notDrawLine          = YES;
    [datas addObject:entity];
    [entity release];
    
    entity                      = [[DZHAxisEntity alloc] init];
    entity.location             = CGPointMake(.0, top);
    entity.labelText            = [NSString stringWithFormat:@"%.1f",(float)self.maxVolume/10000];
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
    
    CGFloat vol,x;
    DZHDrawingItemModel *entity;
    
    for (NSUInteger i = startIndex; i <= endIndex; i++)
    {
        entity                  = [klines objectAtIndex:i];
        vol                     = [DZHDrawingUtil locationYForValue:entity.volume withMax:_maxVolume min:0 top:top bottom:bottom];
        x                       = [context locationForIndex:i];
        
        entity.barRect          = CGRectMake(x, vol, context.itemWidth, MAX(ABS(bottom - vol), 1.));
        entity.barFillColor     = [_colorProvider colorForVolumeType:entity.volumeType];
        [datas addObject:entity];
    }
    return datas;
}

- (NSArray *)extendDatasWithContext:(id<DZHDataProviderContextProtocol>)context top:(CGFloat)top bottom:(CGFloat)bottom
{
    NSUInteger startIndex       = context.fromIndex;
    NSUInteger endIndex         = context.toIndex;
    NSArray *klines             = context.datas;
    NSMutableArray *datas       = [NSMutableArray array];
    
    DZHDrawingItemModel *entity;
    
    for (DZHMAModel *model in _volumeMAModels)
    {
        model.color             = [_colorProvider colorForVolumeMACycle:model.cycle];
        
        NSInteger begin         = [self MAStartIndexWithIndex:startIndex cycle:model.cycle];
        NSInteger count         = endIndex - begin + 1;
        
        if (count <= 0)
            continue;
        [datas addObject:model];
        
        CGPoint *points         = malloc(sizeof(CGPoint) * count);
        for (NSInteger i = 0,j = begin; i < count; i ++,j++)
        {
            entity              = [klines objectAtIndex:j];
            points[i]           = CGPointMake([context centerLocationForIndex:j], [DZHDrawingUtil locationYForValue:[entity volumeMAWithCycle:model.cycle] withMax:_maxVolume min:0 top:top bottom:bottom]);
        }
        [model setPoints:points withCount:count];
        free(points);
    }
    
    return datas;
}

@end
