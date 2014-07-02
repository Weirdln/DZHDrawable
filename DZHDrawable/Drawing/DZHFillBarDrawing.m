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
    
    NSArray *datas                  = [self.dataSource datasForDrawing:self];
    NSInteger i                     = 0;
    NSInteger endIndex              = [datas count] - 1;
    CGColorRef color;
    CGRect fillRect;
    CGFloat x;
    
    for (DZHFillBarEntity *entity in datas)
    {
        color                       = entity.color.CGColor;
        fillRect                    = entity.barRect;
        x                           = fillRect.origin.x;
        
        BOOL draw                   = YES;
        if (i == endIndex && CGRectGetMaxX(fillRect) > CGRectGetMaxX(rect)) //最后一根k线部分超出范围，不绘制
        {
            draw            = NO;
        }
        else if (i == 0 && CGRectGetMinX(fillRect) < CGRectGetMinX(rect))   //第一根k线部分超出范围，不绘制
        {
            draw            = NO;
        }
        
        if (draw)
        {
            CGContextSetFillColorWithColor(context, color);
            CGContextFillRect(context, fillRect);
        }
        i ++ ;
    }
    CGContextRestoreGState(context);
}

@end
