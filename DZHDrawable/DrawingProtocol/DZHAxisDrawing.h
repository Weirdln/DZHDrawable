//
//  DZHAxisDrawing.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-6-26.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHDrawing.h"

/**
 * 坐标轴绘制对象
 */
@protocol DZHAxisDrawing <DZHDrawing>

/**格式化数据，通过数据获取绘制文本*/
@property (nonatomic, retain) NSFormatter *formatter;

/**线条颜色*/
@property (nonatomic, retain) UIColor *lineColor;

/**文字颜色*/
@property (nonatomic, retain) UIColor *labelColor;

/**文字字体*/
@property (nonatomic, retain) UIFont *labelFont;

@end
