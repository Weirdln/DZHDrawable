//
//  NSFixedArray.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-1.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

@interface NSFixedArray : NSMutableArray
{
    NSUInteger                  fixedNumber;
}

- (instancetype)initWithFixedCapacity:(NSUInteger)numItems;

@end
