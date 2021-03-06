//
//  DZHAxisDrawing.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-6-26.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHDrawing.h"

@protocol DZHAxisDrawingDataSource;

/**
 * 坐标轴绘制对象
 */
@protocol DZHAxisDrawing <DZHDrawing>

/**线条颜色*/
@property (nonatomic, retain) UIColor *lineColor;

/**文字颜色*/
@property (nonatomic, retain) UIColor *labelColor;

/**文字字体*/
@property (nonatomic, retain) UIFont *labelFont;

/**x轴为文字高度，y轴为文字宽度*/
@property (nonatomic, assign) int labelSpace;

@end

