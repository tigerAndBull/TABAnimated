//
//  TABViewAnimated.h
//  AnimatedDemo
//
//  github: https://github.com/tigerAndBull/TABAnimated
//  jianshu: https://www.jianshu.com/p/6a0ca4995dff
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#ifndef TABAnimated_h
#define TABAnimated_h

#import <Foundation/Foundation.h>

#import "UIView+TABAnimated.h"

#import "UIView+TABControlAnimation.h"
#import "NSArray+TABAnimated.h"

#import "TABViewAnimated.h"
#import "TABTableAnimated.h"
#import "TABCollectionAnimated.h"

#import "TABAnimationMethod.h"

#import "TABComponentManager.h"
#import "TABBaseComponent.h"

#define tabAnimatedLog(x) {if([TABAnimated sharedAnimated].openLog) NSLog(x);}
#define tab_kColor(s) [UIColor colorWithRed:(((s&0xFF0000)>>16))/255.0 green:(((s&0xFF00)>>8))/255.0 blue:((s&0xFF))/255.0 alpha:1.]
#define tab_RGB(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.]

#endif

extern NSString * const TABAnimatedAlphaAnimation;  /// the key of bin animation
extern NSString * const TABAnimatedLocationAnimation;  /// the key of flex animation
extern NSString * const TABAnimatedShimmerAnimation;  ///the key of shimmer animation
extern NSString * const TABAnimatedDropAnimation;   /// the key of drop animation

@class TableDeDaSelfModel, CollectionDeDaSelfModel, TABAnimatedCacheManager;

/**
 * Gobal animation type,
 * which determines whether you need to add additional animations on top of the skeleton layer.
 *
 * Besides `TABAnimationTypeOnlySkeleton` outside value, can add additional an animation.
 *
 * When you have a specified view that doesn't need a global animation type that's already set,
 * You can use a `TABViewSuperAnimationType` covering the local properties `TABAnimationType` values.
 *
 * 全局动画类型，它决定了你是否需要在骨架层的基础之上，增加额外的动画。
 *
 * 除了`TABAnimationTypeOnlySkeleton`以外的值，都会添加额外的一种动画。
 *
 * 当你有一个指定的view不需要已经设置好的全局的动画类型时，
 * 你可以使用`TABViewSuperAnimationType`这个局部属性覆盖`TABAnimationType`的值。
 */
typedef NS_ENUM(NSInteger, TABAnimationType) {
    
    /// only contain the skeleton of your view created by CALayer
    /// 骨架层
    TABAnimationTypeOnlySkeleton = 0,
    
    /// the skeleton of your view with bin animation
    /// 骨架层 + 呼吸灯动画
    TABAnimationTypeBinAnimation,
    
    /// the skeleton of your view with shimmer animation
    /// 骨架层 + 闪光灯
    TABAnimationTypeShimmer,
    
    /// the skeleton of your view with drop animation
    /// 骨架层 + 豆瓣下坠动画
    TABAnimationTypeDrop
};

/**
 * Control some global attributes,
 * including breath lamp animation, flash animation, douban drop animation global parameter Settings.
 * At the same time, there are auxiliary development, debugging parameter Settings.
 *
 * Init types of methods, must be in `didFinishLaunchingWithOptions` first use.
 *
 * 控制一些全局的属性，包含了呼吸灯动画、闪光灯动画、豆瓣下坠动画的全局参数设置。
 * 同时还有辅助开发、调试的参数设置。
 *
 * init类型的方法，必须要在`didFinishLaunchingWithOptions`首先使用
 */
@interface TABAnimated : NSObject

/**
 * Global animation type
 *
 * Default is to include the skeleton layer.
 * The last three values are based on the skeleton layer, with additional animations added by default.
 *
 * 全局动画类型
 *
 * 默认是只有骨架层，后三者是在骨架层的基础之上，还会默认加上额外的动画。
 * 优先级：全局动画类型 < 控制视图声明的动画类型
 */
@property (nonatomic, assign) TABAnimationType animationType;

