//
//  TABAnimatedChainManagerImpl.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/5/17.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "TABAnimatedChainManagerImpl.h"
#import "TABComponentLayer.h"
#import "TABComponentManager.h"

@implementation TABAnimatedChainManagerImpl

- (void)chainAdjustWithBackgroundLayer:(TABComponentLayer *)backgroundLayer
                                layers:(NSMutableArray <TABComponentLayer *> *)layers
                           adjustBlock:(TABAdjustBlock)adjustBlock
                         animatedColor:(UIColor *)animatedColor {
    TABComponentManager *manager = [TABComponentManager managerWithBackgroundLayer:backgroundLayer layers:layers animatedColor:animatedColor];
    if (adjustBlock) {
        adjustBlock(manager);
    }
}

- (void)chainAdjustWithBackgroundLayer:(TABComponentLayer *)backgroundLayer
                                layers:(NSMutableArray <TABComponentLayer *> *)layers
                  adjustWithClassBlock:(TABAdjustWithClassBlock)adjustWithClassBlock
                           targetClass:(Class)targetClass
                         animatedColor:(UIColor *)animatedColor {
    TABComponentManager *manager = [TABComponentManager managerWithBackgroundLayer:backgroundLayer layers:layers animatedColor:animatedColor];
    if (adjustWithClassBlock) {
        adjustWithClassBlock(manager, targetClass);
    }
}

- (void)destory {}

@end
