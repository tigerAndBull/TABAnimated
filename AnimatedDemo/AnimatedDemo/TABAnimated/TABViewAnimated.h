//
//  TABViewAnimated.h
//  lifeAndSport
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "UIView+Animated.h"

#define tab_kColor(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0]
#define tab_kBackColor tab_kColor(0xEEEEEEFF)

typedef NS_ENUM(NSInteger,TABAnimationType) {
    TABAnimationTypeDefault = 0,     // default animation for all registered views in your project.
    TABAnimationTypeShimmer,         // shimmer animation for all views in your project.
    TABAnimationTypeOnlySkeleton,    // onlySkeleton for all views in your project.
    TABAnimationTypeCustom,          // you can select one among the three types mentioned above for the superView.
};

@interface TABViewAnimated : NSObject

@property (nonatomic,assign) TABAnimationType animationType;

@property (nonatomic,assign) BOOL isUseTemplate;

@property (nonatomic,assign) CGFloat animatedDuration;           // TABAnimationTypeDefault: default is 0.6
@property (nonatomic,assign) CGFloat animatedDurationShimmer;    // TABAnimationTypeShimmer: default is 1.5

@property (nonatomic,strong) UIColor *animatedColor;             // default is 0xEEEEEE. the backgroundcolor of your animations.
@property (nonatomic,assign) CGFloat longToValue;                // toValue for LongAnimation in TABAnimationTypeDefault.
@property (nonatomic,assign) CGFloat shortToValue;               // toValue for ShortAnimation in TABAnimationTypeDefault.

@property (nonatomic,assign) CGFloat animatedHeightCoefficient;  // compare to old view's height. default is 0.75. Don't adapt to UIImageView.

// In most cases, when we layout the UI, we need to give the default text property of `UIlabel` to see the effect.
// If this property is set to YES, when the animation is started, the text property of `UIlabel` is set to @"“.
// 大多数情况下，我们在布局UI的时候，都需要给UILabel的text属性一个默认值，以便查看效果。
// 如果设置这个属性为YES，动画开启时，将所有控件的text属性置为@""，默认为NO。
@property (nonatomic,assign) BOOL isRemoveLabelText;

// Use to `UIButton` similar to isRemoveLabelText.
@property (nonatomic,assign) BOOL isRemoveButtonTitle;

// Use to `UIImageView` similar to isRemoveLabelText. set image = nil
@property (nonatomic,assign) BOOL isRemoveImageViewImage;


/**
 SingleTon

 @return return object
 */
+ (TABViewAnimated *)sharedAnimated;


#pragma mark - Default Animation

/**
 default Animation
 
 */
- (void)initWithDefaultAnimated;

/**
 set animation duration and backgroundcolor.

 @param duration back and forth
 @param color backgroundcolor
 */
- (void)initWithAnimatedDuration:(CGFloat)duration
                       withColor:(UIColor *)color;

/**
to set toValue

 @param duration back and forth
 @param color backgroundcolor
 @param longToValue toValue for LongAnimation
 @param shortToValue toValue for ShortAnimation
 */
- (void)initWithAnimatedDuration:(CGFloat)duration
                       withColor:(UIColor *)color
                 withLongToValue:(CGFloat)longToValue
                withShortToValue:(CGFloat)shortToValue;

#pragma mark - Shimmer Animation

/**
 shimmer Animation

 */
- (void)initWithShimmerAnimated;

/**
 shimmer Animation
 
 @param duration back and forth
 @param color backgroundcolor
 */
- (void)initWithShimmerAnimatedDuration:(CGFloat)duration
                              withColor:(UIColor *)color;

#pragma mark - OnlySkeleton

- (void)initWithOnlySkeleton;

#pragma mark - Custom Animation

- (void)initWithCustomAnimation;

- (void)initWithDefaultDurationAnimation:(CGFloat)defaultAnimationDuration
                         withLongToValue:(CGFloat)longToValue
                        withShortToValue:(CGFloat)shortToValue
            withShimmerAnimationDuration:(CGFloat)shimmerAnimationDuration
                               withColor:(UIColor *)color;

@end
