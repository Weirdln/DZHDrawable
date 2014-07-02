//
//  DZHKLineEntity.m
//  DzhIPhone
//
//  Created by Duanwwu on 14-6-23.
//
//

#import "DZHKLineEntity.h"

@interface DZHKLineEntity ()

@property (nonatomic, retain) NSMutableDictionary *extendData;

@end

@implementation DZHKLineEntity

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:_date forKey:@"date"];
    [aCoder encodeInt:_open forKey:@"open"];
    [aCoder encodeInt:_high forKey:@"high"];
    [aCoder encodeInt:_low forKey:@"low"];
    [aCoder encodeInt:_close forKey:@"close"];
    [aCoder encodeInt:_vol forKey:@"vol"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _date       = [aDecoder decodeIntForKey:@"date"];
        _open       = [aDecoder decodeIntForKey:@"open"];
        _high       = [aDecoder decodeIntForKey:@"high"];
        _low        = [aDecoder decodeIntForKey:@"low"];
        _close      = [aDecoder decodeIntForKey:@"close"];
        _vol        = [aDecoder decodeIntForKey:@"vol"];
        _extendData = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _extendData = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_extendData release];
    [super dealloc];
}

- (KLineType)type
{
    if (self.open < self.close)
        return KLineTypePositive;
    else if (self.open > self.close)
        return  KLineTypeNegative;
    else
        return KLineTypeCross;
}

- (void)setMa:(int)ma withCycle:(int)cycle
{
    [_extendData setObject:@(ma) forKey:[NSString stringWithFormat:@"MA%d",cycle]];
}

- (int)maWithCycle:(int)cycle
{
    return [[_extendData objectForKey:[NSString stringWithFormat:@"MA%d",cycle]] intValue];
}

@end

