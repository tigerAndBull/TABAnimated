//
//  UIView+TABControllerAnimation.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/1/17.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import "UIView+TABControlAnimation.h"
#import "TABAnimated.h"
#import "EstimatedTableViewDelegate.h"
#import <objc/runtime.h>

#define kDelayReloadDataTime 0.4

@implementation UIView (TABControlAnimation)

- (void)tab_startAnimation {
    
    if (!self.tabAnimated.canLoadAgain &&
        self.tabAnimated.state == TABViewAnimationEnd) {
        return;
    }
    
    self.tabAnimated.isAnimating = YES;
    self.tabAnimated.state = TABViewAnimationStart;
    
    [self startAnimation];
}

- (void)tab_startAnimationWithCompletion:(void (^)(void))completion {
    [self tab_startAnimationWithDelayTime:kDelayReloadDataTime
                               completion:completion];
}

- (void)tab_startAnimationWithDelayTime:(CGFloat)delayTime
                             completion:(void (^)(void))completion {
    
    if (!self.tabAnimated.canLoadAgain &&
        self.tabAnimated.state == TABViewAnimationEnd) {
        return;
    }
    
    self.tabAnimated.state = TABViewAnimationStart;
    
    if (!self.tabAnimated.isAnimating) {
        [self startAnimation];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*delayTime), dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    }
    
    self.tabAnimated.isAnimating = YES;
}

- (void)tab_endAnimation {
    
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
        TABTableAnimated *tabAnimated = (TABTableAnimated *)((UITableView *)self.tabAnimated);
        
        if (tabAnimated.oldEstimatedRowHeight > 0) {
            NSLog(@"值 %lf",tabAnimated.oldEstimatedRowHeight);
            tableView.estimatedRowHeight = tabAnimated.oldEstimatedRowHeight;
            tableView.rowHeight = UITableViewAutomaticDimension;
        }
        [tabAnimated.runAnimationSectionArray removeAllObjects];
        
        self.tabAnimated = tabAnimated;
        
        if (tableView.tableHeaderView != nil &&
            tableView.tableHeaderView.tabAnimated != nil) {
            [tableView.tableHeaderView tab_endAnimation];
        }
        
        if (tableView.tableFooterView != nil &&
            tableView.tableFooterView.tabAnimated != nil) {
            [tableView.tableFooterView tab_endAnimation];
        }
        
        [UIView transitionWithView:tableView duration:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
        } completion:^(BOOL finished) {
            
        }];
        
        [tableView reloadData];

    }else {
        if ([self isKindOfClass:[UICollectionView class]]) {
            
            TABCollectionAnimated *tabAnimated = (TABCollectionAnimated *)((UICollectionView *)self.tabAnimated);
            [tabAnimated.runAnimationSectionArray removeAllObjects];
            self.tabAnimated = tabAnimated;
            
            [(UICollectionView *)self reloadData];
            
        }else {
            [TABManagerMethod removeMask:self];
            [TABManagerMethod endAnimationToSubViews:self];
        }
    }
}

- (void)tab_endAnimationEaseOut {
    [self tab_endAnimation];
    [TABAnimationMethod addEaseOutAnimation:self];
}

