//
//  UIView+TABControllerAnimation.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/1/17.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import "UIView+TABControlAnimation.h"

#import "TABAnimated.h"
#import "TABManagerMethod.h"
#import "TABAnimatedCacheManager.h"
#import "TABAnimatedDocumentMethod.h"

#import <objc/runtime.h>

static const NSTimeInterval kDelayReloadDataTime = .4;

@implementation UIView (TABControlAnimation)

#pragma mark - 启动动画

- (void)tab_startAnimation {
    
    if (self.tabAnimated.state == TABViewAnimationEnd && !self.tabAnimated.canLoadAgain) {
        return;
    }
    
    self.tabAnimated.isAnimating = YES;
    self.tabAnimated.state = TABViewAnimationStart;
    
    [self startAnimationIsAll:YES index:0];
}

- (void)tab_startAnimationWithCompletion:(void (^)(void))completion {
    [self tab_startAnimationWithDelayTime:kDelayReloadDataTime
                               completion:completion];
}

- (void)tab_startAnimationWithDelayTime:(CGFloat)delayTime
                             completion:(void (^)(void))completion {
    
    if (!self.tabAnimated.canLoadAgain &&
        self.tabAnimated.state == TABViewAnimationEnd) {
        if (completion) {
            completion();
        }
        return;
    }
    
    self.tabAnimated.state = TABViewAnimationStart;
    
    if (!self.tabAnimated.isAnimating) {
        [self startAnimationIsAll:YES index:0];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*delayTime), dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    }
    
    self.tabAnimated.isAnimating = YES;
}

- (void)tab_startAnimationWithSection:(NSInteger)section {
    
    if (!self.tabAnimated.canLoadAgain &&
        self.tabAnimated.state == TABViewAnimationEnd) {
        return;
    }
    
    self.tabAnimated.isAnimating = YES;
    self.tabAnimated.state = TABViewAnimationStart;
    
    [self startAnimationIsAll:NO index:section];
}

- (void)tab_startAnimationWithSection:(NSInteger)section
                           completion:(void (^)(void))completion {
    [self tab_startAnimationWithSection:section
                              delayTime:kDelayReloadDataTime
                             completion:completion];
}

- (void)tab_startAnimationWithSection:(NSInteger)section
                            delayTime:(CGFloat)delayTime
                           completion:(void (^)(void))completion {
    if (!self.tabAnimated.canLoadAgain &&
        self.tabAnimated.state == TABViewAnimationEnd) {
        if (completion) {
            completion();
        }
        return;
    }
    
    self.tabAnimated.state = TABViewAnimationStart;
    
    if (!self.tabAnimated.isAnimating) {
        [self startAnimationIsAll:NO index:section];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*delayTime), dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    }
    
    self.tabAnimated.isAnimating = YES;
}

#pragma mark -

- (void)tab_startAnimationWithRow:(NSInteger)row {
    
    if (!self.tabAnimated.canLoadAgain &&
        self.tabAnimated.state == TABViewAnimationEnd) {
        return;
    }
    
    self.tabAnimated.isAnimating = YES;
    self.tabAnimated.state = TABViewAnimationStart;
    
    [self startAnimationIsAll:NO index:row];
}

- (void)tab_startAnimationWithRow:(NSInteger)row
                       completion:(void (^)(void))completion {
    [self tab_startAnimationWithRow:row
                          delayTime:kDelayReloadDataTime
                         completion:completion];
}

- (void)tab_startAnimationWithRow:(NSInteger)row
                        delayTime:(CGFloat)delayTime
                       completion:(void (^)(void))completion {
    if (!self.tabAnimated.canLoadAgain &&
        self.tabAnimated.state == TABViewAnimationEnd) {
        if (completion) {
            completion();
        }
        return;
    }
    
    self.tabAnimated.state = TABViewAnimationStart;
    
    if (!self.tabAnimated.isAnimating) {
        [self startAnimationIsAll:NO index:row];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*delayTime), dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    }
    
    self.tabAnimated.isAnimating = YES;
}

#pragma mark -

