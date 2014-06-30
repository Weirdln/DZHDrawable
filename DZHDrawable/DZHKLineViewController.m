//
//  DZHKLineViewController.m
//  DZHDrawable
//
//  Created by Duanwwu on 14-6-27.
//  Copyright (c) 2014年 Duanwwu. All rights reserved.
//

#import "DZHKLineViewController.h"
#import "UIColor+RGB.h"
#import "DZHKLineDataSource.h"
#import "DZHKLineContainer.h"
#import "DZHRectangleDrawing.h"
#import "DZHAxisXDrawing.h"
#import "DZHAxisYDrawing.h"
#import "DZHKLineDrawing.h"

@interface DZHKLineViewController ()<DZHKLineContainerDelegate,UIScrollViewDelegate>

@property (nonatomic, assign) NSUInteger centerIndex;

@end

@implementation DZHKLineViewController
{
    DZHKLineDataSource                  *_dataSource;
    DZHKLineContainer                   *kLineContainer;
    DZHKLineDrawing                     *klineDrawing;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _dataSource             = [[DZHKLineDataSource alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
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

    kLineContainer                      = [[DZHKLineContainer alloc] initWithFrame:CGRectMake(10., 10., 300., 400)];
    kLineContainer.backgroundColor      = [UIColor colorFromRGB:0x0e1014];
    kLineContainer.delegate             = self;
    kLineContainer.kLineDelegate        = self;
    kLineContainer.containerDelegate    = self;
    [self.view addSubview:kLineContainer];
    [kLineContainer release];
    
    UIColor *lineColor                  = [UIColor colorFromRGB:0x1e2630];
    UIColor *labelColor                 = [UIColor colorFromRGB:0x707880];
    
    //画外层框
    DZHRectangleDrawing *rectDrawing    = [[DZHRectangleDrawing alloc] init];
    rectDrawing.lineColor               = lineColor;
    [kLineContainer addDrawing:rectDrawing atVirtualRect:CGRectMake(20., .0, 260., 160.)];
    [rectDrawing release];
    
    //画x轴的直线
    DZHAxisXDrawing *axisXDrawing       = [[DZHAxisXDrawing alloc] init];
    axisXDrawing.dataSource             = _dataSource;
    axisXDrawing.labelColor             = labelColor;
    axisXDrawing.lineColor              = lineColor;
    axisXDrawing.labelFont              = [UIFont systemFontOfSize:10.];
    axisXDrawing.labelSpace             = 20.;
    [kLineContainer addDrawing:axisXDrawing atVirtualRect:CGRectMake(20., .0, 260., 180.)];
    [axisXDrawing release];
    
    //画y轴的直线
    DZHAxisYDrawing *axisYDrawing       = [[DZHAxisYDrawing alloc] init];
    axisYDrawing.dataSource             = _dataSource;
    axisYDrawing.labelFont              = [UIFont systemFontOfSize:10.];
    axisYDrawing.labelColor             = labelColor;
    axisYDrawing.lineColor              = lineColor;
    axisYDrawing.labelSpace             = 20.;
    [kLineContainer addDrawing:axisYDrawing atVirtualRect:CGRectMake(.0, 5., 280., 150.)];
    [axisYDrawing release];
    
    //画k线
    klineDrawing                        = [[DZHKLineDrawing alloc] init];
    klineDrawing.dataSource             = _dataSource;
    [klineDrawing setColor:[UIColor colorFromRGB:0xf92a27] forType:KLineTypePositive];
    [klineDrawing setColor:[UIColor colorFromRGB:0x2b9826] forType:KLineTypeNegative];
    [klineDrawing setColor:[UIColor grayColor] forType:KLineTypeCross];
    [kLineContainer addDrawing:klineDrawing atVirtualRect:CGRectMake(20., 5., 260., 150.)];
    [klineDrawing release];
    
    _dataSource.kLineOffset             = 20.;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *resource          = [[NSBundle mainBundle] resourcePath];
    NSData *unarchiveData       = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/klines.data",resource]];
    NSMutableArray *datas       = [NSKeyedUnarchiver unarchiveObjectWithData:unarchiveData];
    
    NSMutableArray *klines      = [NSMutableArray array];
    [klines addObjectsFromArray:datas];
    [klines addObjectsFromArray:datas];
    [klines addObjectsFromArray:datas];
    [klines addObjectsFromArray:datas];
    _dataSource.klines              = klines;
    
    [self changeScrollContainerContentSize:CGSizeMake([self _getContainerWidth], kLineContainer.frame.size.height)];
}

- (CGFloat)_getContainerWidth
{
    return [_dataSource totalKLineWidth] + kLineContainer.frame.size.width - klineDrawing.virtualFrame.size.width;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)changeScrollContainerContentSize:(CGSize)size
{
    CGFloat oldContentWidth     = kLineContainer.contentSize.width;
    CGFloat newContentWidth     = size.width;
    
    CGRect frame                = kLineContainer.frame;
    kLineContainer.contentSize  = CGSizeMake(newContentWidth, frame.size.height);
    
    [kLineContainer scrollRectToVisible:CGRectMake(newContentWidth - oldContentWidth - frame.size.width, .0, frame.size.width, frame.size.height) animated:NO];
}

#pragma mark - DZHDrawingContainerDelegate

- (void)prepareContainerDrawing:(id<DZHDrawingContainer>)drawing rect:(CGRect)rect
{
    CGRect realRect             = [drawing realRectForVirtualRect:klineDrawing.virtualFrame currentRect:rect];
    [_dataSource prepareWithKLineRect:realRect];
}

#pragma mark -  DZHKLineContainerDelegate

- (CGFloat)scaledOfkLineContainer:(DZHKLineContainer *)container
{
    self.centerIndex            = (_dataSource.startIndex + _dataSource.endIndex) * .5;
    return _dataSource.scale;
}

- (void)kLineContainer:(DZHKLineContainer *)container scaled:(CGFloat)scale
{
    CGRect frame                = container.frame;
    _dataSource.scale           = scale;
    CGFloat newPosition         = [_dataSource kLineLocationForIndex:self.centerIndex];
    container.contentSize       = CGSizeMake([self _getContainerWidth], frame.size.height);
    
    if (container.contentOffset.x == 0)
    {
        [container setNeedsDisplay];
    }
    else
    {
        [container scrollRectToVisible:CGRectMake(newPosition - frame.size.width * .5, .0, frame.size.width, frame.size.height) animated:NO];
    }
}

- (void)kLineContainer:(DZHKLineContainer *)container longPressLocation:(CGPoint)point state:(UIGestureRecognizerState)state
{
    NSUInteger index    = [_dataSource nearIndexForLocation:point.x];
    if (index == NSUIntegerMax)
    {
        NSLog(@"无对应K线数据");
    }
    else
    {
        DZHKLineEntity *entity  = [_dataSource.klines objectAtIndex:index];
        
        NSLog(@"对应索引:%d 日期:%d",index,entity.date);
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [scrollView setNeedsDisplay];
}

@end


