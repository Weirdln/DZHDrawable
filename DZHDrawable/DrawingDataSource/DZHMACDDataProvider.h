//
//  DZHMACDDataProvider.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-8.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHDataProviderBase.h"

@class DZHMACDCalculator;

@interface DZHMACDDataProvider : DZHDataProviderBase<DZHDataProviderProtocol>
{
    DZHMACDCalculator                   *_macdCal;
}

@end
