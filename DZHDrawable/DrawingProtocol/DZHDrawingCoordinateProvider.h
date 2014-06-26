//
//  DZHDrawingCoordinateProvider.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-6-26.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 图像绘制对象坐标提供接口
 */
@protocol DZHDrawingCoordinateProvider <NSObject>

/**
 * 该索引数据对应的绘制起始位置x坐标
 * @param index 数据索引
 */
- (int)beginCoordXForIndex:(NSUInteger)index;

/**
 * 该索引数据对应的绘制中点x坐标
 * @param index 数据索引
 */
- (int)centerCoordXForIndex:(NSUInteger)index;

@end
