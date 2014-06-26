//
//  DZHGridLineDrawing.h
//  DzhIPhone
//
//  Created by Duanwwu on 14-6-23.
//
//

#import <Foundation/Foundation.h>
#import "DZHAxisDrawing.h"

@protocol DZHAxisYDrawing <DZHAxisDrawing>

/**y轴刻度最少个数*/
@property (nonatomic) int minTickCount;

/**y轴刻度最多个数*/
@property (nonatomic) int maxTickCount;

/**刻度个数*/
@property (nonatomic) int tickCount;

/**每个刻度之间的跨度*/
@property (nonatomic) int strip;

/**y轴最小值*/
@property (nonatomic) int max;

/**y轴最大值*/
@property (nonatomic) int min;

/**y轴刻度值宽度*/
@property (nonatomic) CGFloat tickLabelWidth;

/**
 * 准备工作，如果有必要则调整最大值，以提高绘制精度。如当刻度个数为3~6，最大值最小值之差为113时候，找不到合适的刻度个数，则调整最大值
 * @returns max 最大值
 * @returns min 最小值
 */
- (void)prepareAndAdjustMaxIfNeedWithMax:(int *)max min:(int *)min;

@end

@interface DZHAxisYDrawing : NSObject<DZHAxisYDrawing>

@end
