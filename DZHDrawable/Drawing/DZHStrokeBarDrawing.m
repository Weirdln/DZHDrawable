//
//  DZHStrokeBarDrawing.m
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-1.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHStrokeBarDrawing.h"
#import "DZHStrokeBarEntity.h"

@implementation DZHStrokeBarDrawing

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
    NSParameterAssert(self.dataSource);
    
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 1.);
    
    NSArray *datas                  = [self.dataSource datasForDrawing:self inRect:rect];

    for (DZHStrokeBarEntity *entity in datas)
    {
        CGContextSetStrokeColorWithColor(context, entity.color.CGColor);
        CGContextAddLines(context, (CGPoint []){entity.startPoint,entity.endPoint}, 2);
        CGContextStrokePath(context);
    }
    CGContextRestoreGState(context);
}

@end
