//
//  UICollectionView+TABControlAnimation.m
//  TABAnimatedDemo
//
//  Created by wenhuan on 2021/6/6.
//  Copyright © 2021 tigerAndBull. All rights reserved.
//

#import "UICollectionView+TABControlAnimation.h"
#import "TABCollectionAnimated.h"
#import "UIView+TABControlModel.h"
#import "UIView+TABControlAnimation.h"

@implementation UICollectionView (TABControlAnimation)

- (void)tab_startAnimationWithConfigBlock:(nullable TABCollectionViewConfigBlock)configBlock
                              adjustBlock:(nullable TABAdjustBlock)adjustBlock
                               completion:(nullable void (^)(void))completion {
    if (!self.tabAnimated) {
        TABCollectionAnimated *tabAnimated = TABCollectionAnimated.new;
        tabAnimated.adjustBlock = adjustBlock;
        self.tabAnimated = tabAnimated;
    }
    
    if (configBlock && !self.tabAnimated.configed) {
        configBlock(self.tabAnimated);
        self.tabAnimated.configed = YES;
    }
    
    [self tab_startAnimation];
}

@end
