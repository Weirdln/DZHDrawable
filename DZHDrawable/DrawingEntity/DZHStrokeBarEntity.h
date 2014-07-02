//
//  DZHStrokeBarEntity.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-1.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//
#import "DZHFillBarEntity.h"

@interface DZHStrokeBarEntity : NSObject

@property (nonatomic, assign) CGPoint startPoint;/**起始点*/

@property (nonatomic, assign) CGPoint endPoint;/**结束点*/

@property (nonatomic, retain) UIColor *color;/**柱线颜色*/

@end