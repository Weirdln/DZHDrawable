//
//  DZHDataSource2.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-7.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHDataSource.h"
#import "DZHDrawing.h"

typedef enum
{
    DrawingTagsKLineX,
    DrawingTagsKLineY,
    DrawingTagsKLineItem,
    DrawingTagsVolumeX,
    DrawingTagsVolumeY,
    DrawingTagsVolumeItem,
    DrawingTagsMa,
    DrawingTagsVolumeMa,
}DrawingTags;

@interface DZHKLineDataSource : NSObject<DZHDrawingDataSource,DZHDrawingDelegate>
{
    
}

@property (nonatomic, retain) NSDictionary *MAConfigs;/**k线、量线移动平均线配置 {周期:颜色}*/

@property (nonatomic, retain) NSArray *klines;

@property (nonatomic) CGFloat scale;

@property (nonatomic) CGFloat minScale;

@property (nonatomic) CGFloat maxScale;

@property (nonatomic) CGFloat kLineWidth; //k线实体宽度

@property (nonatomic) CGFloat kLinePadding; //k线之间间距

@property (nonatomic, assign) id<DZHDataProviderProtocol> kLineDataProvider;

@property (nonatomic, assign) id<DZHDataProviderProtocol> indexDataProvider;

@property (nonatomic, retain)id<DZHDataProviderContextProtocol> context;

@end
