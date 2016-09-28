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
@property (nonatomic, assign) double increment; /// d的增量，如每帧移动4point
@property (nonatomic, assign) double mid_d;     /// 挤压完成，开始拉伸的距离
@property (nonatomic, assign) double mid_d_rate;/// mid_d段中的速率，默认1.5x
@property (nonatomic, assign) double tube_d;     /// 挤压开始，到达出口的距离，即管道长度
@property (nonatomic, assign) double tube_d_rate;/// tube_d 段中的速率，默认3x
@property (nonatomic, assign) double mainRectWidth; //主体矩形的宽度

//@property (nonatomic, assign) double shape_tube_d;  //形状在管道中的长度，管道可能长一些，如用此参数需设置距离比例，暂未实施

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) CAShapeLayer *leftSemiShape;          //左边圆弧
@property (nonatomic, strong) CAShapeLayer *mainRecShape;           //主体矩形区域
@property (nonatomic, strong) CAShapeLayer *volcanoShape;           //火山形状
@property (nonatomic, strong) CAShapeLayer *rightSemicircleShape;        //半圆形状
@property (nonatomic, strong) CAShapeLayer *leftCircleShape;        //快完全进入时，使用该形状代替整体形状
@property (nonatomic, strong) CAShapeLayer *recShape;               //管道形状矩形区域

@end

@implementation NYNarrowView
{
    CGPoint _pointO;
    CGPoint _pointQ;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _r1 = 40;
        _r2 = 20;
        _a = 28.0;      //角度制
        _d = 0;
        _increment = 4;
        _mainRectWidth = _r1 * 2;
        _tube_d = _r1 * 6;
        
        _mid_d_rate = 1.5f;
        _tube_d_rate = 3.0f;
        
        //左块右圆圆心
        _pointO = CGPointMake(200, 500);
        //动态圆圆心
        _pointQ = _pointO;

        [self initShapes];
        
//        _d = 199;
//        [self drawWithParams];
        [self setDisplayLink];
    }
    return self;
}

//初始化各shape
- (void)initShapes
{
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

    self.leftSemiShape = [[CAShapeLayer alloc]init];
    self.volcanoShape = [[CAShapeLayer alloc]init];
    self.rightSemicircleShape = [[CAShapeLayer alloc]init];
    self.recShape = [[CAShapeLayer alloc]init];
    self.mainRecShape = [[CAShapeLayer alloc]init];
    self.leftCircleShape = [[CAShapeLayer alloc]init];
    
    self.leftSemiShape.frame = frame;
    self.volcanoShape.frame = frame;
    self.rightSemicircleShape.frame = frame;
    self.recShape.frame = frame;
    self.mainRecShape.frame = frame;
    self.leftCircleShape.frame = frame;
    
    [self.layer addSublayer:self.leftSemiShape];
    [self.layer addSublayer:self.mainRecShape];
    [self.layer addSublayer:self.volcanoShape];
    [self.layer addSublayer:self.rightSemicircleShape];
    [self.layer addSublayer:self.recShape];
    [self.layer addSublayer:self.leftCircleShape];
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
    _d = _d + _increment;
    [self drawWithParams];

    if (_d >= _tube_d + _mid_d + _mid_d) {
        _d = 0;
    }
}

