//
//  UITableView+TABControlAnimation.m
//  TABAnimatedDemo
//
//  Created by wenhuan on 2021/5/23.
//  Copyright © 2021 tigerAndBull. All rights reserved.
//

#import "UITableView+TABControlAnimation.h"
#import "TABTableAnimated.h"
#import "UIView+TABControlModel.h"
#import "UIView+TABControlAnimation.h"

@implementation UITableView (TABControlAnimation)

- (void)tab_startAnimationWithConfigBlock:(nullable TABTableViewConfigBlock)configBlock
                              adjustBlock:(nullable TABAdjustBlock)adjustBlock
                               completion:(nullable void (^)(void))completion {
    if (!self.tabAnimated) {
        TABTableAnimated *tabAnimated = TABTableAnimated.new;
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
