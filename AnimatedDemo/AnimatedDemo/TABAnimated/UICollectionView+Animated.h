//
//  UICollectionView+Animated.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/10/12.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+Animated.h"

NS_ASSUME_NONNULL_BEGIN

@class TABAnimatedObject;

@protocol UICollectionViewAnimatedDelegate <NSObject>

@optional

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfAnimatedItemsInSection:(NSInteger)section;

@end

@interface UICollectionView (Animated)

@property (nonatomic,strong) TABAnimatedObject *tabAnimated;

@property (nonatomic,weak) id<UICollectionViewAnimatedDelegate> animatedDelegate;

@property (nonatomic,assign) NSInteger animatedCount;    // default is six. count of cell during animating.

- (void)registerTemplateClass:(Class)templateClass;

- (void)registerTemplateClassArray:(NSArray <Class> *)classArray;

@end

NS_ASSUME_NONNULL_END
