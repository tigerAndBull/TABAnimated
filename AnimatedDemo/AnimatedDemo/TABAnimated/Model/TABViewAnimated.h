//
//  TABViewAnimated.h
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
//  Created by tigerAndBull on 2019/4/27.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define tab_animated_error_code -1000
#define tab_header_prefix @"tab_header_"
#define tab_footer_prefix @"tab_footer_"
#define tab_default_suffix @"default_resuable_view"

@class TABComponentManager;

/**
 * The status of the animation on the control view.
 * 动画状态
 */
typedef NS_ENUM(NSInteger,TABViewAnimationStyle) {
    TABViewAnimationDefault = 0,                             // default, nothing to do
    TABViewAnimationStart,                                   // start animation
    TABViewAnimationRunning,                                 // runing animation
    TABViewAnimationEnd,                                     // end animation
};

/**
 * The type of superAnimation, it decides the type of the animation.
 * If the property's value is default, the type of the animation is decided by the global property named `animationType` in the file named `TABViewAnimated.h`.
 * 控制视图设置此属性后，动画类型以该属性为准
 *
 * - TABViewSuperAnimationTypeDefault: 不做降权处理
 */
typedef NS_ENUM(NSInteger,TABViewSuperAnimationType) {
    TABViewSuperAnimationTypeDefault = 0,                    // default, 不做降权处理
    TABViewSuperAnimationTypeOnlySkeleton,                   // 骨架层
    TABViewSuperAnimationTypeBinAnimation,                   // 呼吸灯
    TABViewSuperAnimationTypeShimmer,                        // 闪光灯
    TABViewSuperAnimationTypeDrop,                           // 豆瓣下坠动画
};

/**
 * 预处理动画组回调，
 * 一个动画组为一次回调，
 * UIView作为控制视图，那么UIView的动画元素会作为一个组
 * UITableView作为控制视图，那么UITableViewCell的动画元素会作为一个组
 * 当UIView作为控制视图，且嵌套着UITableView，那么UIView为主控制视图，UITableView为次控制视图。
 *
 @param view 动画组持有者
 */
typedef void(^TABAnimatedCategoryBlock)(UIView *view);

/**
 * 新预处理回调
 *
 * @param manager 管理动画组对象
 */
typedef void(^TABAdjustBlock)(TABComponentManager *manager);

/**
 * 适用于多cell, 建议使用该回调
 * 默认情况下，cellArray的下标就是section的值
 * 指定section的情况，就是你所指定的值
 *
 * @param manager 管理动画组对象
 * @param targetClass 多cell情况，对应的数组下标
 */
typedef void(^TABAdjustWithClassBlock)(TABComponentManager *manager, Class targetClass);

@interface TABViewAnimated : NSObject

/**
 * v2.2.0新预处理回调, 职责更明确
 * 可以在其中使用链式语法便捷调整每一个动画元素
 */
@property (nonatomic,copy) TABAdjustBlock adjustBlock;

/**
 * v2.2.0新预处理回调, 职责更明确
 * 可以在其中使用链式语法便捷调整每一个动画元素,
 * section是指数组中不同cell的下标
 */
@property (nonatomic,copy) TABAdjustWithClassBlock adjustWithClassBlock;

/**
 * 预处理回调，可以在其中使用链式语法便捷调整每一个动画元素
 */
@property (nonatomic,copy) TABAnimatedCategoryBlock categoryBlock  DEPRECATED_MSG_ATTRIBUTE("该回调在v2.1.4被弃用，请使用新的回调`adjustBlock`或者`adjustWithClassBlock`取代");

/**
 * The state of the animation, you can reset it.
 * 动画状态，可重置
 */
@property (nonatomic,assign) TABViewAnimationStyle state;

/**
 * The type of superAnimation, it decides the type of the animation.
 * If the property's value is default, the type of the animation is decided by the global property named `animationType` in the file named `TABViewAnimated.h`.
 * 使用该属性时，全局动画类型失效，目标视图将更改为当前属性指定的动画类型。
 */
@property (nonatomic,assign) TABViewSuperAnimationType superAnimationType;

/**
 * One-to-one correspondence between section and templateClass
 * 一个section对应一个templateClass
 */
@property (nonatomic,copy) NSArray <Class> *cellClassArray;

/**
 * Similar to `animatedCount`.
 * when animatedCountArray.count > section.count，the extra on animatedCountArray is not effective.
 * when animatedCountArray.count < section.count，the financial departments load by animatedCountArray.lastobject.
 * 多个section使用该属性，设置动画时row数量
 * 当数组数量大于section数量，多余数据将舍弃
 * 当数组数量小于seciton数量，剩余部分动画时row的数量为默认值
 */
@property (nonatomic,copy) NSArray <NSNumber *> *animatedCountArray;

/**
 * It determines the color of all animations on the control view.
 * 决定当前视图动画内容颜色
 */
@property (nonatomic,strong) UIColor *animatedColor;

/**
 * It determines the backgroundColor of all animations on the control view.
 * 决定当前视图动画背景颜色
 */
@property (nonatomic,strong) UIColor *animatedBackgroundColor;

/**
 * 如果开启了全局圆角，当该属性设置为YES，则该控制视图下圆角将取消，
 * 但是视图本身如果有圆角，则保持不变。
 */
@property (nonatomic,assign) BOOL cancelGlobalCornerRadius;

/**
 * It determines the cornerRadius of all animations on the control view.
 * 决定当前视图动画元素圆角
 */
@property (nonatomic,assign) CGFloat animatedCornerRadius;

/**
 * 如果你的背景视图的圆角失效了，请使用这个属性设置其圆角
 */
@property (nonatomic,assign) CGFloat animatedBackViewCornerRadius;

/**
 * It determines the cornerRadius of all animations without the class of `UIImageView` on the control view.
 * 决定当前视图动画高度
 */
@property (nonatomic,assign) CGFloat animatedHeight;

/**
 * Is runing animation or not.
 * 是否在动画中，在普通模式中，用于快速判断
 */
@property (nonatomic,assign) BOOL isAnimating;

/**
 * Is the nest view or not.
 * 是否是嵌套在内部的表格视图
 */
@property (nonatomic,assign) BOOL isNest;

/**
 * 是否可以重复开启动画，默认开启只生效一次。
 */
@property (nonatomic,assign) BOOL canLoadAgain;

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
@property (nonatomic,assign) CGSize filterSubViewSize;

#pragma mark - 豆瓣动画属性

/**
 * 豆瓣动画变色时长，无默认，默认读取全局属性
 */
@property (nonatomic,assign) CGFloat dropAnimationDuration;

/**
 * 豆瓣动画变色值
 */
@property (nonatomic,strong) UIColor *dropAnimationDeepColor;

/**
 * 判断指定分区是否在动画中
 *
 * @param section section 目标section
 * @return return value 是否在动画中
 */
- (BOOL)currentSectionIsAnimatingWithSection:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
