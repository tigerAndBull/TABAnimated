//
//  UIView+TABControllerAnimation.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/1/17.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import "UIView+TABControlAnimation.h"
#import "TABAnimated.h"

@implementation UIView (TABControlAnimation)

- (void)tab_startAnimation {
    
    if (!self.tabAnimated.canLoadAgain &&
        self.tabAnimated.state == TABViewAnimationEnd) {
        return;
    }
    
    self.tabAnimated.isAnimating = YES;
    self.tabAnimated.state = TABViewAnimationStart;
    
    if ([self isKindOfClass:[UICollectionView class]]) {

        for (Class class in self.tabAnimated.cellClassArray) {
            [(UICollectionView *)self registerClass:class forCellWithReuseIdentifier:[NSString stringWithFormat:@"tab_%@",NSStringFromClass(class)]];
            [(UICollectionView *)self registerClass:class forCellWithReuseIdentifier:NSStringFromClass(class)];
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
        
        TABTableAnimated *tabAnimated = (TABTableAnimated *)((UITableView *)self.tabAnimated);
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
        
        [(UITableView *)self reloadData];
    }else {
        [TABManagerMethod fullData:self];
        [self layoutSubviews];
    }
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
        
        TABTableAnimated *tabAnimated = (TABTableAnimated *)((UITableView *)self.tabAnimated);
        [tabAnimated.runAnimationSectionArray removeAllObjects];
        self.tabAnimated = tabAnimated;
        
        [(UITableView *)self reloadData];
        
    }else {
        if ([self isKindOfClass:[UICollectionView class]]) {
            
            TABCollectionAnimated *tabAnimated = (TABCollectionAnimated *)((UICollectionView *)self.tabAnimated);
            [tabAnimated.runAnimationSectionArray removeAllObjects];
            self.tabAnimated = tabAnimated;
            
            [(UICollectionView *)self reloadData];
            
        }else {
            [TABManagerMethod resetData:self];
            [self layoutSubviews];
        }
    }
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
        
        [(UITableView *)self reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
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

@end
