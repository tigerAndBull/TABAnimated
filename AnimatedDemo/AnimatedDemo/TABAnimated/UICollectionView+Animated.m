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
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        // Gets the viewDidLoad method to the class,whose type is a pointer to a objc_method structure.
        Method originMethod = class_getInstanceMethod([self class], @selector(setDelegate:));
        // Get the method you created.
        Method newMethod = class_getInstanceMethod([self class], @selector(tab_setDelegate:));
        
        IMP newIMP = method_getImplementation(newMethod);
        
        BOOL isAdd = class_addMethod([self class], @selector(tab_setDelegate:), newIMP, method_getTypeEncoding(newMethod));
        
        if (isAdd) {
            // replace
            class_replaceMethod([self class], @selector(setDelegate:), newIMP, method_getTypeEncoding(newMethod));
        } else {
            // exchange
            method_exchangeImplementations(originMethod, newMethod);
        }
        
    });
}

- (void)tab_setDelegate:(id<UICollectionViewDelegate>)delegate {
    
    SEL oldSectionSelector = @selector(collectionView:numberOfItemsInSection:);
    SEL newSectionSelector = @selector(tab_collectionView:numberOfItemsInSection:);
    
    if ([self respondsToSelector:newSectionSelector]) {
        [self exchangeCollectionDelegateMethod:oldSectionSelector withNewSel:newSectionSelector withCollectionDelegate:delegate];
    }

    [self tab_setDelegate:delegate];
}

#pragma mark - TABCollectionViewDelegate

- (NSInteger)tab_collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView.animatedStyle == TABCollectionViewAnimationStart) {
        return collectionView.animatedCount;
    }
    return [self tab_collectionView:collectionView numberOfItemsInSection:section];
}

#pragma mark - Private Methods

- (void)exchangeCollectionDelegateMethod:(SEL)oldSelector
                              withNewSel:(SEL)newSelector
                  withCollectionDelegate:(id<UICollectionViewDelegate>)delegate {
    
    Method oldMethod_del = class_getInstanceMethod([delegate class], oldSelector);
    Method newMethod = class_getInstanceMethod([self class], newSelector);
    IMP oldImp = method_getImplementation(oldMethod_del);
    
    if ([self isKindOfClass:[delegate class]]) {
        // If self.delegate = self,no animation.
        // method_exchangeImplementations(oldMethod_del, newMethod);
    } else {
        
        // If the child is not imp new Method, add imp.
        BOOL isSuccess = class_addMethod([delegate class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
        
        if (isSuccess) {
            
            class_addMethod([delegate class], newSelector, oldImp, method_getTypeEncoding(oldMethod_del));
            
        } else {
            
            // If the child is not imp old Method, add imp.
            BOOL isVictory = class_addMethod([delegate class], newSelector, class_getMethodImplementation([delegate class], oldSelector), method_getTypeEncoding(oldMethod_del));
            if (isVictory) {
                // exchange
                class_replaceMethod([delegate class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
            }
        }
    }
}

#pragma mark - Getter / Setter

- (TABViewAnimationStyle)animatedStyle {
    NSNumber *value = objc_getAssociatedObject(self, @selector(animatedStyle));
    return value.intValue;
}

- (void)setAnimatedStyle:(TABViewAnimationStyle)animatedStyle {
    
    // If the animation started, disable touch events.
    if (animatedStyle == 4) {
        [self setScrollEnabled:NO];
        [self setAllowsSelection:NO];
    } else {
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

- (NSInteger)sectionCount {
    NSNumber *value = objc_getAssociatedObject(self, @selector(sectionCount));
    return (value.integerValue == 0)?(3):(value.integerValue);
}

- (void)setSectionCount:(NSInteger)sectionCount {
    objc_setAssociatedObject(self, @selector(sectionCount), @(sectionCount), OBJC_ASSOCIATION_ASSIGN);
}

@end
