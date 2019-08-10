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
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#ifndef TABAnimated_h
#define TABAnimated_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "UIView+TABAnimated.h"
#import "UITableView+TABAnimated.h"
#import "UICollectionView+TABAnimated.h"

#import "UIView+TABLayoutSubviews.h"
#import "UITableViewCell+TABLayoutSubviews.h"
#import "UICollectionViewCell+TABLayoutSubviews.h"

#import "UIView+TABControlAnimation.h"

#import "TABAnimationMethod.h"
#import "TABManagerMethod.h"

#import "TABComponentLayer.h"
#import "NSArray+TABAnimated.h"

#import "TABViewAnimated.h"
#import "TABTableAnimated.h"
#import "TABCollectionAnimated.h"

#import "TABBaseComponent.h"

#import "TableDeDaSelfModel.h"

#define tabAnimatedLog(x) {if([TABAnimated sharedAnimated].openLog) NSLog(x);}

#define tab_kColor(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0]
#define tab_kBackColor tab_kColor(0xEEEEEEFF)
#define tab_kShimmerBackColor tab_kColor(0xDFDFDFFF)

#endif

static NSString * const kTABAlphaAnimation = @"TABAlphaAnimation";
static NSString * const kTABLocationAnimation = @"TABLocationAnimation";
static NSString * const kTABShimmerAnimation = @"TABShimmerAnimation";
static NSString * const kTABDropAnimation = @"TABDropAnimation";

typedef NS_ENUM(NSInteger,TABAnimationType) {
    TABAnimationTypeOnlySkeleton = 0,    // onlySkeleton for all views in your project. 普通骨架层
    TABAnimationTypeBinAnimation,        // default animation for all registered views in your project.                                        呼吸灯
    TABAnimationTypeShimmer,             // shimmer animation for all views in your project. 闪光灯
    TABAnimationTypeDrop                 // drop animation for all views in your project. 豆瓣下坠动画
};

@interface TABAnimated : NSObject

/**
 * 全局动画类型
 * 默认是只有骨架屏，后三者是在骨架屏的基础之上，采用`热插拔`的方式，植入的动画效果。
 */
@property (nonatomic,assign) TABAnimationType animationType;

/**
 *
 * 属性含义：动画高度与视图原有高度比例系数，该属性将对除了`UIImageView`类型的所有subViews生效
 * 在实践中发现，对于UILabel,UIButton等视图，当动画的高度与原视图的高度一致时，效果并不美观（太粗）。
 * 大概保持在0.75的比例，动画效果比较美观，具体还需要您自己尝试，稍作调整。
 * 你完全可以改变这个值。
 *
 * The height of animations compare to origin views' height, the property acts on all subViews except `UIImageView`.
 * In practice, we find that for `UILabel`,`UIButton` and other views, when the height of the animation is
 * consistent with the origin view, the effect is not beautiful.
 * About 0.75, the animation effect is more beautiful, you need to try and adjust it slightly.
 * You can alse reset it.
 *
 **/
@property (nonatomic,assign) CGFloat animatedHeightCoefficient;

/**
 * 全局动画内容颜色
 * The color of animations' content in your project, default is 0xEEEEEE.
 */
@property (nonatomic,strong) UIColor *animatedColor;

/**
 * 全局动画背景颜色
 * The backgroundcolor of animations in your project, default is UIColor.white.
 */
@property (nonatomic,strong) UIColor *animatedBackgroundColor;

/**
 * 开启全局圆角
 * 开启后，全局圆角默认值为: 动画高度/2.0
 * The cornerRadius of animations in your project.
 * the value of cornerRadius is the animation's height / 2.0
 */
@property (nonatomic,assign) BOOL useGlobalCornerRadius;

/**
 * 全局圆角的值
 * 优先级：view设置的圆角 > animatedCornerRadius
 * The cornerRadius of animations in your project.
 * If the view's layer had been setted `cornerRadius`, view's' animation
 */
@property (nonatomic,assign) CGFloat animatedCornerRadius;

