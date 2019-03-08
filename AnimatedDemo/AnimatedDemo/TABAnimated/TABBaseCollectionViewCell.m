//
//  BaseCollectionViewCell.m
//  yifu
//
//  Created by tigerAndBull on 2019/2/25.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import "TABBaseCollectionViewCell.h"

@implementation TABBaseCollectionViewCell

+ (NSString *)cellIdentifier {
    return [NSString stringWithFormat:@"%@", [self class]];
}

+ (void)registerCellInCollectionView:(UICollectionView *)collectionView {
    [collectionView registerClass:[self class] forCellWithReuseIdentifier:[self cellIdentifier]];
}

+ (instancetype)cellWithIndexPath:(NSIndexPath *)indexPath atCollectionView:(UICollectionView *)collectionView {
    return [collectionView dequeueReusableCellWithReuseIdentifier:[self cellIdentifier] forIndexPath:indexPath];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

+ (NSValue *)cellSize {
    return [NSValue valueWithCGSize:CGSizeMake(1, 1)];
}

@end
