//
//  DZHDataProviderBase.m
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-9.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHDataProviderBase.h"

@implementation DZHDataProviderBase

@synthesize context         = _context;
@synthesize colorProvider   = _colorProvider;

#pragma mark - DZHDataProviderProtocol

- (NSInteger)beginOfIndex:(NSInteger)idx indexCycle:(int)cycle
{
    return idx < cycle - 1 ? cycle - 1 : idx;
}

- (void)setupPropertyWhenTravelLastData:(id)lastData currentData:(id)curData index:(NSInteger)index
{
    
}

- (void)setupMaxAndMinWhenTravelLastData:(id)lastData currentData:(id)data index:(NSInteger)index
{
    
}

- (NSArray *)axisYDatasWithContext:(id<DZHDataProviderContextProtocol>)context top:(CGFloat)top bottom:(CGFloat)bottom
{
    return nil;
}

- (NSArray *)itemDatasWithContext:(id<DZHDataProviderContextProtocol>)context top:(CGFloat)top bottom:(CGFloat)bottom
{
    return nil;
}

- (NSArray *)extendDatasWithContext:(id<DZHDataProviderContextProtocol>)context top:(CGFloat)top bottom:(CGFloat)bottom
{
    return nil;
}


@end
