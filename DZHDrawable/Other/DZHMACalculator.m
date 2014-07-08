//
//  DZHMACalculate.m
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-2.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHMACalculator.h"
#import "DZHDrawingItemModel.h"

@implementation DZHMACalculator
{
    int                     _total;
    int                     *_lastValues;//缓存数据
}

- (instancetype)initWithMACycle:(int)cycle
{
    if (self  = [super init])
    {
        self.cycle          = cycle;
        _lastValues         = malloc(sizeof(int) * cycle);
    }
    return self;
}

- (void)dealloc
{
    free(_lastValues);
    [super dealloc];
}

- (void)travelerBeginAtIndex:(NSInteger)index
{
    _total                  = 0;
    memset(_lastValues, 0, sizeof(int) * _cycle);
}

- (void)travelerWithLastData:(DZHDrawingItemModel *)last currentData:(DZHDrawingItemModel *)currentData index:(NSInteger)index
{
    int close                   = currentData.close;
    int cycle                   = _cycle;
    
    _total                      += close;
    if (index >= cycle)
    {
        int idx                 = (index - cycle) % cycle;//缓存中需要重新设置值的索引，当前索引-周期所在数据的值在缓存中的索引
        _total                  -= _lastValues[idx];
        int ma                  = _total / cycle;
        [currentData setMA:ma withCycle:cycle];
        _lastValues[idx]        = close;
    }
    else if (index == cycle - 1) //均线第一个点
    {
        int ma                  = _total / cycle;
        [currentData setMA:ma withCycle:cycle];
        _lastValues[index]      = close;
    }
    else
    {
        _lastValues[index]      = close;
    }
}

@end
