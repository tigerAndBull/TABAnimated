//
//  UIView+Animated.h
//  lifeAndSport
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

// the style of default animation.
// 经典动画枚举
typedef NS_ENUM(NSInteger,TABViewLoadAnimationStyle) {
    TABViewLoadAnimationDefault = 0,                         // default,没有动画
    TABViewLoadAnimationShort,                               // 动画先变短再变长
    TABViewLoadAnimationLong,                                // 动画先变长再变短
    TABViewLoadAnimationWithOnlySkeleton,                    // 骨架层
    
    TABViewLoadAnimationRemove,                              // 从动画队列中移出, 只用于第二种和第三种动画模式
};

// the animation status.
// 动画状态
typedef NS_ENUM(NSInteger,TABViewAnimationStyle) {
    TABViewAnimationDefault = 0,                             // 默认,没有动画
    TABViewAnimationStart,                                   // 开始动画
    TABViewAnimationRunning,                                 // 动画中 you don't need care the status.
    TABViewAnimationEnd,                                     // 结束动画      
};

// the type of superAnimation. (1.8.7 新增)
typedef NS_ENUM(NSInteger,TABViewSuperAnimationType) {
    TABViewSuperAnimationTypeDefault = 0,                    // default,没有动画
    TABViewSuperAnimationTypeClassic,                        // 经典动画类型(包含只有骨架，动静结合）
    TABViewSuperAnimationTypeShimmer,                        // 闪光灯动画
    TABViewSuperAnimationTypeOnlySkeleton,                   // 骨架层
};

@interface UIView (Animated)

// 你可能会用到的属性

@property (nonatomic,assign) TABViewLoadAnimationStyle loadStyle;           // 组件动画类型
@property (nonatomic,assign) TABViewSuperAnimationType superAnimationType;  // 父级权限

@property (nonatomic,assign) BOOL isAnimating;                              // is runing animation or not.

// width of view to you appiont it during animating.
// default is your phone screen's width / 3.
@property (nonatomic,assign) float tabViewWidth;

// height of views to you appiont it, default is 20.
// If your view's height is 0 during animating, you can use the property.
// (1.8.7 新增)
@property (nonatomic,assign) float tabViewHeight;

@property (nonatomic,assign) BOOL isNest;

// 你不必关心的属性

@property (nonatomic,assign) TABViewAnimationStyle animatedStyle;   // 不要修改它，旧版可以使用，1.8.8以上不推荐使用
@property (nonatomic,copy) NSString *tabIdentifier;                 // A string that identifies the user interface element.

@end
