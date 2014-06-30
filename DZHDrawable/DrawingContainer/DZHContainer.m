//
//  DZHContainer.m
//  DZHDrawable
//
//  Created by Duanwwu on 14-6-26.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHContainer.h"
#import "DZHDrawingWrapper.h"

@implementation DZHContainer

@synthesize containerDelegate       = _containerDelegate;

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
    
    if (_containerDelegate && [_containerDelegate respondsToSelector:@selector(prepareContainerDrawing:rect:)])
    {
        [_containerDelegate prepareContainerDrawing:self rect:rect];
    }
    
    [self drawRect:rect withContext:context];
    
    if (_containerDelegate && [_containerDelegate respondsToSelector:@selector(completeContainerDrawing:rect:)])
    {
        [_containerDelegate completeContainerDrawing:self rect:rect];
    }
}

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
    for (DZHDrawingWrapper *wrapper in _drawings)
    {
        id<DZHDrawing> drawing      = wrapper.drawing;
        
        if (CGRectIsEmpty(wrapper.virtualRect))
            continue;
        
        CGRect rect                 = [self realRectForVirtualRect:wrapper.virtualRect currentRect:rect];
        
        if (drawing.delegate && [drawing.delegate respondsToSelector:@selector(prepareDrawing:)])
        {
            [drawing.delegate prepareDrawing:drawing];
        }
        
        [drawing drawRect:rect withContext:context];
        
        if (drawing.delegate && [drawing.delegate respondsToSelector:@selector(completeDrawing:)])
        {
            [drawing.delegate prepareDrawing:drawing];
        }
    }
}

#pragma mark - DZHDrawingContainer

- (void)addDrawing:(id<DZHDrawing>)drawing atVirtualRect:(CGRect)rect
{
    DZHDrawingWrapper *wrapper          = [[DZHDrawingWrapper alloc] initWithDrawing:drawing virtualRect:rect];
    drawing.virtualFrame                = rect;
    [_drawings addObject:wrapper];
    [wrapper release];
}

- (void)removeDrawing:(id<DZHDrawing>)drawing
{
    [_drawings removeObject:drawing];
}

- (CGRect)realRectForVirtualRect:(CGRect)virtualRect currentRect:(CGRect)currentRect;
{
    return virtualRect;
}

@end