//
//  UICollectionView+TABControlAnimation.h
//  TABAnimatedDemo
//
//  Created by wenhuan on 2021/6/6.
//  Copyright © 2021 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+TABControlAnimation.h"

NS_ASSUME_NONNULL_BEGIN

@class TABCollectionAnimated;

typedef void(^TABCollectionViewConfigBlock)(TABCollectionAnimated * _Nonnull tabAnimated);

@interface UICollectionView (TABControlAnimation)

- (void)tab_startAnimationWithConfigBlock:(nullable TABCollectionViewConfigBlock)configBlock
                              adjustBlock:(nullable TABAdjustBlock)adjustBlock
                               completion:(nullable void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
