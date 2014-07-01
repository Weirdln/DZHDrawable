//
//  DZHAxisXDrawing.m
//  DzhIPhone
//
//  Created by Duanwwu on 14-6-24.
//
//

#import "DZHAxisXDrawing.h"
#import "DZHAxisEntity.h"

@implementation DZHAxisXDrawing

- (instancetype)init
{
    if (self = [super init])
    {
        self.axisType           = AxisTypeX;
    }
    return self;
}

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
    NSParameterAssert(self.dataSource);
    
    NSArray *datas              = [self.dataSource datasForDrawing:self];
    if ([datas count] == 0)
        return;
    
    DZHAxisEntity *entity       = [datas firstObject];
    CGFloat maxX                = CGRectGetMaxX(rect);
    CGFloat y                   = CGRectGetMaxY(rect) - self.labelSpace;
    
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 1.);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    
    CGSize size                 = [entity.labelText sizeWithFont:self.labelFont constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    CGFloat lastX               = CGFLOAT_MIN;
    CGColorRef textColor        = self.labelColor.CGColor;
    
    for (DZHAxisEntity *entity in datas)
    {
        CGFloat x               = entity.location.x;
        NSString *labelText     = entity.labelText;
        CGRect tickRect         = CGRectMake(x - size.width * .5, y, size.width, size.height);
        CGFloat centerX         = CGRectGetMidX(tickRect);
        
        if (tickRect.origin.x - lastX < size.width)
            continue;
        
        if (x > rect.origin.x && x < maxX) //只有在范围内的才绘制
        {
            CGContextAddLines(context, (CGPoint[]){CGPointMake(x, rect.origin.y), CGPointMake(x, y)}, 2);
            CGContextStrokePath(context);
        }
        
        if (self.labelSpace > 0 && centerX > rect.origin.x && CGRectGetMaxX(tickRect) <= maxX) //只有在范围内的才绘制
        {
            CGContextSaveGState(context);
            CGContextSetFillColorWithColor(context, textColor);
            [self drawStrInRect:labelText
                           rect:tickRect
                           font:self.labelFont
                      alignment:NSTextAlignmentLeft];
            CGContextRestoreGState(context);
            
            lastX               = tickRect.origin.x;
        }
    }
    CGContextRestoreGState(context);
}

@end

