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
    TABAnimationTypeDefault = 0,     // default animation for all views in your project.
    TABAnimationTypeShimmer,         // shimmer animation for all views in your project.
    TABAnimationTypeOnlySkeleton,    // onlySkeleton for all views in your project.
    TABAnimationTypeCustom           // you can select one among the three types mentioned above for the superView.
};

@interface TABViewAnimated : NSObject

@property (nonatomic) TABAnimationType animationType;

@property (nonatomic) CGFloat animatedDuration;                    // TABAnimationTypeDefault: default is 0.4
@property (nonatomic) CGFloat animatedDurationShimmer;             // TABAnimationTypeShimmer: default is 1.5

@property (nonatomic,strong) UIColor *animatedColor;               // default is 0xEEEEEE. the backgroundcolor of your animations.
@property (nonatomic) CGFloat longToValue;                         // toValue for LongAnimation
@property (nonatomic) CGFloat shortToValue;                        // toValue for ShortAnimation

/**
 SingleTon

 @return return object
 */
+ (TABViewAnimated *)sharedAnimated;

/**
 start/end animatiqons to UIView.

 @param view to the UIView
 */
- (void)startOrEndViewAnimated:(UIView *)view;

/**
 start/end animations to UITableView.
 
 @param cell to UITableViewCell
 */
- (void)startOrEndTableAnimated:(UITableViewCell *)cell;

/**
 start/end animations to UICollectionView.
 
 @param cell to UICollectionViewCell.
 */
- (void)startOrEndCollectionAnimated:(UICollectionViewCell *)cell;

#pragma mark - Default Animation

/**
 shimmer Animation
 
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
