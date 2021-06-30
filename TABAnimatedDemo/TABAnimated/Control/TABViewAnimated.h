//
//  TABViewAnimated.h
//  TABAnimatedDemo
//
//  github: https://github.com/tigerAndBull/TABAnimated
//  jianshu: https://www.jianshu.com/p/6a0ca4995dff
//
//  Created by tigerAndBull on 2019/4/27.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TABViewAnimatedDefines.h"
#import "TABAnimatedProductInterface.h"
#import "TABAnimatedDecorateInterface.h"
#import "TABAnimatedDarkModeInterface.h"
#import "TABAnimatedDarkModeManagerInterface.h"
#import "TABComponentLayerSerializationInterface.h"

NS_ASSUME_NONNULL_BEGIN

extern int const TABAnimatedIndexTag;
FOUNDATION_EXPORT NSString *tab_NSStringFromClass(Class aClass);

@interface TABViewAnimated : NSObject

// 生产者
@property (nonatomic, strong) id <TABAnimatedProductInterface> producter;
// 装饰者，用于制作自定义动画, 关联layers
// 开发者可以设置TABShimmerAnimation,TABDropAnimation,TABBindAnimation达到局部自定制，也可以设置自己制定的规则
@property (nonatomic, strong) id <TABAnimatedDecorateInterface> decorator;
// 暗黑模式骨架内容切换协议
@property (nonatomic, strong) id <TABAnimatedDarkModeInterface> switcher;
// TABComponetLayer序列化协议
@property (nonatomic, strong) id <TABComponentLayerSerializationInterface> serializationImpl;

// 不需要手动赋值，但是你需要知道当前视图的结构，从而选择初始化方法和启动方法。
@property (nonatomic, assign) TABAnimatedRunMode runMode;

// 动画状态，可重置
@property (nonatomic) TABViewAnimationStyle state;

// 使用该属性时，全局动画类型失效，目标视图将更改为当前属性指定的动画类型。
@property (nonatomic, assign) TABViewSuperAnimationType superAnimationType;

// 可以在其中使用链式语法便捷调整每一个动画元素
@property (nonatomic, copy) TABAdjustBlock adjustBlock;

// 可以在其中使用链式语法便捷调整每一个动画元素, 使用class区分不同cell
@property (nonatomic, copy) TABAdjustWithClassBlock adjustWithClassBlock;

// 推荐高度
@property (nonatomic, copy) TABRecommendHeightBlock recommendHeightBlock;

// 当前视图动画内容颜色
@property (nonatomic, strong) UIColor *animatedColor;

// 当前视图动画背景颜色
@property (nonatomic, strong) UIColor *animatedBackgroundColor;

// 当前视图暗黑模式下动画内容颜色
@property (nonatomic, strong) UIColor *darkAnimatedColor;

// 当前视图暗黑模式下动画背景颜色
@property (nonatomic, strong) UIColor *darkAnimatedBackgroundColor;

/**
 * 如果开启了全局圆角，当该属性设置为YES，则该控制视图下圆角将取消，
 * 但是视图本身如果有圆角，则保持不变。
 */
@property (nonatomic, assign) BOOL cancelGlobalCornerRadius;

/**
 * 决定当前视图动画元素圆角
 */
@property (nonatomic, assign) CGFloat animatedCornerRadius;

/**
 * 如果你的背景视图的圆角失效了，请使用这个属性设置其圆角
 */
@property (nonatomic, assign) CGFloat animatedBackViewCornerRadius;

/**
 * 决定当前视图动画高度
 */
@property (nonatomic, assign) CGFloat animatedHeight;

/// 动画中view的高度
@property (nonatomic, assign) CGFloat viewHeight;

/// 动画前的view高度，暂时没有用到，一般来说，动画结束后，开发者会调用sizeToFIt重新设置高度 
@property (nonatomic, assign) CGFloat originViewHeight;

/**
 * 是否在动画中，在普通模式中，用于快速判断
 */
@property (nonatomic, assign) BOOL isAnimating;

/**
 * 是否有嵌套在内部的表格视图
 */
@property (nonatomic, assign) BOOL containNestAnimation;

/**
 * 是否可以重复开启动画，默认开启只生效一次。
 */
@property (nonatomic, assign) BOOL canLoadAgain;

#pragma mark - 过滤条件

/**
 * 过滤子视图条件，默认为CGSizeZero。
 * 如果width为0，则不过滤width
 * 如果height为0，则不过滤height
 * 如果width为5，则过滤掉`width <= 5`的子视图
 * 如果height为5，则过滤掉`height <= 5`的子视图
 * 如果width, height条件同时存在，两种条件都会被过滤。
 *
 * PS：width为原始宽度，height为原始高度，不受全局属性`animatedHeightCoefficient`的影响
 */
@property (nonatomic, assign) CGSize filterSubViewSize;

#pragma mark - Other

/**
 * 控制视图所处的控制器类型
 */
@property (nonatomic, copy) NSString *targetControllerClassName;

/// 只显示自己，不再遍历子视图
@property (nonatomic, assign) Class withoutSubViewsClass;

/// 是否需要基于UITextField创建骨架元素，默认为NO
@property (nonatomic, assign) BOOL needToCreateTextFieldLayer;

@property (nonatomic, assign) BOOL configed;

- (nonnull UIColor *)getCurrentAnimatedColorWithCollection:(UITraitCollection *)collection;
- (nonnull UIColor *)getCurrentAnimatedBackgroundColorWithCollection:(UITraitCollection *)collection;

/// viewHeight为骨架屏周期的视图高度，不影响骨架屏结束前后
- (instancetype)initWithViewHeight:(CGFloat)viewHeight;
+ (instancetype)animatedWithViewHeight:(CGFloat)viewHeight;

#pragma mark - DEPRECATED

typedef void(^TABAnimatedCategoryBlock)(UIView *view);
@property (nonatomic, assign) BOOL isNest DEPRECATED_MSG_ATTRIBUTE("该属性在v2.4.4被弃用，请使用`containNestAnimation`取代");

@property (nonatomic, assign) CGFloat dropAnimationDuration DEPRECATED_MSG_ATTRIBUTE("该属性在v2.2.5被弃用，请使用`TABDropAnimation`取代");
@property (nonatomic, strong) UIColor *dropAnimationDeepColor DEPRECATED_MSG_ATTRIBUTE("该属性在v2.2.5被弃用，请使用`TABDropAnimation`取代");
@property (nonatomic, strong) UIColor *dropAnimationDeepColorInDarkMode DEPRECATED_MSG_ATTRIBUTE("该属性在v2.2.5被弃用，请使用`TABDropAnimation`取代");
@property (nonatomic, copy) TABAnimatedCategoryBlock categoryBlock  DEPRECATED_MSG_ATTRIBUTE("该回调在v2.1.4被弃用，请使用新的回调`adjustBlock`或者`adjustWithClassBlock`取代");

@end

NS_ASSUME_NONNULL_END
