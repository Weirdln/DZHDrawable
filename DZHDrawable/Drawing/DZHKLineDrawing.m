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
    
    NSArray *datas                  = [self.dataSource datasForDrawing:self];
    NSInteger i                     = 0;
    NSInteger endIndex              = [datas count] - 1;
    CGColorRef color;
    CGRect fillRect;
    CGFloat x;
    CGPoint high,low;
    
    for (DZHCandleEntity *entity in datas)
    {
        color                       = entity.color.CGColor;
        fillRect                    = entity.fillRect;
        x                           = fillRect.origin.x;
        high                        = entity.high;
        low                         = entity.low;
        
//        BOOL drawLine               = YES;      //决定是否需要绘制最高点与最低点连成的线
//        if (i == endIndex)                      //最后一根k线有可能超出范围，需要进行裁剪
//        {
//            CGFloat maxX            = CGRectGetMaxX(rect);
//            
//            if (CGRectGetMaxX(fillRect) > maxX)
//            {
//                CGFloat redundant   = CGRectGetMaxX(fillRect) - maxX;
//                fillRect.size.width = MAX(fillRect.size.width - redundant, 0.);
//                drawLine            = high.x + 1 < maxX;
//            }
//        }
//        else if (i == 0)                        //第一根k线有可能超出范围，需要进行裁剪
//        {
//            if (x < rect.origin.x)
//            {
//                CGFloat redundant   = rect.origin.x - x;
//                fillRect.size.width = MAX(fillRect.size.width - redundant, 0.);
//                fillRect.origin.x   = rect.origin.x;
//                drawLine            = high.x > rect.origin.x;
//            }
//        }
        
        BOOL draw                   = YES;
        if (i == endIndex && CGRectGetMaxX(fillRect) > CGRectGetMaxX(rect)) //最后一根k线部分超出范围，不绘制
        {
            draw            = NO;
        }
        else if (i == 0 && CGRectGetMinX(fillRect) < CGRectGetMinX(rect))   //第一根k线部分超出范围，不绘制
        {
            draw            = NO;
        }
        
        if (draw)
        {
            CGContextSetFillColorWithColor(context, color);
            CGContextFillRect(context, fillRect);
            
            CGContextSetStrokeColorWithColor(context, color);
            CGContextAddLines(context, (CGPoint []){high, low}, 2);
            CGContextStrokePath(context);
        }
        i ++ ;
    }
    CGContextRestoreGState(context);
}

@end


