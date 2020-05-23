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

- (void)traitCollectionDidChange:(UITraitCollection *)traitCollection
                     tabAnimated:(TABViewAnimated *)tabAnimated
                 backgroundLayer:(TABComponentLayer *)backgroundLayer
                          layers:(NSArray <TABComponentLayer *> *)layers;

@end

#endif /* TABAnimatedDarkModeInterface_h */
