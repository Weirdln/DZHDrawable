//
//  DZHKLineDateFormatter.m
//  DzhIPhone
//
//  Created by Duanwwu on 14-6-24.
//
//

#import "DZHKLineDateFormatter.h"

@implementation DZHKLineDateFormatter

- (NSString *)stringForObjectValue:(id)obj
{
    int date    = [obj intValue];
    int year    = date / 10000;
    int month   = (date % 10000)/100;
    
    return [NSString stringWithFormat:@"%d/%02d",year,month];
}

- (BOOL)getObjectValue:(out id *)obj forString:(NSString *)string errorDescription:(out NSString **)error
{
    int year        = [[string substringWithRange:NSMakeRange(0, 4)] intValue];
    int month       = [[string substringWithRange:NSMakeRange(5, 2)] intValue];
    
    *obj            = @(year * 1000 + month * 100);
    return YES;
}

@end
