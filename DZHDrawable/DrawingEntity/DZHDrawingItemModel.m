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
@synthesize EMAFast;
@synthesize EMASlow;
@synthesize DIF;
@synthesize DEA;

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

//- (float)positionForValue:(float)value max:(float)max min:(float)min
//{
//    float y;
//	
//	if (max == min)
//		y = .0;
//	else if (value <= max && value >= min)
//		y = (value - min)/(max - min);
//	else
//		y = (value < min) ? .0 : 1.;
//	
//	return y;
//}
//
//- (CGFloat)locationInRect:(CGRect)rect withPosition:(float)position
//{
//    CGFloat bottom          = CGRectGetMaxY(rect);
//    return bottom - position * (bottom - CGRectGetMinY(rect));
//}

- (CGFloat)locationYForValue:(float)v withMax:(float)max min:(float)min top:(CGFloat)top bottom:(CGFloat)bottom
{
	CGFloat y;
	
	if (max == min)
		y = bottom;
	else if (v <= max && v >= min)
		y = bottom - (v - min)/(max - min)*(bottom - top);
	else
		y = (v < min) ? bottom : top;
	
	return y;
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

