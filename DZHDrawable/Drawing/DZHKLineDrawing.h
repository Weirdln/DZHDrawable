//
//  DZHKLineDrawing.h
//  DzhIPhone
//
//  Created by Duanwwu on 14-6-19.
//
//

#import <Foundation/Foundation.h>
#import "DZHDrawing.h"
#import "DZHKLineEntity.h"

@protocol DZHKLineDrawingDataSource <NSObject>

- (CGFloat)widthForKLine:(id<DZHKLineDrawing>)drawing;

- (CGFloat)kLineDrawing:(id<DZHKLineDrawing>)drawing locationForIndex:(NSUInteger)index;

@end

@interface DZHKLineDrawing : NSObject<DZHKLineDrawing>

@property (nonatomic, assign) id<DZHKLineDrawingDataSource> dataSource;

/**k线数据起始索引*/
@property (nonatomic) NSUInteger fromIndex;

/**k线数据结束索引*/
@property (nonatomic) NSUInteger toIndex;

#pragma mark - 属性设置

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

