//
//  TABAnimationManagerInterface.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/5/17.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#ifndef TABAnimationManagerInterface_h
#define TABAnimationManagerInterface_h

@class UIView;

@protocol TABAnimationManagerInterface <NSObject>

// 绑定控制视图
- (void)setControlView:(UIView *)controlView;

// 为目标view添加动画
- (void)addAnimationWithTargetView:(UIView *)targetView;

- (void)destory;

@end

#endif /* TABAnimationManagerInterface_h */
