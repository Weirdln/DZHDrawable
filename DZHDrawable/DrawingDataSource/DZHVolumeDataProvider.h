//
//  DZHVolumeDataprovider.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-7.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHDataSource.h"

@interface DZHVolumeDataProvider : NSObject<DZHDataProviderProtocol>

@property (nonatomic, retain) NSDictionary *MAConfigs;/**k线、量线移动平均线配置 {周期:颜色}*/

@end
