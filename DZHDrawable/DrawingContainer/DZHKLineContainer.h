//
//  DZHKLineContainer.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-6-27.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHScrollContainer.h"

@protocol DZHKLineContainerDelegate;

@interface DZHKLineContainer : DZHScrollContainer

@property (nonatomic, assign) id<DZHKLineContainerDelegate> kLineDelegate;

@end

@protocol DZHKLineContainerDelegate <NSObject>

- (CGFloat)scaledOfkLineContainer:(DZHKLineContainer *)container;

- (void)kLineContainer:(DZHKLineContainer *)container scaled:(CGFloat)scale;

- (void)kLineContainer:(DZHKLineContainer *)container longPressLocation:(CGPoint)point state:(UIGestureRecognizerState)state;

@end