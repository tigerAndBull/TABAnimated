//
//  TABAnimated.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/9/15.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#ifndef TABAnimated_h
#define TABAnimated_h

#import "UIView+Animated.h"
#import "UITableView+Animated.h"
#import "UICollectionView+Animated.h"

#import "UIView+TABLayoutSubviews.h"
#import "UITableViewCell+TABLayoutSubviews.h"
#import "UICollectionViewCell+TABLayoutSubviews.h"

#import "UIView+TABControlAnimation.h"

#import "TABViewAnimated.h"
#import "TABAnimationMethod.h"
#import "TABManagerMethod.h"

/*
 v1.9.1 模版功能新增
 */
#import "TABAnimatedObject.h"
#import "TABBaseCollectionViewCell.h"
#import "TABBaseTableViewCell.h"

/*
 v2.0.0 新增
 */
#import "TABLayer.h"
#import "TABTemplateCollectionViewCell.h"
#import "TABTemplateTableViewCell.h"

#define tab_suppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#endif /* TABAnimated_h */
