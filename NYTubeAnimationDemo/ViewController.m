//
//  ViewController.m
//  NYTubeAnimationDemo
//
//  Created by 牛严 on 16/9/1.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import "ViewController.h"
#import "NYTubeAnimationView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NYTubeAnimationView *animationView = [[NYTubeAnimationView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:animationView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
