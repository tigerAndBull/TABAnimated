//
//  UIView+Animated.h
//  lifeAndSport
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TABLayer;
@class TABViewAnimated;
@class TABComponentLayer;

typedef TABComponentLayer *_Nullable(^TABSearchLayerBlock)(NSInteger);
typedef NSArray <TABComponentLayer *> *_Nullable(^TABSearchLayerArrayBlock)(NSInteger location, NSInteger length);

@interface UIView (TABAnimated)

// To the control view
@property (nonatomic, strong) TABViewAnimated * _Nullable tabAnimated;

// To the control view
@property (nonatomic, strong) TABLayer * _Nullable tabLayer;

/**
 获取单个动画组件
 
 @return return value description
 */
- (TABSearchLayerBlock _Nullable )animation;

/**
 获取多个动画组件，需要传递2个参数
 第一个参数为起始下标
 第二个参数长度
 
 @return return value description
 */
- (TABSearchLayerArrayBlock _Nullable)animations;

@end
