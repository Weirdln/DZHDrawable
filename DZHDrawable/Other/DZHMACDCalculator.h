//
//  DZHMACDCalculator.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-4.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHDataTraveler.h"

@interface DZHMACDCalculator : NSObject<DZHDataTraveler>

- (instancetype)initWithEMAFastDay:(int)fast slowDay:(int)slow difDay:(int)difDay;

@property (nonatomic) int fastDay;/**快速移动平均值周期*/

@property (nonatomic) int slowDay;/**慢速移动平均值周期*/

@property (nonatomic) int difDay;

@end
