//
//  DZHGridLineDrawing.m
//  DzhIPhone
//
//  Created by Duanwwu on 14-6-23.
//
//

#import "DZHAxisYDrawing.h"
#import "DZHAxisEntity.h"

@implementation DZHAxisYDrawing

- (instancetype)init
{
    if (self = [super init])
    {
        self.axisType           = AxisTypeY;
    }
    return self;
}

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
    NSParameterAssert(self.lineColor != nil);
    NSParameterAssert(self.labelColor != nil);
    NSParameterAssert(self.labelFont != nil);
    NSParameterAssert(self.dataSource != nil);
    
    NSArray *datas                  = [self.dataSource datasForDrawing:self];
    if ([datas count] == 0)
        return;
    
    CGFloat tickHeight              = [@"xx.xx" sizeWithFont:self.labelFont constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
    NSInteger end                   = [datas count] - 1;
    NSInteger idx                   = 0;
    
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 1.);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetFillColorWithColor(context, self.labelColor.CGColor);
    
    for (DZHAxisEntity *entity in datas)
    {
        CGFloat y                   = entity.location.y;
        NSString *labelText         = entity.labelText;
        
        CGContextAddLines(context, (CGPoint[]){CGPointMake(rect.origin.x + self.labelSpace, y),CGPointMake(CGRectGetMaxX(rect), y)}, 2);
        CGContextStrokePath(context);
        
        CGFloat tickPosition;
        if (idx == 0)
            tickPosition            = y - tickHeight;
        else if (idx == end)
            tickPosition            = y;
        else
            tickPosition            = y - tickHeight * .5;
        
        if (self.labelSpace > 0)
        {
            CGRect tickRect             = CGRectMake(rect.origin.x , tickPosition, self.labelSpace, tickHeight);
            
            [self drawStrInRect:labelText
                           rect:tickRect
                           font:self.labelFont
                      alignment:NSTextAlignmentRight];
        }
        
        idx ++;
    }
    CGContextRestoreGState(context);
}

@end
