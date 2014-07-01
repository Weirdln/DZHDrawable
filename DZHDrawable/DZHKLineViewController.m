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
#import "DZHBarDrawing.h"

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
    UIFont *labelFont                   = [UIFont systemFontOfSize:8.];
    
    //画k线外框
    DZHRectangleDrawing *rectDrawing    = [[DZHRectangleDrawing alloc] init];
    rectDrawing.lineColor               = lineColor;
    [kLineContainer addDrawing:rectDrawing atVirtualRect:CGRectMake(20., .0, 260., 160.)];
    [rectDrawing release];
    
    //画k线x轴
    DZHAxisXDrawing *axisXDrawing       = [[DZHAxisXDrawing alloc] init];
    axisXDrawing.dataSource             = _dataSource;
    axisXDrawing.tag                    = DrawingTagsKLineX;
    axisXDrawing.labelColor             = labelColor;
    axisXDrawing.lineColor              = lineColor;
    axisXDrawing.labelFont              = labelFont;
    axisXDrawing.labelSpace             = 20.;
    [kLineContainer addDrawing:axisXDrawing atVirtualRect:CGRectMake(20., .0, 260., 180.)];
    [axisXDrawing release];
    
    //画k线y轴，y轴需在k线之前绘制，因为绘制y轴的时候，为提高精度，会调整价格最大值
    DZHAxisYDrawing *axisYDrawing       = [[DZHAxisYDrawing alloc] init];
    axisYDrawing.dataSource             = _dataSource;
    axisYDrawing.tag                    = DrawingTagsKLineY;
    axisYDrawing.labelFont              = labelFont;
    axisYDrawing.labelColor             = labelColor;
    axisYDrawing.lineColor              = lineColor;
    axisYDrawing.labelSpace             = 20.;
    [kLineContainer addDrawing:axisYDrawing atVirtualRect:CGRectMake(.0, 5., 280., 150.)];
    [axisYDrawing release];
    
    //画k线
    klineDrawing                        = [[DZHKLineDrawing alloc] init];
    klineDrawing.dataSource             = _dataSource;
    klineDrawing.tag                    = DrawingTagsKLineItem;
    [kLineContainer addDrawing:klineDrawing atVirtualRect:CGRectMake(20., 5., 260., 150.)];
    [klineDrawing release];
    
    _dataSource.kLineOffset             = 20.;
    
    //画成交量外框
    DZHRectangleDrawing *volRectDrawing = [[DZHRectangleDrawing alloc] init];
    volRectDrawing.lineColor            = lineColor;
    [kLineContainer addDrawing:rectDrawing atVirtualRect:CGRectMake(20., 190.0, 260., 100.)];
    [volRectDrawing release];
    
    //画成交量x轴的直线
    DZHAxisXDrawing *volumeAxisXDrawing = [[DZHAxisXDrawing alloc] init];
    volumeAxisXDrawing.dataSource       = _dataSource;
    volumeAxisXDrawing.tag              = DrawingTagsVolumeX;
    volumeAxisXDrawing.lineColor        = lineColor;
    [kLineContainer addDrawing:volumeAxisXDrawing atVirtualRect:CGRectMake(20., 190.0, 260., 100.)];
    [volumeAxisXDrawing release];
    
    //画成交量y轴的直线
    DZHAxisYDrawing *volumeAxisYDrawing = [[DZHAxisYDrawing alloc] init];
    volumeAxisYDrawing.dataSource       = _dataSource;
    volumeAxisYDrawing.tag              = DrawingTagsVolumeY;
    volumeAxisYDrawing.labelFont        = labelFont;
    volumeAxisYDrawing.labelColor       = labelColor;
    volumeAxisYDrawing.lineColor        = lineColor;
    volumeAxisYDrawing.labelSpace       = 20.;
    [kLineContainer addDrawing:volumeAxisYDrawing atVirtualRect:CGRectMake(.0, 190.0, 280., 100.)];
    [volumeAxisYDrawing release];
    
    //画成交量柱
    DZHBarDrawing *barDrawing           = [[DZHBarDrawing alloc] init];
    barDrawing.dataSource               = _dataSource;
    barDrawing.tag                      = DrawingTagsVolumeItem;
    [kLineContainer addDrawing:barDrawing atVirtualRect:CGRectMake(20., 190.0, 260., 100.)];
    [barDrawing release];
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
    CGFloat maxScale            = _dataSource.maxScale;
    CGFloat minScale            = _dataSource.minScale;
    if (scale > maxScale && _dataSource.scale == maxScale)//超出最大缩放倍数，不做处理
        return;
    if (scale < minScale && _dataSource.scale == minScale)//超出最小缩放倍数，不做处理
        return;
    if ((int)scale * 100 % 2 != 0)//过滤部分数据，降低刷新频率
        return;

    CGRect frame                = container.frame;
    _dataSource.scale           = MAX(MIN(scale * 1.2,maxScale),minScale); //乘一个系数，增加放大时的平滑度
    CGFloat newPosition         = [_dataSource kLineLocationForIndex:self.centerIndex];
    container.contentSize       = CGSizeMake([self _getContainerWidth], frame.size.height);
    
    if (container.contentOffset.x == 0)//offset为0时，手动刷新
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


