//
//  DZHKDJCalculator.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-8.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHDataTraveler.h"

@interface DZHKDJCalculator : NSObject<DZHDataTraveler>

- (instancetype)initWithKDay:(int)kDay DDay:(int)dDay rsvDay:(int)rsvDay;

@property (nonatomic) int kDay;

@property (nonatomic) int dDay;

@property (nonatomic) int rsvDay;

@end
