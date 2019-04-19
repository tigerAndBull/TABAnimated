//
//  UIView+TABControllerAnimation.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/1/17.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (TABControlAnimation)

/**
 开启动画
 */
- (void)tab_startAnimation;

/**
 结束动画
 */
- (void)tab_endAnimation;

@end

NS_ASSUME_NONNULL_END
