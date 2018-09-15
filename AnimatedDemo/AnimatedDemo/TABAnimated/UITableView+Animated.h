//
//  UITableView+Animated.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBulll. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TABTableViewAnimationDefault = 0, //没有动画，默认
    TABTableViewAnimationStart,  //开始动画
    TABTableViewAnimationEnd  //结束动画
}TABTableViewAnimationStyle; //table动画状态枚举

@interface UITableView (Animated)

@property (nonatomic) TABTableViewAnimationStyle animatedStyle;

@end
