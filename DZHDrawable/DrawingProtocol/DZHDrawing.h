//
//  DZHDrawable.h
//  DzhIPhone
//
//  Created by Duanwwu on 14-6-19.
//
//

@protocol DZHDrawingDelegate;
@protocol DZHDrawingDataSource;

/**
 * 绘制对象接口
 */
@protocol DZHDrawing <NSObject>

@property (nonatomic) CGRect virtualFrame;

@property (nonatomic) NSInteger drawingTag;

@property (nonatomic, assign) id<DZHDrawingDataSource> drawingDataSource;

@property (nonatomic, assign) id<DZHDrawingDelegate> drawingDelegate;

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context;

@end

/**
 * 绘制对象委托接口
 */
@protocol DZHDrawingDelegate <NSObject>

@optional

- (void)prepareDrawing:(id<DZHDrawing>)drawing inRect:(CGRect)rect;

- (void)completeDrawing:(id<DZHDrawing>)drawing inRect:(CGRect)rect;

@end

/**
 * 绘制对象数据源接口
 */
@protocol DZHDrawingDataSource <NSObject>

- (NSArray *)datasForDrawing:(id<DZHDrawing>)drawing inRect:(CGRect)rect;

@end


