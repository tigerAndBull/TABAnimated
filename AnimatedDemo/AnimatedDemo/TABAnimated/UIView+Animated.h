//
//  UIView+Animated.h
//  lifeAndSport
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

// 组件动画类型枚举
typedef NS_ENUM(NSInteger,TABViewLoadAnimationStyle) {
    TABViewLoadAnimationDefault = 0,                         // 默认不加入队列，没有动画
    TABViewLoadAnimationWithOnlySkeleton,                    // 加入动画队列，父视图开启动画后，所有子view将设置为该属性
    TABViewLoadAnimationRemove,                              // 将view从动画队列中移出，由开发者使用
};

@class TABAnimatedObject;
@class TABLayer;

@interface UIView (Animated)

@property (nonatomic,strong) TABAnimatedObject *tabAnimated;
@property (nonatomic,strong) TABLayer *tabLayer;

// 组件动画类型
@property (nonatomic,assign) TABViewLoadAnimationStyle loadStyle;

// 为了降低框架的侵入式程度，在2.0.0版本，针对自动布局，进行了动画时的视图宽高预处理操作
// 下面为保留属性，在92.28%的情况下不要使用

// width of view to you appiont it during animating.
// default is your phone screen's width / 3.
@property (nonatomic,assign) float tabViewWidth;

// height of views to you appiont it, default is 20.
// If your view's height is 0 during animating, you can use the property.
// (1.8.7 新增)
@property (nonatomic,assign) float tabViewHeight;


@end
