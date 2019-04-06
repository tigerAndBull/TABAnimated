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

@protocol UICollectionViewAnimatedDelegate <NSObject>

@optional
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfAnimatedItemsInSection:(NSInteger)section;

@end

@interface UICollectionView (Animated)

@property (nonatomic,weak) id<UICollectionViewAnimatedDelegate> animatedDelegate;

@end

NS_ASSUME_NONNULL_END
