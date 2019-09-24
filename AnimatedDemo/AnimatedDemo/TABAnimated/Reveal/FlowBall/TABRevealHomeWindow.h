//
//  TABRevealHomeWindow.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/9/7.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define tab_revealScreenWidth [UIScreen mainScreen].bounds.size.width
#define tab_revealScreenHeight [UIScreen mainScreen].bounds.size.height

@interface TABRevealHomeWindow : UIWindow

@property (nonatomic, strong) UINavigationController *nav;

+ (TABRevealHomeWindow *)shared;

- (void)show;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
