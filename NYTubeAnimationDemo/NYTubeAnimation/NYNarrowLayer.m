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
    
}

@end
