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

- (instancetype)init
{
    self = [super init];
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

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
    for (DZHDrawingWrapper *wrapper in _drawings)
    {
        id<DZHDrawing> drawing      = wrapper.drawing;
        
        if (CGRectIsEmpty(wrapper.virtualFrame))
            continue;
        
        CGRect realRect             = [self realRectForVirtualRect:wrapper.virtualFrame currentRect:rect];
        
        if (drawing.drawingDelegate && [drawing.drawingDelegate respondsToSelector:@selector(prepareDrawing:inRect:)])
        {
            [drawing.drawingDelegate prepareDrawing:drawing inRect:realRect];
        }
        
        [drawing drawRect:realRect withContext:context];
        
        if (drawing.drawingDelegate && [drawing.drawingDelegate respondsToSelector:@selector(completeDrawing:inRect:)])
        {
            [drawing.drawingDelegate prepareDrawing:drawing inRect:realRect];
        }
    }
}

#pragma mark - DZHDrawingContainer

- (void)addDrawing:(id<DZHDrawing>)drawing atVirtualRect:(CGRect)rect
{
    DZHDrawingWrapper *wrapper          = [[DZHDrawingWrapper alloc] initWithDrawing:drawing virtualFrame:rect];
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
    return CGRectMake(currentRect.origin.x + virtualRect.origin.x, currentRect.origin.y + virtualRect.origin.y, virtualRect.size.width, virtualRect.size.height);
}

@end