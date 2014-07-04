//
//  DZHKLineEntity.m
//  DzhIPhone
//
//  Created by Duanwwu on 14-6-23.
//
//

#import "DZHKLineEntity.h"

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
    }
    return self;
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

@end

