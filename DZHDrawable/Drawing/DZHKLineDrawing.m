//
//  DZHKLineDrawing.m
//  DzhIPhone
//
//  Created by Duanwwu on 14-6-19.
//
//

#import "DZHKLineDrawing.h"
#import "DZHDrawingItemModels.h"

@implementation DZHKLineDrawing

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
    NSParameterAssert(self.dataSource);
    
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 1.);
    
    NSArray *datas                  = [self.dataSource datasForDrawing:self inRect:rect];

    for (id<DZHCandleStick> entity in datas)
    {
        CGContextSetFillColorWithColor(context, entity.stickColor.CGColor);
        CGContextAddRect(context, entity.solidRect);
        CGContextAddRect(context, entity.stickRect);
        CGContextFillPath(context);
        CGContextStrokePath(context);
    }
    CGContextRestoreGState(context);
}

@end


