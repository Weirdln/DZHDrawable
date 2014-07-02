//
//  DZHDrawableEntity.m
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-2.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHDrawableEntity.h"

@implementation DZHDrawableEntity

- (instancetype)initWithKItem:(DZHKLineEntity *)item
{
    if (self = [super init])
    {
        self.originData              = item;
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

- (float)positionForValue:(float)value max:(float)max min:(float)min
{
    float y;
	
	if (max == min)
		y = .0;
	else if (value <= max && value >= min)
		y = (value - min)/(max - min);
	else
		y = (value < min) ? .0 : 1.;
	
	return y;
}

@end

@implementation DZHDrawableEntity (CandleStick)

- (float)openPosition
{
    return [[_extendData objectForKey:@"openPosition"] floatValue];
}

- (float)closePosition
{
    return [[_extendData objectForKey:@"closePosition"] floatValue];
}

- (float)highPosition
{
    return [[_extendData objectForKey:@"highPosition"] floatValue];
}

- (float)lowPosition
{
    return [[_extendData objectForKey:@"lowPosition"] floatValue];
}

- (CGFloat)stickLocationX
{
    return _locationX;
}

- (CGFloat)stickWidth
{
    return _width;
}

- (void)calculateStickPositionWithMaxPrice:(int)max minPrice:(int)min
{
    float openPosition          = [self positionForValue:_originData.open max:max min:min];
    float closePosition         = [self positionForValue:_originData.close max:max min:min];
    float highPosition          = [self positionForValue:_originData.high max:max min:min];
    float lowPosition           = [self positionForValue:_originData.low max:max min:min];
    
    [_extendData setObject:[NSNumber numberWithFloat:openPosition] forKey:@"openPosition"];
    [_extendData setObject:[NSNumber numberWithFloat:closePosition] forKey:@"closePosition"];
    [_extendData setObject:[NSNumber numberWithFloat:highPosition] forKey:@"highPosition"];
    [_extendData setObject:[NSNumber numberWithFloat:lowPosition] forKey:@"lowPosition"];
}

@end

@implementation DZHDrawableEntity (VolumeBar)

- (float)volumeBarPosition
{
    return [[_extendData objectForKey:@"volumeBarPosition"] floatValue];
}

- (CGFloat)volumeLocationX
{
    return _locationX;
}

- (CGFloat)volumeBarWidth
{
    return _width;
}

- (void)calculateVolumePositionWithMaxVolume:(int)max minVolume:(int)min
{
    float volumeBarPosition         = [self positionForValue:_originData.vol max:max min:min];
    [_extendData setObject:[NSNumber numberWithFloat:volumeBarPosition] forKey:@"volumeBarPosition"];
}

@end
