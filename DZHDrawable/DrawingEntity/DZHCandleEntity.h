//
//  DZHCandleEntity.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-6-30.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHKLineEntity.h"

@interface DZHCandleEntity : NSObject

/**填充矩形*/
@property (nonatomic, assign) CGRect fillRect;

/**最高点*/
@property (nonatomic, assign) CGPoint high;

/**最低点*/
@property (nonatomic, assign) CGPoint low;

@property (nonatomic, assign) int kLineType;

@end
