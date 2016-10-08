//
//  NYTubeAnimationView.m
//  NYTubeAnimationDemo
//
//  Created by 牛严 on 16/9/1.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "NYTubeAnimationControl.h"
#import "NYTubeAnimationView.h"

#define sinx(a)  sin(a/180*M_PI)
#define cosx(a)  cos(a/180*M_PI)
#define tanx(a)  tan(a/180*M_PI)

@interface NYTubeAnimationControl ()<NYTubeAnimationViewDelegate>

@property (nonatomic, strong) NYTubeAnimationView *narrowView;
@property (nonatomic, strong) NYTubeAnimationView *opNarrowView;

@end

@implementation NYTubeAnimationControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.narrowView];
        [self addSubview:self.opNarrowView];
        self.narrowView.chosen_d = 0.001;
        self.opNarrowView.chosen_d = 0.001;
    }
    return self;
}

- (void)turnToFirstPage
{
    self.narrowView.chosen_d = 0.001;
    self.narrowView.hidden = YES;
    self.opNarrowView.chosen_d = self.frame.size.width/2;
    self.opNarrowView.hidden = NO;
}

- (void)turnToSecondePage
{
    self.opNarrowView.chosen_d = 0.001;
    self.opNarrowView.hidden = YES;
    self.narrowView.chosen_d = self.frame.size.width/2;
    self.narrowView.hidden = NO;
}

#pragma mark NYTubeAnimtionViewDelegate
- (void)didTurnedToLeft
{
    if ([self.delegate respondsToSelector:@selector(didTurnedToFirstPage)]) {
        [self.delegate didTurnedToFirstPage];
    }
}

- (void)didTurnedToRight
{
    if ([self.delegate respondsToSelector:@selector(didTurnedToSecondPage)]) {
        [self.delegate didTurnedToSecondPage];
    }
}

#pragma mark Get
- (BOOL)origin
{
    if (self.narrowView.d <= 10) {
        return YES;
    }else{
        return NO;
    }
}

 - (NYTubeAnimationView *)narrowView
{
    if (!_narrowView) {
        _narrowView = [[NYTubeAnimationView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _narrowView.towardsType = TowardRight;
        _narrowView.delegate = self;
    }
    return _narrowView;
}

- (NYTubeAnimationView *)opNarrowView
{
    if (!_opNarrowView) {
        _opNarrowView = [[NYTubeAnimationView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _opNarrowView.towardsType = TowardLeft;
        _opNarrowView.transform = CGAffineTransformMakeRotation(M_PI);
        _opNarrowView.hidden = YES;
        _opNarrowView.delegate = self;
    }
    return _opNarrowView;
}

@end



@interface TestView ()

@property (nonatomic, assign) double a;
@property (nonatomic, assign) double d;     /// 平移距离
@property (nonatomic, assign) double max_d;

@end


@implementation TestView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

//输入圆心坐标，半径，起始角度，结束角度，计算两个控制点坐标（只能拟合小于九十度的圆弧）
- (UIBezierPath *)bezierPathWithCenter:(CGPoint)center radius:(double)radius startAngle:(double)startAngle endAngle:(double)endAngle
{
    //start点，逆时针
    CGPoint pointStart = CGPointMake(center.x + cosx(startAngle) * radius, center.y + sinx(startAngle) * radius);
    //end点
    CGPoint pointEnd = CGPointMake(center.x + cosx(endAngle) * radius, center.y + sinx(endAngle) * radius);
    //圆弧角度
    double pathAngle = endAngle - startAngle;
    //控制点的长度
    double offset = 4 * tanx(pathAngle/4) /3;
    //起点控制点的坐标
    CGPoint startControlPoint = CGPointMake(pointStart.x - offset * (pointStart.y - center.y), pointStart.y + offset * (pointStart.x - center.x));
    //终点控制点的坐标
    CGPoint endControlPoint = CGPointMake(pointEnd.x + offset * (pointEnd.y - center.y), pointEnd.y - offset * (pointEnd.x - center.x));
    
    UIBezierPath *arcPath = [UIBezierPath bezierPath];
    [arcPath moveToPoint:pointStart];
    [arcPath addCurveToPoint:pointEnd controlPoint1:startControlPoint controlPoint2:endControlPoint];
    
    return arcPath;
}

//一个提取出来的画点的方法：在 point 位置画一个点，方便观察运动情况
-(void)drawPoint:(NSArray *)points withContext:(CGContextRef)ctx
{
    for (NSValue *pointValue in points) {
        CGPoint point = [pointValue CGPointValue];
        NSLog(@"-----%@",NSStringFromCGPoint(point));
        CGContextFillRect(ctx, CGRectMake(point.x - 2,point.y - 2,4,4));
    }
}

@end
