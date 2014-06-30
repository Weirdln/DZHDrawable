//
//  DZHDrawing.m
//  DZHDrawable
//
//  Created by Duanwwu on 14-6-26.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHDrawingBase.h"

@implementation DZHDrawingBase

@synthesize virtualFrame    = _virtualFrame;
@synthesize delegate        = _delegate;
@synthesize dataSource      = _dataSource;

- (void)dealloc
{
    _delegate               = nil;
    _dataSource             = nil;
    [super dealloc];
}

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
    
}

- (float)coordYWithValue:(float)v max:(float)max min:(float)min
{
    return [self coordYWithValue:v max:max min:min top:_virtualFrame.origin.y bottom:CGRectGetMaxY(_virtualFrame)];
}

- (float)coordYWithValue:(float)v max:(float)max min:(float)min top:(float)top bottom:(float)bottom
{
	float y;
	
	if (max == min)
		y = bottom;
	else if (v <= max && v >= min)
		y = bottom - (v - min)/(max - min)*(bottom - top);
	else
		y = (v < min) ? bottom : top;
	
	return y;
}

@end
