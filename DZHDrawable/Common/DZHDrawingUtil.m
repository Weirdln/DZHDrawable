//
//  DZHDrawingUtil.m
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-3.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHDrawingUtil.h"

@implementation DZHDrawingUtil

+ (CGFloat)locationYForValue:(float)v withMax:(float)max min:(float)min top:(CGFloat)top bottom:(CGFloat)bottom
{
    CGFloat y;
	
	if (max == min)
		y = bottom;
	else if (v <= max && v >= min)
		y = round(bottom - (v - min)/(max - min)*(bottom - top));
	else
		y = (v < min) ? bottom : top;
	
	return y;
}

@end
