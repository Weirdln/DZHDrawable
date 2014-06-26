//
//  DZHDrawingWrapper.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-6-26.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DZHDrawing.h"

@interface DZHDrawingWrapper : NSObject

@property (nonatomic, retain) id<DZHDrawing> drawing;

@property (nonatomic) CGRect virtualRect;

- (instancetype)initWithDrawing:(id<DZHDrawing>)drawing virtualRect:(CGRect)rect;

@end
