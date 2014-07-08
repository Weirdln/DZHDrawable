//
//  DZHKDJCalculator.m
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-8.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHKDJCalculator.h"
#import "DZHDrawingItemModel.h"

@implementation DZHKDJCalculator
{
    int                     *_low;//rsvDay天内最低价
    int                     *_high;//rsvDay天内高价
    int                     K;
    int                     D;
    int                     J;
}

- (instancetype)initWithKDay:(int)kDay DDay:(int)dDay rsvDay:(int)rsvDay
{
    if (self = [super init])
    {
        self.kDay           = kDay;
        self.dDay           = dDay;
        self.rsvDay         = rsvDay;
        
        _low                = malloc(sizeof(int) * _rsvDay);
        _high               = malloc(sizeof(int) * _rsvDay);
    }
    return self;
}

- (void)dealloc
{
    free(_low);
    free(_high);
    
    [super dealloc];
}

- (void)travelerBeginAtIndex:(NSInteger)index
{
    K       = D     = J     = 50;
    memset(_low, 0, sizeof(int) * _rsvDay);
    memset(_high, 0, sizeof(int) * _rsvDay);
}

- (void)calculateWithCycle:(int)cycle index:(NSInteger)index max:(int *)maxValue min:(int *)minValue
{
    int min             = _low[0];
    int max             = _high[0];
    
    NSInteger i         = index >= cycle ? cycle - 1 : index;
    for(; i >= 1; i--)
    {
        if (min > _low[i])
        {
            min         = _low[i];
        }
        
        if (max < _high[i])
        {
            max         = _high[i];
        }
    }
    
    *maxValue           = max;
    *minValue           = min;
}

//rsv=（收盘-N日内最低）/（N日内最高-N日内最低）*100
- (void)travelerWithLastData:(DZHDrawingItemModel *)last currentData:(DZHDrawingItemModel *)currentData index:(NSInteger)index
{
    if (index >= _rsvDay)
    {
        int idx                 = (index - _rsvDay) % _rsvDay;
        _low[idx]               = currentData.low;
        _high[idx]              = currentData.high;
    }
    else
    {
        _low[index]             = currentData.low;
        _high[index]            = currentData.high;
    }
    
    int ndayMax,ndayMin;
    [self calculateWithCycle:_rsvDay index:index max:&ndayMax min:&ndayMin];
    
    int rsv                     = (currentData.close - ndayMin) * 1. / (ndayMax - ndayMin) * 100.;
    
    K	= (_kDay - 1) * K / _kDay + rsv / _kDay;
    D	= (_dDay - 1) * D / _dDay +  K /_dDay;
    J	= 3 * K - 2 * D;
    
    currentData.K               = K;
    currentData.D               = D;
    currentData.J               = J;
}

@end
