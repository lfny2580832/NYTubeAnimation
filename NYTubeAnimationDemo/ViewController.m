//
//  ViewController.m
//  NYTubeAnimationDemo
//
//  Created by 牛严 on 16/9/1.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "ViewController.h"
#import "NYTubeAnimationControl.h"

@interface ViewController ()

@property (nonatomic, strong) NYTubeAnimationControl *animationViewControl;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, assign) double chosen_d;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.animationViewControl];
    
    [self.view addSubview:self.label];
    
    UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(160, 200, 50, 50)];
    [addBtn setBackgroundColor:[UIColor blackColor]];
    [addBtn setTitle:@"下一页" forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addChosend) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
    UIButton *subBtn = [[UIButton alloc]initWithFrame:CGRectMake(220, 200, 50, 50)];
    [subBtn setBackgroundColor:[UIColor blackColor]];
    [subBtn setTitle:@"上一页" forState:UIControlStateNormal];
    [subBtn addTarget:self action:@selector(subChosend) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:subBtn];
}

- (void)addChosend
{
    [self.animationViewControl turnToSecondePage];
}

- (void)subChosend
{
    [self.animationViewControl turnToFirstPage];
}

#pragma mark Get
- (NYTubeAnimationControl *)animationViewControl
{
    if (!_animationViewControl) {
        _animationViewControl = [[NYTubeAnimationControl alloc]initWithFrame:CGRectMake(0, 500, self.view.frame.size.width, 60)];
    }
    return _animationViewControl;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(50, 200, 100, 50)];
    }
    return _label;
}

@end
