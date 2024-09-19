//
//  UIView+Animated.h
//  TABAnimatedDemo
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TABAnimatedProduction;

@interface UIView (TABAnimatedProduction)

// 骨架屏管理单元持有
@property (nonatomic, strong) TABAnimatedProduction * _Nullable tabAnimatedProduction;

@end

