//
//  ViewController.m
//  DZHDrawable
//
//  Created by Duanwwu on 14-6-26.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "ViewController.h"
#import "UIColor+RGB.h"
#import "DZHKLineView.h"

@interface ViewController ()<UIScrollViewDelegate>

@end

@implementation ViewController
{
    DZHKLineView                *drawing;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
    NSString *resource          = [[NSBundle mainBundle] resourcePath];
    NSData *unarchiveData       = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/klines.data",resource]];
    NSMutableArray *datas       = [NSKeyedUnarchiver unarchiveObjectWithData:unarchiveData];
    
    NSMutableArray *klines      = [NSMutableArray array];
    [klines addObjectsFromArray:datas];
    [klines addObjectsFromArray:datas];
    [klines addObjectsFromArray:datas];
    [klines addObjectsFromArray:datas];
    
    self.view.backgroundColor   = [UIColor whiteColor];
    drawing                     = [[DZHKLineView alloc] initWithFrame:CGRectMake(20., 10., 280., 400)];
    drawing.backgroundColor     = [UIColor colorFromRGB:0x0e1014];
    drawing.delegate            = self;
    drawing.klines              = klines;
    
    [self.view addSubview:drawing];
    [drawing release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [scrollView setNeedsDisplay];
}

@end
