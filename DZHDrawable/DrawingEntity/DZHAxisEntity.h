//
//  DZHAxisEntity.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-6-27.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 坐标轴绘制数据对象
 */
@interface DZHAxisEntity : NSObject

/**绘制x轴表示x坐标，绘制y轴表示y轴坐标*/
@property (nonatomic) CGPoint location;

/**刻度上显示的文本字符串*/
@property (nonatomic, copy) NSString *labelText;

@end
