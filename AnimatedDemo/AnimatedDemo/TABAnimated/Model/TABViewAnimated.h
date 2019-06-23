//
//  TABBaseAnimated.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/4/27.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TABLayer;
@class TABComponentLayer;

// `TABAnimatedObject` is used to the control view.

/**
 The status of the animation on the control view.
 动画状态
 */
typedef NS_ENUM(NSInteger,TABViewAnimationStyle) {
    TABViewAnimationDefault = 0,                             // default, nothing to do
    TABViewAnimationStart,                                   // start animation
    TABViewAnimationRunning,                                 // runing animation
    TABViewAnimationEnd,                                     // end animation
};

/**
 The type of superAnimation, it decides the type of the animation.
 If the property's value is default, the type of the animation is decided by the global property named `animationType` in the file named `TABViewAnimated.h`.
 控制视图设置此属性后，动画类型以该属性为准

 - TABViewSuperAnimationTypeDefault: 不做降权处理
 */
typedef NS_ENUM(NSInteger,TABViewSuperAnimationType) {
    TABViewSuperAnimationTypeDefault = 0,                    // default, 不做降权处理
    TABViewSuperAnimationTypeOnlySkeleton,                   // 骨架层
    TABViewSuperAnimationTypeBinAnimation,                   // 呼吸灯
    TABViewSuperAnimationTypeShimmer,                        // 闪光灯
    TABViewSuperAnimationTypeDrop,                           // 豆瓣下坠动画
};

typedef void(^TABAnimatedCategoryBlock)(UIView *view);

@interface TABViewAnimated : NSObject

/**
 预处理回调，可以在其中使用链式语法便捷调整每一个动画元素
 */
@property (nonatomic,copy) TABAnimatedCategoryBlock categoryBlock;

/**
 The state of the animation, you can reset it.
 动画状态，可重置
 */
@property (nonatomic,assign) TABViewAnimationStyle state;

/**
 The type of superAnimation, it decides the type of the animation.
 If the property's value is default, the type of the animation is decided by the global property named `animationType` in the file named `TABViewAnimated.h`.
 使用该属性时，全局动画类型失效，目标视图将更改为当前属性指定的动画类型。
 */
@property (nonatomic,assign) TABViewSuperAnimationType superAnimationType;

/**
 One-to-one correspondence between section and templateClass
 一个section对应一个templateClass
 */
@property (nonatomic,copy) NSArray <Class> *cellClassArray;

/**
 动画时row数量，默认填充屏幕为准
 **/
@property (nonatomic,assign) NSInteger animatedCount;

/**
 Similar to `animatedCount`.
 when animatedCountArray.count > section.count，the extra on animatedCountArray is not effective.
 when animatedCountArray.count < section.count，the financial departments load by animatedCountArray.lastobject.
 多个section使用该属性，设置动画时row数量
 当数组数量大于section数量，多余数据将舍弃
 当数组数量小于seciton数量，剩余部分动画时row的数量为默认值
 */
@property (nonatomic,copy) NSArray <NSNumber *> *animatedCountArray;

/**
 It determines the color of all animations on the control view.
 决定当前视图动画内容颜色
 */
@property (nonatomic,strong) UIColor *animatedColor;

/**
 It determines the backgroundColor of all animations on the control view.
 决定当前视图动画背景颜色
 */
@property (nonatomic,strong) UIColor *animatedBackgroundColor;

/**
 如果开启了全局圆角，当该属性设置为YES，则该控制视图下圆角将取消，
 但是视图本身如果有圆角，则保持不变。
 */
@property (nonatomic,assign) BOOL cancelGlobalCornerRadius;

/**
 It determines the cornerRadius of all animations on the control view.
 决定当前视图动画圆角
 */
@property (nonatomic,assign) CGFloat animatedCornerRadius;

/**
 It determines the cornerRadius of all animations without the class of `UIImageView` on the control view.
 决定当前视图动画高度
 */
@property (nonatomic,assign) CGFloat animatedHeight;

/**
 Is runing animation or not.
 是否在动画中，在普通模式中，用于快速判断
 */
@property (nonatomic,assign) BOOL isAnimating;

/**
 Is the nest view or not.
 是否是嵌套在内部的表格视图
 */
@property (nonatomic,assign) BOOL isNest;

/**
 是否可以重复开启动画，默认开启只生效一次。
 */
@property (nonatomic,assign) BOOL canLoadAgain;

#pragma mark - 豆瓣动画属性

/**
 豆瓣动画变色时长，无默认，默认读取全局属性
 */
@property (nonatomic,assign) CGFloat dropAnimationDuration;

/**
 豆瓣动画变色值
 */
@property (nonatomic,strong) UIColor *dropAnimationDeepColor;

@end

NS_ASSUME_NONNULL_END
