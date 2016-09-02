//
//  NYNarrowLayer.m
//  NYTubeAnimationDemo
//
//  Created by 牛严 on 16/9/2.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "NYNarrowLayer.h"

@interface NYNarrowLayer ()

@property (nonatomic, assign) double a;

@property (nonatomic, assign) double d;

@end

@implementation NYNarrowLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        _r1 = 50;
        _r2 = 25;
        _a = 30/360 * M_PI;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx
{
    CGPoint pointO = CGPointMake(100, 100);
    CGPoint pointP = CGPointMake(3/2*_r1*cos(_a) + pointO.x, 3/2*_r1*sin(_a) + pointO.y);
    CGPoint pointA = CGPointMake(_r1*cos(_a) + pointO.x, _r1*sin(_a) + pointO.y);
    CGPoint pointB = CGPointMake(pointA.x, pointO.y - pointA.y);
    CGPoint pointC = CGPointMake(pointP.x, pointP.y - _r2);
    double h = 2* (pointP.y - pointC.y);
    CGPoint pointD = CGPointMake(pointC.x, pointC.y - h);
    double Mx = pointA.x + _d;
    double My = sqrt(pow(_r2, 2) - pow(Mx, 2) - pow(pointP.x, 2) + 2*Mx*(pointP.x)) + pointP.y;
    CGPoint E = CGPointMake(Mx + My - pointO.y, pointO.y);
    double r3 = sqrt(2) * (My - pointO.y);
    double H = cos((90 -_a ) * _r2);
    double L = sin((90 -_a ) * _r2);
    double b = atan((L - _d)/H);
    
    double r1Offset = _r1/3.6;
//    CGPoint Ac = CGPointMake(<#CGFloat x#>, <#CGFloat y#>)
}

@end
