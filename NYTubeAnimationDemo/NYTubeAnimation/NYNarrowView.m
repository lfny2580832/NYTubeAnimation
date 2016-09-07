//
//  NYNarrowLayer.m
//  NYTubeAnimationDemo
//
//  Created by 牛严 on 16/9/2.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "NYNarrowView.h"

#define sinx(a)  sin(a/180*M_PI)
#define cosx(a)  cos(a/180*M_PI)
#define tanx(a)  tan(a/180*M_PI)

@interface NYNarrowView ()

@property (nonatomic, assign) double a;
@property (nonatomic, assign) double d;     /// 平移距离
@property (nonatomic, assign) double max_d;

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) CAShapeLayer *volcanoShape;           //火山形状
@property (nonatomic, strong) CAShapeLayer *semicircleShape;        //半圆形状
@end

@implementation NYNarrowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _r1 = 400;
        _r2 = 200;
        _a = 30.0;      //角度制
        
        self.volcanoShape = [[CAShapeLayer alloc]init];
        self.semicircleShape = [[CAShapeLayer alloc]init];
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.volcanoShape.frame = frame;
        self.semicircleShape.frame = frame;
        [self.layer addSublayer:self.volcanoShape];
        [self.layer addSublayer:self.semicircleShape];
        
        _d = 0;
//        [self drawWithParams];
        [self setDisplayLink];
    }
    return self;
}

- (void)setDisplayLink
{
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeParam)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)changeParam
{
    _d = _d + 4;
    [self drawWithParams];

    if (_d >= _max_d) {
        _d = 0;
    }
}

- (void)drawWithParams
{
    CGPoint pointO = CGPointMake(0, 500);
    CGPoint pointP = CGPointMake(1.5*_r1*cosx(_a) + pointO.x, -1.5*_r1*sinx(_a) + pointO.y);
    
    _max_d = pointP.x - pointO.x;
    
    CGPoint pointA = CGPointMake(_r1*cosx(_a) + pointO.x, -_r1*sinx(_a) + pointO.y);
    CGPoint pointB = CGPointMake(pointA.x, pointO.y + (pointO.y - pointA.y ));
    CGPoint pointC = CGPointMake(pointP.x, pointP.y + _r2);
    double h = 2* ( pointO.y - pointC.y );
    CGPoint pointD = CGPointMake(pointC.x, pointC.y + h);
    
    //动态圆 的圆弧角度/2
    double c = atan((pointP.x - pointO.x - _d)/(pointO.y - pointP.y))*180/M_PI;
    //上方动态点的坐标
    double Mx = pointP.x - sinx(c) * _r2;
    double My = pointP.y + cosx(c) * _r2;
//    double My = sqrt(pow(_r2, 2) - pow(Mx, 2) - pow(pointP.x, 2) + 2*Mx*(pointP.x)) + pointP.y;
    CGPoint pointM1 = CGPointMake(Mx, My);
    CGPoint pointM2 = CGPointMake(Mx, My + 2 * (pointO.y - My));
    CGPoint pointE = CGPointMake(Mx + My - pointO.y, pointO.y);
    //动态圆的圆心
    CGPoint pointQ = CGPointMake(pointO.x + _d, pointO.y);
    //动态圆的半径
    double r3 = (pointO.y - pointP.y)/cosx(c) - _r2;
    
    //----------------------------------------------直接圆弧画path-----------------------------------------
    UIBezierPath *vocalnoPath = [UIBezierPath bezierPath];
    [vocalnoPath addArcWithCenter:pointP radius:_r2 startAngle:(M_PI * ((90 + c)/180)) endAngle:(M_PI * ((180 - _a)/180)) clockwise:YES];
//    [vocalnoPath addArcWithCenter:pointO radius:_r1 startAngle: (- M_PI * _a/180) endAngle:(M_PI * _a/180) clockwise:YES];
    [vocalnoPath addArcWithCenter:CGPointMake(pointP.x, pointO.y + (pointO.y - pointP.y)) radius:_r2 startAngle:((180 + _a)/180 *M_PI) endAngle:(((270 - c)/180) *M_PI) clockwise:YES];
    
    self.volcanoShape.path = vocalnoPath.CGPath;
    
    
    UIBezierPath *semiPath = [UIBezierPath bezierPath];
    //减去0.2是为了严密贴合，因为double计算最终结果稍有偏差
    [semiPath addArcWithCenter:CGPointMake(pointQ.x - 0.25, pointQ.y) radius:r3 startAngle:(((270 + c)/180) * M_PI) endAngle:(((90 - c)/180)*M_PI) clockwise:YES];

    self.semicircleShape.path  = semiPath.CGPath;
    
    [self.volcanoShape setNeedsDisplay];
    [self.semicircleShape setNeedsDisplay];
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
