//
//  DZHVolumeMACalculator.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-4.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHDataTraveler.h"

@interface DZHVolumeMACalculator : NSObject<DZHDataTraveler>

@property (nonatomic) int cycle;

- (instancetype)initWithMACycle:(int)cycle;

@end
