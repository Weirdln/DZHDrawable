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
#import "DZHFillBarDrawing.h"
#import "DZHMACurveDrawing.h"
#import "DZHKLineEntity.h"

@interface DZHKLineViewController ()<DZHKLineContainerDelegate,UIScrollViewDelegate>

@property (nonatomic, assign) NSUInteger centerIndex;

@property (nonatomic, assign) CGFloat scale;

@property (nonatomic, assign) CGFloat lastOffset;

@end

@implementation DZHKLineViewController
{
    DZHKLineDataSource                  *_dataSource;
    DZHKLineContainer                   *kLineContainer;
    DZHContainer                        *kContainer;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _dataSource             = [[DZHKLineDataSource alloc] init];
        _scale                  = 1.;
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

    kLineContainer                      = [[DZHKLineContainer alloc] initWithFrame:CGRectMake(10., 25., 420., 240.)];
    kLineContainer.backgroundColor      = [UIColor colorFromRGB:0x0e1014];
    kLineContainer.kLineDelegate        = self;
    kLineContainer.delegate             = self;
    [self.view addSubview:kLineContainer];
    [kLineContainer release];
    
    UIColor *lineColor                  = [UIColor colorFromRGB:0x1e2630];
    UIColor *labelColor                 = [UIColor colorFromRGB:0x707880];
    UIFont *labelFont                   = [UIFont systemFontOfSize:8.];
    
    CGFloat axisWidth                   = 400.;
    CGFloat width                       = 380.;
    CGFloat kHeight                     = 120.;
    
    kContainer                          = [[DZHContainer alloc] init];
    
    //画k线外框
    DZHRectangleDrawing *rectDrawing    = [[DZHRectangleDrawing alloc] init];
    rectDrawing.drawingDelegate         = _dataSource;
    rectDrawing.lineColor               = lineColor;
    [kContainer addDrawing:rectDrawing atVirtualRect:CGRectMake(20., 0., width, kHeight + 10.)];
    [rectDrawing release];
    
    //画k线x轴
    DZHAxisXDrawing *axisXDrawing       = [[DZHAxisXDrawing alloc] init];
    axisXDrawing.drawingDataSource      = _dataSource;
    axisXDrawing.drawingTag             = DrawingTagsKLineX;
    axisXDrawing.labelColor             = labelColor;
    axisXDrawing.lineColor              = lineColor;
    axisXDrawing.labelFont              = labelFont;
    axisXDrawing.labelSpace             = 20.;
    [kContainer addDrawing:axisXDrawing atVirtualRect:CGRectMake(20., 0., width, kHeight + 30.)];
    [axisXDrawing release];
    
    //画k线y轴，y轴需在k线之前绘制，因为绘制y轴的时候，为提高精度，会调整价格最大值
    DZHAxisYDrawing *axisYDrawing       = [[DZHAxisYDrawing alloc] init];
    axisYDrawing.drawingDataSource      = _dataSource;
    axisYDrawing.drawingTag             = DrawingTagsKLineY;
    axisYDrawing.labelFont              = labelFont;
    axisYDrawing.labelColor             = labelColor;
    axisYDrawing.lineColor              = lineColor;
    axisYDrawing.labelSpace             = 20.;
    [kContainer addDrawing:axisYDrawing atVirtualRect:CGRectMake(.0, 5., axisWidth, kHeight)];
    [axisYDrawing release];
    
    //画k线
    DZHKLineDrawing *klineDrawing       = [[DZHKLineDrawing alloc] init];
    
    klineDrawing.drawingDataSource      = _dataSource;
    klineDrawing.drawingTag             = DrawingTagsKLineItem;
    [kContainer addDrawing:klineDrawing atVirtualRect:CGRectMake(20., 5., width, kHeight)];
    
    //k线移动平均线
    DZHMACurveDrawing *maDrawing        = [[DZHMACurveDrawing alloc] init];
    maDrawing.drawingDataSource         = _dataSource;
    maDrawing.drawingTag                = DrawingTagsMa;
    [kContainer addDrawing:maDrawing atVirtualRect:CGRectMake(20., 5., width, kHeight)];
    [maDrawing release];
    
    [kLineContainer addDrawing:kContainer atVirtualRect:CGRectMake(.0, 5., width, kHeight + 30.)];
    [kContainer release];
    
    DZHContainer *volumeContainer       = [[DZHContainer alloc] init];
    
    CGFloat y                           = kHeight + 30.;
    CGFloat volHeight                   = 80.;
    //画成交量外框
    DZHRectangleDrawing *volRectDrawing = [[DZHRectangleDrawing alloc] init];
    volRectDrawing.lineColor            = lineColor;
    [volumeContainer addDrawing:volRectDrawing atVirtualRect:CGRectMake(20., 0, width, volHeight)];
    [volRectDrawing release];
    
    //画成交量x轴的直线
    DZHAxisXDrawing *volumeAxisXDrawing = [[DZHAxisXDrawing alloc] init];
    volumeAxisXDrawing.drawingDataSource    = _dataSource;
    volumeAxisXDrawing.drawingTag       = DrawingTagsVolumeX;
    volumeAxisXDrawing.lineColor        = lineColor;
    [volumeContainer addDrawing:volumeAxisXDrawing atVirtualRect:CGRectMake(20., 0, width, volHeight)];
    [volumeAxisXDrawing release];
    
    //画成交量y轴的直线
    DZHAxisYDrawing *volumeAxisYDrawing = [[DZHAxisYDrawing alloc] init];
    volumeAxisYDrawing.drawingDataSource    = _dataSource;
    volumeAxisYDrawing.drawingTag       = DrawingTagsVolumeY;
    volumeAxisYDrawing.labelFont        = labelFont;
    volumeAxisYDrawing.labelColor       = labelColor;
    volumeAxisYDrawing.lineColor        = lineColor;
    volumeAxisYDrawing.labelSpace       = 20.;
    [volumeContainer addDrawing:volumeAxisYDrawing atVirtualRect:CGRectMake(.0, 0, axisWidth, volHeight)];
    [volumeAxisYDrawing release];
    
    //画成交量柱
    DZHFillBarDrawing *barDrawing       = [[DZHFillBarDrawing alloc] init];
    barDrawing.drawingDataSource        = _dataSource;
    barDrawing.drawingTag               = DrawingTagsVolumeItem;
    [volumeContainer addDrawing:barDrawing atVirtualRect:CGRectMake(20., 0, width, volHeight)];
    [barDrawing release];
    
    //k线移动平均线
    DZHMACurveDrawing *volMADrawing     = [[DZHMACurveDrawing alloc] init];
    volMADrawing.drawingDataSource      = _dataSource;
    volMADrawing.drawingTag             = DrawingTagsVolumeMa;
    [volumeContainer addDrawing:volMADrawing atVirtualRect:CGRectMake(20., 0, width, volHeight)];
    [volMADrawing release];
    
    [kLineContainer addDrawing:volumeContainer atVirtualRect:CGRectMake(.0, y, axisWidth, volHeight)];
    [volumeContainer release];
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
    return [_dataSource.context totalWidth] + kLineContainer.frame.size.width - kContainer.virtualFrame.size.width;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)changeScrollContainerContentSize:(CGSize)size
{
    CGFloat oldContentWidth     = kLineContainer.contentSize.width;
    CGRect frame                = kLineContainer.frame;
    CGFloat newContentWidth     = size.width;
    
    if (newContentWidth < frame.size.width)
    {
        kLineContainer.contentSize  = CGSizeMake(frame.size.width + 1., frame.size.height);
    }
    else
    {
        kLineContainer.contentSize  = CGSizeMake(newContentWidth, frame.size.height);
        [kLineContainer scrollRectToVisible:CGRectMake(newContentWidth - oldContentWidth - frame.size.width, .0, frame.size.width, frame.size.height) animated:NO];
    }
}

