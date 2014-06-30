//
//  DZHAxisDrawingBase.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-6-27.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHDrawingBase.h"
#import "DZHAxisDrawing.h"

@interface DZHAxisDrawingBase : DZHDrawingBase<DZHAxisDrawing>

- (void)drawStrInRect:(NSString *)str rect:(CGRect)rect font:(UIFont *)font alignment:(NSTextAlignment)alignment;

@end