/**
 * The ratio of the height of the animation to the original height of the view,
 * This property is valid for all subviews except for the type 'UIImageView'.
 *
 * In practice, it is found that for UILabel, UIButton and other views, when the height of animation is the same as the height of the original
 * view, the effect is not beautiful (too thick).
 * Keep the ratio around 0.75, the animation effect will look more beautiful, the specific coefficient can be modified according to your own
 * aesthetic.
 *
 * 动画高度与视图原有高度的比例系数，
 * 该属性对除了`UIImageView`类型的所有子视图生效。
 *
 * 在实践中发现，对于UILabel, UIButton等视图，当动画的高度与原视图的高度一致时，效果并不美观（太粗）。
 * 大概保持在原高度的0.75的比例，动画效果会看起来比较美观，具体系数可以根据你自己的审美进行修改。
 */
@property (nonatomic, assign) CGFloat animatedHeightCoefficient;

/**
 * Global animation content color, default value 0xEEEEEE
 *
 * 全局动画内容颜色，默认值为0xEEEEEE
 */
@property (nonatomic, strong) UIColor *animatedColor;

/**
 * Global animation background color, the default value is UIColor.whiteColor
 *
 * 全局动画背景颜色，默认值为UIColor.whiteColor
 */
@property (nonatomic, strong) UIColor *animatedBackgroundColor;

/**
 * Whether global rounded corners are enabled.
 * When enabled, global rounded corners default to animation height / 2.0.
 *
 * 是否开启全局圆角
 * 开启后，全局圆角默认值为: 动画高度/2.0
 */
@property (nonatomic, assign) BOOL useGlobalCornerRadius;

/**
 * Global rounded corner value
 *
 * priority: this property < view's own rounded corner
 *
 * When you need to personalize rounded corners,
 * you can override the value of this property by chain-syntax '.radius(x)'.
 *
 * 全局圆角的值
 *
 * 优先级：此属性 < view自身的圆角
 *
 * 当需要个性化设置圆角的时候，你可以通过链式语法`.radius(x)`覆盖此属性的值。
 */
@property (nonatomic, assign) CGFloat animatedCornerRadius;

/**
 * It determines whether setting the global animation height
 * After use it, all animation elements except those based on the 'UIImageView' type mapping are set to the value of 'animatedHeight'.
 *
 * When the developer sets 'animatedHeight' in 'TABViewAnimated', the change will be overwritten,
 * When developers use the chain function '.height(x)' to set the height, it has the highest priority.
 *
 * Priority: global height animatedHeight < TABViewAnimated animatedHeight < the height of a single animation element
 *
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
 * Global animation height
 * Set to take effect, and does not contain animation elements that are mapped by the 'UIImageView' type.
 *
 * 全局动画高度
 * 设置后生效，且不包含`UIImageView`类型映射出的动画元素。
 */
@property (nonatomic, assign) CGFloat animatedHeight;

/**
 * An object that manages  skeleton screen cache.
 * 管理骨架屏缓存的全局对象
 */
@property (nonatomic, strong, readonly) TABAnimatedCacheManager *cacheManager;

#pragma mark - Other

/**
 * Whether to turn on console Log reminder, default is NO.
 * 是否开启控制台Log提醒，默认不开启
 */
@property (nonatomic, assign) BOOL openLog;

/**
 * Whether to turn on the animation subscript mark, default is NO.
 * This property, even if it is 'YES', will only take effect in the debug environment.
 *
 * When opened, a red number will be added to each animation element, which represents the subscript of the animation element, so as
 *  to quickly locate an animation element.
 *
 * 是否开启动画下标标记，默认不开启
 * 这个属性即使是`YES`，也仅会在debug环境下生效。
 *
 * 开启后，会在每一个动画元素上增加一个红色的数字，该数字表示该动画元素所在的下标，方便快速定位某个动画元素。
 */
@property (nonatomic, assign) BOOL openAnimationTag;

/**
 * 关闭缓存功能
 * DEBUG环境下，默认关闭缓存功能（为了方便调试预处理回调），即为YES
 * RELEASE环境下，默认开启缓存功能，即为NO
 *
 * 如果你想在DEBUG环境下测试缓存功能，可以手动置为YES
 * 如果你始终都不想使用缓存功能，可以手动置为NO
 */
@property (nonatomic, assign) BOOL closeCache;

#pragma mark - Dark Mode

/**
 * set the backgroundColor of animations in dark mode.
 * 暗黑模式下，动画背景色
 */
@property (nonatomic, strong) UIColor *darkAnimatedBackgroundColor;

/**
 * set the contentColor of animations in dark mode.
 * 暗黑模式下，动画内容的颜色
 */
@property (nonatomic, strong) UIColor *darkAnimatedColor;

