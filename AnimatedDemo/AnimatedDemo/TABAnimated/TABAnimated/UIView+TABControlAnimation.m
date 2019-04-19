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
    
    self.tabAnimated.isAnimating = YES;
    self.tabAnimated.animatedStyle = TABViewAnimationStart;
    
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
            
            if (self.tabAnimated.templateClassArray.count == 1) {
                [self layoutIfNeeded];
                SEL sel = @selector(cellSize);
                tab_suppressPerformSelectorLeakWarning(
                                                       NSValue *value = [NSClassFromString((((UICollectionView *)self).tabAnimated.templateClassArray[0])) performSelector:sel];
                                                       if (value.CGSizeValue.height <= 1.0) {
                                                           NSAssert(NO, @"TABAnimated模版模式提醒 - 请在注册的模版类中设置固定高度，否则没有动画效果");
                                                       }
                                                       
                                                       self.tabAnimated.animatedCount = ceilf(self.frame.size.height/value.CGSizeValue.height*1.0);
                                                       
                                                       tabAnimatedLog(@"TABAnimate提醒 - 自动计算cell数量，以填充屏幕为标准");
                );
            }
            
            [(UICollectionView *)self reloadData];
            
        }else if ([self isKindOfClass:[UITableView class]]) {
            
            if (self.tabAnimated.templateClassArray.count == 0) {
                
                if ([TABViewAnimated sharedAnimated].templateTableViewCell) {
                    self.tabAnimated.templateClassArray = @[NSStringFromClass([[TABViewAnimated sharedAnimated].templateTableViewCell class])];
                }else {
                    self.tabAnimated.templateClassArray = @[NSStringFromClass([TABTemplateTableViewCell class])];
                }
            }
            
            if (self.tabAnimated.templateClassArray.count == 1) {
                [self layoutIfNeeded];
                SEL sel = @selector(cellHeight);
                tab_suppressPerformSelectorLeakWarning(
                                                       NSNumber *num = [NSClassFromString((((UITableView *)self).tabAnimated.templateClassArray[0])) performSelector:sel];
                                                       if (num.floatValue <= 1.0) {
                                                           NSAssert(NO, @"TABAnimated模版模式提醒 - 请在注册的模版类中设置固定高度，否则没有动画效果");
                                                       }
                                                       
                                                       self.tabAnimated.animatedCount = ceilf(self.frame.size.height/num.floatValue*1.0);

                                                       tabAnimatedLog(@"TABAnimate提醒 - 自动计算cell数量，以填充屏幕为标准");
                                                       );
            }
            
            [(UITableView *)self reloadData];
        }
    }
}

- (void)tab_startAnimationWithCompletion:(void (^ __nullable)(BOOL finished))completion {
    [self tab_startAnimation];
    if (completion) {
        completion(nil);
    }
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
