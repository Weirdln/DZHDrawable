//
//  DZHKLineDataSource.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-6-30.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHDrawing.h"
#import "DZHKLineEntity.h"

@interface DZHKLineDataSource : NSObject<DZHDrawingDataSource>

@property (nonatomic, retain) NSArray *klines;

@property (nonatomic, retain) NSMutableArray *grouping;

@property (nonatomic) NSInteger startIndex;

@property (nonatomic) NSInteger endIndex;

@property (nonatomic) NSInteger max;

@property (nonatomic) NSInteger min;

@property (nonatomic) CGFloat scale;//缩放比例

@property (nonatomic) CGFloat minScale;

@property (nonatomic) CGFloat maxScale;

@property (nonatomic) CGFloat kLineWidth; //k线实体宽度

@property (nonatomic) CGFloat kLinePadding; //k线之间间距

@property (nonatomic) NSInteger minTickCount;/**y轴刻度最少个数*/

@property (nonatomic) NSInteger maxTickCount;/**y轴刻度最多个数*/

@property (nonatomic) NSInteger tickCount;/**刻度个数*/

@property (nonatomic) CGFloat kLineOffset;/**k线绘制区域在x轴上的偏移量*/

@end

@interface DZHKLineDataSource (Base)

/**
 * 绘制前的准备工作，计算绘制范围和最大值最小值
 * @param rect k线绘制范围
 */
- (void)prepareWithKLineRect:(CGRect)rect;

/**
 * 计算指定区域内可绘制k线的起始结束索引
 * @param rect 指定区域
 * @returns startIndex:绘制k线起始索引
 * @returns endIndex:绘制k线结束索引
 */
- (void)needDrawKLinesInRect:(CGRect)rect startIndex:(NSInteger *)startIndex endIndex:(NSInteger *)endIndex;

/**
 * 计算范围内k线数据的最大值最小值
 * @param from 计算开始索引
 * @param to 计算结束索引
 * @returns maxPrice 最大价格
 * @returns minPrice 最小价格
 */
- (void)calculateMaxPrice:(NSInteger *)maxPrice minPrice:(NSInteger *)minPrice fromIndex:(NSInteger)from toIndex:(NSInteger)to;

/**
 * @returns k线实体宽度＋k线间隔
 */
- (CGFloat)itemWidth;

/**
 * 绘制所有k线需要的宽度
 * @returns 总的宽度
 */
- (CGFloat)totalKLineWidth;

/**
 * 计算指定索引k线绘制的起始x坐标
 * @param index k线索引
 * @returns 绘制该k线的起始x坐标
 */
- (CGFloat)kLineLocationForIndex:(NSUInteger)index;

/**
 * 算指定索引k线的中点x坐标
 * @param index k线索引
 * @returns 该k线的中点x坐标
 */
- (CGFloat)kLineCenterLocationForIndex:(NSUInteger)index;

/**
 * 计算指定位置的点对应k线的索引，如果该位置没有k线则返回NSUIntegerMax。如两个k线之间的间隔，应返回NSUIntegerMax
 * @param position x坐标
 * @returns 该位置k线索引
 */
- (NSUInteger)indexForLocation:(CGFloat)position;

/**
 * 计算指定位置的点对应k线的索引，如果该位置没有k线则返回最接近的索引。
 * @param position x坐标
 * @returns 该位置k线索引
 */
- (NSUInteger)nearIndexForLocation:(CGFloat)position;

@end

/**
 * 对k线数据进行分组,分组以一个月为单位
 */
@interface DZHKLineDataSource (AxisX)

- (NSArray *)axisXDatasForDrawing:(id<DZHDrawing>)drawing;

- (void)decisionGroupIfNeedWithPreEntity:(DZHKLineEntity *)preEntity curEntity:(DZHKLineEntity *)curEntity index:(int)index;

- (NSArray *)groupsFromIndex:(NSInteger)from toIndex:(NSInteger)to monthInterval:(int)interval;

@end

@interface DZHKLineDataSource (AxisY)

- (NSArray *)axisYDatasForDrawing:(id<DZHDrawing>)drawing;

- (void)adjustMaxIfNeed:(NSInteger *)tickCount strip:(NSInteger *)strip;

- (NSInteger)tickCountWithMax:(NSInteger)max min:(NSInteger)min strip:(NSInteger *)strip;

@end

@interface DZHKLineDataSource (KLine)

- (NSArray *)kLineDatasForDrawing:(id<DZHDrawing>)drawing;

@end
