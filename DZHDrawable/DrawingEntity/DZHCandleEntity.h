//
//  DZHCandleEntity.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-6-30.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

@interface DZHCandleEntity : NSObject

@property (nonatomic, assign) CGRect barRect;/**开盘、收盘*/

@property (nonatomic, assign) CGRect stickRect;/**最高、最低*/

@property (nonatomic, retain) UIColor *color;/**蜡烛图颜色*/

@end
