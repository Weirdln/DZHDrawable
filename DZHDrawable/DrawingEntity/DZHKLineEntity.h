//
//  DZHKLineEntity.h
//  DzhIPhone
//
//  Created by Duanwwu on 14-6-23.
//
//

#import <Foundation/Foundation.h>

@interface DZHKLineEntity : NSObject<NSCoding>

@property (nonatomic) int date; // K线时间
@property (nonatomic) int open; // 开盘价
@property (nonatomic) int high; // 最高价
@property (nonatomic) int low;  // 最低价
@property (nonatomic) int close;    // 收盘价
@property (nonatomic) int vol;

@end