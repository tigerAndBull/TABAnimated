//
//  UIView+TABControllerAnimation.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/1/17.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import "UIView+TABControlAnimation.h"
#import "UIView+Animated.h"
#import "TABManagerMethod.h"

@implementation UIView (TABControlAnimation)

- (void)tab_startAnimation {
    self.isAnimating = YES;
    self.animatedStyle = TABViewAnimationStart;
}

- (void)tab_endAnimation {
    self.animatedStyle = TABViewAnimationEnd;
    self.isAnimating = NO;
    if ([self isKindOfClass:[UITableView class]]) {
        [(UITableView *)self reloadData];
    }else {
        if ([self isKindOfClass:[UICollectionView class]]) {
            [(UICollectionView *)self reloadData];
        }else {
            [self layoutSubviews];
        }
    }
}

@end
