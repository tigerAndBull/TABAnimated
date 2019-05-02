//
//  JC_BaseCollectionCell.m
//
//  Created by tigerAndBull on 2017/12/15.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCollectionCell : UICollectionViewCell

@property (nonatomic, strong) id model;

+ (NSString *)cellIdentifier;
+ (void)registerCellInCollectionView:(UICollectionView *)collectionView;
- (void)updateWithModel:(id)model;
+ (CGSize)cellSize;
+ (instancetype)cellWithIndexPath:(NSIndexPath *)indexPath atCollectionView:(UICollectionView *)collectionView;

@end
