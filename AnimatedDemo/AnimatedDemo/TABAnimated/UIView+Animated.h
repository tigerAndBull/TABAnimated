//
//  UIView+Animated.h
//  lifeAndSport
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TABViewLoadAnimationDefault = 0, //默认没有动画
    TABViewLoadAnimationShort,  //动画先变短再变长
    TABViewLoadAnimationLong  //动画先变长再变短
}TABViewLoadAnimationStyle; //view动画类型枚举

@interface UIView (Animated)

@property (nonatomic) TABViewLoadAnimationStyle loadStyle;

@end
