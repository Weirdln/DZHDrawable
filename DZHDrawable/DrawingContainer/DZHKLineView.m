//
//  DZHKLineView.m
//  DzhIPhone
//
//  Created by Duanwwu on 14-6-20.
//
//

#import "DZHKLineView.h"
#import "DZHKLineDateFormatter.h"
#import "DZHKLineValueFormatter.h"
#import "DZHAxisYDrawing.h"
#import "UIColor+RGB.h"
#import "DZHRectangleDrawing.h"
#import "DZHDrawingWrapper.h"

#define kStrokeColorKey @"strokeColor"
#define kFillColorKey   @"fillColor"

@interface DZHKLineView ()<UIGestureRecognizerDelegate>

@property (nonatomic, retain) NSMutableDictionary *typeAttributes;//阳线、阴线、十字线相关属性设置

@property (nonatomic, retain) NSMutableArray *groups;// {索引:DZHDrawingGroup}

@property (nonatomic, retain) NSMutableArray *drawings;

@property (nonatomic) int groupStartIndex;

@property (nonatomic) int groupEndIndex;

@property (nonatomic) CGFloat yLabelWidth;

- (CGFloat)_getKLineWidth;

- (CGFloat)_getKlinePadding;

- (void)_getKLineMaxPrice:(int *)maxPrice minPrice:(int *)minPrice fromIndex:(int)from toIndex:(int)to;

/**
 * 调整contentSize，当视图放大缩小时，需手动调用此方法设置正确的contentSize
 */
- (void)_adjustContentSize;

@end

@implementation DZHKLineView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor            = [UIColor clearColor];
        self.typeAttributes             = [NSMutableDictionary dictionary];
        self.groups                     = [NSMutableArray array];
        self.drawings                   = [NSMutableArray array];
        
        self.kLineWidth                 = 2.;
        self.kLinePadding               = 2.;
        self.decelerationRate           = .4;
        self.showsHorizontalScrollIndicator = NO;
        self.scale                      = 1.0;
        self.yLabelWidth                = 20.;
        
        UIColor *lineColor              = [UIColor colorFromRGB:0x1e2630];
        UIColor *labelColor             = [UIColor colorFromRGB:0x707880];
        
        _kLineDrawing                   = [[DZHKLineDrawing alloc] init];
        _kLineDrawing.dataSource        = self;
        [_kLineDrawing setColor:[UIColor colorFromRGB:0xf92a27] forType:KLineTypePositive];
        [_kLineDrawing setColor:[UIColor colorFromRGB:0x2b9826] forType:KLineTypeNegative];
        [_kLineDrawing setColor:[UIColor grayColor] forType:KLineTypeCross];
        
        _axisYDrawing                   = [[DZHAxisYDrawing alloc] init];
        _axisYDrawing.formatter         = [[[DZHKLineValueFormatter alloc] init] autorelease];
        _axisYDrawing.labelFont         = [UIFont systemFontOfSize:10.];
        _axisYDrawing.labelColor        = labelColor;
        _axisYDrawing.lineColor         = lineColor;
        _axisYDrawing.tickLabelWidth    = self.yLabelWidth;
        _axisYDrawing.minTickCount      = 4;
        _axisYDrawing.maxTickCount      = 4;
        
        _axisXDrawing                   = [[DZHAxisXDrawing alloc] init];
        _axisXDrawing.dataSource        = self;
        _axisXDrawing.formatter         = [[[DZHKLineDateFormatter alloc] init] autorelease];
        _axisXDrawing.labelColor        = labelColor;
        _axisXDrawing.lineColor         = lineColor;
        _axisXDrawing.labelFont         = [UIFont systemFontOfSize:10.];
        _axisXDrawing.labelHeight       = 20.;
        
        _rectDrawing                    = [[DZHRectangleDrawing alloc] init];
        _rectDrawing.lineColor          = lineColor;
        
        UILabel *label                  = [[UILabel alloc] initWithFrame:CGRectMake(- 50., 95., 40., 20.)];
        label.font                      = [UIFont systemFontOfSize:10.];
        label.textColor                 = [UIColor whiteColor];
        label.backgroundColor           = [UIColor clearColor];
        label.text                      = @"加载中...";
        [self addSubview:label];
        _tipLable                       = label;
        
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleKLine:)];
        pinch.delegate                  = self;
        [self addGestureRecognizer:pinch];
        [pinch release];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressKLine:)];
        [self addGestureRecognizer:longPress];
        [longPress release];
        
        [pinch requireGestureRecognizerToFail:longPress];
        [self.panGestureRecognizer requireGestureRecognizerToFail:longPress];
        [self.pinchGestureRecognizer requireGestureRecognizerToFail:longPress];
    }
    return self;
}

