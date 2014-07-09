//
//  DZHDrawableEntity.m
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-2.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHDrawingItemModel.h"

@implementation DZHDrawingItemModel

@synthesize solidRect;
@synthesize stickRect;
@synthesize stickColor;
@synthesize barRect;
@synthesize barFillColor;
@synthesize DIF;
@synthesize DEA;
@synthesize MACD;
@synthesize K;
@synthesize D;
@synthesize J;
@synthesize RSI1;
@synthesize RSI2;
@synthesize RSI3;

- (instancetype)initWithOriginData:(DZHKLineEntity *)originData
{
    if (self = [super init])
    {
        self.originData         = originData;
        _extendData             = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_originData release];
    [_extendData release];
    [super dealloc];
}

- (int)open
{
    return _originData.open;
}

- (int)close
{
    return _originData.close;
}

- (int)high
{
    return _originData.high;
}

- (int)low
{
    return _originData.low;
}

- (int)date
{
    return _originData.date;
}

- (int)volume
{
    return _originData.vol;
}

@end

@implementation DZHDrawingItemModel (MACurve)

- (void)setMA:(int)ma withCycle:(int)cycle
{
    [_extendData setObject:@(ma) forKey:[NSString stringWithFormat:@"MA%d",cycle]];
}

- (int)MAWithCycle:(int)cycle
{
    return [[_extendData objectForKey:[NSString stringWithFormat:@"MA%d",cycle]] intValue];
}

@end

@implementation DZHDrawingItemModel (VolumeMACurve)

- (void)setVolumeMA:(int)ma withCycle:(int)cycle
{
    [_extendData setObject:@(ma) forKey:[NSString stringWithFormat:@"VolMA%d",cycle]];
}

- (int)volumeMAWithCycle:(int)cycle
{
    return [[_extendData objectForKey:[NSString stringWithFormat:@"VolMA%d",cycle]] intValue];
}

@end

