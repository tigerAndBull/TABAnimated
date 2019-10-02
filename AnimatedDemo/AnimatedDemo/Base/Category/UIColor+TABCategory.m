//
//  UIColor+TABCategory.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/10/1.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "UIColor+TABCategory.h"

@implementation UIColor (TABCategory)

+ (UIColor *)tab_getColorWithLightColor:(UIColor *)lightColor
                              darkColor:(UIColor * _Nullable)darkColor {
    if (@available(iOS 13.0, *)) {
        return [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return darkColor;
            }else {
                return lightColor;
            }
        }];
    } else {
        return lightColor;
    }
}

+ (UIColor *)tab_normalDynamicBackgroundColor {
    if (@available(iOS 13.0, *)) {
        return [UIColor tab_getColorWithLightColor:UIColor.whiteColor
                                         darkColor:UIColor.systemBackgroundColor];
        
    }else {
        return [UIColor tab_getColorWithLightColor:UIColor.whiteColor
                                         darkColor:nil];
    }
}

+ (UIColor *)tab_cardDynamicBackgroundColor {
    if (@available(iOS 13.0, *)) {
        return [UIColor tab_getColorWithLightColor:UIColor.whiteColor
                                         darkColor:UIColor.secondarySystemBackgroundColor];
        
    }else {
        return [UIColor tab_getColorWithLightColor:UIColor.whiteColor
                                         darkColor:nil];
    }
}

@end
