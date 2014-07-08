//
//  DZHDataProviderContext.m
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-7.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHDataProviderContext.h"

@implementation DZHDataProviderContext

@synthesize fromIndex;
@synthesize toIndex;

@synthesize itemWidth;
@synthesize itemPadding;
@synthesize startLocation;

@synthesize datas;
@synthesize itemCount;

@synthesize scale;

- (CGFloat)totalWidth
{
    return itemCount * (itemWidth + itemPadding) + itemPadding;
}

- (CGFloat)locationForIndex:(NSUInteger)index
{
    return startLocation + itemPadding + index * (itemPadding + itemWidth);
}

- (CGFloat)centerLocationForIndex:(NSUInteger)index
{
    return startLocation + itemPadding * (index + 1) + itemWidth * (index + .5);
}

- (NSUInteger)nearIndexForLocation:(CGFloat)position
{
    CGFloat index   = (position - itemPadding - startLocation) / (itemPadding + itemWidth);
    return MIN(index, itemCount - 1);
}

- (void)calculateFromAndToIndexWithRect:(CGRect)rect
{
    CGFloat space               = itemWidth + itemPadding;
    fromIndex                   = MAX(ceilf((rect.origin.x - itemPadding - startLocation)/space), 0);
    toIndex                     = MIN((CGRectGetMaxX(rect) - itemPadding - startLocation)/space - 1, itemCount - 1);
}

@end
