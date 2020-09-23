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

- (void)chainAdjustWithArray:(NSMutableArray <TABComponentLayer *> *)array
                 adjustBlock:(TABAdjustBlock)adjustBlock
               animatedColor:(UIColor *)animatedColor {
    TABComponentManager *manager = [TABComponentManager managerWithLayers:array animatedColor:animatedColor];
    if (adjustBlock) {
        adjustBlock(manager);
    }
}

- (void)chainAdjustWithArray:(NSMutableArray <TABComponentLayer *> *)array
        adjustWithClassBlock:(TABAdjustWithClassBlock)adjustWithClassBlock
                 targetClass:(Class)targetClass
               animatedColor:(UIColor *)animatedColor {
    TABComponentManager *manager = [TABComponentManager managerWithLayers:array animatedColor:animatedColor];
    if (adjustWithClassBlock) {
        adjustWithClassBlock(manager, targetClass);
    }
}

- (void)destory {
}

@end
