//
//  NSFixedArray.m
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-1.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "NSFixedArray.h"

@implementation NSFixedArray

- (instancetype)initWithFixedCapacity:(NSUInteger)numItems
{
    if (self = [super initWithCapacity:numItems])
    {
        fixedNumber             = numItems;
    }
    return self;
}

- (void)addObject:(id)anObject
{
    NSInteger count             = [self count];
    if (count == fixedNumber)
    {
        [self removeObjectAtIndex:0];
        [super addObject:anObject];
    }
    else
    {
        [super addObject:anObject];
    }
}

- (void)addObjectsFromArray:(NSArray *)otherArray
{
    if ([otherArray count] > fixedNumber)
        [NSException raise:@"Argument not allow" format:@"add array's count big than fixedNumber"];
    else
        [super addObjectsFromArray:otherArray];
}

@end
