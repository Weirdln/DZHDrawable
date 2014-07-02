//
//  DZHDrawableEntity.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-2.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHKLineEntity.h"
#import "DZHDrawableEntityProtocols.h"

@interface DZHDrawableEntity : NSObject<DZHDrawableMapping>

@property (nonatomic, retain) DZHKLineEntity *originData;

@property (nonatomic) CGFloat locationX;

@property (nonatomic) CGFloat width;

@property (nonatomic, retain, readonly) NSMutableDictionary *extendData;

@end

@interface DZHDrawableEntity (CandleStick)<DZHCandleStick>

@end

@interface DZHDrawableEntity (VolumeBar)<DZHVolumeBar>

@end