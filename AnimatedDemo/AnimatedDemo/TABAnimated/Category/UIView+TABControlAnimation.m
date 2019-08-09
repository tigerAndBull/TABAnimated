//
//  UIView+TABControllerAnimation.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/1/17.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import "UIView+TABControlAnimation.h"
#import <objc/runtime.h>

#define kDelayReloadDataTime 0.4

@implementation UIView (TABControlAnimation)

#pragma mark - 启动动画

- (void)tab_startAnimation {
    
    if (!self.tabAnimated.canLoadAgain &&
        self.tabAnimated.state == TABViewAnimationEnd) {
        return;
    }
    
    self.tabAnimated.isAnimating = YES;
    self.tabAnimated.state = TABViewAnimationStart;
    
    [self startAnimationIsAll:YES section:0];
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
        [self startAnimationIsAll:YES section:0];
        
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
    
    [self startAnimationIsAll:NO section:section];
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
        [self startAnimationIsAll:NO section:section];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*delayTime), dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    }
    
    self.tabAnimated.isAnimating = YES;
}

- (void)startAnimationIsAll:(BOOL)isAll
                    section:(NSInteger)section {
    
    if ([self isKindOfClass:[UICollectionView class]]) {
        
        for (Class class in self.tabAnimated.cellClassArray) {
            
            NSString *classString = NSStringFromClass(class);
            if ([classString containsString:@"."]) {
                NSRange range = [classString rangeOfString:@"."];
                classString = [classString substringFromIndex:range.location+1];
            }
            
            NSString *nibPath = [[NSBundle mainBundle] pathForResource:classString ofType:@"nib"];
            
            if (nil != nibPath && nibPath.length > 0) {
                [(UICollectionView *)self registerNib:[UINib nibWithNibName:classString bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:[NSString stringWithFormat:@"tab_%@",classString]];
                [(UICollectionView *)self registerNib:[UINib nibWithNibName:classString bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:classString];
            }else {
                [(UICollectionView *)self registerClass:class forCellWithReuseIdentifier:[NSString stringWithFormat:@"tab_%@",classString]];
                [(UICollectionView *)self registerClass:class forCellWithReuseIdentifier:classString];
            }
        }
        
        TABCollectionAnimated *tabAnimated = (TABCollectionAnimated *)((UICollectionView *)self.tabAnimated);
        
        if (tabAnimated.headerClassArray.count > 0) {
            [self registerHeaderOrFooter:YES tabAnimated:tabAnimated];
        }
        
        if (tabAnimated.footerClassArray.count > 0) {
            [self registerHeaderOrFooter:NO tabAnimated:tabAnimated];
        }

        [tabAnimated.runAnimationSectionArray removeAllObjects];
        
        if (isAll) {
            if (tabAnimated.animatedSectionArray.count > 0) {
                for (NSNumber *num in tabAnimated.animatedSectionArray) {
                    [tabAnimated.runAnimationSectionArray addObject:num];
                }
            }else {
                for (NSInteger i = 0; i < [(UICollectionView *)self numberOfSections]; i++) {
                    [tabAnimated.runAnimationSectionArray addObject:[NSNumber numberWithInteger:i]];
                }
            }
        }else {
            [tabAnimated.runAnimationSectionArray addObject:@(section)];
        }
        
        self.tabAnimated = tabAnimated;
        
        if (isAll) {
            [(UICollectionView *)self reloadData];
        }else {
            [(UICollectionView *)self reloadSections:[NSIndexSet indexSetWithIndex:section]];
        }
        
    }else if ([self isKindOfClass:[UITableView class]]) {
        
        UITableView *tableView = (UITableView *)self;
        TABTableAnimated *tabAnimated = (TABTableAnimated *)((UITableView *)self.tabAnimated);
        
        for (Class class in self.tabAnimated.cellClassArray) {
            
            NSString *classString = NSStringFromClass(class);
            if ([classString containsString:@"."]) {
                NSRange range = [classString rangeOfString:@"."];
                classString = [classString substringFromIndex:range.location+1];
            }
            
            NSString *nibPath = [[NSBundle mainBundle] pathForResource:classString ofType:@"nib"];
            
            if (nil != nibPath && nibPath.length > 0) {
                [(UITableView *)self registerNib:[UINib nibWithNibName:classString bundle:[NSBundle mainBundle]] forCellReuseIdentifier:[NSString stringWithFormat:@"tab_%@",classString]];
                [(UITableView *)self registerNib:[UINib nibWithNibName:classString bundle:[NSBundle mainBundle]] forCellReuseIdentifier:classString];
            }else {
                [(UITableView *)self registerClass:class forCellReuseIdentifier:[NSString stringWithFormat:@"tab_%@",classString]];
                [(UITableView *)self registerClass:class forCellReuseIdentifier:classString];
            }
        }
        
        if (tableView.estimatedRowHeight != UITableViewAutomaticDimension ||
            tableView.estimatedRowHeight != 0) {
            tabAnimated.oldEstimatedRowHeight = tableView.estimatedRowHeight;
            tableView.estimatedRowHeight = UITableViewAutomaticDimension;
            if ([tableView numberOfSections] == 1) {
                tabAnimated.animatedHeight = ceilf([UIScreen mainScreen].bounds.size.height/tableView.estimatedRowHeight*1.0);
            }
        }
        
        if (tableView.tabAnimated.showTableHeaderView) {
            if (tableView.tableHeaderView.tabAnimated != nil) {
                tableView.tableHeaderView.tabAnimated.superAnimationType = tableView.tabAnimated.superAnimationType;
                [tableView.tableHeaderView tab_startAnimation];
            }
        }
        
        if (tableView.tabAnimated.showTableFooterView) {
            if (tableView.tableFooterView.tabAnimated != nil) {
                tableView.tableFooterView.tabAnimated.superAnimationType = tableView.tabAnimated.superAnimationType;
                [tableView.tableFooterView tab_startAnimation];
            }
        }
        
        [tabAnimated.runAnimationSectionArray removeAllObjects];
        
        if (isAll) {
            if (tabAnimated.animatedSectionArray.count > 0) {
                for (NSNumber *num in tabAnimated.animatedSectionArray) {
                    [tabAnimated.runAnimationSectionArray addObject:num];
                }
            }else {
                for (NSInteger i = 0; i < [(UITableView *)self numberOfSections]; i++) {
                    [tabAnimated.runAnimationSectionArray addObject:[NSNumber numberWithInteger:i]];
                }
            }
        }else {
            [tabAnimated.runAnimationSectionArray addObject:@(section)];
        }
        
        self.tabAnimated = tabAnimated;
        if (isAll) {
            [tableView reloadData];
        }else {
            [(UITableView *)self reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }else {
        
        if (nil == self.tabComponentManager) {
            self.tabComponentManager = [TABComponentManager initWithView:self tabAnimated:self.tabAnimated];
            [TABManagerMethod fullData:self];
        }
        [self layoutSubviews];
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
        TABTableAnimated *tabAnimated = (TABTableAnimated *)((UITableView *)self.tabAnimated);
        
        if (tabAnimated.oldEstimatedRowHeight > 0) {
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
        
        [tableView reloadData];
        
    }else {
        if ([self isKindOfClass:[UICollectionView class]]) {
            
            TABCollectionAnimated *tabAnimated = (TABCollectionAnimated *)((UICollectionView *)self.tabAnimated);
            [tabAnimated.runAnimationSectionArray removeAllObjects];
            self.tabAnimated = tabAnimated;
            
            [(UICollectionView *)self reloadData];
            
        }else {
            [TABManagerMethod resetData:self];
            [TABManagerMethod removeMask:self];
            [TABManagerMethod endAnimationToSubViews:self];
        }
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
    NSMutableArray *classArray = @[].mutableCopy;
    NSString *kind = nil;
    
    if (isHeader) {
        defaultPrefix = tab_header_prefix;
        classArray = tabAnimated.headerClassArray;
        kind = UICollectionElementKindSectionHeader;
    }else {
        defaultPrefix = tab_footer_prefix;
        classArray = tabAnimated.footerClassArray;
        kind = UICollectionElementKindSectionFooter;
    }
    
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:kind withReuseIdentifier:[NSString stringWithFormat:@"%@%@",defaultPrefix,tab_default_suffix]];
    
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
