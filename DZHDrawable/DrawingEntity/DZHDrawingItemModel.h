//
//  DZHDrawableEntity.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-2.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHKLineEntity.h"
#import "DZHDrawingItems.h"

@interface DZHDrawingItemModel : NSObject<DZHCandleStick,DZHBarItem,DZHMACD,DZHKDJ>

@property (nonatomic, retain) DZHKLineEntity *originData;

@property (nonatomic) KLineType type;

@property (nonatomic) VolumeType volumeType;

@property (nonatomic, retain, readonly) NSMutableDictionary *extendData;

- (instancetype)initWithOriginData:(DZHKLineEntity *)originData;

@end

@interface DZHDrawingItemModel (MACurve)<DZHMACurve>

@end

@interface DZHDrawingItemModel (VolumeMACurve)<DZHVolumeMACurve>

@end
