//
//  DZHContainer.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-6-26.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHDrawingContainer.h"
#import "DZHDrawingBase.h"

@interface DZHContainer : DZHDrawingBase<DZHDrawingContainer>
{
    NSMutableArray                      *_drawings;
}

@end