- (void)dealloc
{
    [_klines release];
    [_typeAttributes release];
    [_kLineDrawing release];
    [_groups release];
    [_axisXDrawing release];
    [_axisYDrawing release];
    [_rectDrawing release];
    [super dealloc];
}

- (void)setKlines:(NSArray *)klines
{
    if (_klines != klines)
    {
        [_klines release];
        _klines                             = [klines retain];
        
        [self _adjustContentSize];
        
        [_groups removeAllObjects];
        
        int max                             = NSIntegerMin;
        int min                             = NSIntegerMax;
        int idx                             = 0;
        
        DZHKLineEntity *lastEntity;
        DZHDrawingGroup *group          = [[DZHDrawingGroup alloc] init];
        
        int endIndex                        = [klines count] - 1;
        for (DZHKLineEntity *entity in _klines)
        {
            if (idx == 0)
            {
                group.startIndex            = idx;
                max                         = entity.high;
                min                         = entity.low;
            }
            else
            {
                if ([self _divideGroupAtEntity:entity preEntity:lastEntity]) // 切换组
                {
                    group.endIndex          = idx - 1;
                    group.date              = lastEntity.date;
                    group.max               = max;
                    group.min               = min;
                    
                    [_groups addObject:group];
                    [group release];
                    
                    group                   = [[DZHDrawingGroup alloc] init];
                    group.startIndex        = idx;
                    
                    max                     = entity.high;
                    min                     = entity.low;
                }
                else // 计算该组的最大值最小值
                {
                    if (entity.high > max)
                        max                 = entity.high;
                    
                    if (entity.low < min)
                        min                 = entity.low;
                }
                
                if (idx == endIndex) //最后一个数据，直接保存组
                {
                    group.endIndex          = idx;
                    group.date              = entity.date;
                    group.max               = max;
                    group.min               = min;

                    [_groups addObject:group];
                    [group release];
                }
            }
            lastEntity          = entity;
            idx ++;
        }
    }
}

- (void)scaleKLine:(UIPinchGestureRecognizer *)gesture
{
    CGPoint offset              = self.contentOffset;
    CGFloat centerPosition      = offset.x + self.frame.size.width * .5;
    int index                   = [self nearIndexForLocation:centerPosition];
    
    if (gesture.scale > 3.)
        gesture.scale           = 3.;
    else if (gesture.scale < .5)
        gesture.scale           = .5;
    
    self.scale                  = gesture.scale;
    CGFloat newPosition         = [self kLineLocationForIndex:index];
    self.contentSize            = CGSizeMake([self totalKLineWidth], self.frame.size.height);
    [self scrollRectToVisible:CGRectMake(newPosition - self.frame.size.width * .5, .0, self.frame.size.width, self.frame.size.height) animated:NO];
    NSLog(@"scale : %f", self.scale);
}

- (void)longPressKLine:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        
    }
    else if (gesture.state == UIGestureRecognizerStateEnded)
    {
        
    }
    
    CGPoint point       = [gesture locationInView:self];
    NSUInteger index    = [self indexForLocation:point.x];
    
    if (index == NSUIntegerMax)
    {
        NSLog(@"无对应K线数据");
    }
    else
    {
        DZHKLineEntity *entity  = [_klines objectAtIndex:index];
        NSLog(@"(%f,%f) 索引:%d 开:%d 收:%d 高:%d 低:%d",point.x,point.y,index,entity.open,entity.close,entity.high,entity.low);
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context        = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    [self drawRect:rect withContext:context];
}

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
    CGRect region               = CGRectMake(rect.origin.x + _yLabelWidth, .0, rect.size.width - _yLabelWidth, 210.);
    CGRect axisXRect            = CGRectMake(rect.origin.x + _yLabelWidth, 0., rect.size.width - _yLabelWidth, 230.);
    CGRect axisYRect            = CGRectMake(rect.origin.x, 5., rect.size.width, 200.);
    CGRect kLineRect            = CGRectMake(rect.origin.x + _yLabelWidth, 5., rect.size.width - _yLabelWidth, 200.);
    
    [_rectDrawing drawRect:region withContext:context];
    
    int drawStartIndex,drawEndIndex;
    [self needDrawKLinesInRect:kLineRect startIndex:&drawStartIndex endIndex:&drawEndIndex];
    
    int min,max;
    [self _getKLineMaxPrice:&max minPrice:&min fromIndex:drawStartIndex toIndex:drawEndIndex];
    
    [self drawAxisX:axisXRect context:context];
    
    [_axisYDrawing prepareAndAdjustMaxIfNeedWithMax:&max min:&min];
    [self drawAxisY:axisYRect context:context max:max min:min];
    
    [self drawKLine:kLineRect context:context fromIndex:drawStartIndex toIndex:drawEndIndex max:max min:min];
}