/**
 *
 * 是否需要全局动画高度，
 * 使用后，所有除了基于`UIImageView`类型映射的动画元素，高度都会设置为`animatedHeight`的高度。
 *
 * 当开发者设置了`TABViewAnimated`中的`animatedHeight`时，将会覆盖改值，
 * 当开发者使用链式语法`.height(x)`设置高度时，则具有最高优先级
 *
 * 优先级：全局高度animatedHeight < TABViewAnimated中animatedHeight < 单个设置动画元素的高度
 *
 */
@property (nonatomic,assign) BOOL useGlobalAnimatedHeight;

/**
 * 全局动画高度（不包含`UIImageView`类型映射出的动画元素），默认12
 */
@property (nonatomic,assign) CGFloat animatedHeight;

#pragma mark - Other

/**
 * 是否开启控制台Log提醒
 * Is opening log or not, default is NO.
 */
@property (nonatomic,assign) BOOL openLog;

/**
 * 是否开启动画坐标标记，如果开启，也仅在debug环境下有效。
 * 开启后，会在每一个动画元素上增加一个红色的数字，该数字表示该动画元素所在下标，方便快速定位某个动画元素。
 */
@property (nonatomic,assign) BOOL openAnimationTag;

#pragma mark - 动态伸缩动画相关的全局属性

/**
 * 伸缩动画来回时长
 */
@property (nonatomic,assign) CGFloat animatedDuration;

/**
 * 变长伸缩比例
 */
@property (nonatomic,assign) CGFloat longToValue;

/**
 * 变短伸缩比例
 */
@property (nonatomic,assign) CGFloat shortToValue;

#pragma mark - 呼吸灯动画相关的全局属性

/**
 * 呼吸灯时长
 */
@property (nonatomic,assign) CGFloat animatedDurationBin;

#pragma mark - 闪光灯动画相关的全局属性

/**
 * 闪光灯动画时长，默认是1秒。
 * The duration of shimmer animation, default is 1 seconds.
 */
@property (nonatomic,assign) CGFloat animatedDurationShimmer;

/**
 * 闪光灯动画方向，默认是`TABShimmerDirectionToRight`,意为从左往右。
 */
@property (nonatomic,assign) TABShimmerDirection shimmerDirection;

/**
 * 变色值，默认值0xDFDFDF
 */
@property (nonatomic,strong) UIColor *shimmerBackColor;

/**
 * 闪光灯的亮度，默认值0.92
 */
@property (nonatomic,assign) CGFloat shimmerBrightness;

#pragma mark - 记录`self.delegate = self`地址

@property (nonatomic,strong,readonly) NSMutableArray <TableDeDaSelfModel *> *tableDeDaSelfModelArray;

- (TableDeDaSelfModel *)getTableDeDaModelAboutDeDaSelfWithClassName:(NSString *)className;

#pragma mark - 豆瓣动画相关的全局属性

/**
 * 豆瓣动画帧时长，默认值为0.4，你可以理解为`变色速度`
 */
@property (nonatomic,assign) CGFloat dropAnimationDuration;

/**
 * 豆瓣动画变色值，默认值为0xE1E1E1
 */
@property (nonatomic,strong) UIColor *dropAnimationDeepColor;

#pragma mark - 初始化方法

/**
 * 单例模式
 * SingleTon
 *
 * @return return object
 */
+ (TABAnimated *)sharedAnimated;

/**
 * 只有骨架屏
 * only skeleton
 */
- (void)initWithOnlySkeleton;

/**
 * 呼吸灯
 * bin animation
 */
- (void)initWithBinAnimation;

/**
 * 闪光灯
 * shimmer animation
 */
- (void)initWithShimmerAnimated;

/**
 * 闪光灯
 * shimmer Animation
 *
 * @param duration 时长
 * @param color 动画内容颜色
 */
- (void)initWithShimmerAnimatedDuration:(CGFloat)duration
                              withColor:(UIColor *)color;

/**
 * 豆瓣动画
 * drop Animation
 */
- (void)initWithDropAnimated;

@end
