//
//  UIView+TABControllerAnimation.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/1/17.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import "UIView+TABControlAnimation.h"

#import "TABAnimatedConfig.h"
#import "TABAnimatedCacheManager.h"
#import "TABComponentLayer.h"

static const NSTimeInterval kDelayReloadDataTime = 40;
const int TABAnimatedIndexTag = -1000;

@implementation UIView (TABControlAnimation)

#pragma mark - 启动动画

- (void)tab_startAnimation {
    [self _startAnimationWithIndex:TABAnimatedIndexTag delayTime:kDelayReloadDataTime completion:nil];
}

- (void)tab_startAnimationWithCompletion:(void (^)(void))completion {
    [self _startAnimationWithIndex:TABAnimatedIndexTag delayTime:kDelayReloadDataTime completion:completion];
}

- (void)tab_startAnimationWithDelayTime:(CGFloat)delayTime
                             completion:(void (^)(void))completion {
    [self _startAnimationWithIndex:TABAnimatedIndexTag delayTime:delayTime completion:completion];
}

- (void)tab_startAnimationWithIndex:(NSInteger)index {
    [self _startAnimationWithIndex:index delayTime:kDelayReloadDataTime completion:nil];
}

- (void)tab_startAnimationWithIndex:(NSInteger)index
                           completion:(void (^)(void))completion {
    [self _startAnimationWithIndex:index delayTime:kDelayReloadDataTime completion:completion];
}

- (void)tab_startAnimationWithIndex:(NSInteger)index
                          delayTime:(CGFloat)delayTime
                         completion:(void (^)(void))completion {
    [self _startAnimationWithIndex:index delayTime:kDelayReloadDataTime completion:completion];
}

- (void)_startAnimationWithIndex:(NSInteger)index
                       delayTime:(CGFloat)delayTime
                      completion:(void (^)(void))completion {
    
    TABViewAnimated *tabAnimated = self.tabAnimated;
    if (tabAnimated == nil || (tabAnimated.state == TABViewAnimationEnd && !tabAnimated.canLoadAgain)) {
        if (completion) {
            completion();
        }
        return;
    }
    
    BOOL isFirstLoad = YES;
    if (tabAnimated.canLoadAgain && tabAnimated.state == TABViewAnimationEnd) {
        isFirstLoad = NO;
    }
    
    tabAnimated.isAnimating = YES;
    tabAnimated.state = TABViewAnimationStart;
    
    if (tabAnimated.targetControllerClassName == nil || tabAnimated.targetControllerClassName.length == 0) {
        UIViewController *controller = [self _viewController];
        if (controller) {
            tabAnimated.targetControllerClassName = NSStringFromClass(controller.class);
        }
    }
    
    if ([self isKindOfClass:[UITableView class]]) {
        [((TABTableAnimated *)tabAnimated) startAnimationWithIndex:index isFirstLoad:isFirstLoad controlView:self];
    }else if([self isKindOfClass:[UICollectionView class]]) {
        [((TABCollectionAnimated *)tabAnimated) startAnimationWithIndex:index isFirstLoad:isFirstLoad controlView:self];
    }else {
        [self _startViewAnimationWithIsFirstLoad:isFirstLoad];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*delayTime), dispatch_get_main_queue(), ^{
        if (completion) {
            completion();
        }
    });
}

- (void)_startViewAnimationWithIsFirstLoad:(BOOL)isFirstLoad {
    if (self.tabAnimatedProduction.backgroundLayer.hidden == YES) {
        self.tabAnimatedProduction.backgroundLayer.hidden = NO;
        return;
    }
    [self.tabAnimated.producter productWithView:self controlView:self currentClass:self.class indexPath:nil origin:TABAnimatedProductOriginView];
}

#pragma mark - 结束动画

- (void)tab_endAnimation {
    [self tab_endAnimationWithIndex:TABAnimatedIndexTag isEaseOut:NO];
}

- (void)tab_endAnimationEaseOut {
    [self tab_endAnimationWithIndex:TABAnimatedIndexTag isEaseOut:YES];
}

- (void)tab_endAnimationWithIndex:(NSInteger)index {
    [self tab_endAnimationWithIndex:index isEaseOut:YES];
}

- (void)tab_endAnimationWithIndex:(NSInteger)index
                        isEaseOut:(BOOL)isEaseOut {
    
    if (self.tabAnimated.state == TABViewAnimationEnd) return;
    
    if (index == TABAnimatedIndexTag &&
        (![self isKindOfClass:[UITableView class]] && ![self isKindOfClass:[UICollectionView class]])) {
        [self _endViewAnimation];
        return;
    }
    
    BOOL isNeedReset = NO;
    if (index == TABAnimatedIndexTag) {
        isNeedReset = YES;
    }
    
    TABFormAnimated *tabAnimated = (TABFormAnimated *)self.tabAnimated;
    
    if ([self isKindOfClass:[UITableView class]]) {
        if (isNeedReset) {
            [tabAnimated endAnimation];
            UITableView *tableView = (UITableView *)self;
            if (((TABTableAnimated *)tabAnimated).oldEstimatedRowHeight > 0) {
                tableView.estimatedRowHeight = ((TABTableAnimated *)tabAnimated).oldEstimatedRowHeight;
                tableView.rowHeight = UITableViewAutomaticDimension;
            }
            [tableView reloadData];
            if (tableView.tableHeaderView != nil && tableView.tableHeaderView.tabAnimated != nil) {
                [tableView.tableHeaderView tab_endAnimation];
            }
            if (tableView.tableFooterView != nil && tableView.tableFooterView.tabAnimated != nil) {
                [tableView.tableFooterView tab_endAnimation];
            }
        }else {
            [tabAnimated endAnimationWithIndex:index];
            if (tabAnimated.runMode == TABAnimatedRunBySection) {
                [(UITableView *)self reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
            }else {
                [(UITableView *)self reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }else if ([self isKindOfClass:[UICollectionView class]]) {
        if (isNeedReset) {
            [tabAnimated endAnimation];
            [(UICollectionView *)self reloadData];
        }else {
            [tabAnimated endAnimationWithIndex:index];
            if (tabAnimated.runMode == TABAnimatedRunBySection) {
                [(UICollectionView *)self reloadSections:[NSIndexSet indexSetWithIndex:index]];
            }else {
                [(UICollectionView *)self reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
            }
        }
    }else {
        [self _endViewAnimation];
    }
    
    if (isEaseOut) {
        [TABAnimationMethod addEaseOutAnimation:self];
    }
}

- (void)_endViewAnimation {
    self.tabAnimated.state = TABViewAnimationEnd;
    self.tabAnimatedProduction.backgroundLayer.hidden = YES;
}

#pragma mark - Private Method

- (UIViewController*)_viewController {
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
