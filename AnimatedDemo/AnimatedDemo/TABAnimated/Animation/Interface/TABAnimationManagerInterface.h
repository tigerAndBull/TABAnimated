//
//  TABAnimationManagerInterface.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/5/17.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#ifndef TABAnimationManagerInterface_h
#define TABAnimationManagerInterface_h

@protocol TABAnimationManagerInterface <NSObject>

- (void)setControlView:(UIView *)controlView;
- (void)addAnimation;

@end

#endif /* TABAnimationManagerInterface_h */
