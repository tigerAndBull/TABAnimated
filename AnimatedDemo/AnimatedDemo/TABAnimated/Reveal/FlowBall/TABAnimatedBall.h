//
//  TABAnimatedBall.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/9/7.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TABRevealFlowBall.h"

NS_ASSUME_NONNULL_BEGIN

@interface TABAnimatedBall : NSObject

@property (nonatomic, strong) TABRevealFlowBall *flowBall;

- (void)install;

/**
 单例模式
 
 @return return object
 */
+ (TABAnimatedBall *)shared;

@end

NS_ASSUME_NONNULL_END
