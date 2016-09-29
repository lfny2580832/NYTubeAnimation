//
//  NYTubeAnimationView.m
//  NYTubeAnimationDemo
//
//  Created by 牛严 on 16/9/1.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "NYTubeAnimationView.h"
#import "NYNarrowView.h"

#define sinx(a)  sin(a/180*M_PI)
#define cosx(a)  cos(a/180*M_PI)
#define tanx(a)  tan(a/180*M_PI)

@interface NYTubeAnimationView ()

@property (nonatomic, strong) NYNarrowView *narrowView;
@property (nonatomic, strong) TestView *testView;

@end

@implementation NYTubeAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = NO;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self addSubview:self.narrowView];
    self.narrowView.chosen_d = 1;
}

- (void)setChosen_d:(double)chosen_d
{
    self.narrowView.chosen_d = chosen_d;
}

#pragma mark Get
 - (NYNarrowView *)narrowView
{
    if (!_narrowView) {
        _narrowView = [[NYNarrowView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    return _narrowView;
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
