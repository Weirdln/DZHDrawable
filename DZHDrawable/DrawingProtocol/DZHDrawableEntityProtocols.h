//
//  DZHCandleStick.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-2.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

@protocol DZHDrawableMapping <NSObject>

/**
 * 计算value在最大值最小值之间的位置，0为最小值，1为最大值
 * @param value 值
 * @param max 最大值
 * @param min 最小值
 * @returns 位置
 */
- (float)positionForValue:(float)value max:(float)max min:(float)min;

@end

@protocol DZHCandleStick <NSObject>

- (float)openPosition;/**开盘点在绘制区域的位置，取值范围[0,1]，0为CGRectGetMaxY，1为CGRectGetMinY*/

- (float)closePosition;/**收盘点在绘制区域的位置，取值范围[0,1]，0为CGRectGetMaxY，1为CGRectGetMinY*/

- (float)highPosition;/**最高点点在绘制区域的位置，取值范围[0,1]，0为CGRectGetMaxY，1为CGRectGetMinY*/

- (float)lowPosition;/**最低点在绘制区域的位置，取值范围[0,1]，0为CGRectGetMaxY，1为CGRectGetMinY*/

- (CGFloat)stickLocationX;/**绘制起始点坐标*/

- (CGFloat)stickWidth;/**柱状图实体宽度*/

- (void)calculateStickPositionWithMaxPrice:(int)max minPrice:(int)min;/**计算开盘、收盘、最高、最低位置值*/

@end

@protocol DZHVolumeBar <NSObject>

- (float)volumeBarPosition;/**柱图在绘制区域的位置，取值范围[0,1]，0为CGRectGetMaxY，1为CGRectGetMinY*/

- (CGFloat)volumeLocationX;/**柱图x点坐标*/

- (CGFloat)volumeBarWidth;/**柱宽度*/

- (void)calculateVolumePositionWithMaxVolume:(int)max minVolume:(int)min;/**计算柱结束值位置*/

@end

@protocol DZHMACurve <NSObject>

/**
 * 设置指定周期的ma最大值、最小值
 * @param maxMa ma最大值
 * @param minMa ma最小值
 * @param cycle ma周期
 */
- (void)setMaxMa:(int)maxMa minMa:(int)minMa withCycle:(NSInteger)cycle;

/**
 * 指定周期的ma最大值
 * @param cycle ma周期
 */
- (int)maxMaWithCycle:(NSInteger)cycle;

/**
 * 指定周期的ma最小值
 * @param cycle ma周期
 */
- (int)minMaWithCycle:(NSInteger)cycle;

- (NSArray *)maPositionsWithCycle:(NSInteger)cycle;/**曲线点位置集合，集合项取值范围[0,1]，0为CGRectGetMaxY，1为CGRectGetMinY*/

- (CGFloat)maStartXWithCycle:(NSInteger)cycle;/**曲线绘制起始位置*/

- (CGFloat)curveXStrip;/**每个点x坐标间隔*/

@end
