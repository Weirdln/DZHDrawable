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

@property (nonatomic)CGRect virtualFrame;

@property (nonatomic, assign)id<DZHDrawingDataSource> dataSource;

@property (nonatomic, assign)id<DZHDrawingDelegate> delegate;

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context;

- (int)coordYWithValue:(float)v max:(float)max min:(float)min;

@end

/**
 * 绘制对象委托接口
 */
@protocol DZHDrawingDelegate <NSObject>

@optional

- (void)prepareDrawing:(id<DZHDrawing>)drawing;

- (void)completeDrawing:(id<DZHDrawing>)drawing;

@end

/**
 * 绘制对象数据源接口
 */
@protocol DZHDrawingDataSource <NSObject>

- (NSArray *)datasForDrawing:(id<DZHDrawing>)drawing;

@end


