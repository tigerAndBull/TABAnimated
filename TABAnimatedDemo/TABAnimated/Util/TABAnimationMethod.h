//
//  TABAnimationMethod.h
//  TABAnimatedDemo
//
//  Created by tigerAndBull on 2018/12/28.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *tab_NSStringFromIndex(NSInteger index);

@interface TABAnimationMethod : NSObject

/**
 UIView加入淡入淡出动画
 @param view 目标view
 */
+ (void)addEaseOutAnimation:(UIView *)view;

/// 获取App版本
+ (NSString *)appVersion;

@end

NS_ASSUME_NONNULL_END
