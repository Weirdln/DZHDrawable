//
//  DZHDataSource2.m
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-7.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHKLineDataSource.h"
#import "DZHKLineDataProvider.h"
#import "DZHVolumeDataprovider.h"
#import "DZHDrawingItemModel.h"
#import "DZHDataProviderContext.h"
#import "DZHDrawing.h"

@interface DZHKLineDataSource ()


@end

@implementation DZHKLineDataSource

- (instancetype)init
{
    if (self = [super init])
    {
        _kLineDataProvider          = [[DZHKLineDataProvider alloc] init];
        _indexDataProvider          = [[DZHVolumeDataProvider alloc] init];
        
        self.maxScale               = 5.;
        self.minScale               = .5;
        
        _context                    = [[DZHDataProviderContext alloc] init];
        _context.startLocation      = 20.;
        
        self.kLineWidth             = _context.itemWidth    = 2.;
        self.kLinePadding           = _context.itemPadding  = 1.;
        self.scale                  = _context.scale        = 1.;
    }
    return self;
}

- (void)setMAConfigs:(NSDictionary *)MAConfigs
{
    [((DZHKLineDataProvider *)_kLineDataProvider) setMAConfigs:MAConfigs];
    [((DZHVolumeDataProvider *)_indexDataProvider) setMAConfigs:MAConfigs];
}

- (void)setKlines:(NSArray *)klines
{
    if (_klines != klines)
    {
        [_klines release];
        
        NSInteger idx                       = 0;
        
        NSMutableArray *datas               = [[NSMutableArray alloc] init];
        DZHDrawingItemModel *lastModel      = nil;
        DZHDrawingItemModel *model          = nil;
        
        for (DZHKLineEntity *entity in klines)
        {
            model                           = [[DZHDrawingItemModel alloc] initWithOriginData:entity];
            [datas addObject:model];
            [model release];
            
            [_kLineDataProvider setupPropertyWhenTravelLastData:lastModel currentData:model index:idx];
            [_indexDataProvider setupPropertyWhenTravelLastData:lastModel currentData:model index:idx];
            
            lastModel          = model;
            idx ++;
        }
        
        _klines                             = datas;
        _context.datas                      = datas;
        _context.itemCount                  = idx;
    }
}

- (void)setScale:(CGFloat)scale
{
    if (_scale != scale)
    {
        _scale              = scale;
        
        int width           = roundf(_kLineWidth * scale);
        _context.scale      = scale;
        _context.itemWidth  = width % 2 == 0 ? width + 1 : width;
    }
}

#pragma mark - DZHDrawingDelegate

- (void)prepareDrawing:(id<DZHDrawing>)drawing inRect:(CGRect)rect
{
    
    if ([_kLineDataProvider respondsToSelector:@selector(setupStartAndEndIndexInRect:withParameter:)])
        [_kLineDataProvider setupStartAndEndIndexInRect:rect withParameter:_context];
    
    if ([_indexDataProvider respondsToSelector:@selector(setupStartAndEndIndexInRect:withParameter:)])
        [_indexDataProvider setupStartAndEndIndexInRect:rect withParameter:_context];
    
    NSInteger from                      = _context.fromIndex;
    NSInteger to                        = _context.toIndex;
    DZHDrawingItemModel *lastModel      = nil;
    DZHDrawingItemModel *model          = nil;
    
    for (NSInteger i = from; i <= to; i++)
    {
        model                          = [_klines objectAtIndex:i];
        
        [_kLineDataProvider setupMaxAndMinWhenTravelLastData:lastModel currentData:model index:i];
        [_indexDataProvider setupMaxAndMinWhenTravelLastData:lastModel currentData:model index:i];
        
        lastModel          = model;
    }
}

#pragma mark - DZHDrawingDataSource

- (NSArray *)datasForDrawing:(id<DZHDrawing>)drawing inRect:(CGRect)rect
{
    CGFloat top         = CGRectGetMinY(rect);
    CGFloat bottom      = CGRectGetMaxY(rect);
    switch (drawing.drawingTag)
    {
        case DrawingTagsKLineX:
            return [_kLineDataProvider axisXDatasWithParameter:_context top:top bottom:bottom];
        case DrawingTagsKLineY:
            return [_kLineDataProvider axisYDatasWithParameter:_context top:top bottom:bottom];
        case DrawingTagsKLineItem:
            return [_kLineDataProvider itemDatasWithParameter:_context top:top bottom:bottom];
        case DrawingTagsVolumeX:
            return [_kLineDataProvider axisXDatasWithParameter:_context top:top bottom:bottom];
        case DrawingTagsVolumeY:
            return [_indexDataProvider axisYDatasWithParameter:_context top:top bottom:bottom];
        case DrawingTagsVolumeItem:
            return [_indexDataProvider itemDatasWithParameter:_context top:top bottom:bottom];
        case DrawingTagsMa:
            return [_kLineDataProvider extendDatasWithParameter:_context top:top bottom:bottom];
        case DrawingTagsVolumeMa:
            return [_indexDataProvider extendDatasWithParameter:_context top:top bottom:bottom];
        default:
            return nil;
    }
}


@end
