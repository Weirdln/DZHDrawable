//
//  DZHKLineView.h
//  DzhIPhone
//
//  Created by Duanwwu on 14-6-20.
//
//

#import "DZHKLineDrawing.h"
#import "DZHAxisXDrawing.h"

@class DZHAxisYDrawing;

@interface DZHKLineView : UIScrollView<DZHKLineDrawingDataSource,DZHAxisXDrawingDataSource>
{
    DZHKLineDrawing                 *_kLineDrawing;
    DZHAxisXDrawing                 *_axisXDrawing;
    DZHAxisYDrawing                 *_axisYDrawing;
    UILabel                         *_tipLable;
}

@property (nonatomic, retain) NSArray *klines;

@property (nonatomic) CGFloat scale;//缩放比例

@property (nonatomic) CGFloat kLineWidth; //k线实体宽度

@property (nonatomic) CGFloat kLinePadding; //k线之间间距

@end

@interface DZHKLineView (abstract)

/**
 * 计算指定区域内可绘制k线的起始结束索引
 * @param rect 指定区域
 * @returns startIndex:绘制k线起始索引
 * @returns endIndex:绘制k线结束索引
 */
- (void)needDrawKLinesInRect:(CGRect)rect startIndex:(int *)startIndex endIndex:(int *)endIndex;

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