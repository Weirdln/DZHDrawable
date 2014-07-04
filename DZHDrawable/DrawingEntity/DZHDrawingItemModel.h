//
//  DZHDrawableEntity.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-2.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHKLineEntity.h"
#import "DZHDrawingItemModels.h"

@interface DZHDrawingItemModel : NSObject<DZHCandleStick,DZHVolumeBar>

@property (nonatomic, retain) DZHKLineEntity *originData;

@property (nonatomic) CGFloat locationX;

@property (nonatomic) CGFloat itemWidth;

@property (nonatomic, retain, readonly) NSMutableDictionary *extendData;

- (instancetype)initWithOriginData:(DZHKLineEntity *)originData;

@end

@interface DZHDrawingItemModel (MACurve)<DZHMACurve>

@end

@interface DZHDrawingItemModel (VolumeMACurve)<DZHVolumeMACurve>

@end