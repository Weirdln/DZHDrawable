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
	int bit         = 2;
    
    return [self FormatPrice:[obj intValue] len:7 dig:bit];
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
        int bit         = 2;
        
        *obj            = @(value * powf(10, bit));
    }

    return YES;
}

- (NSString *) FormatPrice:(int)price len:(int)len dig:(int)dig
{
	NSString *strVal = @"--";
	
	double fprice = 0;
	
	if (price != 0)
	{
		int v = 1;
		
		for (int i=0; i<dig; i++)
			v *= 10;
		
		fprice = (double)price / v;
		strVal = [self FormatDStr:fprice len:len dig:dig];
	}
	
	return strVal;
}

- (void)itoa:(int)n c:(char *)c
{
    NSString *str = [NSString stringWithFormat:@"%d", n];
    strcpy(c, [str UTF8String]);
}

- (NSString *) FormatDStr:(float)v len:(int)len dig:(int)dig
{
	int ln, rn;
	char floatstr[64];
	char temp[2];
	char formatStr[10];
	char formatStr2[10] = {'%'};
	
	NSString *strRetVal;
	
	[self itoa:dig c:temp];
    sprintf(formatStr, ".%sf", temp);
    strcat(formatStr2, formatStr);
    sprintf(floatstr, formatStr2, v);
    
    NSString * vv = [NSString stringWithUTF8String:floatstr];
    NSRange rang 	= [vv rangeOfString:@"."];
    ln 				= rang.location;
    rn 				= [vv length] - ln - 1;
    
    if (rang.location != NSNotFound)
    {
        NSRange subrang;
        NSString *rightstr;
        subrang.location 	= 0;
        subrang.length 		= MAX(ln, 0);
        NSString *leftstr 	= [vv substringWithRange:subrang];
        subrang.location 	= ln + 1;
        subrang.length 		= MAX(rn, 0);
        NSString *rightstro = [vv substringWithRange:subrang];
        int over 			= [vv length] - len;
        
        if (over > 0)
        {
            NSRange r;
            r.location 	= 0;
            r.length 	= MIN([rightstro length] - over, [rightstro length]);
            rightstr 	= [rightstro substringWithRange:r];
        }
        else
            rightstr = rightstro;
        
        if ([rightstr length] > 0 && [leftstr length] < len)
            strRetVal = [NSString stringWithFormat:@"%@.%@", leftstr, rightstr];
        else
            strRetVal = leftstr;
    }
    else
        strRetVal = vv;
	
	return strRetVal;
}

@end
