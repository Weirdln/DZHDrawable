//
//  DZHAxisXDrawing.h
//  DzhIPhone
//
//  Created by Duanwwu on 14-6-24.
//
//

#import <Foundation/Foundation.h>
#import "DZHDrawing.h"

@class DZHAxisXDrawing;

@protocol DZHAxisXDrawingDataSource <NSObject>

- (CGFloat)axisXDrawing:(DZHAxisXDrawing *)drawing locationForIndex:(NSUInteger)index;

@end

@interface DZHAxisXDrawing : NSObject<DZHAxisDrawing>

@property (nonatomic,assign) id<DZHAxisXDrawingDataSource> dataSource;

@property (nonatomic) CGFloat labelHeight;

@property (nonatomic, retain) NSArray *groups;

@end
