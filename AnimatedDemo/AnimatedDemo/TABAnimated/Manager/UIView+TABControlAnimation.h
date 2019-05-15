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
 start animation
 
 `[self tab_startAnimation]`, if you call it many times, it can only take effect once.
 If you special needs, change the state of `TABAnimatedObject`, and then restart it.
 
 开启动画
 
 `[self tab_startAnimation]`即使多次调用，也只会生效一次。
 如有其他需要，请自行修改`TABViewAnimated`中的`canLoadAgain`属性，解除限制。
 */
- (void)tab_startAnimation;

/**
 end animation
 结束动画
 
 simmer to `tab_startAnimation`
 */
- (void)tab_endAnimation;

@end

NS_ASSUME_NONNULL_END
