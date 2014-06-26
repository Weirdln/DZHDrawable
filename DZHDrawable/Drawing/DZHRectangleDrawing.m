//
//  DZHRectangleDrawing.m
//  DzhIPhone
//
//  Created by Duanwwu on 14-6-25.
//
//

#import "DZHRectangleDrawing.h"

@implementation DZHRectangleDrawing

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
    CGContextSetLineWidth(context, 1.);
    CGContextStrokeRect(context, rect);
    CGContextRestoreGState(context);
}

@end
