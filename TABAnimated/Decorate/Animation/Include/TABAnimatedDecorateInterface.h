//
//  TABAnimatedDecorateInterface.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/4/6.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#ifndef TABAnimatedDecorateInterface_h
#define TABAnimatedDecorateInterface_h

@class TABAnimatedProduction, TABComponentLayer;

@protocol TABAnimatedDecorateInterface <NSObject>

@optional

// layer装饰期
- (void)addAnimationWithTraitCollection:(UITraitCollection *)traitCollection
                        backgroundLayer:(TABComponentLayer *)backgroundLayer
                                 layers:(NSArray <TABComponentLayer *> *)layers;

// 骨架结束，释放
- (void)destory;

@end

#endif /* TABAnimatedDecorateInterface_h */
