//
//  DZHDrawableTests.m
//  DZHDrawableTests
//
//  Created by Duanwwu on 14-6-26.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DZHMACalculator.h"
#import "DZHKLineEntity.h"

@interface DZHDrawableTests : XCTestCase

@end

@implementation DZHDrawableTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMACalculator
{
    NSString *resource          = [[NSBundle mainBundle] resourcePath];
    NSData *unarchiveData       = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/klines.data",resource]];
    NSMutableArray *datas       = [NSKeyedUnarchiver unarchiveObjectWithData:unarchiveData];

    int cycle                   = 10;
    DZHMACalculator *ma         = [[DZHMACalculator alloc] initWithMACycle:cycle];
    int total                   = 0;
    int idx                     = 0;
    
    for (DZHKLineEntity *entity in datas)
    {
        total                   += entity.close;
        if (idx >= cycle)
        {
            DZHKLineEntity *lastEntity  = [datas objectAtIndex:idx - cycle];
            total                       -= lastEntity.close;
            printf("%d,",total / cycle);
        }
        else
        {
            printf("%d,",total / (idx + 1));
        }
        
        [ma travelerWithLastData:nil currentData:entity index:idx];
        
        idx ++;
    }
    
    printf("\n---------------\n");
    
    for (DZHKLineEntity *entity in datas)
    {
        printf("%d,",[entity maWithCycle:cycle]);
    }
    
    printf("\n");
}

@end
