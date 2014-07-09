//
//  DZHRSICalculator.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-8.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHDataTraveler.h"

@interface DZHRSICalculator : NSObject<DZHDataTraveler>

- (instancetype)initWithRSI1:(int)rsiDay1 RSI2:(int)rsiDay2 RSI3:(int)rsiDay3;

@property (nonatomic) int RSIDay1;

@property (nonatomic) int RSIDay2;

@property (nonatomic) int RSIDay3;

@end
