//
//  NYNarrowLayer.m
//  NYTubeAnimationDemo
//
//  Created by 牛严 on 16/9/2.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "NYTubeAnimationView.h"

#define sinx(a)  sin(a/180*M_PI)
#define cosx(a)  cos(a/180*M_PI)
#define tanx(a)  tan(a/180*M_PI)

@interface NYTubeAnimationView ()

@property (nonatomic, assign) double a;         /// 大圆、小圆圆心连线与x轴的夹角
@property (nonatomic, assign) double d;         /// 平移距离，输入值
@property (nonatomic, assign) double increment; /// d的增量，如每帧移动4point
@property (nonatomic, assign) double mid_d;     /// 挤压完成，开始拉伸的距离
@property (nonatomic, assign) double mid_d_rate;/// mid_d段中的速率，默认1.5x
@property (nonatomic, assign) double tube_d;     /// 挤压开始，到达出口的距离，即管道长度
@property (nonatomic, assign) double tube_d_rate;/// tube_d 段中的速率，默认3x
@property (nonatomic, assign) double mainRectWidth; //主体矩形的宽度

//@property (nonatomic, assign) double shape_tube_d;  //形状在管道中的长度，管道可能长一些，如用此参数需设置距离比例，暂未实施

@property (nonatomic, strong) CADisplayLink *chosenDisplayLink;
@property (nonatomic, strong) CAShapeLayer *leftSemiShape;          //左边圆弧
@property (nonatomic, strong) CAShapeLayer *mainRecShape;           //主体矩形区域
@property (nonatomic, strong) CAShapeLayer *volcanoShape;           //火山形状
@property (nonatomic, strong) CAShapeLayer *rightCircleShape;        //半圆形状
@property (nonatomic, strong) CAShapeLayer *leftCircleShape;        //快完全进入时，使用该形状代替整体形状
@property (nonatomic, strong) CAShapeLayer *recShape;               //管道形状矩形区域

@end

@implementation NYTubeAnimationView
{
    CGPoint _pointO;
    CGPoint _pointQ;
    CGPoint _pointQ2;
    CGPoint _pointO2;
    CGPoint _pointP;
    CGPoint _pointP2;
    CGPoint _pointR;
    CGPoint _pointA;
    CGPoint _pointB;
    CGPoint _pointC;
    CGPoint _pointD;
    double  _tube_h;
    double  _dynamic_pointQ_d;
    double  _dynamic_pointQ2_d;
    double _pointOx;
    BOOL _finished;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self initParams];
        [self initShapes];
    }
    return self;
}

- (void)initParams
{
    _finished = NO;
    
    _r1 = 20;
    _r2 = 10;
    _a = 27.0;      //角度制
    _d = 0;
    _increment = 1;
    _mainRectWidth = _r1 * 2;
    _pointOx = _r1 + _mainRectWidth ;

    //左块右圆圆心
    _pointO = CGPointMake(_pointOx, self.frame.size.height/2);
    //动态圆圆心
    _pointQ = _pointO;
    //形状右圆圆心
    _pointQ2 = _pointQ;
    //左方右上角圆心
    _pointP = CGPointMake(1.5*_r1*cosx(_a) + _pointO.x, -1.5*_r1*sinx(_a) + _pointO.y);
    
    _mid_d = _pointP.x - _pointO.x;
    
    //左方右上角圆与主体右圆上交点
    _pointA = CGPointMake(_r1*cosx(_a) + _pointO.x, -_r1*sinx(_a) + _pointO.y);
    _pointB = CGPointMake(_pointA.x, _pointO.y + (_pointO.y - _pointA.y ));
    _pointC = CGPointMake(_pointP.x, _pointP.y + _r2);
    _tube_h = 2* ( _pointO.y - _pointC.y );
    _pointD = CGPointMake(_pointC.x, _pointC.y + _tube_h);
    
    _dynamic_pointQ_d = 0;
    _dynamic_pointQ2_d = 0;
    
    
    _tube_d = self.frame.size.width - _pointOx * 2 - _mid_d * 2 ;
    
    _mid_d_rate = 2.f;
    _tube_d_rate = 4.0f;
}

//初始化各shape
- (void)initShapes
{
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

    self.leftSemiShape = [[CAShapeLayer alloc]init];
    self.volcanoShape = [[CAShapeLayer alloc]init];
    self.rightCircleShape = [[CAShapeLayer alloc]init];
    self.recShape = [[CAShapeLayer alloc]init];
    self.mainRecShape = [[CAShapeLayer alloc]init];
    self.leftCircleShape = [[CAShapeLayer alloc]init];
    
    self.leftSemiShape.frame = frame;
    self.volcanoShape.frame = frame;
    self.rightCircleShape.frame = frame;
    self.recShape.frame = frame;
    self.mainRecShape.frame = frame;
    self.leftCircleShape.frame = frame;
    
    [self.layer addSublayer:self.leftSemiShape];
    [self.layer addSublayer:self.mainRecShape];
    [self.layer addSublayer:self.volcanoShape];
    [self.layer addSublayer:self.rightCircleShape];
    [self.layer addSublayer:self.recShape];
    [self.layer addSublayer:self.leftCircleShape];
}

