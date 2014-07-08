//
//  DZHCurveDrawing.m
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-1.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHMACurveDrawing.h"
#import "DZHMAModel.h"

@implementation DZHMACurveDrawing

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
    NSParameterAssert(self.drawingDataSource);
   
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 1.);
    
    NSArray *datas                  = [self.drawingDataSource datasForDrawing:self inRect:rect];
    for (DZHMAModel *model in datas)
    {
        NSInteger end               = model.count - 1;
        CGPoint *pts                = model.points;
        
        CGContextSetStrokeColorWithColor(context, model.color.CGColor);
        CGContextMoveToPoint(context, pts[0].x, pts[0].y);
        for (int i = 0; i < end; i++)
        {
            CGContextAddQuadCurveToPoint(context, pts[i].x, pts[i].y, (pts[i].x + pts[i+1].x) * 0.5, (pts[i].y + pts[i+1].y) * 0.5);
        }
        if (end > 0) CGContextAddLineToPoint(context, pts[end].x, pts[end].y);
        CGContextStrokePath(context);
    }
    CGContextRestoreGState(context);
}

@end
