//
//  DZHDataTraveler.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-6-27.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DZHDataTraveler <NSObject>

- (void)travelerWithLastData:(id)last currentData:(id)currentData index:(int)index;

- (void)travelerEndAtIndex:(int)index;

@end
