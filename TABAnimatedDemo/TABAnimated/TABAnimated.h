//
//  TABViewAnimated.h
//  TABAnimatedDemo
//
//  github: https://github.com/tigerAndBull/TABAnimated
//  jianshu: https://www.jianshu.com/p/6a0ca4995dff
//  关注 tigerAndBull技术分享 公众号，加群快速沟通
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

#ifndef TABAnimated_h
#define TABAnimated_h

#import <UIKit/UIKit.h>

#import "UIView+TABControlAnimation.h"
#import "UIView+TABControlModel.h"

#import "TABComponentManager.h"
#import "NSArray+TABAnimatedChain.h"

#import "TABBinAnimation.h"
#import "TABShimmerAnimation.h"
#import "TABDropAnimationDefines.h"
#import "TABClassicAnimation.h"
#import "TABBaseComponent+TABClassicAnimation.h"

#import "UIScrollView+TABAnimated.h"

#import "TABAnimatedDarkModeDefines.h"
#import "UITableView+TABControlAnimation.h"
#import "UICollectionView+TABControlAnimation.h"

#endif

/**
 * 全局动画类型，它决定了你是否需要在骨架层的基础之上，增加额外的动画。
 *
 * 每一种类型都会添加额外的一种动画，`TABAnimationTypeOnlySkeleton` 包含了经典的伸缩动画
 *
 * 当你有一个特定的view不需要此处全局的动画时，
 * 你可以使用`TABViewSuperAnimationType`这个局部属性去覆盖`TABAnimationType`的值。
 */
typedef NS_ENUM(NSInteger, TABAnimationType) {
    
    // 骨架层 + 经典伸缩动画
    TABAnimationTypeOnlySkeleton = 0,
    
    // 骨架层 + 呼吸灯动画
    TABAnimationTypeBinAnimation,
    
    // 骨架层 + 闪光灯动画
    TABAnimationTypeShimmer,
    
    // 骨架层 + 豆瓣下坠动画
    TABAnimationTypeDrop,
    
    // 骨架层 + 自定义动画
    TABAnimationTypeCustom
};

/**
 * 控制一些全局的属性，包含了呼吸灯动画、闪光灯动画、豆瓣下坠动画的全局参数设置。
 * 同时还有辅助开发、调试的参数设置。
 *
 * init类型的方法，必须要在`didFinishLaunchingWithOptions`首先使用
 */
@interface TABAnimated : NSObject

/**
 * 全局动画类型
 *
 * 默认是只有骨架层，后三者是在骨架层的基础之上，还会默认加上额外的动画。
 * 优先级：全局动画类型 < 控制视图声明的动画类型
 */
@property (nonatomic, assign) TABAnimationType animationType;

/**
 * 动画高度与视图原有高度的比例系数，
 * 该属性仅仅对`UILabel`生效。
 *
 * 在实践中发现，对于UILabel视图，当动画的高度与原视图的高度一致时，效果并不美观（高度太高，看起来很粗）。
 * 大概保持在原高度的0.75的比例，动画效果会看起来比较美观，具体系数可以根据你自己的审美进行修改。
 */
@property (nonatomic, assign) CGFloat animatedHeightCoefficient;

/**
 * 全局动画内容颜色，默认值为0xEEEEEE
 */
@property (nonatomic, strong) UIColor *animatedColor;

/**
 * 全局动画背景颜色，默认值为UIColor.whiteColor
 */
@property (nonatomic, strong) UIColor *animatedBackgroundColor;

/**
 * 是否开启全局圆角
 * 开启后，全局圆角默认值为: 动画高度/2.0
 */
@property (nonatomic, assign) BOOL useGlobalCornerRadius;

/**
 * 全局圆角的值
 *
 * 优先级：此属性 < view自身的圆角
 *
 * 当需要个性化设置圆角的时候，你可以通过链式语法`.radius(x)`覆盖此属性的值。
 */
@property (nonatomic, assign) CGFloat animatedCornerRadius;

