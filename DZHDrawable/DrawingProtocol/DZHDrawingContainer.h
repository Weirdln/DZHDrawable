//
//  DZHDrawingContainer.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-6-26.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHDrawingCoordinateProvider.h"
#import "DZHDrawing.h"

/**
 * 绘制容器，用于管理绘制对象绘制位置
 */
@protocol DZHDrawingContainer <DZHDrawingCoordinateProvider,DZHDrawing>

/**
 * 在指定位置添加一个绘制对象
 * @param drawing 绘制对象
 * @param rect
 */
- (void)addDrawing:(id<DZHDrawing>)drawing atVirtualRect:(CGRect)rect;

/**
 * 将绘制对象的虚拟位置转换为当前进行绘制的实际区域，如在一个ScrollView上进行绘制时，滚动时绘制区域会变化，需进行转换
 * @param rect 虚拟的位置
 * @param currentRect 容器当前的绘制区域
 * @returns 图像绘制对象需要进行绘制的区域
 */
- (CGRect)realRectForVirtualRect:(CGRect)virtualRect currentRect:(CGRect)currentRect;

@end