- (void)tab_endAnimationWithSection:(NSInteger)section {
    
    if (![self isKindOfClass:[UITableView class]] &&
        ![self isKindOfClass:[UICollectionView class]]) {
        tabAnimatedLog(@"TABAnimated提醒 - 该类型view不支持分区结束动画");
        return;
    }
    
    NSInteger maxSection = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        maxSection = [(UITableView *)self numberOfSections] - 1;
    }else {
        if ([self isKindOfClass:[UICollectionView class]]) {
            maxSection = [(UICollectionView *)self numberOfSections] - 1;
        }
    }
    
    if (section > maxSection) {
        tabAnimatedLog(@"TABAnimated提醒 - 超过当前最大分区数");
        return;
    }
    
    if ([self isKindOfClass:[UICollectionView class]]) {
        
        TABCollectionAnimated *tabAnimated = (TABCollectionAnimated *)((UICollectionView *)self.tabAnimated);
        
        for (NSInteger i = 0; i < tabAnimated.runAnimationSectionArray.count; i++) {
            if (section == [tabAnimated.runAnimationSectionArray[i] integerValue]) {
                [self tab_removeObjectAtIndex:i
                                    withArray:tabAnimated.runAnimationSectionArray];
                break;
            }
        }
        
        self.tabAnimated = tabAnimated;
        
        [(UICollectionView *)self reloadSections:[NSIndexSet indexSetWithIndex:section]];
        
    }else if ([self isKindOfClass:[UITableView class]]) {
        
        TABTableAnimated *tabAnimated = (TABTableAnimated *)((UITableView *)self.tabAnimated);
        
        for (NSInteger i = 0; i < tabAnimated.runAnimationSectionArray.count; i++) {
            if (section == [tabAnimated.runAnimationSectionArray[i] integerValue]) {
                [self tab_removeObjectAtIndex:i
                                    withArray:tabAnimated.runAnimationSectionArray];
                break;
            }
        }
        
        self.tabAnimated = tabAnimated;
        
        [(UITableView *)self reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - Private Method

- (void)startAnimation {
    if ([self isKindOfClass:[UICollectionView class]]) {
        
        for (Class class in self.tabAnimated.cellClassArray) {
            
            NSString *classString = NSStringFromClass(class);
            NSString *nibPath = [[NSBundle mainBundle] pathForResource:classString ofType:@"nib"];
            
            if (nil != nibPath && nibPath.length > 0) {
                [(UICollectionView *)self registerNib:[UINib nibWithNibName:classString bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:classString];
                [(UICollectionView *)self registerNib:[UINib nibWithNibName:classString bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:[NSString stringWithFormat:@"tab_%@",classString]];
                
            }else {
                [(UICollectionView *)self registerClass:class forCellWithReuseIdentifier:[NSString stringWithFormat:@"tab_%@",classString]];
                [(UICollectionView *)self registerClass:class forCellWithReuseIdentifier:classString];
            }
        }
        
        TABCollectionAnimated *tabAnimated = (TABCollectionAnimated *)((UICollectionView *)self.tabAnimated);
        [tabAnimated.runAnimationSectionArray removeAllObjects];
        
        if (tabAnimated.animatedSectionArray.count > 0) {
            for (NSNumber *num in tabAnimated.animatedSectionArray) {
                [tabAnimated.runAnimationSectionArray addObject:num];
            }
        }else {
            for (NSInteger i = 0; i < [(UICollectionView *)self numberOfSections]; i++) {
                [tabAnimated.runAnimationSectionArray addObject:[NSNumber numberWithInteger:i]];
            }
        }
        
        self.tabAnimated = tabAnimated;
        
        [(UICollectionView *)self reloadData];
        
    }else if ([self isKindOfClass:[UITableView class]]) {
        
        UITableView *tableView = (UITableView *)self;
        TABTableAnimated *tabAnimated = (TABTableAnimated *)((UITableView *)self.tabAnimated);
        
        if (tableView.estimatedRowHeight != UITableViewAutomaticDimension ||
            tableView.estimatedRowHeight != 0) {
            tabAnimated.oldEstimatedRowHeight = tableView.estimatedRowHeight;
            tableView.estimatedRowHeight = UITableViewAutomaticDimension;
            tableView.rowHeight = [[tabAnimated.cellHeightArray lastObject] floatValue];
        }
        
        if (tableView.tableHeaderView.tabAnimated != nil) {
            [tableView.tableHeaderView tab_startAnimation];
        }
        if (tableView.tableFooterView.tabAnimated != nil) {
            [tableView.tableFooterView tab_startAnimation];
        }
        
        [tabAnimated.runAnimationSectionArray removeAllObjects];
        
        if (tabAnimated.animatedSectionArray.count > 0) {
            for (NSNumber *num in tabAnimated.animatedSectionArray) {
                [tabAnimated.runAnimationSectionArray addObject:num];
            }
        }else {
            for (NSInteger i = 0; i < [(UITableView *)self numberOfSections]; i++) {
                [tabAnimated.runAnimationSectionArray addObject:[NSNumber numberWithInteger:i]];
            }
        }
        
        self.tabAnimated = tabAnimated;
        [tableView reloadData];
    }else {
        [TABManagerMethod fullData:self];
        [self layoutSubviews];
    }
}

- (void)tab_removeObjectAtIndex:(NSInteger)index
                      withArray:(NSMutableArray *)array {
    [array removeObjectAtIndex:index];
    if (array.count == 0) {
        self.tabAnimated.state = TABViewAnimationEnd;
        self.tabAnimated.isAnimating = NO;
    }
}

@end
