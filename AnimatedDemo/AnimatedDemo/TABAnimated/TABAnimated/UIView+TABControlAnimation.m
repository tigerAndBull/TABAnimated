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
    
    if (self.tabAnimated &&
        self.tabAnimated.state == TABViewAnimationEnd) {
        return;
    }
    
    if (!self.tabAnimated) {
        tabAnimatedLog(@"TABAnimated提醒 - 检测到未进行初始化设置，将以默认属性加载");
        self.tabAnimated = [[TABViewAnimated alloc] init];
    }
    
    if ([self isKindOfClass:[UICollectionView class]]) {
        [(UICollectionView *)self setScrollEnabled:NO];
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
            [self layoutSubviews];
        }
    }
}

@end
