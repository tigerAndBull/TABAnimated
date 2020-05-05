//
//  TABShimmerAnimationImpl.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/4/20.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TABAnimatedDecorateInterface, TABAnimatedDarkModeInterface;

@interface TABShimmerAnimationImpl : NSObject <TABAnimatedDecorateInterface, TABAnimatedDarkModeInterface>

@end

NS_ASSUME_NONNULL_END
