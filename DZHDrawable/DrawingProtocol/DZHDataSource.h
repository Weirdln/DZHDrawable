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

@protocol DZHDataProviderProtocol <NSObject>

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
 * 计算绘制起始结束索引
 */
- (void)setupStartAndEndIndexInRect:(CGRect)rect withParameter:(id<DZHDataProviderContextProtocol>)param;

/**
 * 横坐标数据
 */
- (NSArray *)axisXDatasWithParameter:(id<DZHDataProviderContextProtocol>)param top:(CGFloat)top bottom:(CGFloat)bottom;

/**
 * 纵坐标数据
 */
- (NSArray *)axisYDatasWithParameter:(id<DZHDataProviderContextProtocol>)param top:(CGFloat)top bottom:(CGFloat)bottom;

/**
 * 绘制项数据
 */
- (NSArray *)itemDatasWithParameter:(id<DZHDataProviderContextProtocol>)param top:(CGFloat)top bottom:(CGFloat)bottom;

/**
 * 额外数据，如k线、量线的平均线。
 */
- (NSArray *)extendDatasWithParameter:(id<DZHDataProviderContextProtocol>)param top:(CGFloat)top bottom:(CGFloat)bottom;

@end
