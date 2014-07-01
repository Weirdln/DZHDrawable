//
//  DZHCandleEntity.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-6-30.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

@interface DZHCandleEntity : NSObject

@property (nonatomic, assign) CGRect fillRect;/**填充矩形*/

@property (nonatomic, assign) CGPoint high;/**最高点*/

@property (nonatomic, assign) CGPoint low;/**最低点*/

@property (nonatomic, retain) UIColor *color;/**蜡烛图颜色*/

@end
