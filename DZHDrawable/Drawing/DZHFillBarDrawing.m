//
//  DZHBarDrawing.m
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-1.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHFillBarDrawing.h"
#import "DZHDrawingItems.h"

@implementation DZHFillBarDrawing

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
    NSParameterAssert(self.drawingDataSource);
    
    NSArray *datas                  = [self.drawingDataSource datasForDrawing:self inRect:rect];
    if ([datas count] == 0)
        return;
    
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 1.);
    
    for (id<DZHBarItem> entity in datas)
    {
        CGContextSetFillColorWithColor(context, entity.barFillColor.CGColor);
        CGContextFillRect(context, entity.barRect);
    }
    CGContextRestoreGState(context);
}

@end
