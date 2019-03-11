//
//  UICollectionView+Animated.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/10/12.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "UICollectionView+Animated.h"
#import "UIView+Animated.h"
#import "UIView+TABControlAnimation.m"
#import "TABViewAnimated.h"

#import "TABAnimatedObject.h"
#import "TABBaseCollectionViewCell.h"

#import <objc/runtime.h>
#import "TABAnimated.h"

@implementation UICollectionView (Animated)

struct {
    unsigned int animatedSectionCountDelegate:1;
} collectionViewAnimatedDelegateRespondTo;

+ (void)load {
    
    // Ensure that the exchange method executed only once.
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        // Gets the viewDidLoad method to the class,whose type is a pointer to a objc_method structure.
        Method originMethod = class_getInstanceMethod([self class], @selector(setDelegate:));
        // Get the method you created.
        Method newMethod = class_getInstanceMethod([self class], @selector(tab_setDelegate:));
        
        method_exchangeImplementations(originMethod, newMethod);
    });
}

- (void)tab_setDelegate:(id<UICollectionViewDelegate>)delegate {
    
    SEL oldSectionSelector = @selector(collectionView:numberOfItemsInSection:);
    SEL newSectionSelector = @selector(tab_collectionView:numberOfItemsInSection:);
    
    SEL old = @selector(collectionView:willDisplayCell:forItemAtIndexPath:);
    SEL new = @selector(tab_collectionView:willDisplayCell:forItemAtIndexPath:);
    
    SEL oldCell = @selector(collectionView:cellForItemAtIndexPath:);
    SEL newCell = @selector(tab_collectionView:cellForItemAtIndexPath:);
    
    SEL oldHeightSel = @selector(collectionView:layout:sizeForItemAtIndexPath:);
    SEL newHeightSel = @selector(tab_collectionView:layout:sizeForItemAtIndexPath:);
    
    if ([self respondsToSelector:newSectionSelector]) {
        [self exchangeCollectionDelegateMethod:oldSectionSelector withNewSel:newSectionSelector withCollectionDelegate:delegate];
        [self exchangeCollectionDelegateMethod:old withNewSel:new withCollectionDelegate:delegate];
        [self exchangeCollectionDelegateMethod:oldCell withNewSel:newCell withCollectionDelegate:delegate];
        [self exchangeCollectionDelegateMethod:oldHeightSel withNewSel:newHeightSel withCollectionDelegate:delegate];
    }

    [self tab_setDelegate:delegate];
}

#pragma mark - TABCollectionViewDelegate

- (NSInteger)tab_collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView.isAnimating) {
        if (collectionView.delegate &&
            [collectionView.delegate respondsToSelector:@selector(collectionView:numberOfAnimatedItemsInSection:)]) {
            return [collectionView.animatedDelegate collectionView:collectionView numberOfAnimatedItemsInSection:section];
        }
        return collectionView.animatedCount;
    }
    return [self tab_collectionView:collectionView numberOfItemsInSection:section];
}

- (UICollectionViewCell *)tab_collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([TABViewAnimated sharedAnimated].isUseTemplate) {
        if (collectionView.animatedStyle == TABViewAnimationStart) {
            SEL sel = @selector(cellWithIndexPath:atCollectionView:);
            tab_suppressPerformSelectorLeakWarning(
                return [NSClassFromString(collectionView.tabAnimated.classNameArray[indexPath.section])
                        performSelector:sel
                        withObject:indexPath
                        withObject:collectionView];
            );
        }
        return [self tab_collectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
    return [self tab_collectionView:collectionView cellForItemAtIndexPath:indexPath];
}

- (CGSize)tab_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([TABViewAnimated sharedAnimated].isUseTemplate) {
        if (collectionView.animatedStyle == TABViewAnimationStart) {
            SEL sel = @selector(cellSize);
            tab_suppressPerformSelectorLeakWarning(
                NSValue *value = [NSClassFromString(collectionView.tabAnimated.classNameArray[indexPath.section]) performSelector:sel];
                return [value CGSizeValue];
            );
        }
        return [self tab_collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
    return [self tab_collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
}

- (void)tab_collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView.animatedStyle == TABViewAnimationStart) {
        return;
    }
    [self tab_collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
}

#pragma mark - Private Methods

- (void)exchangeCollectionDelegateMethod:(SEL)oldSelector
                              withNewSel:(SEL)newSelector
                  withCollectionDelegate:(id<UICollectionViewDelegate>)delegate {
    
    Method oldMethod = class_getInstanceMethod([delegate class], oldSelector);
    Method newMethod = class_getInstanceMethod([self class], newSelector);
    
    if ([self isKindOfClass:[delegate class]]) {
        method_exchangeImplementations(oldMethod, newMethod);
    }else {
        
        if (oldMethod == nil) {
            return;
        }
        
        // 代理对象添加newMethod，指向oldImp
        BOOL isVictory = class_addMethod([delegate class], newSelector, class_getMethodImplementation([delegate class], oldSelector), method_getTypeEncoding(oldMethod));
        if (isVictory) {
            // 添加成功后，将oldMethod指向当前类的新的
            class_replaceMethod([delegate class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
        }else {
            method_exchangeImplementations(oldMethod, newMethod);
        }
    }
}

#pragma mark - Public Method

- (void)registerTemplateClass:(Class)templateClass {
    
    [self registerClass:[templateClass class] forCellWithReuseIdentifier:NSStringFromClass(templateClass)];
    
    TABAnimatedObject *obj = [[TABAnimatedObject alloc] init];
    obj.className = NSStringFromClass(templateClass);
    self.tabAnimated = obj;
}

- (void)registerTemplateClassArray:(NSArray <Class> *)classArray {
    
    for (Class class in classArray) {
        [self registerClass:[class class] forCellWithReuseIdentifier:NSStringFromClass(class)];
    }
    
    TABAnimatedObject *obj = [[TABAnimatedObject alloc] init];
    NSMutableArray *array = [NSMutableArray array];
    for (Class class in classArray) {
        [array addObject:NSStringFromClass(class)];
    }
    obj.classNameArray = array.mutableCopy;
    self.tabAnimated = obj;
}

#pragma mark - Getter / Setter

- (void)setAnimatedStyle:(TABViewAnimationStyle)animatedStyle {
    
    // If the animation started, disable touch events.
    if (animatedStyle == TABViewAnimationStart ||
        animatedStyle == TABViewAnimationRunning) {
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

- (id<UICollectionViewAnimatedDelegate>)animatedDelegate {
    id<UICollectionViewAnimatedDelegate> delegate = objc_getAssociatedObject(self, @selector(animatedDelegate));
    return delegate;
}

- (void)setAnimatedDelegate:(id<UICollectionViewAnimatedDelegate>)animatedDelegate {

    if (self.animatedDelegate != animatedDelegate) {
        
        objc_setAssociatedObject(self, @selector(animatedDelegate), animatedDelegate, OBJC_ASSOCIATION_ASSIGN);
        
        collectionViewAnimatedDelegateRespondTo.animatedSectionCountDelegate = [animatedDelegate respondsToSelector:@selector(collectionView:numberOfAnimatedItemsInSection:)];
    }
}

- (TABAnimatedObject *)tabAnimated {
    return objc_getAssociatedObject(self, @selector(tabAnimated));
}

- (void)setTabAnimated:(TABAnimatedObject *)tabAnimated {
    objc_setAssociatedObject(self, @selector(tabAnimated),tabAnimated, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
