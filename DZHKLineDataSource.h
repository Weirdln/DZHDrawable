//
//  DZHKLineDataSource.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-6-30.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHDrawing.h"
#import "DZHDrawingItemModel.h"

typedef enum
{
    DrawingTagsKLineX,
    DrawingTagsKLineY,
    DrawingTagsKLineItem,
    DrawingTagsVolumeX,
    DrawingTagsVolumeY,
    DrawingTagsVolumeItem,
    DrawingTagsMa,
    DrawingTagsVolumeMa,
}DrawingTags;

typedef enum
{
    KLineCycleFive          = 5,
    KLineCycleTen           = 10,
    KLineCycleTwenty        = 20,
}KLineCycle;

@interface DZHKLineDataSource : NSObject<DZHDrawingDataSource>

@property (nonatomic, retain) NSArray *klines;

@property (nonatomic, retain) NSMutableArray *grouping;

@property (nonatomic) NSInteger startIndex;

@property (nonatomic) NSInteger endIndex;

@property (nonatomic) NSInteger maxPrice;

@property (nonatomic) NSInteger minPrice;

@property (nonatomic) NSInteger maxVol;

@property (nonatomic) CGFloat scale;//缩放比例

@property (nonatomic) CGFloat minScale;

@property (nonatomic) CGFloat maxScale;

@property (nonatomic) CGFloat kLineWidth; //k线实体宽度

@property (nonatomic) CGFloat kLinePadding; //k线之间间距

@property (nonatomic) NSInteger minTickCount;/**y轴刻度最少个数*/

@property (nonatomic) NSInteger maxTickCount;/**y轴刻度最多个数*/

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
 */
- (void)calculateStartAndEndIndexAtRect:(CGRect)rect;

/**
 * 计算范围内k线数据的最大值最小值
 * @param from 计算开始索引
 * @param to 计算结束索引
 */
- (void)calculateMaxAndMinDataFromIndex:(NSInteger)from toIndex:(NSInteger)to;

/**
 * k线宽度 包括k线实体和k线间隔
 * @returns 每根k线总宽度
 */
- (CGFloat)kItemWidth;

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
 * 计算指定位置的点对应k线的索引，如果该位置没有k线则返回最接近的索引。
 * @param position x坐标
 * @returns 该位置k线索引
 */
- (NSUInteger)nearIndexForLocation:(CGFloat)position;

/**
 * 计算最接近的能被k线宽度整除的坐标
 * @param position 位置
 * @returns 最接近的k线宽度整数倍坐标
 */
- (CGFloat)nearTimesLocationForLocation:(CGFloat)position;

- (NSInteger)MAStartIndexWithIndex:(NSInteger)index cycle:(int)cycle;

@end

/**
 * 获取不同k线类型绘制的颜色
 */
@interface DZHKLineDataSource (Color)

- (UIColor *)corlorForType:(KLineType)type;

@end

/**
 * 对k线数据进行分组,分组以一个月为单位
 */
@interface DZHKLineDataSource (AxisX)

- (NSArray *)axisXDatasForDrawing:(id<DZHDrawing>)drawing inRect:(CGRect)rect;

- (void)decisionGroupIfNeedWithPreDate:(int)preDate curDate:(int)curDate index:(int)index;

- (NSArray *)groupsFromIndex:(NSInteger)from toIndex:(NSInteger)to monthInterval:(int)interval;

@end

@interface DZHKLineDataSource (AxisY)

- (NSArray *)axisYDatasForDrawing:(id<DZHDrawing>)drawing inRect:(CGRect)rect;

- (void)adjustMaxIfNeed:(NSInteger *)tickCount strip:(NSInteger *)strip;

- (NSInteger)tickCountWithMax:(NSInteger)max min:(NSInteger)min strip:(NSInteger *)strip;

@end

@interface DZHKLineDataSource (KLine)

- (NSArray *)kLineDatasForDrawing:(id<DZHDrawing>)drawing inRect:(CGRect)rect;

@end

@interface DZHKLineDataSource (VolumeAxisY)

- (NSArray *)axisYDatasForVolumeDrawing:(id<DZHDrawing>)drawing inRect:(CGRect)rect;

@end

@interface DZHKLineDataSource (Volume)

- (NSArray *)volumeDatasForVolumeDrawing:(id<DZHDrawing>)drawing inRect:(CGRect)rect;

@end

@interface DZHKLineDataSource (MA)

- (NSArray *)maDatasForMaDrawing:(id<DZHDrawing>)drawing inRect:(CGRect)rect;

@end

@interface DZHKLineDataSource (VolumeMA)

- (NSArray *)volumeMADatasForMaDrawing:(id<DZHDrawing>)drawing inRect:(CGRect)rect;

@end