- (void)changeParamManually
{
    if (_d >= _chosen_d) {
        return;
    }
    [self drawWithParams];

    _d = _d + _increment;
}

- (void)setChosen_d:(double)chosen_d
{
    _chosen_d = chosen_d;
    _d = 0;
    [self initParams];

    if (self.chosenDisplayLink) {
        [self.chosenDisplayLink invalidate];
        self.chosenDisplayLink = nil;
    }
    self.chosenDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeParamManually)];
    [self.chosenDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)animationDidfinish
{
    [self.chosenDisplayLink invalidate];
    self.chosenDisplayLink = nil;
}

#pragma mark 绘制方法
- (void)drawWithParams
{
    //右块左圆圆心
    _pointO2 = CGPointMake(_pointO.x + _tube_d + 2 * _mid_d, _pointO.y);
    //右方左上角圆心
    _pointP2 = CGPointMake(_pointP.x + _tube_d, _pointP.y);
    //主体左圆圆心
    _pointR = CGPointMake(_pointO.x - _mainRectWidth + _d, _pointO.y);

    //形状右方的圆行进距离，用来在最后进管道当做尾巴
    if (_dynamic_pointQ2_d <= _mid_d)
    {
        if (_d <= _mainRectWidth) {
            _dynamic_pointQ2_d = 0;
        }else{
            _dynamic_pointQ2_d += _mid_d_rate * _increment;
        }
    }
    else if (_dynamic_pointQ2_d <= _tube_d + _mid_d)
    {
        _dynamic_pointQ2_d += _tube_d_rate * _increment;
    }
    else if (_dynamic_pointQ2_d <  _mid_d + _tube_d + _mid_d)
    {
        _dynamic_pointQ2_d += _mid_d_rate * _increment;
        if (_dynamic_pointQ2_d >= _mid_d + _tube_d + _mid_d) {
            _dynamic_pointQ2_d = _mid_d + _tube_d + _mid_d;
        }
    }
    else
    {
        _dynamic_pointQ2_d = _mid_d + _tube_d + _mid_d;
    }
    
    _pointQ2 = CGPointMake(_pointO.x + _dynamic_pointQ2_d, _pointO.y);
    
    //动态圆弧行进距离
    if (_dynamic_pointQ_d <= _mid_d)
    {
        _dynamic_pointQ_d += _mid_d_rate * _increment;
    }
    else if (_dynamic_pointQ_d < _mid_d + _tube_d)
    {
        _dynamic_pointQ_d += _tube_d_rate * _increment;
        if (_dynamic_pointQ_d > _tube_d + _mid_d)
        {
            _dynamic_pointQ_d = _tube_d + _mid_d;
        }
    }
    else if (_dynamic_pointQ_d <= _mid_d + _tube_d + _mid_d)
    {
        _dynamic_pointQ_d += _mid_d_rate * _increment;
    }
    else if(_dynamic_pointQ_d <= _mid_d + _tube_d + _mid_d + _mainRectWidth)
    {   //到右方后原速行驶
        _dynamic_pointQ_d += _increment;
        if (_dynamic_pointQ_d > _mid_d + _tube_d + _mid_d + _mainRectWidth)
        {
            _dynamic_pointQ_d = _mid_d + _tube_d + _mid_d + _mainRectWidth;
            
            if (!_finished) {
                _finished = !_finished;
                [self animationDidfinish];
                if (self.towardsType == TowardRight) {
                    if ([self.delegate respondsToSelector:@selector(didTurnedToSecondPage)]) {
                        [self.delegate didTurnedToSecondPage];
                    }
                }else if([self.delegate respondsToSelector:@selector(didTurnedToFirstPage)]){
                    [self.delegate didTurnedToFirstPage];
                }
            }
        }
    }
    //动态圆弧的圆心
    _pointQ = CGPointMake(_pointO.x + _dynamic_pointQ_d, _pointO.y);
    
    //动态圆弧端-圆心与y轴的夹角
    double c;
    
    if (_dynamic_pointQ_d <= _mid_d)
    {
        c = atan((_pointP.x - _pointO.x - _dynamic_pointQ_d)/(_pointO.y - _pointP.y))*180/M_PI;
    }
    else if (_dynamic_pointQ_d <= _mid_d + _tube_d)
    {
        c = 0;
    }
    else if (_dynamic_pointQ_d <= _mid_d + _tube_d + _mid_d)
    {
        c = atan((_pointQ.x - _pointP2.x)/(_pointO.y - _pointP.y))*180/M_PI;
    }
    else{
        c = 90 - _a;
    }
    
    //动态圆的半径
    double r3 = (_pointO.y - _pointP.y)/cosx(c) - _r2;
    
    //----------------------------------------------分部画path-----------------------------------------
    
    //----------------------------------------leftSemiShape(左圆弧形状)-----------------------------------------

    UIBezierPath *leftSemiPath = [UIBezierPath bezierPath];
    if (_d <= _mainRectWidth) {
        [leftSemiPath addArcWithCenter:_pointR radius:_r1 startAngle:(0.5 * M_PI) endAngle:(1.5 * M_PI) clockwise:YES];
    }
    else if(_dynamic_pointQ_d >= _mid_d + _tube_d + _mid_d)
    {
        [leftSemiPath addArcWithCenter:_pointQ radius:_r1 startAngle:(1.5 * M_PI) endAngle:(0.5 * M_PI) clockwise:YES];
    }
    self.leftSemiShape.path = leftSemiPath.CGPath;
    
    //----------------------------------------mainRecShape(主体矩形形状)-----------------------------------------
    
    UIBezierPath *mainRecShape = [UIBezierPath bezierPath];
    if (_d <= _mainRectWidth)
    {
        [mainRecShape moveToPoint:CGPointMake(_pointR.x, _pointR.y - _r1)];
        [mainRecShape addLineToPoint:CGPointMake(_pointR.x, _pointR.y + _r1)];
        [mainRecShape addLineToPoint:CGPointMake(_pointO.x, _pointO.y + _r1)];
        [mainRecShape addLineToPoint:CGPointMake(_pointO.x, _pointO.y - _r1)];
    }
    else if(_dynamic_pointQ_d >= _mid_d + _tube_d + _mid_d )
    {
        [mainRecShape moveToPoint:CGPointMake(_pointO2.x, _pointO2.y - _r1)];
        [mainRecShape addLineToPoint:CGPointMake(_pointO2.x, _pointO2.y + _r1)];
        [mainRecShape addLineToPoint:CGPointMake(_pointQ.x, _pointQ.y + _r1)];
        [mainRecShape addLineToPoint:CGPointMake(_pointQ.x, _pointQ.y - _r1)];
    }
    self.mainRecShape.path = mainRecShape.CGPath;
    
     //-------------------------------------------volcanoPath(火山形状)-----------------------------------------

    UIBezierPath *vocalnoPath = [UIBezierPath bezierPath];
    if(_d <= _mainRectWidth)
    {   //形状左圆行驶到开始压缩之前
        double temC = c;
        if (c <= 0 ) {
            temC = 0;
        }
        [vocalnoPath addArcWithCenter:_pointP radius:_r2 startAngle:(M_PI * ((90 + temC)/180)) endAngle:(M_PI * ((180 - _a)/180)) clockwise:YES];
        [vocalnoPath addArcWithCenter:CGPointMake(_pointP.x, _pointO.y + (_pointO.y - _pointP.y)) radius:_r2 startAngle:((180 + _a)/180 *M_PI) endAngle:(((270 - temC)/180) *M_PI) clockwise:YES];
    }
    else if(_dynamic_pointQ2_d <= _mid_d)
    {
        double temC = atan((_pointP.x - _pointO.x - _dynamic_pointQ2_d)/(_pointO.y - _pointP.y))*180/M_PI;

        [vocalnoPath addArcWithCenter:_pointP radius:_r2 startAngle:(0.5 * M_PI) endAngle:(((90 + temC)/180) * M_PI) clockwise:YES];
        [vocalnoPath addArcWithCenter:CGPointMake(_pointP.x, _pointO.y + (_pointO.y - _pointP.y)) radius:_r2 startAngle:((270 - temC)/180 *M_PI) endAngle:(1.5 *M_PI) clockwise:YES];
    }
    else if (_dynamic_pointQ_d >= _tube_d + _mid_d && _dynamic_pointQ2_d <= _tube_d + _mid_d )
    {
        //左滑到右，另一边的火山形状
        double temC = atan(((_pointQ.x - _pointO.x) - _mid_d - _tube_d)/(_pointO.y - _pointP.y))*180/M_PI;
        
        [vocalnoPath addArcWithCenter:_pointP2 radius:_r2 startAngle:(((90 - temC)/180) * M_PI) endAngle:(M_PI * 0.5) clockwise:YES];
        [vocalnoPath addArcWithCenter:CGPointMake(_pointP2.x, _pointO.y + (_pointO.y - _pointP.y)) radius:_r2 startAngle:(1.5 * M_PI) endAngle:(((270 + temC)/180) * M_PI) clockwise:YES];
    }
    else if (_dynamic_pointQ2_d < _mid_d + _tube_d + _mid_d && _dynamic_pointQ2_d >= _mid_d + _tube_d )
    {
        double temC = atan((_pointQ2.x - _pointP2.x)/(_pointO.y - _pointP.y))*180/M_PI;
        [vocalnoPath addArcWithCenter:_pointP2 radius:_r2 startAngle:(((_a)/180) * M_PI) endAngle:(M_PI * ((90 - temC)/180)) clockwise:YES];
        [vocalnoPath addArcWithCenter:CGPointMake(_pointP2.x, _pointO.y + (_pointO.y - _pointP.y)) radius:_r2 startAngle:(((270 + temC)/180) * M_PI) endAngle:(((360 - _a)/180) * M_PI) clockwise:YES];
    }
    self.volcanoShape.path = vocalnoPath.CGPath;
    
    //-------------------------------------------rightSemiCircle(右边圆形状)-----------------------------------------

    UIBezierPath *semiPath = [UIBezierPath bezierPath];
    //减去0.2是为了严密贴合，因为double计算最终结果稍有偏差
    
    if (_dynamic_pointQ_d <= _mid_d + _tube_d + _mid_d) {
        [semiPath addArcWithCenter:CGPointMake(_pointQ.x, _pointQ.y) radius:r3 startAngle:(0 * M_PI) endAngle:(2*M_PI) clockwise:YES];
    }else{
        [semiPath addArcWithCenter:CGPointMake(_pointO2.x, _pointQ.y) radius:r3 startAngle:(0 * M_PI) endAngle:(2*M_PI) clockwise:YES];
    }

    self.rightCircleShape.path  = semiPath.CGPath;
    
    //----------------------------------------leftCircleShape(完全进入时左圆形状)-----------------------------------------
    
    UIBezierPath *leftPath = [UIBezierPath bezierPath];
    if (_d <= _mainRectWidth)
    {
        [leftPath addArcWithCenter:_pointO radius:_r1 startAngle:(0 * M_PI) endAngle:(2.0 * M_PI) clockwise:YES];
    }
    else if(_dynamic_pointQ2_d <= _mid_d)
    {
        double temC = atan((_pointP.x - _pointO.x - _dynamic_pointQ2_d)/(_pointO.y - _pointP.y))*180/M_PI;
        double temR3 = (_pointO.y - _pointP.y)/cosx(temC) - _r2;
        [leftPath addArcWithCenter:_pointQ2 radius:temR3 startAngle:(0 * M_PI) endAngle:(2.0 * M_PI) clockwise:YES];
    }
    else if (_dynamic_pointQ2_d <= _mid_d + _tube_d)
    {
        CGPoint tem_pointQ = CGPointMake(_pointO.x + _dynamic_pointQ2_d, _pointO.y);
        [leftPath addArcWithCenter:tem_pointQ radius:_tube_h/2 startAngle:(0 * M_PI) endAngle:(2.0 * M_PI) clockwise:YES];
    }
    else if (_dynamic_pointQ2_d <= _mid_d + _tube_d + _mid_d)
    {
        double temC = atan(((_pointQ2.x - _pointO.x) - _mid_d - _tube_d)/(_pointO.y - _pointP.y))*180/M_PI;
        double temR3 = (_pointO.y - _pointP.y)/cosx(temC) - _r2;
        [leftPath addArcWithCenter:_pointQ2 radius:temR3 startAngle:(0 * M_PI) endAngle:(2.0 * M_PI) clockwise:YES];
    }
    self.leftCircleShape.path = leftPath.CGPath;
    

    //---------------------------------------------recPath(管道形状)-----------------------------------------
    
    UIBezierPath *recPath = [UIBezierPath bezierPath];
    
    if(_d <= _tube_d + _mid_d)
    {

        [recPath moveToPoint:CGPointMake(_pointQ2.x , _pointC.y)];
        [recPath addLineToPoint:CGPointMake(_pointQ2.x , _pointD.y)];
        [recPath addLineToPoint:CGPointMake(_pointQ.x, _pointD.y)];
        [recPath addLineToPoint:CGPointMake(_pointQ.x, _pointC.y)];
        [recPath addLineToPoint:_pointC];
        [recPath closePath];
    }else {
        recPath = [UIBezierPath bezierPath];
    }
    self.recShape.path = recPath.CGPath;

    //------------------------------------------------设置绘制标示----------------------------------------------
    
    [self.leftSemiShape setNeedsDisplay];
    [self.mainRecShape setNeedsDisplay];
    [self.volcanoShape setNeedsDisplay];
    [self.rightCircleShape setNeedsDisplay];
    [self.recShape setNeedsDisplay];
    [self.leftCircleShape setNeedsDisplay];
}

@end
