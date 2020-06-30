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
                 adjustBlock:(TABAdjustBlock)adjustBlock {
    TABComponentManager *manager = [TABComponentManager managerWithLayers:array];
    if (adjustBlock) {
        adjustBlock(manager);
    }
}

- (void)chainAdjustWithArray:(NSMutableArray <TABComponentLayer *> *)array
        adjustWithClassBlock:(TABAdjustWithClassBlock)adjustWithClassBlock
                 targetClass:(Class)targetClass {
    TABComponentManager *manager = [TABComponentManager managerWithLayers:array];
    if (adjustWithClassBlock) {
        adjustWithClassBlock(manager, targetClass);
    }
}

- (void)destory {
}

@end
