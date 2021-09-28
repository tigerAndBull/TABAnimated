//
//  UIView+TABControllerAnimation.m
//  TABAnimatedDemo
//
//  Created by tigerAndBull on 2019/1/17.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import "UIView+TABControlAnimation.h"

#import "UIView+TABControlModel.h"
#import "UIView+TABAnimatedProduction.h"

#import "TABComponentLayer.h"
#import "TABAnimationMethod.h"

#import "TABFormAnimated.h"
#import "TABTableAnimated.h"

#import "TABAnimatedProduction.h"

#import "TABAnimatedPullLoadingComponent.h"
#import "TABAnimatedProductHelper.h"

#ifdef DEBUG
static const NSTimeInterval kDelayReloadDataTime = 1;
#else
static const NSTimeInterval kDelayReloadDataTime = .25;
#endif

const int TABAnimatedIndexTag = -100000;

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

#pragma mark - Only TABViewAnimated

- (void)tab_startAnimationWithConfigBlock:(nullable TABConfigBlock)configBlock
                              adjustBlock:(nullable TABAdjustBlock)adjustBlock
                               completion:(nullable void (^)(void))completion {
    if (!self.tabAnimated) {
        TABViewAnimated *tabAnimated = TABViewAnimated.new;
        tabAnimated.adjustBlock = adjustBlock;
        self.tabAnimated = tabAnimated;
    }
    
    if (configBlock && !self.tabAnimated.configed) {
        configBlock(self.tabAnimated);
        self.tabAnimated.configed = YES;
    }
    
    [self _startAnimationWithIndex:TABAnimatedIndexTag delayTime:kDelayReloadDataTime completion:completion];
}

