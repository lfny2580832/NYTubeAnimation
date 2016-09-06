//
//  NYNarrowLayer.m
//  NYTubeAnimationDemo
//
//  Created by 牛严 on 16/9/2.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "NYNarrowLayer.h"

#define sinx(a)  sin(a/180*M_PI)
#define cosx(a)  cos(a/180*M_PI)
#define tanx(a)  tan(a/180*M_PI)

@interface NYNarrowLayer ()

@property (nonatomic, assign) double a;
@property (nonatomic, assign) double d;     /// 平移距离
@property (nonatomic, assign) double max_d;

@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation NYNarrowLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        _r1 = 400;
        _r2 = 200;
        _a = 30.0;      //角度制
        _d = 0;
        
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
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

- (void)drawWithParams
{
    CGPoint pointO = CGPointMake(0, 500);
    CGPoint pointP = CGPointMake(1.5*_r1*cosx(_a) + pointO.x, -1.5*_r1*sinx(_a) + pointO.y);
    CGPoint pointA = CGPointMake(_r1*cosx(_a) + pointO.x, -_r1*sinx(_a) + pointO.y);
    CGPoint pointB = CGPointMake(pointA.x, pointO.y + (pointO.y - pointA.y ));
    CGPoint pointC = CGPointMake(pointP.x, pointP.y + _r2);
    double h = 2* ( pointO.y - pointC.y );
    CGPoint pointD = CGPointMake(pointC.x, pointC.y + h);
    
#warning 此处计算错误
    //动态圆 的圆弧角度/2
    double c = atan((pointP.x - pointO.x - _d)/(pointO.y - pointP.y))*180/M_PI;
    //上方动态点的坐标
    double Mx = pointP.x - sinx(c) * _r2;
    double My = pointP.y + cosx(c) * _r2;
//    double My = sqrt(pow(_r2, 2) - pow(Mx, 2) - pow(pointP.x, 2) + 2*Mx*(pointP.x)) + pointP.y;
    CGPoint pointM1 = CGPointMake(Mx, My);
    CGPoint pointM2 = CGPointMake(Mx, My + 2 * (pointO.y - My));
    CGPoint pointE = CGPointMake(Mx + My - pointO.y, pointO.y);
    
    _max_d = pointP.x - pointO.x;

    //动态圆的圆心
    CGPoint pointQ = CGPointMake(pointO.x + _d, pointO.y);
    //动态圆的半径
    double r3 = (pointO.y - pointP.y)/cosx(c) - _r2;
    
    NSLog(@"-----------%f",r3);
    //    // beizer控制点
//    // 画 AB
//    double r1_Offset = _r1/3.6;
//    CGPoint Ac_r1 = CGPointMake(pointA.x + sinx(_a) * r1_Offset, pointA.y + cosx(_a) * r1_Offset);
//    CGPoint Bc_r1 = CGPointMake(Ac_r1.x, pointB.y - cosx(_a) * r1_Offset);
//    
//    // 画 AC BD
//    double r2_Offset = _r2/3.6;
//    CGPoint Cc_left = CGPointMake(pointC.x - r2_Offset, pointC.y);
//    CGPoint Cc_right = CGPointMake(pointC.x + (h/2)/3.6, pointC.y);
//    CGPoint Dc_right = CGPointMake(pointD.x + (h/2)/3.6, pointD.y);
//    
//    CGPoint Dc_left = CGPointMake(pointD.x - r2_Offset, pointD.y);
//
//    CGPoint M1c_left = CGPointMake(pointM1.x - cosx(b) * r2_Offset, pointM1.y - sinx(b) * r2_Offset);
//    CGPoint M2c_left = CGPointMake(M1c_left.x, pointM2.y + sinx(b) * r2_Offset);
//    CGPoint Ac_r2 = CGPointMake(pointA.x + sinx(_a) * r2_Offset, pointA.y + cosx(_a) * r2_Offset);
//    CGPoint Bc_r2 = CGPointMake(Ac_r2.x, pointB.y - cosx(_a) * r2_Offset);
//    
//    // 画 M1M
//    double r3_Offset = r3/3.6;
//    CGPoint M1c_right = CGPointMake(pointM1.x + sinx(b) * r3_Offset, pointM1.y + sinx(b) * r3_Offset);
//    CGPoint M2c_right = CGPointMake(M1c_right.x, pointM2.y - sinx(b) * r3_Offset);

//    
//    
//    
//    
//    //---------------------------------------------使用appendPath方式组合path-------------------------------
//    UIBezierPath *pathAB =[UIBezierPath bezierPath];
//    [pathAB addArcWithCenter:pointO radius:_r1 startAngle: (- M_PI * _a/180) endAngle:(M_PI * _a/180) clockwise:YES];
//    
//    UIBezierPath *pathAC =[UIBezierPath bezierPath];
//    [pathAC addArcWithCenter:pointP radius:_r2 startAngle:(M_PI * 0.5) endAngle:(M_PI * (180 - _a)/180) clockwise:YES];
//    
//    
//    UIBezierPath *pathCD =[UIBezierPath bezierPath];
//    [pathCD addArcWithCenter:CGPointMake(pointP.x, pointO.y) radius:h/2 startAngle:(1.5*M_PI) endAngle:(0.5*M_PI) clockwise:YES];
//    
//    UIBezierPath *pathDB = [UIBezierPath bezierPath];
//    [pathDB addArcWithCenter:CGPointMake(pointP.x, pointO.y + (pointO.y - pointP.y)) radius:_r2 startAngle:((180 + _a)/180 *M_PI) endAngle:(1.5 *M_PI) clockwise:YES];
//    
//    [pathAC appendPath:pathAB];
//    [pathAC appendPath:pathDB];
//    [pathAC appendPath:pathCD];
//
//    [pathAC closePath];
//    
//    self.path = pathAC.CGPath;
    
    
    
    
    //----------------------------------------------直接圆弧画path-----------------------------------------
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:pointP radius:_r2 startAngle:(M_PI * ((90 + c)/180)) endAngle:(M_PI * ((180 - _a)/180)) clockwise:YES];
//    [path addArcWithCenter:pointO radius:_r1 startAngle: (- M_PI * _a/180) endAngle:(M_PI * _a/180) clockwise:YES];
    [path addArcWithCenter:CGPointMake(pointP.x, pointO.y + (pointO.y - pointP.y)) radius:_r2 startAngle:((180 + _a)/180 *M_PI) endAngle:(((270 - c)/180) *M_PI) clockwise:YES];
    [path addArcWithCenter:pointQ radius:r3 startAngle:(((270 + c)/180) * M_PI) endAngle:(((90 - c)/180)*M_PI) clockwise:YES];

    [path closePath];
    self.path = path.CGPath;
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
