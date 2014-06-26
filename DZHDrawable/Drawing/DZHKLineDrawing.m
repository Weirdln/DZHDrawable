//
//  DZHKLineDrawing.m
//  DzhIPhone
//
//  Created by Duanwwu on 14-6-19.
//
//

#import "DZHKLineDrawing.h"

#define kLineColorKey @"kLineColor"

@implementation DZHKLineDrawing
{
    NSMutableDictionary                 *_typeAttributes;
}

@synthesize maxPrice    = _maxPrice;
@synthesize minPrice    = _minPrice;
@synthesize kLineDatas  = _kLineDatas;

- (instancetype)init
{
    if (self = [super init])
    {
        _typeAttributes     = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_typeAttributes release];
    [_kLineDatas release];
    [super dealloc];
}

#pragma mark - 属性设置

- (void)setColor:(UIColor *)color forType:(KLineType)type
{
    [_typeAttributes setObject:color forKey:@(type)];
}

- (UIColor *)colorForType:(KLineType)type
{
    UIColor *color              = [_typeAttributes objectForKey:@(type)];
    return color ? color : [UIColor blackColor];
}

#pragma mark - 绘图方法

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
    NSParameterAssert(_dataSource);
    NSParameterAssert([_dataSource respondsToSelector:@selector(widthForKLine:)]);
    NSParameterAssert([_dataSource respondsToSelector:@selector(kLineDrawing:locationForIndex:)]);
    
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 1.);
    
    CGFloat kWidth              = [_dataSource widthForKLine:self];
    int max                     = self.maxPrice;
    int min                     = self.minPrice;
    
    NSUInteger startIndex       = self.fromIndex;   //绘制起始点
    NSUInteger endIndex         = self.toIndex;     //绘制结束点
    
    CGFloat topY                = rect.origin.y;
    CGFloat bottomY             = CGRectGetMaxY(rect);
    
    CGFloat open,close,high,low;
    
    for (NSUInteger i = startIndex; i <= endIndex; i++)
    {
        DZHKLineEntity *entity  = [_kLineDatas objectAtIndex:i];
        
        open                    = [self mappingAsixYValue:max min:min v:entity.open top:topY bottom:bottomY];
        close                   = [self mappingAsixYValue:max min:min v:entity.close top:topY bottom:bottomY];
        high                    = [self mappingAsixYValue:max min:min v:entity.high top:topY bottom:bottomY];
        low                     = [self mappingAsixYValue:max min:min v:entity.low top:topY bottom:bottomY];
        
        KLineType type          = [entity type];
        
        CGColorRef color        = [self colorForType:type].CGColor;
        CGFloat x               = [_dataSource kLineDrawing:self locationForIndex:i];
        CGRect fillRect         = CGRectMake(x, MIN(open, close), kWidth, MAX(ABS(open - close), 1.));
        CGFloat center          = CGRectGetMidX(fillRect);
        
//        CGMutablePathRef path   = CGPathCreateMutable();

        BOOL drawLine           = YES;//决定是否需要绘制最高点与最低点连成的线
        if (i == endIndex) //最后一根k线有可能超出范围，需要进行裁剪
        {
            CGFloat maxX        = CGRectGetMaxX(rect);
            
            if (CGRectGetMaxX(fillRect) > maxX)
            {
                CGFloat redundant   = CGRectGetMaxX(fillRect) - maxX;
                fillRect.size.width = MAX(fillRect.size.width - redundant, 0.);
                drawLine            = center + 1 < maxX;
            }
        }
        else if (i == startIndex)//第一根k线有可能超出范围，需要进行裁剪
        {
            if (x < rect.origin.x)
            {
                CGFloat redundant   = rect.origin.x - x;
                fillRect.size.width = MAX(fillRect.size.width - redundant, 0.);
                fillRect.origin.x   = rect.origin.x;
                drawLine            = center > rect.origin.x;
            }
        }
        
        CGContextSetFillColorWithColor(context, color);
        CGContextFillRect(context, fillRect);
        
        if (drawLine)
        {
            CGContextSetStrokeColorWithColor(context, color);
            CGContextAddLines(context, (CGPoint []){CGPointMake(center, high), CGPointMake(center, low)}, 2);
            CGContextStrokePath(context);
        }
    }
    
    CGContextRestoreGState(context);
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


