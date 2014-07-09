//
//  DZHRSICalculator.m
//  DZHDrawable
//
//  Created by Duanwwu on 14-7-8.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHRSICalculator.h"
#import "DZHDrawingItemModel.h"

#define kDefault

@implementation DZHRSICalculator
{
    int                 RSI1;
    int                 RSI2;
    int                 RSI3;
    
    int                 *RSI1Closes; //RSIDay1天收盘价集合
    int                 *RSI2Closes; //RSIDay2天收盘价集合
    int                 *RSI3Closes; //RSIDay3天收盘价集合
}

- (instancetype)initWithRSI1:(int)rsiDay1 RSI2:(int)rsiDay2 RSI3:(int)rsiDay3
{
    if (self = [super init])
    {
        self.RSIDay1            = rsiDay1;
        self.RSIDay2            = rsiDay2;
        self.RSIDay3            = rsiDay3;
        
        RSI1Closes              = malloc(sizeof(int) * (rsiDay1 + 1));
        RSI2Closes              = malloc(sizeof(int) * (rsiDay2 + 1));
        RSI3Closes              = malloc(sizeof(int) * (rsiDay3 + 1));
    }
    return self;
}

- (void)dealloc
{
    free(RSI1Closes);
    free(RSI2Closes);
    free(RSI3Closes);
    
    [super dealloc];
}
- (void)travelerBeginAtIndex:(NSInteger)index
{
    RSI1                = 0;
    RSI2                = 0;
    RSI3                = 0;
    memset(RSI1Closes, 0, sizeof(int) * (_RSIDay1 + 1));
    memset(RSI2Closes, 0, sizeof(int) * (_RSIDay2 + 1));
    memset(RSI3Closes, 0, sizeof(int) * (_RSIDay3 + 1));
}

//RSI=100×RS/(1+RS)
//RS=X天的平均上涨点数/X天的平均下跌点数
//综合RSI与RS的公式，可得RSI = 100 * X天的总上涨点数 / (X天的总上涨点数 + X天的总下跌点数)
- (void)travelerWithLastData:(DZHDrawingItemModel *)last currentData:(DZHDrawingItemModel *)currentData index:(NSInteger)index
{
    if (index == _RSIDay1)  //计算RSI1的值
    {
        RSI1Closes[_RSIDay1]  = currentData.close;
        currentData.RSI1    = [self calculateRSIWithCloses:RSI1Closes cyle:_RSIDay1];
    }
    else if (index > _RSIDay1)
    {
        currentData.RSI1    = [self calculateRSIWithCloses:RSI1Closes cyle:_RSIDay1 close:currentData.close];
    }
    else
    {
        RSI1Closes[index]  = currentData.close;
    }
    
    if (index == _RSIDay2)  //计算RSI2的值
    {
        RSI2Closes[_RSIDay2]  = currentData.close;
        currentData.RSI2    = [self calculateRSIWithCloses:RSI2Closes cyle:_RSIDay2];
    }
    else if (index > _RSIDay2)
    {
        currentData.RSI2    = [self calculateRSIWithCloses:RSI2Closes cyle:_RSIDay2 close:currentData.close];
    }
    else
    {
        RSI2Closes[index]  = currentData.close;
    }
    
    if (index == _RSIDay3)  //计算RSI3的值
    {
        RSI3Closes[_RSIDay3]  = currentData.close;
        currentData.RSI3    = [self calculateRSIWithCloses:RSI3Closes cyle:_RSIDay3];
    }
    else if (index > _RSIDay3)
    {
        currentData.RSI3    = [self calculateRSIWithCloses:RSI3Closes cyle:_RSIDay3 close:currentData.close];
    }
    else
    {
        RSI3Closes[index]  = currentData.close;
    }
}

/**
 * 计算RSI值
 *
 */
- (int)calculateRSIWithCloses:(int *)closes cyle:(int)cycle
{
    int du                  = 0; //总上涨点数
    int dd                  = 0; //总下跌点数
    for (int i = 1; i <= cycle; i ++)
    {
        int lastClose       = closes[i - 1];
        int close           = closes[i];
        
        if (close > lastClose)
            du              += close - lastClose;
        else
            dd              += lastClose - close;
    }
    return du + dd == 0 ? 0 : roundf(10000. * du / (du + dd));
}

/**
 * 计算RSI值，并将最新的收盘价push进栈，如果数据个数大于缓存大小，则将最后一个收盘价出栈
 *
 */
- (int)calculateRSIWithCloses:(int *)closes cyle:(int)cycle close:(int)close;
{
    int du                  = 0; //总上涨点数
    int dd                  = 0; //总下跌点数
    for (int i = 2; i <= cycle + 1; i ++)
    {
        int lastClose       = closes[i - 1];
        int curClose        = i == cycle + 1 ? close : closes[i];
        
        if (curClose > lastClose)
            du              += curClose - lastClose;
        else
            dd              += lastClose - curClose;
        
        if (i == 2)
            closes[i - 2]    = lastClose;
        
        closes[i - 1]       = curClose;
    }
    return du + dd == 0 ? 0 : roundf(10000. * du / (du + dd));
}

@end
