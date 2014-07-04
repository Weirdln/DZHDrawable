//
//  DZHDrawingUtil.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-3.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZHDrawingUtil : NSObject

/**
 * 计算值的y坐标
 */
+ (CGFloat)locationYForValue:(float)v withMax:(float)max min:(float)min top:(CGFloat)top bottom:(CGFloat)bottom;

@end
