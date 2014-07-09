//
//  DZHRSIDataProvider.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-9.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHDataProviderBase.h"

@class DZHRSICalculator;

@interface DZHRSIDataProvider : DZHDataProviderBase<DZHDataProviderProtocol>
{
    DZHRSICalculator            *_rsiCal;
}

@end
