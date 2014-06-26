//
//  DZHKLineFormatter.m
//  DzhIPhone
//
//  Created by Duanwwu on 14-6-23.
//
//

#import "DZHKLineValueFormatter.h"

@implementation DZHKLineValueFormatter

- (NSString *)stringForObjectValue:(id)obj
{
    int nType       = [Util getSecurityType];
	int bit         = [Util getSecurityBit];
    
    return [Util FormatPrice:[obj intValue] len:[Util GetLenCount:nType] dig:bit];
}

- (BOOL)getObjectValue:(out id *)obj forString:(NSString *)string errorDescription:(out NSString **)error
{
    if ([@"--" isEqualToString:string])
    {
        *obj            = @(0);
    }
    else
    {
        float value     = [string floatValue];
        int bit         = [Util getSecurityBit];
        
        *obj            = @(value * powf(10, bit));
    }

    return YES;
}

@end
