//
//  BaseCollectionViewCell.m
//  yifu
//
//  Created by tigerAndBull on 2019/2/25.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import "TABBaseCollectionViewCell.h"

#import "UIView+Animated.h"
#import "UITableView+Animated.h"
#import "UIView+TABControlAnimation.h"

#import "TABViewAnimated.h"
#import "TABManagerMethod.h"
#import "TABAnimationMethod.h"

#import "TABAnimatedObject.h"

@implementation TABBaseCollectionViewCell

+ (NSValue *)cellSize {
    return [NSValue valueWithCGSize:CGSizeMake(1, 1)];
}

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

@end