#pragma mark - Flex Animation

/**
 * Flex animation back and forth duration
 * 伸缩动画来回时长
 */
@property (nonatomic, assign) CGFloat animatedDuration;

/**
 * Variable length scaling
 * 变长伸缩比例
 */
@property (nonatomic, assign) CGFloat longToValue;

/**
 * Shortening scaling
 * 变短伸缩比例
 */
@property (nonatomic, assign) CGFloat shortToValue;

#pragma mark - Bin Animation

/**
 * Bin animation duration, default is 1s.
 * 呼吸灯动画的时长，默认是1s。
 */
@property (nonatomic, assign) CGFloat animatedDurationBin;

#pragma mark - Shimmer Animation

/**
 * Shimmer animation duration, default is 1s.
 * 闪光灯动画的时长，默认是1s。
 */
@property (nonatomic, assign) CGFloat animatedDurationShimmer;

/**
 * Shimmer animation direction,
 * The default is `TABShimmerDirectionToRight`, means from left to right.
 *
 * 闪光灯动画的方向，
 * 默认是`TABShimmerDirectionToRight`,意思为从左往右。
 */
@property (nonatomic, assign) TABShimmerDirection shimmerDirection;

/**
 * Shimmer animation color change value, default 0xDFDFDF.
 * 闪光灯变色值，默认值0xDFDFDF
 */
@property (nonatomic, strong) UIColor *shimmerBackColor;

/**
 * the brightness of Shimmer animation, default 0.92.
 * 闪光灯亮度，默认值0.92
 */
@property (nonatomic, assign) CGFloat shimmerBrightness;

/**
 * the backgroundColor of shimmer animation in dark mode.
 * 暗黑模式下，全局闪光灯背景色
 */
@property (nonatomic, strong) UIColor *shimmerBackColorInDarkMode;

/**
 * the bightness of shimmer animation in dark mode.
 * 暗黑模式下，全局闪光灯颜色亮度
*/
@property (nonatomic, assign) CGFloat shimmerBrightnessInDarkMode;

#pragma mark - Douban animation

/**
 * Douban animation frame length,
 * the default value is 0.4, you can understand as 'discoloration speed'.
 *
 * 豆瓣动画帧时长，默认值为0.4，你可以理解为`变色速度`。
 */
@property (nonatomic, assign) CGFloat dropAnimationDuration;

/**
 * Douban animation color change value, default value is 0xE1E1E1.
 * 豆瓣动画变色值，默认值为0xE1E1E1
 */
@property (nonatomic, strong) UIColor *dropAnimationDeepColor;

/**
 * Douban animation color change value in dark mode.
 * 暗黑模式下豆瓣动画变色值
*/
@property (nonatomic, strong) UIColor *dropAnimationDeepColorInDarkMode;

#pragma mark - `self.delegate = self`

@property (nonatomic, strong, readonly) NSMutableArray <TableDeDaSelfModel *> *tableDeDaSelfModelArray;
@property (nonatomic, strong, readonly) NSMutableArray <CollectionDeDaSelfModel *> *collectionDeDaSelfModelArray;

- (TableDeDaSelfModel *)getTableDeDaModelAboutDeDaSelfWithClassName:(NSString *)className;
- (CollectionDeDaSelfModel *)getCollectionDeDaModelAboutDeDaSelfWithClassName:(NSString *)className;

#pragma mark - Init Method

/**
 * SingleTon
 * 单例模式
 *
 * @return return object
 */
+ (TABAnimated *)sharedAnimated;

/**
 * Only contain the skeleton of your view created by CALayer.
 * 骨架层
 */
- (void)initWithOnlySkeleton;

/**
 * the skeleton layer + bin animation
 * 全局呼吸灯动画
 */
- (void)initWithBinAnimation;

/**
 * the skeleton layer + shimmer animation
 * 全局闪光灯动画
 */
- (void)initWithShimmerAnimated;

/**
 * the skeleton layer + shimmer animation
 * 全局闪光灯动画
 *
 * @param duration 时长 (duration of one trip)
 * @param color 动画内容颜色 (animation content color)
 */
- (void)initWithShimmerAnimatedDuration:(CGFloat)duration
                              withColor:(UIColor *)color;

/**
 * the skeleton layer + drop animation
 * 全局豆瓣动画
 */
- (void)initWithDropAnimated;

@end
