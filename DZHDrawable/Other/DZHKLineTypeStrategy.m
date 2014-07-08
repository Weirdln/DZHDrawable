//
//  DZHKLineTypeStrategy.m
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-4.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHKLineTypeStrategy.h"
#import "DZHDrawingItemModel.h"

@implementation DZHKLineTypeStrategy

- (void)travelerWithLastData:(DZHDrawingItemModel *)last currentData:(DZHDrawingItemModel *)currentData index:(NSInteger)index
{
    if (currentData.open < currentData.close)
        currentData.type        = KLineTypePositive;
    else if (currentData.open > currentData.close)
        currentData.type        = KLineTypeNegative;
    else if (last.close < currentData.open)  // 当天开盘 == 收盘，开盘 > 昨收
        currentData             = KLineTypePositive;
    else if (last.close > currentData.open) // 当天开盘 == 收盘，开盘 < 昨收
        currentData.type        = KLineTypeNegative;
    else // 当天开盘 == 收盘，开盘 == 昨收
        currentData.type        = KLineTypeCross;
}

@end
