//
//  TABViewAnimated.h
//  lifeAndSport
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+Animated.h"

@interface TABViewAnimated : NSObject

@property (nonatomic) CGFloat animatedDuration;             // default is 0.4
@property (nonatomic,strong) UIColor *animatedColor;         //default is 0xEEEEEE.

/**
 SingleTon 单例

 @return return object
 */
+ (TABViewAnimated *)sharedAnimated;

/**
 启动/关闭动画
 适用组件UIView及其继承类
 @param view 传入view自身
 */
- (void)startOrEndViewAnimated:(UIView *)view;

/**
 启动/关闭动画
 适用组件UITableView
 @param cell 传入cell自身
 */
- (void)startOrEndTableAnimated:(UITableViewCell *)cell;

/**
 设置动画属性

 @param duration 动画时长，一个来回
 @param color 背景颜色
 */
- (void)initWithAnimatedDuration:(CGFloat)duration withColor:(UIColor *)color;

@end
