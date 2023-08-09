//
//  TABDropAnimationImpl.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/4/20.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TABDropAnimation;
@protocol TABAnimatedDecorateInterface, TABAnimatedDarkModeInterface;

@interface TABDropAnimationImpl : NSObject <TABAnimatedDecorateInterface, TABAnimatedDarkModeInterface>

@property (nonatomic, strong) TABDropAnimation *dropAnimation;

+ (instancetype)dropWithAnimation:(TABDropAnimation *)dropAnimation;
- (instancetype)initWithAnimation:(TABDropAnimation *)dropAnimation;

@end

NS_ASSUME_NONNULL_END
