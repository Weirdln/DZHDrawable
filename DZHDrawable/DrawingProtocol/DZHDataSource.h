//
//  DZHDrawingDataSource.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-7.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

@protocol DZHDataProviderContextProtocol <NSObject>

@property (nonatomic) NSInteger fromIndex;
@property (nonatomic) NSInteger toIndex;

@property (nonatomic) CGFloat itemWidth;
@property (nonatomic) CGFloat itemPadding;
@property (nonatomic) CGFloat startLocation;

@property (nonatomic, retain) NSArray *datas;
@property (nonatomic) NSInteger itemCount;

@property (nonatomic) CGFloat scale;

- (CGFloat)totalWidth;

- (CGFloat)locationForIndex:(NSUInteger)index;

- (CGFloat)centerLocationForIndex:(NSUInteger)index;

- (NSUInteger)nearIndexForLocation:(CGFloat)position;

- (void)calculateFromAndToIndexWithRect:(CGRect)rect;

@end

@protocol DZHColorDataProviderProtocol <NSObject>

- (UIColor *)colorForKLineType:(KLineType)kType;

- (UIColor *)colorForMACycle:(KLineCycle)cycle;


- (UIColor *)colorForVolumeType:(VolumeType)volumeType;

- (UIColor *)colorForVolumeMACycle:(KLineCycle)cycle;


- (UIColor *)colorForMACDLineType:(MACDLineType)type;

- (UIColor *)colorForMACDType:(MACDType)type;


- (UIColor *)colorForKDJType:(KDJLineType)KDJType;

@end

@protocol DZHDataProviderProtocol <NSObject>

@property (nonatomic, retain) id<DZHDataProviderContextProtocol> context;
@property (nonatomic, retain) id<DZHColorDataProviderProtocol> colorProvider;

/**
 * 初始化或者更改数据的时候，计算、设置关键值，如MA数据源，计算各个周期MA的值
 */
- (void)setupPropertyWhenTravelLastData:(id)lastData currentData:(id)curData index:(NSInteger)index;

/**
 * 计算最大值最小值
 */
- (void)setupMaxAndMinWhenTravelLastData:(id)lastData currentData:(id)data index:(NSInteger)index;

@optional

/**
 * 横坐标数据
 */
- (NSArray *)axisXDatasWithContext:(id<DZHDataProviderContextProtocol>)context top:(CGFloat)top bottom:(CGFloat)bottom;

/**
 * 纵坐标数据
 */
- (NSArray *)axisYDatasWithContext:(id<DZHDataProviderContextProtocol>)context top:(CGFloat)top bottom:(CGFloat)bottom;

/**
 * 绘制项数据
 */
- (NSArray *)itemDatasWithContext:(id<DZHDataProviderContextProtocol>)context top:(CGFloat)top bottom:(CGFloat)bottom;

/**
 * 额外数据，如k线、量线的平均线。
 */
- (NSArray *)extendDatasWithContext:(id<DZHDataProviderContextProtocol>)context top:(CGFloat)top bottom:(CGFloat)bottom;

@end
