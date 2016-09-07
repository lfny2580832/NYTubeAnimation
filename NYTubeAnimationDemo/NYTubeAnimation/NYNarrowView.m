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

@property (nonatomic, assign) double a;         /// 大圆、小圆圆心连线与x轴的夹角
@property (nonatomic, assign) double d;         /// 平移距离，输入值
@property (nonatomic, assign) double mid_d;     /// 挤压完成，开始拉伸的距离
@property (nonatomic, assign) double tube_d;     /// 挤压开始，到达出口的距离，即管道长度
@property (nonatomic, assign) double mainRectWidth; //主体矩形的宽度

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) CAShapeLayer *leftSemiShape;          //左边圆弧
@property (nonatomic, strong) CAShapeLayer *mainRecShape;           //主体矩形区域
@property (nonatomic, strong) CAShapeLayer *topRightShape;          //右上角形状
@property (nonatomic, strong) CAShapeLayer *bottomRightShape;       //右下角形状
@property (nonatomic, strong) CAShapeLayer *volcanoShape;           //火山形状
@property (nonatomic, strong) CAShapeLayer *semicircleShape;        //半圆形状
@property (nonatomic, strong) CAShapeLayer *recShape;               //管道形状矩形区域

@end

@implementation NYNarrowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _r1 = 100;
        _r2 = 50;
        _a = 23.0;      //角度制
        _d = 0;
        _mainRectWidth = 200;
        _tube_d = _r1 * 4;
        
        [self initShapes];
        
        _d = 199;
        [self drawWithParams];
//        [self setDisplayLink];
    }
    return self;
}

//初始化各shape
- (void)initShapes
{
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

    self.leftSemiShape = [[CAShapeLayer alloc]init];
    self.volcanoShape = [[CAShapeLayer alloc]init];
    self.semicircleShape = [[CAShapeLayer alloc]init];
    self.recShape = [[CAShapeLayer alloc]init];
    self.mainRecShape = [[CAShapeLayer alloc]init];
    self.topRightShape = [[CAShapeLayer alloc]init];
    self.bottomRightShape = [[CAShapeLayer alloc]init];
    
    self.leftSemiShape.frame = frame;
    self.volcanoShape.frame = frame;
    self.semicircleShape.frame = frame;
    self.recShape.frame = frame;
    self.mainRecShape.frame = frame;
    self.topRightShape.frame = frame;
    self.bottomRightShape.frame = frame;
    
    [self.layer addSublayer:self.leftSemiShape];
    [self.layer addSublayer:self.mainRecShape];
    [self.layer addSublayer:self.topRightShape];
    [self.layer addSublayer:self.bottomRightShape];
    [self.layer addSublayer:self.volcanoShape];
    [self.layer addSublayer:self.semicircleShape];
    [self.layer addSublayer:self.recShape];
}

//初始化CADisplaylink并添加到runloop执行动作
- (void)setDisplayLink
{
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeParam)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

//每帧执行的动作
- (void)changeParam
{
    _d = _d + 4;
    [self drawWithParams];

    if (_d >= _tube_d + _mid_d) {
        _d = 0;
    }
}

