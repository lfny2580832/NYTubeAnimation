//
//  ViewController.m
//  NYTubeAnimationDemo
//
//  Created by 牛严 on 16/9/1.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "ViewController.h"
#import "IndicateView.h"
#import "NYTubeAnimationControl.h"

@interface ViewController ()<NYTubeAnimationControlDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) IndicateView *indicateView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *firstBtn;
@property (nonatomic, strong) UIButton *secondBtn;

@end


@implementation ViewController

#pragma mark Life Circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.indicateView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.firstBtn];
    [self.scrollView addSubview:self.secondBtn];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark NYTubeAnimationControlDelegate
- (void)didTurnedToSecondPage
{
    NSLog(@"到第二页");
}

- (void)didTurnedToFirstPage
{
    NSLog(@"到第一页");
}

#pragma mark UIScrollView Delegate
- (void)turnToSecondPage
{
    [self.indicateView turnToSecondPage];
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
}

- (void)turnToFirstPage
{
    [self.indicateView turnToFirstPage];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark Get
- (IndicateView *)indicateView
{
    if (!_indicateView) {
        _indicateView = [[IndicateView alloc]initWithFrame:CGRectMake(0,0 , SCREEN_WIDTH, 150)];
        [_indicateView setDelegate:self];
    }
    return _indicateView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_indicateView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(_indicateView.frame))];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        [_scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * 2, _scrollView.frame.size.height)];
    }
    return _scrollView;
}

- (UIButton *)firstBtn
{
    if (!_firstBtn) {
        _firstBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _scrollView.frame.size.height)];
        _firstBtn.backgroundColor = RGB(242,242,242);
        [_firstBtn setTitle:@"下一页" forState:UIControlStateNormal];
        [_firstBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_firstBtn addTarget:self action:@selector(turnToSecondPage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _firstBtn;
}

- (UIButton *)secondBtn
{
    if (!_secondBtn) {
        _secondBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, _scrollView.frame.size.height)];
        _secondBtn.backgroundColor = RGB(242,242,242);
        [_secondBtn setTitle:@"上一页" forState:UIControlStateNormal];
        [_secondBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_secondBtn addTarget:self action:@selector(turnToFirstPage) forControlEvents:UIControlEventTouchUpInside];
}
    return _secondBtn;
}

@end
