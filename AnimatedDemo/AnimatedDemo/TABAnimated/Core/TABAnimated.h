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

extern NSString * const TABAnimatedAlphaAnimation;
extern NSString * const TABAnimatedLocationAnimation;
extern NSString * const TABAnimatedShimmerAnimation;
extern NSString * const TABAnimatedDropAnimation;

typedef NS_ENUM(NSInteger,TABAnimationType) {
    TABAnimationTypeOnlySkeleton = 0,    // 普通骨架层
    TABAnimationTypeBinAnimation,        // 呼吸灯
    TABAnimationTypeShimmer,             // 闪光灯
    TABAnimationTypeDrop                 // 豆瓣下坠动画
};

@class TableDeDaSelfModel;

@interface TABAnimated : NSObject

/**
 全局动画类型，优先级：全局动画类型 < 控制视图声明的动画类型，即
 默认是只有骨架屏，后三者是在骨架屏的基础之上，采用`热插拔`的方式，植入的动画效果。
 */
@property (nonatomic, assign) TABAnimationType animationType;

/**
 属性含义：动画高度与视图原有高度的比例系数，该属性对除了`[view isKindOfClass:[UIImageView class]]`的所有子视图生效
 在实践中发现，对于UILabel,UIButton等视图，当动画的高度与原视图的高度一致时，效果并不美观（太粗）。
 大概保持在0.75的比例，动画效果会看起来比较美观，具体系数可以根据你自己的审美进行修改。
 */
@property (nonatomic, assign) CGFloat animatedHeightCoefficient;

/**
 全局动画内容颜色，默认值0xEEEEEE
 */
@property (nonatomic, strong) UIColor *animatedColor;

/**
 全局动画背景颜色
 */
@property (nonatomic, strong) UIColor *animatedBackgroundColor;

/**
 开启全局圆角
 开启后，全局圆角默认值为: 动画高度/2.0
 */
@property (nonatomic, assign) BOOL useGlobalCornerRadius;

/**
 全局圆角的值，优先级：此属性 < view自身的圆角
 当需要个性化设置圆角的时候，你可以通过链式语法`.radius(x)`覆盖此属性的值。
 */
@property (nonatomic, assign) CGFloat animatedCornerRadius;

/**
 是否需要全局动画高度，
 使用后，所有除了基于`UIImageView`类型映射的动画元素，高度都会设置为`animatedHeight`的高度。
 
 当开发者设置了`TABViewAnimated`中的`animatedHeight`时，将会覆盖改值，
 当开发者使用链式语法`.height(x)`设置高度时，则具有最高优先级

 优先级：全局高度animatedHeight < TABViewAnimated中animatedHeight < 单个设置动画元素的高度
 */
@property (nonatomic, assign) BOOL useGlobalAnimatedHeight;

/**
 全局动画高度（不包含`UIImageView`类型映射出的动画元素），默认12
 */
@property (nonatomic, assign) CGFloat animatedHeight;

#pragma mark - Other

/**
 是否开启控制台Log提醒
 */
@property (nonatomic, assign) BOOL openLog;

/**
 是否开启动画坐标标记，如果开启，也仅在debug环境下有效。
 开启后，会在每一个动画元素上增加一个红色的数字，该数字表示该动画元素所在下标，方便快速定位某个动画元素。
 */
@property (nonatomic, assign) BOOL openAnimationTag;

#pragma mark - 动态伸缩动画相关的全局属性

/**
 伸缩动画来回时长
 */
@property (nonatomic, assign) CGFloat animatedDuration;

/**
 变长伸缩比例
 */
@property (nonatomic, assign) CGFloat longToValue;

/**
 变短伸缩比例
 */
@property (nonatomic, assign) CGFloat shortToValue;

#pragma mark - 呼吸灯动画相关的全局属性

/**
 呼吸灯时长
 */
@property (nonatomic, assign) CGFloat animatedDurationBin;

#pragma mark - 闪光灯动画相关的全局属性

/**
 闪光灯动画时长，默认是1秒。
 
 The duration of shimmer animation, default is 1 seconds.
 */
@property (nonatomic, assign) CGFloat animatedDurationShimmer;

/**
 闪光灯动画方向，默认是`TABShimmerDirectionToRight`,意为从左往右。
 */
@property (nonatomic, assign) TABShimmerDirection shimmerDirection;

/**
 变色值，默认值0xDFDFDF
 */
@property (nonatomic, strong) UIColor *shimmerBackColor;

/**
 闪光灯的亮度，默认值0.92
 */
@property (nonatomic, assign) CGFloat shimmerBrightness;

#pragma mark - 记录`self.delegate = self`地址

@property (nonatomic, strong, readonly) NSMutableArray <TableDeDaSelfModel *> *tableDeDaSelfModelArray;

- (TableDeDaSelfModel *)getTableDeDaModelAboutDeDaSelfWithClassName:(NSString *)className;

#pragma mark - 豆瓣动画相关的全局属性

/**
 豆瓣动画帧时长，默认值为0.4，你可以理解为`变色速度`
 */
@property (nonatomic, assign) CGFloat dropAnimationDuration;

/**
 豆瓣动画变色值，默认值为0xE1E1E1
 */
@property (nonatomic, strong) UIColor *dropAnimationDeepColor;

#pragma mark - 初始化方法

/**
 单例模式

 @return return object
 */
+ (TABAnimated *)sharedAnimated;

/**
 只有骨架屏
 */
- (void)initWithOnlySkeleton;

/**
 全局呼吸灯动画
 */
- (void)initWithBinAnimation;

/**
 全局闪光灯动画
 */
- (void)initWithShimmerAnimated;

/**
 全局闪光灯动画
 
 @param duration 时长
 @param color 动画内容颜色
 */
- (void)initWithShimmerAnimatedDuration:(CGFloat)duration
                              withColor:(UIColor *)color;

/**
 全局豆瓣动画
 */
- (void)initWithDropAnimated;

@end
