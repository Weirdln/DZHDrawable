//
//  DZHCurveDrawing.m
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-1.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHCurveDrawing.h"

@implementation DZHCurveDrawing

NSString * const kCurveColorKey         = @"CurveColor";
NSString * const kCurvePointsKey        = @"CurvePoints";
NSString * const kCurvePointCountKey    = @"CurveCount";

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
    NSParameterAssert(self.dataSource);
   
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 1.);
    
    NSArray *datas                  = [self.dataSource datasForDrawing:self];
    for (NSDictionary *dic in datas)
    {
        CGColorRef color            = ((UIColor *)[dic objectForKey:kCurveColorKey]).CGColor;
        int count                   = [[dic objectForKey:kCurvePointCountKey] intValue];
        CGPoint *pts                = [((NSValue *)[dic objectForKey:kCurvePointsKey]) pointerValue];
        
        int begin                   = 0;
        int end                     = count - 1;
        if (pts[0].x <= CGRectGetMinX(rect))
            begin                   = 1;
        if (pts[end].x >= CGRectGetMaxX(rect))
            end                     -= 1;
        
        CGContextSetStrokeColorWithColor(context, color);
        CGContextMoveToPoint(context, pts[begin].x, pts[begin].y);
        for (int i = begin; i < end; i++)
        {
            CGContextAddQuadCurveToPoint(context, pts[i].x, pts[i].y, (pts[i].x + pts[i+1].x) * 0.5, (pts[i].y + pts[i+1].y) * 0.5);
        }
        if (end > 1) CGContextAddLineToPoint(context, pts[end].x, pts[end].y);
        CGContextStrokePath(context);
        
        free(pts);
    }
    CGContextRestoreGState(context);
}

@end