- (void)drawAxisX:(CGRect)rect context:(CGContextRef)context
{
    int endIndex                = (_groupEndIndex == [_groups count] -1) ? _groupEndIndex - 1 : _groupEndIndex;
    _axisXDrawing.groups        = [_groups subarrayWithRange:NSMakeRange(_groupStartIndex, endIndex - _groupStartIndex + 1)];
    [_axisXDrawing drawRect:rect withContext:context];
}

- (void)drawAxisY:(CGRect)rect context:(CGContextRef)context max:(int)max min:(int)min
{
    _axisYDrawing.max       = max;
    _axisYDrawing.min       = min;
    
    [_axisYDrawing drawRect:rect withContext:context];
}

- (void)drawKLine:(CGRect)rect context:(CGContextRef)context fromIndex:(int)fromIndex toIndex:(int)toIndex max:(int)max min:(int)min;
{
    DZHKLineDrawing *drawing    = _kLineDrawing;
    drawing.fromIndex           = fromIndex;
    drawing.toIndex             = toIndex;
    drawing.kLineDatas          = self.klines;
    drawing.maxPrice            = max;
    drawing.minPrice            = min;
    
    [drawing drawRect:rect withContext:context];
}

#pragma mark - Private Method

- (CGFloat)_getKLineWidth
{
    return _kLineWidth * _scale;
}

- (CGFloat)_getKlinePadding
{
    return _kLinePadding * _scale;
}

- (void)_adjustContentSize
{
    CGFloat oldContentWidth     = self.contentSize.width;
    CGFloat newContentWidth     = [self totalKLineWidth];
    
    self.contentSize            = CGSizeMake(newContentWidth, self.frame.size.height);
    
    [self scrollRectToVisible:CGRectMake(newContentWidth - oldContentWidth - self.frame.size.width, .0, self.frame.size.width, self.frame.size.height) animated:NO];
}

- (void)_getKLineMaxPrice:(int *)maxPrice minPrice:(int *)minPrice fromIndex:(int)from toIndex:(int)to
{
    NSEnumerationOptions options = from * 2 > [self.klines count] ? NSEnumerationReverse : 0;
    
    __block int groupStartIndex = NSIntegerMax;
    __block int groupEndIndex   = NSIntegerMax;
    
    [_groups enumerateObjectsWithOptions:options usingBlock:^(DZHDrawingGroup *group, NSUInteger idx, BOOL *stop) {
        
        if (from >= group.startIndex && from <= group.endIndex)
            groupStartIndex      = idx;
        
        if (to >= group.startIndex && to <= group.endIndex)
            groupEndIndex        = idx;
        
        if (groupStartIndex != NSIntegerMax && groupEndIndex != NSIntegerMax)
            *stop               = YES;
    }];
    
    NSParameterAssert(groupStartIndex != NSIntegerMax);
    NSParameterAssert(groupEndIndex != NSIntegerMax);
    
    /*计算最大值最小值，将需要显示组的左边组和右边组也包括进来，用于防止太频繁变动坐标*/
    groupStartIndex             = MAX(0, groupStartIndex);
    groupEndIndex               = MIN(groupEndIndex, [_groups count] - 1);
    
    int max                     = NSIntegerMin;
    int min                     = NSIntegerMax;

    for (int i = from; i <= to; i++)
    {
        DZHKLineEntity *entity  = [_klines objectAtIndex:i];
        
        if (entity.high > max)
            max        = entity.high;
        
        if (entity.low < min)
            min        = entity.low;
    }
    
    *minPrice                           = min;
    *maxPrice                           = max;
    
    self.groupStartIndex                = groupStartIndex;
    self.groupEndIndex                  = groupEndIndex;
    
    NSLog(@"group start:%d,end:%d  price max:%d,min:%d",groupStartIndex,groupEndIndex,max,min);
}

