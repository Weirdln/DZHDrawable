//
//  DZHDrawing.m
//  DZHDrawable
//
//  Created by Duanwwu on 14-6-26.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHDrawingBase.h"

@implementation DZHDrawingBase

@synthesize virtualFrame        = _virtualFrame;
@synthesize drawingTag          = _drawingTag;
@synthesize drawingDelegate     = _drawingDelegate;
@synthesize drawingDataSource   = _drawingDataSource;

- (void)dealloc
{
    _drawingDelegate        = nil;
    _drawingDataSource      = nil;
    [super dealloc];
}

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
    
}

@end
