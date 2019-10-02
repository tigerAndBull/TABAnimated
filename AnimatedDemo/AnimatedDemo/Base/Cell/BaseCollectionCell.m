//
//  JC_BaseCollectionCell.m
//
//  Created by tigerAndBull on 2017/12/15.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "BaseCollectionCell.h"

@implementation BaseCollectionCell

+ (NSString *)cellIdentifier {
    return [NSString stringWithFormat:@"%@", [self class]];
}

+ (NSNumber *)cellSizeByClass {
    return @(YES);
}

+ (NSValue *)cellSizeValue {
    return [NSValue valueWithCGSize:[self cellSize]];
}

+ (void)registerCellInCollectionView:(UICollectionView *)collectionView {
    [collectionView registerClass:[self class] forCellWithReuseIdentifier:[self cellIdentifier]];
}

+ (instancetype)cellWithIndexPath:(NSIndexPath *)indexPath atCollectionView:(UICollectionView *)collectionView {
    return [collectionView dequeueReusableCellWithReuseIdentifier:[self cellIdentifier] forIndexPath:indexPath];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)updateWithModel:(id)model {
    self.model = model;
}

+ (CGSize)cellSize {
    return CGSizeMake(1, 1);
}

@end
