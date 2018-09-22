//
//  UIView+Animated.h
//  lifeAndSport
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,TABViewLoadAnimationStyle) {
    TABViewLoadAnimationDefault = 0,   //默认没有动画
    TABViewLoadAnimationShort,            //动画先变短再变长
    TABViewLoadAnimationLong             //动画先变长再变短
};

typedef NS_ENUM(NSInteger,TABViewAnimationStyle) {
    TABViewAnimationDefault = 0,    //默认没有动画
    TABViewAnimationStart,              //开始动画
    TABViewAnimationEnd                //结束动画
};

@interface UIView (Animated)

@property (nonatomic) TABViewLoadAnimationStyle loadStyle;   //加载的动画类型

@property (nonatomic) TABViewAnimationStyle animatedStyle;   //动画状态

@property (nonatomic) CGFloat tabViewWidth; //动画组件长度,default is your phone screen's width / 3.

@end
