//
//  UIView+Animated.h
//  AnimatedDemo
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
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TABViewAnimated;
@class TABBaseComponent;
@class TABComponentManager;

typedef TABBaseComponent * _Nullable (^TABSearchLayerBlock)(NSInteger);
typedef NSArray <TABBaseComponent *> * _Nullable (^TABSearchLayerArrayBlock)(NSInteger location, NSInteger length);

@interface UIView (TABAnimated)

// To the control view
@property (nonatomic, strong) TABViewAnimated * _Nullable tabAnimated;

// To the control view
@property (nonatomic, strong) TABComponentManager * _Nullable tabComponentManager;

/**
 * 获取单个动画组件
 *
 * @return return value description
 */
- (TABSearchLayerBlock _Nullable)animation;

/**
 * 获取多个动画组件，需要传递2个参数
 * 第一个参数为起始下标
 * 第二个参数长度
 *
 * @return return value description
 */
- (TABSearchLayerArrayBlock _Nullable)animations;

@end
