//
//  UITableView+Animated.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBulll. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,TABTableViewAnimationStyle) {
    TABTableViewAnimationDefault = 0,    //没有动画，默认
    TABTableViewAnimationStart,              //开始动画
    TABTableViewAnimationEnd                //结束动画
};

@interface UITableView (Animated)

@property (nonatomic) TABTableViewAnimationStyle animatedStyle;

@property (nonatomic) NSInteger animatedCount;    //default is three.

@end