- (void)startAnimationIsAll:(BOOL)isAll
                      index:(NSInteger)index {
    
    if (self.tabAnimated.targetControllerClassName == nil ||
        self.tabAnimated.targetControllerClassName.length == 0) {
        UIViewController *controller = [self tab_viewController];
        if (controller) {
            self.tabAnimated.targetControllerClassName = NSStringFromClass(controller.class);
        }
    }
    
    if ([self isKindOfClass:[UICollectionView class]]) {
        
        UICollectionView *collectionView = (UICollectionView *)self;
        
        for (Class class in self.tabAnimated.cellClassArray) {
            
            NSString *classString = NSStringFromClass(class);
            if ([classString containsString:@"."]) {
                NSRange range = [classString rangeOfString:@"."];
                classString = [classString substringFromIndex:range.location+1];
            }
            
            NSString *nibPath = [[NSBundle mainBundle] pathForResource:classString ofType:@"nib"];
            if (nil != nibPath && nibPath.length > 0) {
                [collectionView registerNib:[UINib nibWithNibName:classString bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:[NSString stringWithFormat:@"tab_%@",classString]];
                [collectionView registerNib:[UINib nibWithNibName:classString bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:classString];
            }else {
                [collectionView registerClass:class forCellWithReuseIdentifier:[NSString stringWithFormat:@"tab_%@",classString]];
                [collectionView registerClass:class forCellWithReuseIdentifier:classString];
            }
        }
        
        TABCollectionAnimated *tabAnimated = (TABCollectionAnimated *)(collectionView.tabAnimated);
        [tabAnimated exchangeCollectionViewDelegate:collectionView];
        [tabAnimated exchangeCollectionViewDataSource:collectionView];
        
        if (tabAnimated.headerClassArray.count > 0) {
            [self registerHeaderOrFooter:YES tabAnimated:tabAnimated];
        }
        
        if (tabAnimated.footerClassArray.count > 0) {
            [self registerHeaderOrFooter:NO tabAnimated:tabAnimated];
        }

        [tabAnimated.runAnimationIndexArray removeAllObjects];
        
        if (isAll) {
            
            if (tabAnimated.animatedIndexArray.count > 0) {
                for (NSNumber *num in tabAnimated.animatedIndexArray) {
                    [tabAnimated.runAnimationIndexArray addObject:num];
                }
            }else {
                NSInteger sectionCount = [collectionView numberOfSections];
                for (NSInteger i = 0; i < sectionCount; i++) {
                    [tabAnimated.runAnimationIndexArray addObject:[NSNumber numberWithInteger:i]];
                }
            }
            
            if (tabAnimated.headerClassArray.count > 0 && tabAnimated.headerSectionArray.count == 0) {
                for (int i = 0; i < tabAnimated.runAnimationIndexArray.count; i++) {
                    [tabAnimated.headerSectionArray addObject:tabAnimated.runAnimationIndexArray[i]];
                }
            }

            if (tabAnimated.footerClassArray.count > 0 && tabAnimated.footerSectionArray.count == 0) {
                for (int i = 0; i < tabAnimated.runAnimationIndexArray.count; i++) {
                    [tabAnimated.footerSectionArray addObject:tabAnimated.runAnimationIndexArray[i]];
                }
            }
            
            [collectionView reloadData];
            
        }else {
            [tabAnimated.runAnimationIndexArray addObject:@(index)];
            [collectionView reloadSections:[NSIndexSet indexSetWithIndex:index]];
        }
        
        // 更新loadCount
        dispatch_async(dispatch_get_main_queue(), ^{
            [[TABAnimated sharedAnimated].cacheManager updateCacheModelLoadCountWithCollectionAnimated:collectionView.tabAnimated];
        });
        
    }else if ([self isKindOfClass:[UITableView class]]) {
        
        UITableView *tableView = (UITableView *)self;
        TABTableAnimated *tabAnimated = (TABTableAnimated *)(tableView.tabAnimated);
        [tabAnimated exchangeTableViewDelegate:tableView];
        [tabAnimated exchangeTableViewDataSource:tableView];
        
        for (Class class in self.tabAnimated.cellClassArray) {
            
            NSString *classString = NSStringFromClass(class);
            if ([classString containsString:@"."]) {
                NSRange range = [classString rangeOfString:@"."];
                classString = [classString substringFromIndex:range.location+1];
            }
            
            NSString *nibPath = [[NSBundle mainBundle] pathForResource:classString ofType:@"nib"];
            if (nil != nibPath && nibPath.length > 0) {
                [tableView registerNib:[UINib nibWithNibName:classString bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[NSString stringWithFormat:@"tab_%@",classString]];
                [tableView registerNib:[UINib nibWithNibName:classString bundle:[NSBundle mainBundle]] forCellReuseIdentifier:classString];
            }else {
                [tableView registerClass:class forCellReuseIdentifier:[NSString stringWithFormat:@"tab_%@",classString]];
                [tableView registerClass:class forCellReuseIdentifier:classString];
            }
        }
        
        if (tableView.estimatedRowHeight != 0) {
            tabAnimated.oldEstimatedRowHeight = tableView.estimatedRowHeight;
            tableView.estimatedRowHeight = UITableViewAutomaticDimension;
            if ([tableView numberOfSections] == 1) {
                tabAnimated.animatedCount = ceilf([UIScreen mainScreen].bounds.size.height/tabAnimated.cellHeight*1.0);
                tableView.rowHeight = tabAnimated.cellHeight;
            }
        }
        
        if (tabAnimated.showTableHeaderView && tableView.tableHeaderView.tabAnimated) {
            tableView.tableHeaderView.tabAnimated.superAnimationType = tableView.tabAnimated.superAnimationType;
            [tableView.tableHeaderView tab_startAnimation];
        }
        
        if (tabAnimated.showTableFooterView && tableView.tableFooterView.tabAnimated) {
            tableView.tableFooterView.tabAnimated.superAnimationType = tableView.tabAnimated.superAnimationType;
            [tableView.tableFooterView tab_startAnimation];
        }
        
        [tabAnimated.runAnimationIndexArray removeAllObjects];
        if (isAll) {
            if (tabAnimated.animatedIndexArray.count > 0) {
                for (NSNumber *num in tabAnimated.animatedIndexArray) {
                    [tabAnimated.runAnimationIndexArray addObject:num];
                }
            }else {
                if (tabAnimated.runMode == TABAnimatedRunBySection) {
                    for (NSInteger i = 0; i < [tableView numberOfSections]; i++) {
                        [tabAnimated.runAnimationIndexArray addObject:[NSNumber numberWithInteger:i]];
                    }
                }else {
                    if (tabAnimated.runMode == TABAnimatedRunByRow) {
                        for (NSInteger i = 0; i < [tableView numberOfRowsInSection:0]; i++) {
                            [tabAnimated.runAnimationIndexArray addObject:[NSNumber numberWithInteger:i]];
                        }
                    }
                }
            }
            
            if (tabAnimated.headerClassArray.count > 0 && tabAnimated.headerSectionArray.count == 0) {
                for (int i = 0; i < tabAnimated.runAnimationIndexArray.count; i++) {
                    [tabAnimated.headerSectionArray addObject:tabAnimated.runAnimationIndexArray[i]];
                }
            }

            if (tabAnimated.footerClassArray.count > 0 && tabAnimated.footerSectionArray.count == 0) {
                for (int i = 0; i < tabAnimated.runAnimationIndexArray.count; i++) {
                    [tabAnimated.footerSectionArray addObject:tabAnimated.runAnimationIndexArray[i]];
                }
            }
            
            [tableView reloadData];
            
        }else {
            
            [tabAnimated.runAnimationIndexArray addObject:@(index)];
            
            if (tabAnimated.runMode == TABAnimatedRunBySection) {
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
            }else {
                if (tabAnimated.runMode == TABAnimatedRunByRow) {
                    [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        }
        
        // 更新loadCount
        dispatch_async(dispatch_get_main_queue(), ^{
            [[TABAnimated sharedAnimated].cacheManager updateCacheModelLoadCountWithTableAnimated:tableView.tabAnimated];
        });
        
    }else {
        if (nil == self.tabComponentManager) {
            
            UIView *targetView;
            if (self.superview && self.superview.tabAnimated) {
                targetView = self.superview;
            }else {
                targetView = self;
            }
            
//            self.tabAnimated.oldEnable = self.userInteractionEnabled;
//            self.userInteractionEnabled = NO;
            
            [TABManagerMethod fullData:self];
            [self setNeedsLayout];
            self.tabComponentManager = [TABComponentManager initWithView:self
                                                               superView:targetView
                                                             tabAnimated:self.tabAnimated];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (nil != self.tabAnimated) {
                    [TABManagerMethod runAnimationWithSuperView:self
                                                     targetView:self
                                                         isCell:NO
                                                        manager:self.tabComponentManager];
                }
            });
        }else {
            if (self.tabComponentManager.tabLayer.hidden)
                self.tabComponentManager.tabLayer.hidden = NO;
        }
    }
}

#pragma mark - 结束动画

- (void)tab_endAnimationIsEaseOut:(BOOL)isEaseOut {
    
    if (!self.tabAnimated) {
        tabAnimatedLog(@"TABAnimated提醒 - 动画对象已被提前释放");
        return;
    }
    
    if (self.tabAnimated.state == TABViewAnimationEnd) {
        return;
    }
    
    self.tabAnimated.state = TABViewAnimationEnd;
    self.tabAnimated.isAnimating = NO;
    
    if ([self isKindOfClass:[UITableView class]]) {
        
        UITableView *tableView = (UITableView *)self;
        TABTableAnimated *tabAnimated = (TABTableAnimated *)(tableView.tabAnimated);
        
        if (tabAnimated.oldEstimatedRowHeight > 0) {
            tableView.estimatedRowHeight = tabAnimated.oldEstimatedRowHeight;
            tableView.rowHeight = UITableViewAutomaticDimension;
        }
        
        [tabAnimated.runAnimationIndexArray removeAllObjects];
        
        self.tabAnimated = tabAnimated;
        
        if (tableView.tableHeaderView != nil &&
            tableView.tableHeaderView.tabAnimated != nil) {
            [tableView.tableHeaderView tab_endAnimation];
        }
        
        if (tableView.tableFooterView != nil &&
            tableView.tableFooterView.tabAnimated != nil) {
            [tableView.tableFooterView tab_endAnimation];
        }
        
        [tableView reloadData];
        
    }else if ([self isKindOfClass:[UICollectionView class]]) {
        
        TABCollectionAnimated *tabAnimated = (TABCollectionAnimated *)((UICollectionView *)self.tabAnimated);
        [tabAnimated.runAnimationIndexArray removeAllObjects];
        self.tabAnimated = tabAnimated;
        
        [(UICollectionView *)self reloadData];
        
    }else {
        [TABManagerMethod resetData:self];
        [TABManagerMethod removeMask:self];
        [TABManagerMethod endAnimationToSubViews:self];
    }
    
    if (isEaseOut) {
        [TABAnimationMethod addEaseOutAnimation:self];
    }
}

- (void)tab_endAnimation {
    [self tab_endAnimationIsEaseOut:NO];
}

- (void)tab_endAnimationEaseOut {
    [self tab_endAnimationIsEaseOut:YES];
}

- (void)tab_endAnimationWithRow:(NSInteger)row {
    [self tab_endAnimationWithSection:row];
}
    
- (void)tab_endAnimationWithSection:(NSInteger)section {
    
    if (![self isKindOfClass:[UITableView class]] &&
        ![self isKindOfClass:[UICollectionView class]]) {
        tabAnimatedLog(@"TABAnimated提醒 - 该类型view不支持局部结束动画");
        return;
    }
    
    NSInteger maxIndex = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        TABTableAnimated *tabAnimated = (TABTableAnimated *)self.tabAnimated;
        if (tabAnimated.runMode == TABAnimatedRunBySection) {
            maxIndex = [(UITableView *)self numberOfSections] - 1;
        }else {
            maxIndex = [(UITableView *)self numberOfRowsInSection:0] - 1;
        }
    }else {
        TABCollectionAnimated *tabAnimated = (TABCollectionAnimated *)self.tabAnimated;
        if (tabAnimated.runMode == TABAnimatedRunBySection) {
            maxIndex = [(UICollectionView *)self numberOfSections] - 1;
        }else {
            maxIndex = [(UICollectionView *)self numberOfItemsInSection:0] - 1;
        }
    }
    
    if (section > maxIndex) {
        tabAnimatedLog(@"TABAnimated提醒 - 超过当前最大分区数");
        return;
    }
    
    if ([self isKindOfClass:[UICollectionView class]]) {
        
        TABCollectionAnimated *tabAnimated = (TABCollectionAnimated *)((UICollectionView *)self.tabAnimated);
        
        for (NSInteger i = 0; i < tabAnimated.runAnimationIndexArray.count; i++) {
            if (section == [tabAnimated.runAnimationIndexArray[i] integerValue]) {
                [self tab_removeObjectAtIndex:i
                                    withArray:tabAnimated.runAnimationIndexArray];
                break;
            }
        }
        
        self.tabAnimated = tabAnimated;
        
        if (tabAnimated.runMode == TABAnimatedRunBySection) {
            [(UICollectionView *)self reloadSections:[NSIndexSet indexSetWithIndex:section]];
        }else {
            [(UICollectionView *)self reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:section inSection:0]]];
        }
        
    }else if ([self isKindOfClass:[UITableView class]]) {
        
        TABTableAnimated *tabAnimated = (TABTableAnimated *)((UITableView *)self.tabAnimated);
        
        for (NSInteger i = 0; i < tabAnimated.runAnimationIndexArray.count; i++) {
            if (section == [tabAnimated.runAnimationIndexArray[i] integerValue]) {
                [self tab_removeObjectAtIndex:i
                                    withArray:tabAnimated.runAnimationIndexArray];
                break;
            }
        }
        
        self.tabAnimated = tabAnimated;
        
        if (tabAnimated.runMode == TABAnimatedRunBySection) {
            [(UITableView *)self reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        }else {
            [(UITableView *)self reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:section inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

#pragma mark - Private Method

- (UIViewController*)tab_viewController {
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)tab_removeObjectAtIndex:(NSInteger)index
                      withArray:(NSMutableArray *)array {
    [array removeObjectAtIndex:index];
    if (array.count == 0) {
        self.tabAnimated.state = TABViewAnimationEnd;
        self.tabAnimated.isAnimating = NO;
    }
}

- (void)registerHeaderOrFooter:(BOOL)isHeader
                   tabAnimated:(TABCollectionAnimated *)tabAnimated {
    
    UICollectionView *collectionView = (UICollectionView *)self;
    NSString *defaultPrefix = nil;
    NSMutableArray *classArray;
    NSString *kind = nil;
    
    if (isHeader) {
        defaultPrefix = TABViewAnimatedHeaderPrefixString;
        classArray = tabAnimated.headerClassArray;
        kind = UICollectionElementKindSectionHeader;
    }else {
        defaultPrefix = TABViewAnimatedFooterPrefixString;
        classArray = tabAnimated.footerClassArray;
        kind = UICollectionElementKindSectionFooter;
    }
    
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:kind withReuseIdentifier:[NSString stringWithFormat:@"%@%@",defaultPrefix,TABViewAnimatedDefaultSuffixString]];
    
    for (Class class in classArray) {
        
        NSString *classString = NSStringFromClass(class);
        if ([classString containsString:@"."]) {
            NSRange range = [classString rangeOfString:@"."];
            classString = [classString substringFromIndex:range.location+1];
        }
        
        NSString *nibPath = [[NSBundle mainBundle] pathForResource:classString ofType:@"nib"];
        
        if (nil != nibPath && nibPath.length > 0) {
            [collectionView registerNib:[UINib nibWithNibName:classString
                                                       bundle:[NSBundle mainBundle]]
             forSupplementaryViewOfKind:kind
                    withReuseIdentifier:[NSString stringWithFormat:@"%@%@",defaultPrefix,classString]];
            [collectionView registerNib:[UINib nibWithNibName:classString
                                                       bundle:[NSBundle mainBundle]]
             forSupplementaryViewOfKind:kind
                    withReuseIdentifier:classString];
        }else {
            [collectionView registerClass:class
               forSupplementaryViewOfKind:kind
                      withReuseIdentifier:[NSString stringWithFormat:@"%@%@",defaultPrefix,classString]];
            [collectionView registerClass:class
               forSupplementaryViewOfKind:kind
                      withReuseIdentifier:classString];
        }
    }
}

@end