- (void)drawWithParams
{

    //右块左圆圆心
    CGPoint _pointO2 = CGPointMake(_pointO.x + _tube_d + 2 * _mid_d, _pointO.y);
    CGPoint pointP = CGPointMake(1.5*_r1*cosx(_a) + _pointO.x, -1.5*_r1*sinx(_a) + _pointO.y);
    CGPoint pointP2 = CGPointMake(pointP.x + _tube_d, pointP.y);
    //左圆弧圆心
    CGPoint pointR = CGPointMake(_pointO.x - _mainRectWidth + _d, _pointO.y);
    
    _mid_d = pointP.x - _pointO.x;
    
    CGPoint pointA = CGPointMake(_r1*cosx(_a) + _pointO.x, -_r1*sinx(_a) + _pointO.y);
    CGPoint pointB = CGPointMake(pointA.x, _pointO.y + (_pointO.y - pointA.y ));
    CGPoint pointC = CGPointMake(pointP.x, pointP.y + _r2);
    double h = 2* ( _pointO.y - pointC.y );
    CGPoint pointD = CGPointMake(pointC.x, pointC.y + h);
    
    //动态圆 的圆弧角度/2
    double c = atan((pointP.x - _pointO.x - _d)/(_pointO.y - pointP.y))*180/M_PI;
    //动态圆的圆心

    //动态圆从头走到尾的距离
    double dynamic_pointQ_d = _pointQ.x - _pointO.x;
#warning 此处要求管道长度是main_d+mid_d的两倍，即 完全进入管道后才从右边出来
    if (dynamic_pointQ_d <= _mid_d)
    {                //变小、变大过程中，1.5倍速
         _pointQ = CGPointMake(_pointO.x + _mid_d_rate * _d , _pointO.y);
    }
    else if (dynamic_pointQ_d <= _mid_d + _tube_d && _d <= _mainRectWidth + _mid_d)
    {                 //动态圆变最小后，速率变为tube_d_rate，3.0倍速，直到左边的圆也变最小
        _pointQ = CGPointMake(_pointO.x + _mid_d + _tube_d_rate *(_d - _mid_d), _pointO.y);
    }
    else if (_d >= _mainRectWidth + _mid_d && dynamic_pointQ_d <= _mid_d + _tube_d)
    {                 //动态圆 从左圆完全进入————管道右边头的过程
        _pointQ = CGPointMake(_pointO.x + _mid_d + _tube_d, _pointO.y);
    }
    else if (dynamic_pointQ_d >= _mid_d + _tube_d && dynamic_pointQ_d <= _mid_d + _tube_d + _mid_d)
    {                 // 右边mid_d 过程， 1.5倍速
        _pointQ = CGPointMake(_pointO.x + _mid_d + _tube_d + _mid_d_rate * (_d - _mid_d - _tube_d), _pointO.y);
    }
    else if(dynamic_pointQ_d >= _tube_d + _mid_d + _mid_d)
    {                //出来后固定在左边
        _pointQ = _pointO2;
    }
    //动态圆的半径
    double r3 = (_pointO.y - pointP.y)/cosx(c) - _r2;
    
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
        [mainRecShape addLineToPoint:CGPointMake(_pointO.x, _pointO.y + _r1)];
        [mainRecShape addLineToPoint:CGPointMake(_pointO.x, _pointO.y - _r1)];
    }else{
        
    }
    self.mainRecShape.path = mainRecShape.CGPath;
    
     //-------------------------------------------volcanoPath(火山形状)-----------------------------------------

    UIBezierPath *vocalnoPath = [UIBezierPath bezierPath];
    if(_d < _mainRectWidth){
        double temC = c;
        if (c <= 0 ) {
            temC = 0;
        }
        [vocalnoPath addArcWithCenter:pointP radius:_r2 startAngle:(M_PI * ((90 + temC)/180)) endAngle:(M_PI * ((180 - _a)/180)) clockwise:YES];
        [vocalnoPath addArcWithCenter:CGPointMake(pointP.x, _pointO.y + (_pointO.y - pointP.y)) radius:_r2 startAngle:((180 + _a)/180 *M_PI) endAngle:(((270 - temC)/180) *M_PI) clockwise:YES];
    }
    else if(_d >= _mainRectWidth && (_d - _mainRectWidth) <= _mid_d){
        double temC = atan((pointP.x - _pointO.x - (_d - _mainRectWidth))/(_pointO.y - pointP.y))*180/M_PI;
        [vocalnoPath addArcWithCenter:pointP radius:_r2 startAngle:(0.5 * M_PI) endAngle:(((90 + temC)/180) * M_PI) clockwise:YES];
        [vocalnoPath addArcWithCenter:CGPointMake(pointP.x, _pointO.y + (_pointO.y - pointP.y)) radius:_r2 startAngle:((270 - temC)/180 *M_PI) endAngle:(1.5 *M_PI) clockwise:YES];
    }
    else if (dynamic_pointQ_d >= _tube_d + _mid_d && dynamic_pointQ_d <= _tube_d + _mid_d + _mid_d) {
        //左滑到右，另一边的火山形状
        double temC = atan(((_pointQ.x - _pointO.x) - _mid_d - _tube_d)/(_pointO.y - pointP.y))*180/M_PI;
        
        [vocalnoPath addArcWithCenter:pointP2 radius:_r2 startAngle:(((90 - temC)/180) * M_PI) endAngle:(M_PI * 0.5) clockwise:YES];
        [vocalnoPath addArcWithCenter:CGPointMake(pointP2.x, _pointO.y + (_pointO.y - pointP.y)) radius:_r2 startAngle:(1.5 * M_PI) endAngle:(((270 + temC)/180) * M_PI) clockwise:YES];

    }
    self.volcanoShape.path = vocalnoPath.CGPath;
    
    //-------------------------------------------rightSemiCircle(右边圆形状)-----------------------------------------

    UIBezierPath *semiPath = [UIBezierPath bezierPath];
    //减去0.2是为了严密贴合，因为double计算最终结果稍有偏差
    if (_d >= _mid_d) {
        r3 = h/2;
    }
    
    [semiPath addArcWithCenter:CGPointMake(_pointQ.x, _pointQ.y) radius:r3 startAngle:(((270 + c)/180) * M_PI) endAngle:(((90 - c)/180)*M_PI) clockwise:YES];

    self.rightSemicircleShape.path  = semiPath.CGPath;
    
    //----------------------------------------leftShape(完全进入时左方形状形状)-----------------------------------------
    
    UIBezierPath *leftPath = [UIBezierPath bezierPath];
    if (_d < _mainRectWidth) {
        [leftPath addArcWithCenter:_pointO radius:_r1 startAngle:(0 * M_PI) endAngle:(2.0 * M_PI) clockwise:YES];
    }else if(_d >= _mainRectWidth && (_d - _mainRectWidth) <= _mid_d){
        double temC = atan((pointP.x - _pointO.x - (_d - _mainRectWidth))/(_pointO.y - pointP.y))*180/M_PI;
        CGPoint tem_pointQ = CGPointMake(_pointO.x + (_d - _mainRectWidth), _pointO.y);
        double temR3 = (_pointO.y - pointP.y)/cosx(temC) - _r2;
        [leftPath addArcWithCenter:tem_pointQ radius:temR3 startAngle:(0 * M_PI) endAngle:(2.0 * M_PI) clockwise:YES];
    }else if (_d >= _mid_d + _mainRectWidth){
        CGPoint tem_pointQ = CGPointMake(_pointO.x + ( _d - _mainRectWidth), _pointO.y);
        [leftPath addArcWithCenter:tem_pointQ radius:h/2 startAngle:(0 * M_PI) endAngle:(2.0 * M_PI) clockwise:YES];
        
    }
    self.leftCircleShape.path = leftPath.CGPath;
    

    //---------------------------------------------recPath(管道形状)-----------------------------------------
    
    UIBezierPath *recPath = [UIBezierPath bezierPath];
    
    if(_d <= _tube_d + _mid_d)
    {

        [recPath moveToPoint:CGPointMake(pointR.x , pointC.y)];
        [recPath addLineToPoint:CGPointMake(pointR.x , pointD.y)];
        [recPath addLineToPoint:CGPointMake(_pointQ.x, pointD.y)];
        [recPath addLineToPoint:CGPointMake(_pointQ.x, pointC.y)];
        [recPath addLineToPoint:pointC];
        [recPath closePath];
    }else {
        recPath = [UIBezierPath bezierPath];
    }
    self.recShape.path = recPath.CGPath;

    //------------------------------------------------设置绘制标示----------------------------------------------
    
    [self.leftSemiShape setNeedsDisplay];
    [self.mainRecShape setNeedsDisplay];
    [self.volcanoShape setNeedsDisplay];
    [self.rightSemicircleShape setNeedsDisplay];
    [self.recShape setNeedsDisplay];
    [self.leftCircleShape setNeedsDisplay];
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
