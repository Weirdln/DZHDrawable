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
    
    NSArray *datas                  = [self.dataSource datasForDrawing:self];
    NSInteger i                     = 0;
    NSInteger endIndex              = [datas count] - 1;
    CGColorRef color;
    CGFloat x;
    
    for (DZHStrokeBarEntity *entity in datas)
    {
        color                       = entity.color.CGColor;
        x                           = entity.startPoint.x;
        
        BOOL draw                   = YES;
        if (i == endIndex && x > CGRectGetMaxX(rect)) //最后一根k线部分超出范围，不绘制
        {
            draw            = NO;
        }
        else if (i == 0 && x < CGRectGetMinX(rect))   //第一根k线部分超出范围，不绘制
        {
            draw            = NO;
        }
        
        if (draw)
        {
            CGContextAddLines(context, (CGPoint []){entity.startPoint,entity.endPoint}, 2);
            CGContextStrokePath(context);
        }
        i ++ ;
    }
    CGContextRestoreGState(context);
}

@end
