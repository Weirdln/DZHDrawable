//
//  DZHMAModel.m
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-4.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHMAModel.h"

@implementation DZHMAModel

- (void)dealloc
{
    [_color release];
    
    if (_points != NULL)
        free(_points);
    
    [super dealloc];
}

- (instancetype)initWithMACycle:(int)cyle
{
    if (self = [super init])
    {
        self.cycle      = cyle;
    }
    return self;
}

- (void)setPoints:(CGPoint *)points withCount:(NSInteger)count
{
    if (_points != NULL)
        free(_points);
    
    size_t size         = sizeof(CGPoint) * count;
    _points             = malloc(size);
    memcpy(_points, points, size);
    _count              = count;
}

@end
