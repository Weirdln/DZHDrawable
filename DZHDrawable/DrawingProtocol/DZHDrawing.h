//
//  DZHDrawable.h
//  DzhIPhone
//
//  Created by Duanwwu on 14-6-19.
//
//

#import <Foundation/Foundation.h>

@protocol DZHDrawing <NSObject>

@property (nonatomic) CGFloat scale;

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context;

@end

@protocol DZHKLineDrawing <DZHDrawing>

/**最大价格*/
@property (nonatomic)int maxPrice;

/**最小价格*/
@property (nonatomic)int minPrice;

/**k线数据*/
@property (nonatomic, retain) NSArray *kLineDatas;

@end

@protocol DZHAxisDrawing <DZHDrawing>

/**格式化数据，通过数据获取绘制文本*/
@property (nonatomic, retain) NSFormatter *formatter;

/**线条颜色*/
@property (nonatomic, retain) UIColor *lineColor;

/**文字颜色*/
@property (nonatomic, retain) UIColor *labelColor;

/**文字字体*/
@property (nonatomic, retain) UIFont *labelFont;

@end

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

