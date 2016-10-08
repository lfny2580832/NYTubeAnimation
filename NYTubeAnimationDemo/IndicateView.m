//
//  IndicateView.m
//  NYTubeAnimationDemo
//
//  Created by 牛严 on 2016/10/8.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "IndicateView.h"
#import "NYTubeAnimationControl.h"
#import "ViewController.h"

@interface IndicateView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NYTubeAnimationControl *animationControl;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UILabel *leftNumLabel;
@property (nonatomic, strong) UILabel *rightNumLabel;

@property (nonatomic, weak) id delegateVC;

@end

@implementation IndicateView

#pragma mark
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.animationControl];
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightLabel];
        [self addSubview:self.leftNumLabel];
        [self addSubview:self.rightNumLabel];
    }
    return self;
}

#pragma mark Private Methods
- (void)turnToFirstPage
{
    if (self.animationControl.origin) {
        return;
    }
    [self.animationControl turnToFirstPage];
    self.leftLabel.textColor = RGB(251, 251, 251);
    self.leftNumLabel.textColor = RGB(252, 114, 114);
    self.rightLabel.textColor = RGB(254,163, 163);
    self.rightNumLabel.textColor = RGB(254,163, 163);

}

- (void)turnToSecondPage
{
    if (!self.animationControl.origin) {
        return;
    }
    [self.animationControl turnToSecondePage];
    self.leftLabel.textColor = RGB(254,163, 163);
    self.leftNumLabel.textColor = RGB(254,163, 163);
    self.rightLabel.textColor = RGB(251, 251, 251);
    self.rightNumLabel.textColor = RGB(252, 114, 114);
}

- (void)setDelegate:(id)delegate
{
    self.animationControl.delegate = delegate;
}

#pragma mark Get
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _imageView.image = [UIImage imageNamed:@"assetbg"];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 34, SCREEN_WIDTH, 16)];
        _titleLabel.text = @"余额不足";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}

- (NYTubeAnimationControl *)animationControl
{
    if (!_animationControl) {
        _animationControl = [[NYTubeAnimationControl alloc]initWithFrame:CGRectMake(0, 0, 270, 30)];
        _animationControl.center = CGPointMake(SCREEN_WIDTH/2, 96);
    }
    return _animationControl;
}

- (UILabel *)leftLabel
{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(48, CGRectGetMaxY(_animationControl.frame) + 10, 69, 20)];
        _leftLabel.text = @"确认银行卡";
        _leftLabel.font = [UIFont systemFontOfSize:13];
        _leftLabel.textColor = RGB(251, 251, 251);
    }
    return _leftLabel;
}

- (UILabel *)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 106, _leftLabel.frame.origin.y, 54, 20)];
        _rightLabel.text = @"充值余额";
        _rightLabel.font = [UIFont systemFontOfSize:13];
        _rightLabel.textColor = RGB(254,163, 163);
    }
    return _rightLabel;
}

- (UILabel *)leftNumLabel
{
    if (!_leftNumLabel) {
        _leftNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 10, 15)];
        _leftNumLabel.center = CGPointMake(_leftLabel.center.x, _animationControl.center.y);
        _leftNumLabel.textColor = RGB(252, 114, 114);
        _leftNumLabel.text = @"1";
        _leftNumLabel.font = [UIFont systemFontOfSize:13];
    }
    return _leftNumLabel;
}

- (UILabel *)rightNumLabel
{
    if (!_rightNumLabel) {
        _rightNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(_rightLabel.center.y, _animationControl.center.y, 10, 15)];
        _rightNumLabel.center = CGPointMake(_rightLabel.center.x, _animationControl.center.y);
        _rightNumLabel.textColor = RGB(254,163, 163);
        _rightNumLabel.font = [UIFont systemFontOfSize:13];
        _rightNumLabel.text = @"2";
    }
    return _rightNumLabel;
}
@end
