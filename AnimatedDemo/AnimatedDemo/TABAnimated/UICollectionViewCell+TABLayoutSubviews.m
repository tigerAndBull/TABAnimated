//
//  UICollectionViewCell+Animated.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/10/12.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "UICollectionViewCell+TABLayoutSubviews.h"

#import "UICollectionView+Animated.h"

#import "TABViewAnimated.h"

#import <objc/runtime.h>

@implementation UICollectionViewCell (TABLayoutSubviews)

+ (void)load {
    
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        // Gets the viewDidLoad method to the class,whose type is a pointer to a objc_method structure.
        Method originMethod = class_getInstanceMethod([self class], @selector(layoutSubviews));
        // Get the method you created.
        Method newMethod = class_getInstanceMethod([self class], @selector(tab_collection_layoutSubviews));
        
        IMP newIMP = method_getImplementation(newMethod);
        
        BOOL isAdd = class_addMethod([self class], @selector(tab_collection_layoutSubviews), newIMP, method_getTypeEncoding(newMethod));
        
        if (isAdd) {
            // replace
                class_replaceMethod([self class], @selector(layoutSubviews), newIMP, method_getTypeEncoding(newMethod));
        } else {
            // exchange
            method_exchangeImplementations(originMethod, newMethod);
            
        }
    });
}

#pragma mark - Exchange Method

- (void)tab_collection_layoutSubviews {

    [self tab_collection_layoutSubviews];
    
    // start animation/end animation
    dispatch_async(dispatch_get_main_queue(), ^{
        [[TABViewAnimated sharedAnimated]startOrEndCollectionAnimated:self];
    });
}

@end
