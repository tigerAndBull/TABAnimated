//
//  TABBaseComponent+TABClassicAnimation.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/5/24.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TABBaseComponent.h"
#import "TABAnimatedChainDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface TABBaseComponent (TABClassicAnimation)

/**
 赋予动画元素画由长到短的动画
 
 @return 目标动画元素
 */
- (TABBaseComponentVoidBlock)toLongAnimation;

/**
 赋予动画元素画由短到长的动画
 
 @return 目标动画元素
 */
- (TABBaseComponentVoidBlock)toShortAnimation;

@end

NS_ASSUME_NONNULL_END
