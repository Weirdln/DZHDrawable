//
//  DZHKDJDataProvider.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-8.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHDataProviderBase.h"

@class DZHKDJCalculator;

@interface DZHKDJDataProvider : DZHDataProviderBase<DZHDataProviderProtocol>
{
    DZHKDJCalculator                *_kdjCal;
}

@end
