//
//  DZHDrawingDefine.h
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-8.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#ifndef DZHDrawable_DZHDrawingDefine_h
#define DZHDrawable_DZHDrawingDefine_h

typedef enum
{
    KLineTypePositive   = 0, //阳线
    KLineTypeNegative   = 1, //阴线
    KLineTypeCross      = 2, //十字线
}KLineType;

typedef enum
{
    KLineCycleFive      = 5,
    KLineCycleTen       = 10,
    KLineCycleTwenty    = 20,
    KLineCycleThirty    = 30,
}KLineCycle;

typedef enum
{
    VolumeTypePositive,
    VolumeTypeNegative,
}VolumeType;

typedef enum
{
    MACDLineTypeFast,
    MACDLineTypeSlow,
}MACDLineType;

typedef enum
{
    MACDTypePositive,
    MACDTypeNegative,
}MACDType;

typedef enum
{
    KDJLineTypeK,
    KDJLineTypeD,
    KDJLineTypeJ,
}KDJLineType;

typedef enum
{
    RSILineType1,
    RSILineType2,
    RSILineType3,
}RSILineType;

#endif
