//
//  DZHDrawable.h
//  DzhIPhone
//
//  Created by Duanwwu on 14-6-19.
//
//

#import "DZHDrawingCoordinateProvider.h"

/**
 * 绘制对象
 */
@protocol DZHDrawing <NSObject>

@property (nonatomic) CGFloat scale;

@property (nonatomic, assign) id<DZHDrawingCoordinateProvider> coordinateProvider;

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context;

@end




