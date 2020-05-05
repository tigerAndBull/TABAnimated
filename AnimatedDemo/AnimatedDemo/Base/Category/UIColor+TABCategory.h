//
//  UIColor+TABCategory.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/10/1.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (TABCategory)

+ (UIColor *)tab_normalDynamicBackgroundColor;

+ (UIColor *)tab_cardDynamicBackgroundColor;

+ (UIColor *)tab_getColorWithLightColor:(UIColor *)lightColor
                              darkColor:(UIColor * _Nullable)darkColor;

@end

NS_ASSUME_NONNULL_END
