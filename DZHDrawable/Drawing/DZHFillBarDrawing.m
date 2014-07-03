//
//  DZHBarDrawing.m
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-1.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHFillBarDrawing.h"
#import "DZHFillBarEntity.h"

@implementation DZHFillBarDrawing

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
    NSParameterAssert(self.dataSource);
    
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 1.);
    
    NSArray *datas                  = [self.dataSource datasForDrawing:self inRect:rect];
    
    for (DZHFillBarEntity *entity in datas)
    {
        CGContextSetFillColorWithColor(context, entity.color.CGColor);
        CGContextFillRect(context, entity.barRect);
    }
    CGContextRestoreGState(context);
}

@end
