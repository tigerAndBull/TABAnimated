//
//  TABAnimatedDarkModeInterface.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/5/5.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#ifndef TABAnimatedDarkModeInterface_h
#define TABAnimatedDarkModeInterface_h

@class TABViewAnimated, TABComponentLayer;

@protocol TABAnimatedDarkModeInterface <NSObject>

/// 暗黑模式转化协议主体，开发者可重写
/// TABAnimatedDarkModeImpl是该协议默认的实现，根据traitCollection、tabAnimated自动转化backgroundLayer、layers的属性
/// @param traitCollection 当前的traitCollection
/// @param tabAnimated 目标tabAnimated
/// @param backgroundLayer 目标背景layer
/// @param layers 目标layers
- (void)traitCollectionDidChange:(UITraitCollection *)traitCollection
                     tabAnimated:(TABViewAnimated *)tabAnimated
                 backgroundLayer:(TABComponentLayer *)backgroundLayer
                          layers:(NSArray <TABComponentLayer *> *)layers;

@end

#endif /* TABAnimatedDarkModeInterface_h */
