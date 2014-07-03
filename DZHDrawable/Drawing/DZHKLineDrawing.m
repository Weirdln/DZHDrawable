//
//  DZHKLineDrawing.m
//  DzhIPhone
//
//  Created by Duanwwu on 14-6-19.
//
//

#import "DZHKLineDrawing.h"
#import "DZHCandleEntity.h"

@implementation DZHKLineDrawing

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
    NSParameterAssert(self.dataSource);
    
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 1.);
    
    NSArray *datas                  = [self.dataSource datasForDrawing:self inRect:rect];

    for (DZHCandleEntity *entity in datas)
    {
        CGContextSetFillColorWithColor(context, entity.color.CGColor);
        CGContextAddRect(context, entity.barRect);
        CGContextAddRect(context, entity.stickRect);
        CGContextFillPath(context);
        CGContextStrokePath(context);
    }
    CGContextRestoreGState(context);
}

@end


