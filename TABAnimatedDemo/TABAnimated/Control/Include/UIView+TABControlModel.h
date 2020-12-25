//
//  UIView+TABControlModel.h
//  TABAnimatedDemo
//
//  Created by tigerAndBull on 2020/3/27.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TABViewAnimated;
@interface UIView (TABControlModel)
@property (nonatomic, strong) TABViewAnimated * _Nullable tabAnimated;
@end

@class TABTableAnimated;
@interface UITableView (TABControlModel)
@property (nonatomic, strong) TABTableAnimated * _Nullable tabAnimated;
@end

@class TABCollectionAnimated;
@interface UICollectionView (TABControlModel)
@property (nonatomic, strong) TABCollectionAnimated * _Nullable tabAnimated;
@end

@class TABCollectionAnimated;
@interface UICollectionViewLayout (TABAnimated)
@property (nonatomic, strong) TABCollectionAnimated * _Nullable tabAnimated;
@end

NS_ASSUME_NONNULL_END
