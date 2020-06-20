//
//  UIScrollView+TABCategory.h
//  TABKit
//
//  Created by tigerAndBull on 2019/2/15.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Category for `UIScrollView`.
 */
@interface UIScrollView (TABCategory)

/**
 Scroll content to top with animation.
 */
- (void)scrollToTop;

/**
 Scroll content to top.

 @param animated    show animation or not
 */
- (void)scrollToTopAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
