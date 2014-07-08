//
//  DZHCandleStickDataSource.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-7.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHDataSource.h"

@interface DZHKLineDataProvider : NSObject<DZHDataProviderProtocol>

@property (nonatomic, retain) NSDictionary *MAConfigs;/**k线、量线移动平均线配置 {周期:颜色}*/

@property (nonatomic, retain) id<DZHDataProviderContextProtocol> context;

@end
