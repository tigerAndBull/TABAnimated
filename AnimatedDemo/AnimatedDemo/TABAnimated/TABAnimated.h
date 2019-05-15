//
//  TABViewAnimated.h
//  lifeAndSport
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

#import "TABViewAnimated.h"
#import "TABAnimationMethod.h"
#import "TABManagerMethod.h"

/*
 v2.0.0
 */
#import "TABLayer.h"

/*
 v2.1.0
 */
#import "TABComponentLayer.h"
#import "TABViewAnimated.h"
#import "TABTableAnimated.h"
#import "TABCollectionAnimated.h"
#import "NSArray+TABAnimated.h"

#define tab_suppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#define tabAnimatedLog(x) {if([TABAnimated sharedAnimated].openLog) NSLog(x);}

#define tab_kColor(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0]
#define tab_kBackColor tab_kColor(0xEEEEEEFF)

#define kTABAlphaAnimation @"TABAlphaAnimation"
#define kTABLocationAnimation @"TABLocationAnimation"
#define kTABShimmerAnimation @"TABShimmerAnimation"
#define kTABDropAnimation @"TABDropAnimation"

#endif /* TABAnimated_h */

typedef NS_ENUM(NSInteger,TABAnimationType) {
    TABAnimationTypeOnlySkeleton = 0,    // onlySkeleton for all views in your project. 普通骨架层
    TABAnimationTypeBinAnimation,        // default animation for all registered views in your project.                                        呼吸灯
    TABAnimationTypeShimmer,             // shimmer animation for all views in your project. 闪光灯
    TABAnimationTypeDrop                 // drop animation for all views in your project. 豆瓣下坠动画
};

@interface TABAnimated : NSObject

@property (nonatomic,assign) TABAnimationType animationType;

/**
 
 The height of animations compare to origin views' height, the property acts on all subViews except `UIImageView`.
 In practice, we find that for `UILabel`,`UIButton` and other views, when the height of the animation is
 consistent with the origin view, the effect is not beautiful.
 About 0.75, the animation effect is more beautiful, you need to try and adjust it slightly.
 You can alse reset it.
 
 属性含义：动画高度与视图原有高度比例系数，该属性将对所有subViews生效，除了`UIImageView`
 在实践中发现，对于UILabel,UIButton等视图，当动画的高度与原视图的高度一致时，效果并美观，
 大概保持在0.75的比例，动画效果比较美观，具体还需要您自己尝试，稍作调整.
 你也可以改变这个值
 **/
@property (nonatomic,assign) CGFloat animatedHeightCoefficient;

/**
 The color of animations' content in your project, default is 0xEEEEEE.
 全局动画内容颜色
 */
@property (nonatomic,strong) UIColor *animatedColor;

/**
 The backgroundcolor of animations in your project, default is UIColor.white.
 全局动画背景颜色
 */
@property (nonatomic,strong) UIColor *animatedBackgroundColor;

/**
 The cornerRadius of animations in your project.
 the value of cornerRadius is the animation's height / 2.0
 开启全局圆角
 全局圆角默认值为: 动画高度/2.0
 */
@property (nonatomic,assign) BOOL useGlobalCornerRadius;

/**
 The cornerRadius of animations in your project.
 If the view's layer had been setted `cornerRadius`, view's' animation
 全局圆角
 优先级：view设置的圆角 > animatedCornerRadius
 */
@property (nonatomic,assign) CGFloat animatedCornerRadius;

/**
 针对UILabel / UIButton
 是否需要全局动画高度，拥有最高优先级
 */
@property (nonatomic,assign) BOOL useGlobalAnimatedHeight;

/**
 针对UILabel / UIButton
 设置全局动画高度，默认12，拥有最高优先级
 */
@property (nonatomic,assign) CGFloat animatedHeight;

#pragma mark - Other

/**
 Is opening log or not, default is NO.
 是否开启控制台Log提醒
 */
@property (nonatomic,assign) BOOL openLog;

#pragma mark - Dynmic Animation Property

/**
 伸缩动画来回时长
 */
@property (nonatomic,assign) CGFloat animatedDuration;

/**
 变长伸缩比例
 */
@property (nonatomic,assign) CGFloat longToValue;

/**
 变短伸缩比例
 */
@property (nonatomic,assign) CGFloat shortToValue;

#pragma mark - Bin Animation Property

@property (nonatomic,assign) CGFloat animatedDurationBin;

#pragma mark - Shimmer Animation Property

/**
 The duration of shimmer animation back and forth, default is 1.5 seconds.
 闪光灯动画来回的时长，默认是1.5秒
 */
@property (nonatomic,assign) CGFloat animatedDurationShimmer;

#pragma mark - Drop Animation Property

/**
 豆瓣动画帧时长，默认值为0.4，你可以理解为`变色速度`
 */
@property (nonatomic,assign) CGFloat dropAnimationDuration;

/**
 豆瓣动画变色值
 */
@property (nonatomic,strong) UIColor *dropAnimationDeepColor;

/**
 SingleTon

 @return return object
 */
+ (TABAnimated *)sharedAnimated;

/**
 only skeleton
 */
- (void)initWithOnlySkeleton;

/**
 bin animation
 */
- (void)initWithBinAnimation;

/**
 shimmer animation
 */
- (void)initWithShimmerAnimated;

/**
 shimmer Animation
 
 @param duration back and forth
 @param color backgroundcolor
 */
- (void)initWithShimmerAnimatedDuration:(CGFloat)duration
                              withColor:(UIColor *)color;

/**
 drop Animation
 */
- (void)initWithDropAnimated;

@end