#pragma mark -  DZHKLineContainerDelegat                                                                                                                                                                                                                                  

- (CGFloat)scaledOfkLineContainer:(DZHKLineContainer *)container
{
    self.centerIndex            = (_dataSource.context.fromIndex + _dataSource.context.toIndex) * .5;
    return _scale;
}

- (void)kLineContainer:(DZHKLineContainer *)container scaled:(CGFloat)scale
{
    CGFloat maxScale            = _dataSource.maxScale;
    CGFloat minScale            = _dataSource.minScale;
    CGFloat finalScale          = scale > 1. ? 1.5 * scale : .7 * scale; //乘一个系数，增加放大时的平滑度
    
    if (finalScale >= maxScale && _dataSource.scale == maxScale)//超出最大缩放倍数，不做处理
        return;
    if (finalScale <= minScale && _dataSource.scale == minScale)//超出最小缩放倍数，不做处理
        return;
    
    CGRect frame                = container.frame;
    _dataSource.scale           = MAX(MIN(finalScale,maxScale),minScale);
    _scale                      = MAX(MIN(scale,maxScale),minScale);
    CGFloat newPosition         = [_dataSource.context locationForIndex:self.centerIndex];
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
    NSUInteger index    = [_dataSource.context nearIndexForLocation:point.x];
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
//    CGFloat offset                      = scrollView.contentOffset.x;
//    
//    if (offset > 0. && offset < scrollView.contentSize.width - scrollView.frame.size.width)
//    {
//        int width                       = [_dataSource kItemWidth];
//        if (fabs((offset - _lastOffset) / width) > 1.) //如果移动的距离大于一根k线的宽度，则刷新界面
//        {
//            CGFloat x                   = [_dataSource nearTimesLocationForLocation:offset]; //让偏移量刚好为k线宽度整数倍
//            
//            scrollView.contentOffset    = CGPointMake(x, scrollView.contentOffset.y);
//            self.lastOffset             = x;
//            [scrollView setNeedsDisplay];
//        }
//    }
//    else
    {
        [scrollView setNeedsDisplay];
    }
}

@end


