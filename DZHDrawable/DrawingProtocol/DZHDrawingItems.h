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

- (int)volume;

@end

/**
 * 柱状图绘制项
 */
@protocol DZHBarItem <DZHDrawingItemProtocol>

@property (nonatomic, assign) CGRect barRect;/**柱*/

@property (nonatomic, retain) UIColor *barFillColor;/**柱填充颜色*/

@end

/**
 * 曲线绘制项
 */
@protocol DZHCurveItem <NSObject>

@property (nonatomic, retain) UIColor *curveColor;

@property (nonatomic) CGPoint *points;

@property (nonatomic) NSInteger count;

@end

/**
 * 均线绘制项
 */
@protocol DZHMACurve <DZHDrawingItemProtocol>

- (void)setMA:(int)ma withCycle:(int)cycle;

- (int)MAWithCycle:(int)cycle;

@end

/**
 * 成交量均线绘制项
 */
@protocol DZHVolumeMACurve <DZHDrawingItemProtocol>

- (void)setVolumeMA:(int)ma withCycle:(int)cycle;

- (int)volumeMAWithCycle:(int)cycle;

@end

/**
 * 指数平滑异同平均线绘制项
 */
@protocol DZHMACD <DZHDrawingItemProtocol>

@property (nonatomic) int DIF;

@property (nonatomic) int DEA;

@property (nonatomic) int MACD;

@end
