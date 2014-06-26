//
//  DZHGridLineDrawing.m
//  DzhIPhone
//
//  Created by Duanwwu on 14-6-23.
//
//

#import "DZHAxisYDrawing.h"
#import <CoreText/CoreText.h>

@implementation DZHAxisYDrawing

@synthesize scale           = _scale;
@synthesize formatter       = _formatter;
@synthesize lineColor       = _lineColor;
@synthesize labelFont       = _labelFont;
@synthesize labelColor      = _labelColor;
@synthesize maxTickCount    = _maxTickCount;
@synthesize minTickCount    = _minTickCount;
@synthesize strip           = _strip;
@synthesize tickCount       = _tickCount;
@synthesize tickLabelWidth  = _tickLabelWidth;
@synthesize max             = _max;
@synthesize min             = _min;

- (void)dealloc
{
    [_lineColor release];
    [_labelColor release];
    [_labelFont release];
    [_formatter release];
    [super dealloc];
}

- (void)prepareAndAdjustMaxIfNeedWithMax:(int *)max min:(int *)min
{
    int strip;
    int maxValue    = *max;
    int count       = [self _tickCountWithMax:maxValue min:*min strip:&strip];
    
    while (count == NSIntegerMax)
    {
        maxValue ++;
        NSLog(@"调整后的最大值为:%d",maxValue);
        count       = [self _tickCountWithMax:maxValue min:*min strip:&strip];
    }
    
    *max            = maxValue;
    self.max        = maxValue;
    self.min        = *min;
    self.tickCount  = count;
    self.strip      = strip;
}

- (int)_tickCountWithMax:(int)max min:(int)min strip:(int *)strip
{
    int v               = max - min;
    for (int i = _maxTickCount - 1; i >= _minTickCount - 1; i--)
    {
        if (v % i == 0)
        {
            *strip      = v / i;
            return i;
        }
    }
    return NSIntegerMax;
}

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
    NSParameterAssert(_tickCount != 0);
    NSParameterAssert(_lineColor != nil);
    NSParameterAssert(_labelColor != nil);
    NSParameterAssert(_labelFont != nil);
    NSParameterAssert(_formatter != nil);
    NSParameterAssert(_tickLabelWidth != 0);
    
    int max                         = self.max;
    int min                         = self.min;
    [self prepareAndAdjustMaxIfNeedWithMax:&max min:&min];
    
    int strip                       = self.strip;
    int tickCount                   = self.tickCount;
    CGFloat topY                    = rect.origin.y;
    CGFloat bottomY                 = CGRectGetMaxY(rect);
    CGFloat tickHeight              = [@"xx.xx" sizeWithFont:_labelFont constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height;
    
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 1.);
    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
    
    for (int i = 0; i <= tickCount; i++)
    {
        int value                   = _min + strip * i;
        
        CGFloat y                   = [self mappingAsixYValue:_max min:_min v:value top:topY bottom:bottomY];
        
        CGContextAddLines(context, (CGPoint[]){CGPointMake(rect.origin.x + _tickLabelWidth, y),CGPointMake(CGRectGetMaxX(rect), y)}, 2);
        CGContextStrokePath(context);
        
        CGFloat tickPosition;
        if (i == 0)
            tickPosition            = y - tickHeight;
        else if (i == tickCount)
            tickPosition            = y;
        else
            tickPosition            = y - tickHeight * .5;
        
        CGRect tickRect             = CGRectMake(rect.origin.x , tickPosition, _tickLabelWidth, tickHeight);
        NSString *str               = [_formatter stringForObjectValue:@(value)];

        CGContextSaveGState(context);
        [self drawStrInRect:str
                                 rect:tickRect
                                 font:_labelFont
                                color:_labelColor
                            alignment:NSTextAlignmentLeft];
        CGContextRestoreGState(context);
    }
    
    CGContextRestoreGState(context);
}

- (void)drawStrInRect:(NSString *)str rect:(CGRect)rect font:(UIFont *)font color:(UIColor *)color alignment:(NSTextAlignment)alignment
{
	[color set];
	[str drawInRect:rect withFont:font lineBreakMode:NSLineBreakByClipping alignment:alignment];
}

- (float)mappingAsixYValue:(float)max min:(float)min v:(float)v top:(float)top bottom:(float)bottom
{
	float y;
	
	if (max == min)
		y = bottom;
	else if (v <= max && v >= min)
		y = bottom - (v - min)/(max - min)*(bottom - top);
	else
		y = (v < min) ? bottom : top;
	
	return y;
}

@end
