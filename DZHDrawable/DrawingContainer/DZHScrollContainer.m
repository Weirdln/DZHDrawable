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

@synthesize virtualFrame        = _virtualFrame;
@synthesize drawingTag          = _drawingTag;
@synthesize drawingDelegate     = _drawingDelegate;
@synthesize drawingDataSource   = _drawingDataSource;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _container              = [[DZHContainer alloc] init];
        _container.virtualFrame = CGRectMake(.0, .0, frame.size.width, frame.size.height);
    }
    return self;
}

- (void)dealloc
{
    [_container release];
    
    [super dealloc];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context        = UIGraphicsGetCurrentContext();

    [self drawRect:rect withContext:context];
}

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
    if (self.drawingDelegate && [self.drawingDelegate respondsToSelector:@selector(prepareDrawing:inRect:)])
    {
        [self.drawingDelegate prepareDrawing:self inRect:rect];
    }
    
    [_container drawRect:rect withContext:context];
    
    if (self.drawingDelegate && [self.drawingDelegate respondsToSelector:@selector(completeDrawing:inRect:)])
    {
        [self.drawingDelegate completeDrawing:self inRect:rect];
    }
}

#pragma mark - DZHDrawingContainer

- (void)setVirtualFrame:(CGRect)virtualFrame
{
    _container.virtualFrame     = virtualFrame;
}

- (CGRect)virtualFrame
{
    return _container.virtualFrame;
}

- (void)addDrawing:(id<DZHDrawing>)drawing atVirtualRect:(CGRect)rect
{
    [_container addDrawing:drawing atVirtualRect:rect];
}

- (void)removeDrawing:(id<DZHDrawing>)drawing
{
    [_container removeDrawing:drawing];
}

- (CGRect)realRectForVirtualRect:(CGRect)virtualRect currentRect:(CGRect)currentRect;
{
    return [_container realRectForVirtualRect:virtualRect currentRect:currentRect];
}

@end
