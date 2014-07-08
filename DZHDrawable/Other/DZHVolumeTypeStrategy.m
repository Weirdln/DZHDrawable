//
//  DZHVolumeTypeStrategy.m
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-8.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHVolumeTypeStrategy.h"
#import "DZHDrawingItemModel.h"

@implementation DZHVolumeTypeStrategy

- (void)travelerWithLastData:(DZHDrawingItemModel *)last currentData:(DZHDrawingItemModel *)currentData index:(NSInteger)index
{
    if (last == nil)
    {
        currentData.volumeType   = currentData.close >= currentData.open ? VolumeTypePositive : VolumeTypeNegative;
    }
    else if (currentData.close >= last.close)
    {
        currentData.volumeType  = VolumeTypePositive;
    }
    else
    {
        currentData.volumeType  = VolumeTypeNegative;
    }
}

@end
