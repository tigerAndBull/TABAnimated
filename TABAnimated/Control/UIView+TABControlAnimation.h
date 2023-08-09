//
//  UIView+TABControllerAnimation.h
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
//  Created by tigerAndBull on 2019/1/17.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TABAnimatedConfig.h"
#import "TABAnimatedChainDefines.h"

NS_ASSUME_NONNULL_BEGIN

extern int const TABAnimatedIndexTag;

@class TABViewAnimated;
@class TABComponentManager;

typedef void (^TABConfigBlock)(TABViewAnimated * _Nonnull tabAnimated);

@interface UIView (TABControlAnimation)

#pragma mark - General

/**
 * 开启动画, 建议使用下面的方法
 *
 * `[self tab_startAnimation]`即使多次调用，也只会生效一次。
 * 如有其他需要，请自行修改`TABViewAnimated`中的`canLoadAgain`属性，解除限制。
 */
- (void)tab_startAnimation;

/**
 * 使用原有的启动动画方法`tab_startAnimation`时发现了一个问题:
 * 在网络非常好的情况下，动画基本没机会展示出来，甚至会有一闪而过的视觉差，所以体验会不好。
 * 增加了一个带有延迟时间的启动方法，默认为0.4s
 * 这样的话，在网络卡的情况下，0.4秒并不会造成太大的影响，在网络不卡的情况下，可以有一个短暂的视觉停留效果。
 *
 * @param completion 在回调中加载数据
 */
- (void)tab_startAnimationWithCompletion:(void (^)(void))completion;

/**
 * 与上述方法功能相同，可以自定义延迟时间。
 *
 * @param delayTime 自定义延迟时间
 * @param completion 在回调中加载数据
 */
- (void)tab_startAnimationWithDelayTime:(CGFloat)delayTime
                             completion:(void (^)(void))completion;

/**
 * 结束动画, 默认不加入任何动画效果
 */
- (void)tab_endAnimation;

/**
 * 结束动画, 加入淡入淡出效果
 */
- (void)tab_endAnimationEaseOut;

#pragma mark - 局部启动/局部结束

/**
 * 启动动画并指定section/row
 *
 * @param index 意为Row还是Section 取决于你的视图结构, 框架会自动识别
 */
- (void)tab_startAnimationWithIndex:(NSInteger)index;

/**
 * 启动动画并指定section/row，默认延迟时间0.4s
 *
 * @param index 意为Row还是Section 取决于你的视图结构, 框架会自动识别
 * @param completion 延迟回调
 */
- (void)tab_startAnimationWithIndex:(NSInteger)index
                         completion:(void (^)(void))completion;

/**
 * 启动动画并指定section/row，同时可以自定义延迟时间
 *
 * @param index 意为Row还是Section 取决于你的视图结构, 框架会自动识别
 * @param delayTime 自定义的延迟时间
 * @param completion 完成回调
 */
- (void)tab_startAnimationWithIndex:(NSInteger)index
                          delayTime:(CGFloat)delayTime
                         completion:(void (^)(void))completion;

/**
 * 指定分区结束动画，当表格的所有分区都不存在动画，会自动置为结束动画的状态
 *
 * @param index 意为Row还是Section 取决于你的视图结构, 框架会自动识别
 */
- (void)tab_endAnimationWithIndex:(NSInteger)index;

#pragma mark - TABViewAnimated

// 不需要初始化TABViewAnimated
// 如果需要调整TABViewAnimated的参数，通过configBlock调整
// 如果需要调整骨架元素，通过adjustBlock调整
- (void)tab_startAnimationWithConfigBlock:(nullable TABConfigBlock)configBlock
                              adjustBlock:(nullable TABAdjustBlock)adjustBlock
                               completion:(nullable void (^)(void))completion;

#pragma mark - Penperate

/// 骨架屏启动中，穿透骨架屏指定标记的组件,
/// 一般用于多段网络请求，局部显示指定组件
/// @param index 指定标记元素
- (void)tab_penperateSkeletonWithIndex:(NSInteger)index;

/// 骨架屏启动中，穿透骨架屏指定标记的组件, 用于多段网络请求
/// 一般用于多段网络请求，局部显示指定组件
/// @param indexArray 指定标记数组
- (void)tab_penperateSkeletonWithIndexArray:(NSArray <NSNumber *> *)indexArray;

#pragma mark -

- (void)tab_startAnimationWithSection:(NSInteger)section;
- (void)tab_startAnimationWithSection:(NSInteger)section completion:(void (^)(void))completion;
- (void)tab_startAnimationWithSection:(NSInteger)section delayTime:(CGFloat)delayTime completion:(void (^)(void))completion;
- (void)tab_endAnimationWithSection:(NSInteger)section;

- (void)tab_startAnimationWithRow:(NSInteger)row;
- (void)tab_startAnimationWithRow:(NSInteger)row completion:(void (^)(void))completion;
- (void)tab_startAnimationWithRow:(NSInteger)row delayTime:(CGFloat)delayTime completion:(void (^)(void))completion;
- (void)tab_endAnimationWithRow:(NSInteger)row;

@end

NS_ASSUME_NONNULL_END
