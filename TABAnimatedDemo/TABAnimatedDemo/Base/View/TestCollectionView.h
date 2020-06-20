//
//  TestCollectionView.h
//  TABAnimatedDemo
//
//  Created by tigerAndBull on 2019/10/1.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestCollectionView : UICollectionView

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *cellName;

@end

NS_ASSUME_NONNULL_END
