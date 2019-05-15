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
        [(UICollectionView *)self reloadData];
        
    }else if ([self isKindOfClass:[UITableView class]]) {
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
        [(UITableView *)self reloadData];
    }else {
        if ([self isKindOfClass:[UICollectionView class]]) {
            [(UICollectionView *)self setScrollEnabled:YES];
            [(UICollectionView *)self reloadData];
        }else {
            [TABManagerMethod resetData:self];
            [self layoutSubviews];
        }
    }
}

@end
