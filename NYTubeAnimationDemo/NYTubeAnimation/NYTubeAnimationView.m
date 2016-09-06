//
//  NYTubeAnimationView.m
//  NYTubeAnimationDemo
//
//  Created by 牛严 on 16/9/1.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "NYTubeAnimationView.h"
#import "NYNarrowLayer.h"

#define sinx(a)  sin(a/180*M_PI)
#define cosx(a)  cos(a/180*M_PI)
#define tanx(a)  tan(a/180*M_PI)

@interface NYTubeAnimationView ()

@property (nonatomic, strong) NYNarrowLayer *narrowLayer;
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

    UIView *layerContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [layerContainer.layer addSublayer:self.narrowLayer];
    [self addSubview:layerContainer];
    [self.narrowLayer setNeedsDisplay];
    
//    [self addSubview:self.testView];
}

#pragma mark Get
 - (NYNarrowLayer *)narrowLayer
{
    if (!_narrowLayer) {
        _narrowLayer = [[NYNarrowLayer alloc]init];
        _narrowLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    return _narrowLayer;
}

- (TestView *)testView
{
    if (!_testView) {
        _testView = [[TestView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
    }
    return _testView;
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

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    
    CGPoint pointO = CGPointMake(100, 500);
    CGPoint pointP = CGPointMake(1.5*_r1*cosx(_a) + pointO.x, -1.5*_r1*sinx(_a) + pointO.y);
    CGPoint pointA = CGPointMake(_r1*cosx(_a) + pointO.x, -_r1*sinx(_a) + pointO.y);
    CGPoint pointB = CGPointMake(pointA.x, pointO.y + (pointO.y - pointA.y ));
    CGPoint pointC = CGPointMake(pointP.x, pointP.y + _r2);
    double h = 2* ( pointO.y - pointC.y );
    CGPoint pointD = CGPointMake(pointC.x, pointC.y + h);
    double Mx = pointA.x + _d;
    double My = sqrt(pow(_r2, 2) - pow(Mx, 2) - pow(pointP.x, 2) + 2*Mx*(pointP.x)) + pointP.y;
    CGPoint pointM1 = CGPointMake(Mx, My);
    CGPoint pointM2 = CGPointMake(Mx, My + 2 * (pointO.y - My));
    CGPoint pointE = CGPointMake(Mx + My - pointO.y, pointO.y);
    double r3 = sqrt(2) * (pointO.y - My);
    double H = cosx((90 -_a )) * _r2;
    double L = sinx((90 -_a )) * _r2;
    _max_d = L;
    double b = atan((L - _d)/H)*180/M_PI;        // 切角
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:pointP radius:_r2 startAngle:(M_PI * ((90 + b)/180)) endAngle:(M_PI * ((180 - _a)/180)) clockwise:YES];
    [path addArcWithCenter:pointO radius:_r1 startAngle: (- M_PI * _a/180) endAngle:(M_PI * _a/180) clockwise:YES];
    [path addArcWithCenter:CGPointMake(pointP.x, pointO.y + (pointO.y - pointP.y)) radius:_r2 startAngle:((180 + _a)/180 *M_PI) endAngle:(((270 - b)/180) *M_PI) clockwise:YES];
    //    [path addArcWithCenter:CGPointMake(pointP.x, pointO.y) radius:r3 startAngle:(1.5*M_PI) endAngle:(0.5*M_PI) clockwise:YES];
    
    [path closePath];
    [path stroke];
    
    [self drawPoint:@[[NSValue valueWithCGPoint:pointM1]] withContext:context];
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