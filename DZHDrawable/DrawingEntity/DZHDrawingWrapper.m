//
//  DZHDrawingWrapper.m
//  DZHDrawable
//
//  Created by Duanwwu on 14-6-26.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHDrawingWrapper.h"

@implementation DZHDrawingWrapper

- (instancetype)initWithDrawing:(id<DZHDrawing>)drawing virtualRect:(CGRect)rect
{
    if (self = [super init])
    {
        self.drawing                = drawing;
        self.virtualRect            = rect;
    }
    return self;
}

- (void)dealloc
{
    [_drawing release];
    [super dealloc];
}

@end
