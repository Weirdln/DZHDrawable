//
//  DZHAxisDrawingBase.m
//  DZHDrawable
//
//  Created by Duanwwu on 14-6-27.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHAxisDrawingBase.h"

@implementation DZHAxisDrawingBase

@synthesize lineColor           = _lineColor;
@synthesize labelColor          = _labelColor;
@synthesize labelFont           = _labelFont;
@synthesize labelSpace          = _labelSpace;

- (void)dealloc
{
    [_lineColor release];
    [_labelColor release];
    [_labelFont release];
    [super dealloc];
}

- (void)drawStrInRect:(NSString *)str rect:(CGRect)rect font:(UIFont *)font alignment:(NSTextAlignment)alignment
{
	[str drawInRect:rect withFont:font lineBreakMode:NSLineBreakByClipping alignment:alignment];
}

@end
