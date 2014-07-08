//
//  DZHMACDDataProvider.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-8.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHDataSource.h"

@class DZHMACDCalculator;

@interface DZHMACDDataProvider : NSObject<DZHDataProviderProtocol>
{
    DZHMACDCalculator                   *_macdCal;
}

@end
