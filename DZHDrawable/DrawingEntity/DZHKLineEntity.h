//
//  DZHKLineEntity.h
//  DzhIPhone
//
//  Created by Duanwwu on 14-6-23.
//
//

#import <Foundation/Foundation.h>

typedef enum
{
    KLineTypePositive   = 0, //阳线
    KLineTypeNegative   = 1, //阴线
    KLineTypeCross      = 2, //十字线
}KLineType;

@interface DZHKLineEntity : NSObject<NSCoding>

@property (nonatomic) int date; // K线时间
@property (nonatomic) int open; // 开盘价
@property (nonatomic) int high; // 最高价
@property (nonatomic) int low;  // 最低价
@property (nonatomic) int close;    // 收盘价

- (KLineType)type;

@end

@interface DZHDrawingGroup : NSObject

/**跨度，如1个月的所有k线为1组*/
@property (nonatomic) int step;

/**1组中的最大值*/
@property (nonatomic) int max;

/**1组中的最小值*/
@property (nonatomic) int min;

/**1组开始时间*/
@property (nonatomic) int date;

/**该组起始索引*/
@property (nonatomic) NSUInteger startIndex;

/**该组结束索引*/
@property (nonatomic) NSUInteger endIndex;

@end