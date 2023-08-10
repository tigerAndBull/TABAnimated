//
//  UITableView+TABControlAnimation.h
//  TABAnimatedDemo
//
//  Created by wenhuan on 2021/5/23.
//  Copyright © 2021 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+TABControlAnimation.h"

NS_ASSUME_NONNULL_BEGIN

@class TABTableAnimated;

typedef void(^TABTableViewConfigBlock)(TABTableAnimated * _Nonnull tabAnimated);

@interface UITableView (TABControlAnimation)

- (void)tab_startAnimationWithConfigBlock:(nullable TABTableViewConfigBlock)configBlock
                              adjustBlock:(nullable TABAdjustBlock)adjustBlock
                               completion:(nullable void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
