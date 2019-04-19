//
//  BaseCollectionViewCell.h
//  yifu
//
//  Created by tigerAndBull on 2019/2/25.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TABBaseCollectionViewCell : UICollectionViewCell

/**
 子类需要重写，设置固定值
 
 @return package of animateding cell suze
 */
+ (NSValue *)cellSize;

// 开发者不需要关心
+ (NSString *)cellIdentifier;
+ (void)registerCellInCollectionView:(UICollectionView *)collectionView;
+ (instancetype)cellWithIndexPath:(NSIndexPath *)indexPath atCollectionView:(UICollectionView *)collectionView;

@end

NS_ASSUME_NONNULL_END
