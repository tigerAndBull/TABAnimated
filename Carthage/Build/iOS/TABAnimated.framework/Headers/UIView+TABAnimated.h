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

@class TABViewAnimated, TABBaseComponent, TABComponentManager;

typedef TABBaseComponent * _Nullable (^TABSearchLayerBlock)(NSInteger);
typedef NSArray <TABBaseComponent *> * _Nullable (^TABSearchLayerArrayBlock)(NSInteger location, NSInteger length);

@interface UIView (TABAnimated)

// 控制视图持有
@property (nonatomic, strong) TABViewAnimated * _Nullable tabAnimated;

// 控制视图下的管理单元持有
@property (nonatomic, strong) TABComponentManager * _Nullable tabComponentManager;

/**
 获取指定下标的动画元素

 @return 目标动画元素
 */
- (TABSearchLayerBlock _Nullable)animation;

/**
 获取多个动画元素，需要传递2个参数
 第一个参数为起始下标
 第二个参数长度

 @return 目标动画元素数组
 */
- (TABSearchLayerArrayBlock _Nullable)animations;

@end

@class TABTableAnimated;

@interface UITableView (TABAnimated)

// 控制视图持有
@property (nonatomic, strong) TABTableAnimated * _Nullable tabAnimated;

@end

@class TABCollectionAnimated;

@interface UICollectionView (TABAnimated)

// 控制视图持有
@property (nonatomic, strong) TABCollectionAnimated * _Nullable tabAnimated;

@end