- (void)_startAnimationWithIndex:(NSInteger)index
                       delayTime:(CGFloat)delayTime
                      completion:(void (^)(void))completion {
    
    TABViewAnimated *tabAnimated = self.tabAnimated;
    
    if (tabAnimated == nil || tabAnimated.isAnimating) return;
    
    if (tabAnimated.state == TABViewAnimationEnd && !tabAnimated.canLoadAgain) {
        if (completion) completion();
        return;
    }
    
    BOOL isFirstLoad = YES;
    if (tabAnimated.canLoadAgain) {
        if (tabAnimated.state == TABViewAnimationEnd) {
            isFirstLoad = NO;
        }else if (index != TABAnimatedIndexTag && [tabAnimated isKindOfClass:[TABFormAnimated class]]) {
            TABFormAnimated *formAnimated = (TABFormAnimated *)tabAnimated;
            if (![formAnimated getIndexIsRuning:index]) isFirstLoad = NO;
        }
    }
    
    tabAnimated.state = TABViewAnimationStart;
    
    if (tabAnimated.targetControllerClassName == nil || tabAnimated.targetControllerClassName.length == 0) {
        NSString *prefixString;
        if ([tabAnimated isKindOfClass:[TABFormAnimated class]]) {
            NSObject *oldDelegate;
            NSObject *oldDataSource;
            if ([self isKindOfClass:[UITableView class]]) {
                oldDelegate = ((UITableView *)self).delegate;
                oldDataSource = ((UITableView *)self).dataSource;
            } else if ([self isKindOfClass:[UICollectionView class]]) {
                oldDelegate = ((UICollectionView *)self).delegate;
                oldDataSource = ((UICollectionView *)self).dataSource;
            }
            prefixString = [NSString stringWithFormat:@"%@_%@", NSStringFromClass(oldDelegate.class), NSStringFromClass(oldDataSource.class)];
        }
        tabAnimated.targetControllerClassName = [self _getKeyWithPrefixString:prefixString];
    }
    
    if ([tabAnimated isKindOfClass:[TABFormAnimated class]]) {
        TABFormAnimated *tabAnimated = (TABFormAnimated *)self.tabAnimated;
        UIScrollView *scrollView = (UIScrollView *)self;
        if (!tabAnimated.scrollEnabled) {
            tabAnimated.oldScrollEnabled = scrollView.scrollEnabled;
            scrollView.scrollEnabled = tabAnimated.scrollEnabled;
        }
        [tabAnimated startAnimationWithIndex:index isFirstLoad:isFirstLoad controlView:self];
    }else {
        [self _startViewAnimationWithIsFirstLoad:isFirstLoad];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*delayTime), dispatch_get_main_queue(), ^{
        if (completion) completion();
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

- (void)tab_endAnimationWithIndex:(NSInteger)index isEaseOut:(BOOL)isEaseOut {
    
    TABViewAnimated *viewAnimated = self.tabAnimated;
    if (viewAnimated.state == TABViewAnimationDefault ||
        viewAnimated.state == TABViewAnimationEnd) return;

    
    if (index == TABAnimatedIndexTag && ![viewAnimated isKindOfClass:[TABFormAnimated class]]) {
        [self _endViewAnimation];
        if (isEaseOut) [TABAnimationMethod addEaseOutAnimation:self];
        return;
    }
    
    BOOL isNeedReset = NO;
    if (index == TABAnimatedIndexTag) isNeedReset = YES;
    
    if ([viewAnimated isKindOfClass:[TABFormAnimated class]]) {
        
        TABFormAnimated *tabAnimated = (TABFormAnimated *)viewAnimated;
        
        UIScrollView *scrollView = (UIScrollView *)self;
        if (!tabAnimated.scrollEnabled) {
            scrollView.scrollEnabled = tabAnimated.oldScrollEnabled;
        }
        
        if ([self isKindOfClass:[UITableView class]]) {
            if (isNeedReset) {
                [tabAnimated endAnimation];
                UITableView *tableView = (UITableView *)self;
                if (((TABTableAnimated *)tabAnimated).oldEstimatedRowHeight > 0) {
                    tableView.estimatedRowHeight = ((TABTableAnimated *)tabAnimated).oldEstimatedRowHeight;
                    tableView.rowHeight = UITableViewAutomaticDimension;
                }
                [tableView reloadData];
                if (tableView.tableHeaderView.tabAnimated != nil && ((TABTableAnimated *)tabAnimated).showTableHeaderView) {
                    [tableView.tableHeaderView tab_endAnimation];
                }
                if (tableView.tableHeaderView.tabAnimated != nil && ((TABTableAnimated *)tabAnimated).showTableFooterView) {
                    [tableView.tableFooterView tab_endAnimation];
                }
            }else {
                if (![tabAnimated endAnimationWithIndex:index]) return;
                if (tabAnimated.runMode == TABAnimatedRunBySection || tabAnimated.runMode == TABAnimatedRunByPartSection) {
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
                if (tabAnimated.runMode == TABAnimatedRunBySection || tabAnimated.runMode == TABAnimatedRunByPartSection) {
                    [(UICollectionView *)self reloadSections:[NSIndexSet indexSetWithIndex:index]];
                }else {
                    [(UICollectionView *)self reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
                }
            }
        }
    }else {
        [self _endViewAnimation];
    }
    
    if (isEaseOut) [TABAnimationMethod addEaseOutAnimation:self];
}

- (void)_endViewAnimation {
    self.tabAnimated.state = TABViewAnimationEnd;
    self.tabAnimatedProduction.backgroundLayer.hidden = YES;
}

#pragma mark -

- (void)tab_penperateSkeletonWithIndex:(NSInteger)index {
    [self tab_penperateSkeletonWithIndexArray:@[@(index)]];
}

- (void)tab_penperateSkeletonWithIndexArray:(NSArray <NSNumber *> *)indexArray {
    if (!self.tabAnimated || !self.tabAnimatedProduction || self.tabAnimated.state != TABViewAnimationRunning) {
        return;
    }
    [TABAnimatedProductHelper penerateIndexArray:indexArray production:self.tabAnimatedProduction];
}

#pragma mark -

- (void)tab_startAnimationWithSection:(NSInteger)section {
    [self tab_startAnimationWithIndex:section];
}

- (void)tab_startAnimationWithSection:(NSInteger)section completion:(void (^)(void))completion {
    [self tab_startAnimationWithIndex:section completion:completion];
}

- (void)tab_startAnimationWithSection:(NSInteger)section delayTime:(CGFloat)delayTime completion:(void (^)(void))completion {
    [self tab_startAnimationWithIndex:section delayTime:delayTime completion:completion];
}

- (void)tab_endAnimationWithSection:(NSInteger)section {
    [self tab_endAnimationWithIndex:section];
}

- (void)tab_startAnimationWithRow:(NSInteger)row {
    [self tab_startAnimationWithIndex:row];
}

- (void)tab_startAnimationWithRow:(NSInteger)row completion:(void (^)(void))completion {
    [self tab_startAnimationWithIndex:row completion:completion];
}

- (void)tab_startAnimationWithRow:(NSInteger)row delayTime:(CGFloat)delayTime completion:(void (^)(void))completion {
    [self tab_startAnimationWithIndex:row delayTime:delayTime completion:completion];
}

- (void)tab_endAnimationWithRow:(NSInteger)row {
    [self tab_endAnimationWithIndex:row];
}

#pragma mark - Private

- (NSString *)_getKeyWithPrefixString:(NSString *)prefixString {
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            if (prefixString.length) {
                return [NSString stringWithFormat:@"%@_%@", prefixString, NSStringFromClass(nextResponder.class)];
            }
            return NSStringFromClass(nextResponder.class);
        }
    }
    
    if (prefixString.length) {
        return prefixString;
    }
    
    return nil;
}

@end
