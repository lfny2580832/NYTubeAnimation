//
//  NYTubeAnimationView.h
//  NYTubeAnimationDemo
//
//  Created by 牛严 on 16/9/1.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol NYTubeAnimationControlDelegate <NSObject>

- (void)didTurnedToSecondPage;

- (void)didTurnedToFirstPage;

@end

@interface NYTubeAnimationControl : UIView

@property (nonatomic, assign) BOOL origin;          //是否在初始状态，即在第一个方块
@property (nonatomic, weak) id <NYTubeAnimationControlDelegate> delegate;

- (void)turnToSecondePage;

- (void)turnToFirstPage;

@end

@interface TestView : UIView

@property (nonatomic, assign) double r1;
@property (nonatomic, assign) double r2;

@end
