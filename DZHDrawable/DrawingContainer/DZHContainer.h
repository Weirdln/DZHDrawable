//
//  DZHContainer.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-6-26.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZHDrawingContainer.h"

@interface DZHContainer : UIView<DZHDrawingContainer>
{
    NSMutableArray                      *_drawings;
}

@end
