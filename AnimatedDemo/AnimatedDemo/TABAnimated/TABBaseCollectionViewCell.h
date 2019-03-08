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

+ (NSString *)cellIdentifier;
+ (void)registerCellInCollectionView:(UICollectionView *)collectionView;
+ (instancetype)cellWithIndexPath:(NSIndexPath *)indexPath atCollectionView:(UICollectionView *)collectionView;
+ (NSValue *)cellSize;

@end

NS_ASSUME_NONNULL_END
