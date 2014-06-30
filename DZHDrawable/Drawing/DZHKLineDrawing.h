//
//  DZHKLineDrawing.h
//  DzhIPhone
//
//  Created by Duanwwu on 14-6-19.
//
//

#import "DZHKLineEntity.h"
#import "DZHDrawingBase.h"

@interface DZHKLineDrawing : DZHDrawingBase

/**
 * 设置不同k线绘制时的颜色
 * @param color 颜色
 * @param type k线类型，阳线、阴线、十字星
 */
- (void)setColor:(UIColor *)color forType:(KLineType)type;

/**
 * 获取不同k线绘制时的颜色
 * @param type k线类型，阳线、阴线、十字星
 * @returns 该类型k线绘制时颜色
 */
- (UIColor *)colorForType:(KLineType)type;

@end

