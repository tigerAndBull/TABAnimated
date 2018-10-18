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

@interface TABViewAnimated : NSObject

@property (nonatomic) CGFloat animatedDuration;             // default is 0.4. the duartion of your animations.
@property (nonatomic,strong) UIColor *animatedColor;          // default is 0xEEEEEE. the backgroundcolor of your animations.
@property (nonatomic,strong) NSMutableArray *superArray;         // keep superViews'addresses.

/**
 SingleTon

 @return return object
 */
+ (TABViewAnimated *)sharedAnimated;

/**
 start/end animations to UIView.
 
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

/**
 set animation duration and backgroundcolor.

 @param duration of back and forth
 @param color backgroundcolor
 */
- (void)initWithAnimatedDuration:(CGFloat)duration withColor:(UIColor *)color;

@end