- (BOOL)_divideGroupAtEntity:(DZHKLineEntity *)entity preEntity:(DZHKLineEntity *)preEntity
{
    int lastMonth               = (preEntity.date % 10000)/100;
    int curMonth                = (entity.date % 10000)/100;
    
    return lastMonth != curMonth;
}

#pragma mark - DZHDrawingContainer

- (void)addDrawing:(id<DZHDrawing>)drawing atVirtualRect:(CGRect)rect
{
    DZHDrawingWrapper *wrapper          = [[DZHDrawingWrapper alloc] initWithDrawing:drawing virtualRect:rect];
    [self.drawings addObject:wrapper];
    [wrapper release];
}

- (CGRect)realRectForVirtualRect:(CGRect)virtualRect currentRect:(CGRect)currentRect;
{
    return CGRectMake(currentRect.origin.x + virtualRect.origin.x, virtualRect.origin.y, virtualRect.size.width, virtualRect.size.height);
}

- (CGFloat)beginCoordXForIndex:(NSUInteger)index
{
    return [self kLineLocationForIndex:index];
}

- (CGFloat)centerCoordXForIndex:(NSUInteger)index
{
    return [self centerCoordXForIndex:index];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]])
    {
        ((UIPinchGestureRecognizer *)gestureRecognizer).scale   = self.scale;
    }
    return YES;
}

#pragma mark - DZHKLineDrawingDataSource

- (CGFloat)widthForKLine:(id<DZHKLineDrawing>)drawing
{
    return [self _getKLineWidth];
}

- (CGFloat)kLineDrawing:(id<DZHKLineDrawing>)drawing locationForIndex:(NSUInteger)index
{
    return [self kLineLocationForIndex:index];
}

#pragma mark - DZHAxisXDrawingDataSource

- (CGFloat)axisXDrawing:(DZHAxisXDrawing *)drawing locationForIndex:(NSUInteger)index
{
    return [self kLineCenterLocationForIndex:index];
}

@end

@implementation DZHKLineView (abstract)

- (void)needDrawKLinesInRect:(CGRect)rect startIndex:(int *)startIndex endIndex:(int *)endIndex
{
    CGFloat kWidth              = [self _getKLineWidth];    //k线实体宽度
    CGFloat kPadding            = [self _getKlinePadding];  //k线间距
    CGFloat space               = kWidth + kPadding;
    *startIndex                 = MAX(MAX(.0, rect.origin.x - kPadding - self.yLabelWidth)/space, 0);                   //绘制起始点
    *endIndex                   = MIN((CGRectGetMaxX(rect) - kPadding - self.yLabelWidth)/space, [_klines count] - 1);  //绘制结束点
}

- (CGFloat)totalKLineWidth
{
    CGFloat kLineWidth          = [self _getKLineWidth];
    CGFloat kLinePadding        = [self _getKlinePadding];
    return [self.klines count] * (kLineWidth + kLinePadding) + kLinePadding + self.yLabelWidth;
}

- (CGFloat)kLineLocationForIndex:(NSUInteger)index
{
    CGFloat kWidth              = [self _getKLineWidth];    //k线实体宽度
    CGFloat kPadding            = [self _getKlinePadding];  //k线间距
    CGFloat space               = kWidth + kPadding;
    return index * space + kPadding + self.yLabelWidth;
}

- (CGFloat)kLineCenterLocationForIndex:(NSUInteger)index
{
    CGFloat kWidth              = [self _getKLineWidth];    //k线实体宽度
    CGFloat kPadding            = [self _getKlinePadding];  //k线间距
    CGFloat space               = kWidth + kPadding;
    return index * space + kPadding + self.yLabelWidth + kWidth * .5;
}

- (NSUInteger)indexForLocation:(CGFloat)position
{
    CGFloat kWidth              = [self _getKLineWidth];    //k线实体宽度
    CGFloat kPadding            = [self _getKlinePadding];  //k线间距
    CGFloat space               = kWidth + kPadding;
    CGFloat v                   = (position - kPadding - self.yLabelWidth) / space ;
    int mode                    = ((int)(v * 100)) %100;
    int scale                   = kWidth / space * 100;
    return mode > scale ? NSUIntegerMax : v;
}

- (NSUInteger)nearIndexForLocation:(CGFloat)position
{
    CGFloat kWidth              = [self _getKLineWidth];    //k线实体宽度
    CGFloat kPadding            = [self _getKlinePadding];  //k线间距
    CGFloat space               = kWidth + kPadding;
    CGFloat index               = (position - kPadding - self.yLabelWidth) / space;
    return roundf(index);
}

@end
