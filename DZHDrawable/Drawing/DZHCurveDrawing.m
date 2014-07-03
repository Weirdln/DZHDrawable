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
    
    NSArray *datas                  = [self.dataSource datasForDrawing:self inRect:rect];
    for (NSDictionary *dic in datas)
    {
        CGColorRef color            = ((UIColor *)[dic objectForKey:kCurveColorKey]).CGColor;
        int end                     = [[dic objectForKey:kCurvePointCountKey] intValue] - 1;
        CGPoint *pts                = [((NSValue *)[dic objectForKey:kCurvePointsKey]) pointerValue];
        
        CGContextSetStrokeColorWithColor(context, color);
        CGContextMoveToPoint(context, pts[0].x, pts[0].y);
        for (int i = 0; i < end; i++)
        {
            CGContextAddQuadCurveToPoint(context, pts[i].x, pts[i].y, (pts[i].x + pts[i+1].x) * 0.5, (pts[i].y + pts[i+1].y) * 0.5);
        }
        if (end > 0) CGContextAddLineToPoint(context, pts[end].x, pts[end].y);
        CGContextStrokePath(context);
        
        free(pts);
    }
    CGContextRestoreGState(context);
}

@end
