//
//  UIView+AnimatedStyle.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/9/20.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,TABViewAnimationStyle) {
    TABViewAnimationDefault = 0,    //没有动画，默认
    TABViewAnimationStart,              //开始动画
    TABViewAnimationEnd                //结束动画
};

@interface UIView (AnimatedStyle)

@property (nonatomic) TABViewAnimationStyle animatedStyle;

@end

NS_ASSUME_NONNULL_END
