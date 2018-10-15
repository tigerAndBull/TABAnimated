//
//  UICollectionView+Animated.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/10/12.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "UICollectionView+Animated.h"

#import "UIView+Animated.h"

#import <objc/runtime.h>

@implementation UICollectionView (Animated)

+ (void)load {
    
    // Ensure that the exchange method executed only once.
    // 保证交换方法只执行一次
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        // Gets the viewDidLoad method to the class,whose type is a pointer to a objc_method structure.
        // 获取到这个类的viewDidLoad方法，它的类型是一个objc_method结构体的指针
        Method originMethod = class_getInstanceMethod([self class], @selector(setDelegate:));
        
        // Get the method you created.
        // 获取自己创建的方法
        Method newMethod = class_getInstanceMethod([self class], @selector(tab_setDelegate:));
        
        IMP newIMP = method_getImplementation(newMethod);
        
        BOOL isAdd = class_addMethod([self class], @selector(tab_setDelegate:), newIMP, method_getTypeEncoding(newMethod));
        
        if (isAdd) {
            
            //replace
            class_replaceMethod([self class], @selector(setDelegate:), newIMP, method_getTypeEncoding(newMethod));
        }else {
            //exchange
            method_exchangeImplementations(originMethod, newMethod);
        }
        
    });
}

- (void)tab_setDelegate:(id<UICollectionViewDelegate>)delegate {
    
    SEL oldSelector = @selector(numberOfSectionsInCollectionView:);
    SEL newSelector = @selector(tab_numberOfSectionsInCollectionView:);
    
    SEL oldSectionSelector = @selector(collectionView:numberOfItemsInSection:);
    SEL newSectionSelector = @selector(tab_collectionView:numberOfItemsInSection:);
    
    [self exchangeCollectionDelegateMethod:oldSectionSelector withNewSel:newSectionSelector withCollectionDelegate:delegate];
    [self exchangeCollectionDelegateMethod:oldSelector withNewSel:newSelector withCollectionDelegate:delegate];
    
    [self tab_setDelegate:delegate];
}

#pragma mark - TABCollectionViewDelegate

- (NSInteger)tab_numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    NSNumber *value = objc_getAssociatedObject(self, @selector(numberOfSections));
    
    if (collectionView.animatedStyle == TABCollectionViewAnimationStart) {
        return ([value integerValue] > 0)?[value integerValue]:1;
    }
    return [self tab_numberOfSectionsInCollectionView:collectionView];
}

- (NSInteger)tab_collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView.animatedStyle == TABCollectionViewAnimationStart) {
        return collectionView.animatedCount;
    }
    return [self tab_collectionView:collectionView numberOfItemsInSection:section];
}

- (UICollectionViewCell *)tab_collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    return [self tab_collectionView:collectionView cellForItemAtIndexPath:indexPath];
}

#pragma mark - Private Methods

- (void)exchangeCollectionDelegateMethod:(SEL)oldSelector withNewSel:(SEL)newSelector withCollectionDelegate:(id<UICollectionViewDelegate>)delegate {
    
    Method oldMethod_del = class_getInstanceMethod([delegate class], oldSelector);
    Method oldMethod_self = class_getInstanceMethod([self class], oldSelector);
    Method newMethod = class_getInstanceMethod([self class], newSelector);
    
    // 若未实现代理方法，则先添加代理方法
    BOOL isSuccess = class_addMethod([delegate class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
    
    if (isSuccess) {
        
        class_replaceMethod([delegate class], newSelector, class_getMethodImplementation([self class], oldSelector), method_getTypeEncoding(oldMethod_self));
    } else {
        
        // 若已实现代理方法，则添加 hook 方法并进行交换
        BOOL isVictory = class_addMethod([delegate class], newSelector, class_getMethodImplementation([delegate class], oldSelector), method_getTypeEncoding(oldMethod_del));
        if (isVictory) {
            class_replaceMethod([delegate class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
        }
    }
}


#pragma mark - Getter / Setter

- (TABViewAnimationStyle)animatedStyle {
    
    NSNumber *value = objc_getAssociatedObject(self, @selector(animatedStyle));
    return value.intValue;
}

- (void)setAnimatedStyle:(TABViewAnimationStyle)animatedStyle {

    // 动画开启过程中设置为不可滚动,不接触触摸事件
    if (animatedStyle == 4) {
        [self setScrollEnabled:NO];
        [self setAllowsSelection:NO];
    }else {
        [self setScrollEnabled:YES];
        [self setAllowsSelection:YES];
    }
    objc_setAssociatedObject(self, @selector(animatedStyle), @(animatedStyle), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)animatedCount {
    NSNumber *value = objc_getAssociatedObject(self, @selector(animatedCount));
    return (value.integerValue == 0)?(6):(value.integerValue);
}

- (void)setAnimatedCount:(NSInteger)animatedCount {
    objc_setAssociatedObject(self, @selector(animatedCount), @(animatedCount), OBJC_ASSOCIATION_ASSIGN);
}

@end