- (void)drawWithParams
{
    CGPoint pointO = CGPointMake(400, 500);
    CGPoint pointP = CGPointMake(1.5*_r1*cosx(_a) + pointO.x, -1.5*_r1*sinx(_a) + pointO.y);
    //左圆弧圆心
    CGPoint pointR = CGPointMake(pointO.x - _mainRectWidth + _d, pointO.y);
    _mid_d = pointP.x - pointO.x;
    
    CGPoint pointA = CGPointMake(_r1*cosx(_a) + pointO.x, -_r1*sinx(_a) + pointO.y);
    CGPoint pointB = CGPointMake(pointA.x, pointO.y + (pointO.y - pointA.y ));
    CGPoint pointC = CGPointMake(pointP.x, pointP.y + _r2);
    double h = 2* ( pointO.y - pointC.y );
    CGPoint pointD = CGPointMake(pointC.x, pointC.y + h);
    
    //动态圆 的圆弧角度/2
    double c = atan((pointP.x - pointO.x - _d)/(pointO.y - pointP.y))*180/M_PI;
    //动态圆的圆心
    CGPoint pointQ = CGPointMake(pointO.x + _d, pointO.y);
    //动态圆的半径
    double r3 = (pointO.y - pointP.y)/cosx(c) - _r2;
    
    //----------------------------------------------分部画path-----------------------------------------
    
    //----------------------------------------leftSemiShape(左圆弧形状)-----------------------------------------

    UIBezierPath *leftSemiPath = [UIBezierPath bezierPath];
    if (_d >= _mainRectWidth) {
        
    }else{
        [leftSemiPath addArcWithCenter:pointR radius:_r1 startAngle:(0.5 * M_PI) endAngle:(1.5 * M_PI) clockwise:YES];
    }
    self.leftSemiShape.path = leftSemiPath.CGPath;
    
    //----------------------------------------mainRecShape(主体矩形形状)-----------------------------------------
    
    UIBezierPath *mainRecShape = [UIBezierPath bezierPath];
    if (_d <= _mainRectWidth) {
        [mainRecShape moveToPoint:CGPointMake(pointR.x, pointR.y - _r1)];
        [mainRecShape addLineToPoint:CGPointMake(pointR.x, pointR.y + _r1)];
        [mainRecShape addLineToPoint:CGPointMake(pointO.x, pointO.y + _r1)];
        [mainRecShape addLineToPoint:CGPointMake(pointO.x, pointO.y - _r1)];
    }else{
        
    }
    self.mainRecShape.path = mainRecShape.CGPath;
    
    //----------------------------------------topRightShape(右上角圆弧形状)-----------------------------------------

    UIBezierPath *topRightPath = [UIBezierPath bezierPath];
    if (_d <= _mainRectWidth) {
        [topRightPath moveToPoint:pointA];
        [topRightPath addLineToPoint:pointO];
        [topRightPath addLineToPoint:CGPointMake(pointO.x, pointO.y - _r1)];
        [topRightPath addArcWithCenter:pointO radius:_r1 startAngle:(1.5 * M_PI) endAngle:(((360 - _a)/180) * M_PI) clockwise:YES];
        [topRightPath closePath];
    }else{
        
    }
    self.topRightShape.path = topRightPath.CGPath;
    
    //----------------------------------------bottomRightShape(左上角圆弧形状)-----------------------------------------

    UIBezierPath *bottomRightPath = [UIBezierPath bezierPath];
    if (_d <= _mainRectWidth) {
        [bottomRightPath moveToPoint:CGPointMake(pointO.x, pointO.y + _r1)];
        [bottomRightPath addLineToPoint:pointO];
        [bottomRightPath addLineToPoint:pointB];
        [bottomRightPath addArcWithCenter:pointO radius:_r1 startAngle:((_a/180)*180 * M_PI) endAngle:( 0.5 * M_PI) clockwise:YES];
        [bottomRightPath closePath];
    }else{
        
    }
    self.bottomRightShape.path = bottomRightPath.CGPath;
    
    //-------------------------------------------volcanoPath(火山形状)-----------------------------------------

    UIBezierPath *vocalnoPath = [UIBezierPath bezierPath];
    if (_d >= _mid_d) {
        c = 0;
    }
    [vocalnoPath addArcWithCenter:pointP radius:_r2 startAngle:(M_PI * ((90 + c)/180)) endAngle:(M_PI * ((180 - _a)/180)) clockwise:YES];
    [vocalnoPath addArcWithCenter:CGPointMake(pointP.x, pointO.y + (pointO.y - pointP.y)) radius:_r2 startAngle:((180 + _a)/180 *M_PI) endAngle:(((270 - c)/180) *M_PI) clockwise:YES];
    
    self.volcanoShape.path = vocalnoPath.CGPath;
    
    //-------------------------------------------semiCircle(半圆形状)-----------------------------------------

    UIBezierPath *semiPath = [UIBezierPath bezierPath];
    //减去0.2是为了严密贴合，因为double计算最终结果稍有偏差
    if (_d >= _mid_d) {
        r3 = h/2;
    }
    [semiPath addArcWithCenter:CGPointMake(pointQ.x, pointQ.y) radius:r3 startAngle:(((270 + c)/180) * M_PI) endAngle:(((90 - c)/180)*M_PI) clockwise:YES];

    self.semicircleShape.path  = semiPath.CGPath;
    
    //---------------------------------------------recPath(管道形状)-----------------------------------------
    
    if(_d <= _tube_d + _mid_d && _d>= _mid_d)
    {
        UIBezierPath *recPath = [UIBezierPath bezierPath];
        [recPath moveToPoint:CGPointMake(pointC.x , pointC.y)];
        [recPath addLineToPoint:CGPointMake(pointD.x , pointD.y)];
        [recPath addLineToPoint:CGPointMake(pointD.x + _d - _mid_d, pointD.y)];
        [recPath addLineToPoint:CGPointMake(pointD.x + _d - _mid_d, pointC.y)];
        [recPath addLineToPoint:pointC];
        [recPath closePath];
        self.recShape.path = recPath.CGPath;
    }else{
        UIBezierPath *recPath = [UIBezierPath bezierPath];
        self.recShape.path = recPath.CGPath;
    }
    
    //------------------------------------------------设置绘制标示----------------------------------------------
    
    [self.leftSemiShape setNeedsDisplay];
    [self.mainRecShape setNeedsDisplay];
    [self.topRightShape setNeedsDisplay];
    [self.volcanoShape setNeedsDisplay];
    [self.semicircleShape setNeedsDisplay];
    [self.recShape setNeedsDisplay];
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
