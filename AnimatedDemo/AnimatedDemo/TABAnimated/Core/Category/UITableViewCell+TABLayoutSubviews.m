//
//  UITableViewCell+Animated.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/9/21.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "UITableViewCell+TABLayoutSubviews.h"

#import "UIView+TABAnimated.h"
#import "TABTableAnimated.h"
#import "TABManagerMethod.h"
#import "TABComponentManager.h"

#import <objc/runtime.h>

@implementation UITableViewCell (TABLayoutSubviews)

+ (void)load {

    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        Method originMethod = class_getInstanceMethod([self class], @selector(layoutSubviews));
        Method newMethod = class_getInstanceMethod([self class], @selector(tab_cell_layoutSubviews));
        method_exchangeImplementations(originMethod, newMethod);
    });
}

#pragma mark - Exchange Method

- (void)tab_cell_layoutSubviews {
    [self tab_cell_layoutSubviews];

    // start/end animation.
    dispatch_async(dispatch_get_main_queue(), ^{

        // 获取控制视图
        UITableView *superView;
        
        // 适配不同版本的视图层级
        if ([[[self superview] superview] isKindOfClass:[UITableView class]]) {
            superView = (UITableView *)self.superview.superview;
        }else {
            superView = (UITableView *)self.superview;
        }
        
        if (superView == nil ||
            ![superView isKindOfClass:[UITableView class]] ||
            superView.tabAnimated == nil ||
            !self.tabComponentManager) {
            return;
        }
        
        // 当UITableView使用自适应高度属性时，需要重新设置骨架屏背景层的frame
        TABTableAnimated *tabAnimated = (TABTableAnimated *)superView.tabAnimated;
        if (tabAnimated.oldEstimatedRowHeight > 0.) {
            self.tabComponentManager.tabLayer.frame = self.bounds;
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
