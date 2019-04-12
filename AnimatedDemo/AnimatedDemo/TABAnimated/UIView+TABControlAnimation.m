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
    
    if (!self.tabAnimated) {
        tabAnimatedLog(@"TABAnimated提醒 - 检测到未进行初始化设置，将以默认属性加载");
        self.tabAnimated = [[TABAnimatedObject alloc] init];
    }
    
    if ([self isKindOfClass:[UICollectionView class]]) {
        [(UICollectionView *)self setScrollEnabled:NO];
    }
    
    if ([TABViewAnimated sharedAnimated].isUseTemplate) {
        
        if ([self isKindOfClass:[UICollectionView class]]) {
            
            if (self.tabAnimated.templateClassArray.count == 0) {
                
                if ([TABViewAnimated sharedAnimated].templateCollectionViewCell) {
                    self.tabAnimated.templateClassArray = @[NSStringFromClass([[TABViewAnimated sharedAnimated].templateCollectionViewCell class])];
                }else {
                    self.tabAnimated.templateClassArray = @[NSStringFromClass([TABTemplateCollectionViewCell class])];
                }
            }
            
            for (NSString *className in self.tabAnimated.templateClassArray) {
                [(UICollectionView *)self registerClass:NSClassFromString(className) forCellWithReuseIdentifier:className];
            }
            
        }else if ([self isKindOfClass:[UITableView class]]) {
            
            if (self.tabAnimated.templateClassArray.count == 0) {
                
                if ([TABViewAnimated sharedAnimated].templateTableViewCell) {
                    self.tabAnimated.templateClassArray = @[NSStringFromClass([[TABViewAnimated sharedAnimated].templateTableViewCell class])];
                }else {
                    self.tabAnimated.templateClassArray = @[NSStringFromClass([TABTemplateTableViewCell class])];
                }
            }
        }
    }
    
    self.tabAnimated.isAnimating = YES;
    self.tabAnimated.animatedStyle = TABViewAnimationStart;
}

- (void)tab_endAnimation {
    
    if (!self.tabAnimated) {
        tabAnimatedLog(@"TABAnimated提醒 - 动画对象已被提前释放，请检查");
        return;
    }
    
    self.tabAnimated.animatedStyle = TABViewAnimationEnd;
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
