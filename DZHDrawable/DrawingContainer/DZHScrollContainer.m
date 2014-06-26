//
//  DZHScrollContainer.m
//  DZHDrawable
//
//  Created by Duanwwu on 14-6-26.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHScrollContainer.h"
#import "DZHDrawingWrapper.h"

@implementation DZHScrollContainer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _drawings               = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_drawings release];
    
    [super dealloc];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context        = UIGraphicsGetCurrentContext();
    
    [self drawRect:rect withContext:context];
}

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
    for (DZHDrawingWrapper *wrapper in _drawings)
    {
        id<DZHDrawing> drawing      = wrapper.drawing;
        CGRect rect                 = [self realRectForVirtualRect:wrapper.virtualRect currentRect:rect];
        [drawing drawRect:rect withContext:context];
    }
}

#pragma mark - DZHDrawingContainer

- (void)addDrawing:(id<DZHDrawing>)drawing atVirtualRect:(CGRect)rect
{
    DZHDrawingWrapper *wrapper          = [[DZHDrawingWrapper alloc] initWithDrawing:drawing virtualRect:rect];
    [_drawings addObject:wrapper];
    [wrapper release];
}

- (CGRect)realRectForVirtualRect:(CGRect)virtualRect currentRect:(CGRect)currentRect;
{
    return CGRectMake(currentRect.origin.x + virtualRect.origin.x, virtualRect.origin.y, virtualRect.size.width, virtualRect.size.height);
}

@end
