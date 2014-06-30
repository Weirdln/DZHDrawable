//
//  DZHKLineContainer.m
//  DZHDrawable
//
//  Created by Duanwwu on 14-6-27.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHKLineContainer.h"
#import "UIColor+RGB.h"
#import "DZHKLineDrawing.h"
#import "DZHAxisYDrawing.h"
#import "DZHKLineEntity.h"

@interface DZHKLineContainer ()<UIGestureRecognizerDelegate>

@end

@implementation DZHKLineContainer

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.decelerationRate           = .4;
        self.showsHorizontalScrollIndicator = NO;
        
        UILabel *label                  = [[UILabel alloc] initWithFrame:CGRectMake(- 50., 95., 40., 20.)];
        label.font                      = [UIFont systemFontOfSize:10.];
        label.textColor                 = [UIColor whiteColor];
        label.backgroundColor           = [UIColor clearColor];
        label.text                      = @"加载中...";
        [self addSubview:label];
        
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleKLine:)];
        pinch.delegate                  = self;
        [self addGestureRecognizer:pinch];
        [pinch release];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressKLine:)];
        [self addGestureRecognizer:longPress];
        [longPress release];
        
        [pinch requireGestureRecognizerToFail:longPress];
        [self.panGestureRecognizer requireGestureRecognizerToFail:longPress];
        [self.pinchGestureRecognizer requireGestureRecognizerToFail:longPress];
    }
    return self;
}

- (void)scaleKLine:(UIPinchGestureRecognizer *)gesture
{
    if (_kLineDelegate && [_kLineDelegate respondsToSelector:@selector(kLineContainer:scaled:)])
    {
        [_kLineDelegate kLineContainer:self scaled:gesture.scale];
    }
}

- (void)longPressKLine:(UILongPressGestureRecognizer *)gesture
{
    if (_kLineDelegate && [_kLineDelegate respondsToSelector:@selector(kLineContainer:longPressLocation:state:)])
    {
        CGPoint point       = [gesture locationInView:self];
        [_kLineDelegate kLineContainer:self longPressLocation:point state:gesture.state];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]])
    {
        if (_kLineDelegate && [_kLineDelegate respondsToSelector:@selector(scaledOfkLineContainer:)])
        {
            ((UIPinchGestureRecognizer *)gestureRecognizer).scale   = [_kLineDelegate scaledOfkLineContainer:self];
        }
    }
    return YES;
}

@end
