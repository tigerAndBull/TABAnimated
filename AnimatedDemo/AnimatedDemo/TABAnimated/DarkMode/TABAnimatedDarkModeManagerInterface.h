//
//  TABAnimatedDarkModeManagerInterface.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/4/7.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#ifndef TABAnimatedDarkModeManagerInterface_h
#define TABAnimatedDarkModeManagerInterface_h

@protocol TABAnimatedDarkModeManagerInterface <NSObject>

- (void)setControlView:(UIView *)controlView;

- (void)addDarkModelSentryView;

- (void)addNeedChangeView:(UIView *)view;

- (void)destroy;

@end

#endif /* TABAnimatedDarkModeManagerInterface_h */
