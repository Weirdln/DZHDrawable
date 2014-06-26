//
//  DZHAxisXDrawing.m
//  DzhIPhone
//
//  Created by Duanwwu on 14-6-24.
//
//

#import "DZHAxisXDrawing.h"
#import "DZHKLineEntity.h"

@implementation DZHAxisXDrawing

@synthesize formatter   = _formatter;
@synthesize lineColor   = _lineColor;
@synthesize labelFont   = _labelFont;
@synthesize labelColor  = _labelColor;

- (void)dealloc
{
    [_formatter release];
    [_labelColor release];
    [_labelFont release];
    [_lineColor release];
    
    [_groups release];
    [super dealloc];
}

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
    NSParameterAssert(_formatter != nil);
    NSParameterAssert(_labelColor != nil);
    NSParameterAssert(_labelFont != nil);
    NSParameterAssert(_lineColor != nil);
    NSParameterAssert(_groups != nil);
    NSParameterAssert(_dataSource);
    NSParameterAssert([_dataSource respondsToSelector:@selector(axisXDrawing:locationForIndex:)]);
    
    DZHDrawingGroup *group      = [_groups firstObject];
    if (!group)
        return;

    CGFloat maxX                = CGRectGetMaxX(rect);
    CGFloat y                   = CGRectGetMaxY(rect) - _labelHeight;
    
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 1.);
    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
    
    NSString *date              = [_formatter stringForObjectValue:@(group.date)];
    CGSize size                 = [date sizeWithFont:_labelFont constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    CGFloat lastX               = CGFLOAT_MIN;
    CGColorRef textColor        = _labelColor.CGColor;
    
    for (DZHDrawingGroup *group in _groups)
    {
        int index               = group.endIndex;
        CGFloat x               = [_dataSource axisXDrawing:self locationForIndex:index];
        CGRect tickRect         = CGRectMake(x - size.width * .5, y, size.width, size.height);
        CGFloat centerX         = CGRectGetMidX(tickRect);
        
        if (tickRect.origin.x - lastX < size.width)
            continue;
        
        NSLog(@"x轴日期:%d",group.date);
        
        if (x > rect.origin.x && x < maxX) //只有在范围内的才绘制
        {
            CGContextAddLines(context, (CGPoint[]){CGPointMake(x, rect.origin.y), CGPointMake(x, y)}, 2);
        }
        
        if (_labelHeight > 0 && centerX > rect.origin.x && CGRectGetMaxX(tickRect) <= maxX) //只有在范围内的才绘制
        {
            NSLog(@"显示   x轴日期:%d",group.date);
            NSString *date      = [_formatter stringForObjectValue:@(group.date)];
            
            CGContextSaveGState(context);
            CGContextSetFillColorWithColor(context, textColor);
            [self drawStrInRect:date
                           rect:tickRect
                           font:_labelFont
                      alignment:NSTextAlignmentLeft];
            CGContextRestoreGState(context);
            
            lastX               = tickRect.origin.x;
        }
    }
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

- (void)drawStrInRect:(NSString *)str rect:(CGRect)rect font:(UIFont *)font alignment:(NSTextAlignment)alignment
{
	[str drawInRect:rect withFont:font lineBreakMode:NSLineBreakByClipping alignment:alignment];
}

@end

