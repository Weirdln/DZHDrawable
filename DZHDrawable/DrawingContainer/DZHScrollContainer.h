//
//  DZHScrollContainer.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-6-26.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHContainer.h"

@interface DZHScrollContainer : UIScrollView<DZHDrawingContainer>
{
    DZHContainer                        *_container;
}

@end
