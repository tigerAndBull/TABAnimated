//
//  UITableView+Animated.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

// the animation status of UITableView.
typedef NS_ENUM(NSInteger,TABTableViewAnimationStyle) {
    TABTableViewAnimationDefault = 0,     // default, no animation.
    TABTableViewAnimationStart,           // start animation.
    TABTableViewAnimationEnd              // end animation.
};

@interface UITableView (Animated)

@property (nonatomic) TABTableViewAnimationStyle animatedStyle;

@property (nonatomic) NSInteger animatedCount;    // default is three. count of cell during animating.

@end
