//
//  NYNarrowLayer.h
//  NYTubeAnimationDemo
//
//  Created by 牛严 on 16/9/2.
//  Copyright © 2016年 牛严. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, TowardsType) {
    TowardRight,
    TowardLeft,
};


@protocol NYTubeAnimationViewDelegate <NSObject>

- (void)didTurnedToRight;

- (void)didTurnedToLeft;

@end



@interface NYTubeAnimationView : UIView

@property (nonatomic, assign) double r1;
@property (nonatomic, assign) double r2;
@property (nonatomic, assign) double d;                             /// 平移距离，输入值
@property (nonatomic, assign) double chosen_d;

@property (nonatomic, assign) TowardsType towardsType;

@property (nonatomic, weak) id<NYTubeAnimationViewDelegate> delegate;

@end



@interface NYShapeLayer :CAShapeLayer

- (instancetype)initWithFrame:(CGRect)frame Color:(UIColor *)color;

- (instancetype)initWithFrame:(CGRect)frame Color:(UIColor *)color Path:(UIBezierPath *)path;

@end
