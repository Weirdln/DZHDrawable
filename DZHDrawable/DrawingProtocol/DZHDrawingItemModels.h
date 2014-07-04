//
//  DZHCandleStick.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-2.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

/**
 * 绘制项接口，一个完整的图像，是由一串绘制项数据经过绘制加工而生成
 */
@protocol DZHDrawingItemProtocol <NSObject>

@property (nonatomic) CGFloat locationX;

@property (nonatomic) CGFloat itemWidth;

/**
 * 计算值的y坐标
 */
- (CGFloat)locationYForValue:(float)v withMax:(float)max min:(float)min top:(CGFloat)top bottom:(CGFloat)bottom;

@end

/**
 * k线绘制项
 */
@protocol DZHCandleStick <DZHDrawingItemProtocol>

@property (nonatomic, assign) CGRect solidRect;/**开盘、收盘*/

@property (nonatomic, assign) CGRect stickRect;/**最高、最低*/

@property (nonatomic, retain) UIColor *stickColor;/**蜡烛图颜色*/

- (int)open;

- (int)close;

- (int)high;

- (int)low;

- (int)date;

- (int)type;

@end

/**
 * 成交量绘制项
 */
@protocol DZHVolumeBar <DZHDrawingItemProtocol>

- (int)volume;

@property (nonatomic, assign) CGRect volumeRect;/**柱*/

@property (nonatomic, retain) UIColor *volumeColor;/**柱填充颜色*/

@end

/**
 * 均线绘制项
 */
@protocol DZHMACurve <DZHDrawingItemProtocol>

- (void)setMA:(int)ma withCycle:(int)cycle;

- (int)MAWithCycle:(int)cycle;

- (void)setMAPoint:(CGPoint)point withCycle:(int)cycle;

- (CGPoint)MAPointWithCycle:(int)cycle;

@end

/**
 * 成交量均线绘制项
 */
@protocol DZHVolumeMACurve <DZHDrawingItemProtocol>

- (void)setVolumeMA:(int)ma withCycle:(int)cycle;

- (int)volumeMAWithCycle:(int)cycle;

- (void)setVolumeMAPoint:(CGPoint)point withCycle:(int)cycle;

- (CGPoint)volumeMAPointWithCycle:(int)cycle;

@end
