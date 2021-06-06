//
//  TABAnimationMethod.h
//  TABAnimatedDemo
//
//  github: https://github.com/tigerAndBull/TABAnimated
//  jianshu: https://www.jianshu.com/p/6a0ca4995dff
//
//  集成问答文档：https://www.jianshu.com/p/34417897915a
//  历史更新文档：https://www.jianshu.com/p/e3e9ea295e8a
//  动画下标说明：https://www.jianshu.com/p/8c361ba5aa18
//  豆瓣效果说明：https://www.jianshu.com/p/1a92158ce83a
//  嵌套视图说明：https://www.jianshu.com/p/cf8e37195c11
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