/**
 * 是否需要全局动画高度，
 * 使用后，所有除了基于`UIImageView`类型映射的动画元素，高度都会设置为`animatedHeight`的高度。
 *
 * 当开发者设置了`TABViewAnimated`中的`animatedHeight`时，将会覆盖改值，
 * 当开发者使用链式语法`.height(x)`设置高度时，则具有最高优先级
 *
 * 优先级：全局高度animatedHeight < TABViewAnimated中animatedHeight < 单个设置动画元素的高度
 */
@property (nonatomic, assign) BOOL useGlobalAnimatedHeight;

/**
 * 全局动画高度
 * 设置后生效，且不包含`UIImageView`类型映射出的动画元素。
 */
@property (nonatomic, assign) CGFloat animatedHeight;

/**
 是否可以在滚动，默认可以滚动
 */
@property (nonatomic, assign) BOOL scrollEnabled;

#pragma mark - Other

/**
 * 是否开启控制台Log提醒，默认不开启
 */
@property (nonatomic, assign) BOOL openLog;

/**
 * 是否开启动画下标标记，默认不开启
 * 这个属性即使是`YES`，也仅会在debug环境下生效。
 *
 * 开启后，会在每一个动画元素上增加一个红色的数字，该数字表示该动画元素所在的下标，方便快速定位某个动画元素。
 */
@property (nonatomic, assign) BOOL openAnimationTag;

/**
 * 关闭内存缓存功能，默认开启
 */
@property (nonatomic, assign) BOOL closeCache;

/**
 * 关闭沙盒缓存功能，默认关闭
 */
@property (nonatomic, assign) BOOL closeDiskCache;

#pragma mark - Dark Mode

/**
 * 暗黑模式下，动画背景色
 */
@property (nonatomic, strong) UIColor *darkAnimatedBackgroundColor;

/**
 * 暗黑模式下，动画内容的颜色
 */
@property (nonatomic, strong) UIColor *darkAnimatedColor;

// 暗黑模式选择，跟随系统、强制普通模式、强制暗黑模式
@property (nonatomic, assign) TABAnimatedDarkModeType darkModeType;

#pragma mark - Animation

// 经典动画全局配置
@property (nonatomic, strong) TABClassicAnimation *classicAnimation;

// 下坠动画全局配置
@property (nonatomic, strong) TABDropAnimation *dropAnimation;

// 呼吸灯动画全局配置
@property (nonatomic, strong) TABBinAnimation *binAnimation;

// 闪光灯动画全局配置
@property (nonatomic, strong) TABShimmerAnimation *shimmerAnimation;

#pragma mark - Init Method

/**
 * 单例模式
 *
 * @return return object
 */
+ (TABAnimated *)sharedAnimated;

/**
 * 初始化并选择动画类型
 * @param animationType 全局动画类型
 */
- (instancetype)initWithAnimatonType:(TABAnimationType)animationType;

/**
 * 骨架层
 */
- (void)initWithOnlySkeleton;

/**
 * 全局呼吸灯动画
 */
- (void)initWithBinAnimation;

/**
 * 全局闪光灯动画
 */
- (void)initWithShimmerAnimated;

/**
 * 全局豆瓣动画
 */
- (void)initWithDropAnimated;

/**
 * 全局闪光灯动画
 *
 * @param duration 时长 (duration of one trip)
 * @param color 动画内容颜色 (animation content color)
 */
- (void)initWithShimmerAnimatedDuration:(CGFloat)duration withColor:(UIColor *)color;

#pragma mark - Deprecated

@property (nonatomic, assign) CGFloat animatedDuration;
@property (nonatomic, assign) CGFloat longToValue;
@property (nonatomic, assign) CGFloat shortToValue;
@property (nonatomic, assign) CGFloat animatedDurationBin;
@property (nonatomic, assign) CGFloat animatedDurationShimmer;
@property (nonatomic, assign) TABShimmerDirection shimmerDirection;
@property (nonatomic, strong) UIColor *shimmerBackColor;
@property (nonatomic, assign) CGFloat shimmerBrightness;
@property (nonatomic, strong) UIColor *shimmerBackColorInDarkMode;
@property (nonatomic, assign) CGFloat shimmerBrightnessInDarkMode;

@end
