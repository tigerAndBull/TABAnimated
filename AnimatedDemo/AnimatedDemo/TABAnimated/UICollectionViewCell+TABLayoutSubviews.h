//
//  UICollectionViewCell+Animated.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/10/12.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TABAnimationMethod.h"

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionViewCell (TABLayoutSubviews)

//修改 增加动画属性
@property (nonatomic,strong)TABAnimationMethod *tabAnimatedMethod;

@end

NS_ASSUME_NONNULL_END
