//
//  TABComponentManager.h
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
//  Created by tigerAndBull on 2019/7/16.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TABBaseComponent.h"
#import "TABAnimatedChainDefines.h"
#import "TABAnimationMethod.h"

NS_ASSUME_NONNULL_BEGIN

@class TABViewAnimated, TABAnimatedProduction;

@interface TABComponentManager : NSObject

/**
 * 获取单个动画元素
 * 使用方式：.animationN(x)
 * x为字符串，映射组件的变量名
 *
 * @return TABBaseComponent对象
 */
- (TABBaseComponentStringBlock _Nullable)animationN;

/**
 * 获取单个动画元素
 * 使用方式：.animation(x)
 * x为int值
 *
 * @return TABBaseComponent对象
 */
- (TABBaseComponentBlock _Nullable)animation;

/**
 * 获取多个动画元素，需要传递2个参数
 * 第一个参数为起始下标
 * 第二个参数长度
 * 使用方式：.animations(x,x)
 *
 * @return 装有`TABBaseComponent`类型的数组
 */
- (TABBaseComponentArrayBlock _Nullable)animations;

/**
 * 获取不定量动画元素，参数 >= 1
 * 例如: animationsWithIndexs(1,5,7)，意为获取下标为1，5，7的动画元素
 *
 * @return 装有`TABBaseComponent`类型的数组
 */
- (TABBaseComponentArrayWithIndexsBlock)animationsWithIndexs;

/// 创建一个新的元素
/// 需要传一个index作为唯一标识
/// 如果用了已经存在的index，仍然会被创建，但是不能二次修改
- (TABBaseComponentIntegerBlock)create;

/// 创建一个新的元素
/// 需要传一个参数tag 作为唯一标识
/// 没有做tag重复处理，如果用了重复的tag，会被创建，但是不能二次修改
- (TABBaseComponentStringBlock)createN;

@property (nonatomic, strong) TABBaseComponent *backgroundComponent;

#pragma mark - Method

- (instancetype)initWithBackgroundLayer:(TABComponentLayer *)backgroundLayer
                                 layers:(NSMutableArray <TABComponentLayer *> *)layers
                          animatedColor:(UIColor *)animatedColor;

+ (instancetype)managerWithBackgroundLayer:(TABComponentLayer *)backgroundLayer
                                    layers:(NSMutableArray <TABComponentLayer *> *)layers
                             animatedColor:(UIColor *)animatedColor;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END
