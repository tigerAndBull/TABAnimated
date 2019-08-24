//
//  UICollectionViewCell+Animated.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/10/12.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "UICollectionViewCell+TABLayoutSubviews.h"

#import "UIView+TABAnimated.h"
#import "TABCollectionAnimated.h"
#import "TABManagerMethod.h"

#import <objc/runtime.h>

@implementation UICollectionViewCell (TABLayoutSubviews)

+ (void)load {

    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        Method originMethod = class_getInstanceMethod([self class], @selector(layoutSubviews));
        Method newMethod = class_getInstanceMethod([self class], @selector(tab_collection_layoutSubviews));
        method_exchangeImplementations(originMethod, newMethod);
    });
}

#pragma mark - Exchange Method

- (void)tab_collection_layoutSubviews {
    [self tab_collection_layoutSubviews];

    dispatch_async(dispatch_get_main_queue(), ^{

        // 获取控制视图
        UICollectionView *superView = (UICollectionView *)self.superview;

        if (superView == nil ||
            ![superView isKindOfClass:[UICollectionView class]] ||
            superView.tabAnimated == nil ||
            !self.tabComponentManager) {
            return;
        }
        
        // 获取当前所在indexPath
        NSIndexPath *indexPath = [superView indexPathForCell:self];
        
        // 加载动画
        [TABManagerMethod runAnimationWithSuperView:superView
                                         targetView:self
                                            section:indexPath.section
                                             isCell:YES
                                            manager:self.tabComponentManager];
    });
}

@end
