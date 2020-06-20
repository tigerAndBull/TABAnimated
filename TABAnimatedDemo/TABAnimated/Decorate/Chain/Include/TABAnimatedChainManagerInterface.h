//
//  TABAnimatedChainManagerInterface.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/5/17.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#ifndef TABAnimatedChainManagerInterface_h
#define TABAnimatedChainManagerInterface_h

#import "TABAnimatedChainDefines.h"

@class TABComponentLayer;

@protocol TABAnimatedChainManagerInterface <NSObject>

- (void)chainAdjustWithArray:(NSMutableArray <TABComponentLayer *> *)array
                 adjustBlock:(TABAdjustBlock)adjustBlock;

- (void)chainAdjustWithArray:(NSMutableArray <TABComponentLayer *> *)array
        adjustWithClassBlock:(TABAdjustWithClassBlock)adjustWithClassBlock
                 targetClass:(Class)targetClass;

@end

#endif /* TABAnimatedChainManagerInterface_h */
