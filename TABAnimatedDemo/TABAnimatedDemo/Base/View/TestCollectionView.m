//
//  TestCollectionView.m
//  TABAnimatedDemo
//
//  Created by tigerAndBull on 2019/10/1.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TestCollectionView.h"
#import "TestBaseModel.h"
#import "BaseCollectionCell.h"

@interface TestCollectionView()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@end

@implementation TestCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.delegate = self;
        self.dataSource = self;
        _dataArray = @[].mutableCopy;
    }
    return self;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark - UICollectionViewDelegate

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return .1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return .1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    SuppressPerformSelectorLeakWarning(
                                       SEL judgeSel = @selector(cellSizeByClass);
                                       SEL sel = @selector(cellSizeValue);
                                       NSNumber *num = [NSClassFromString(self.cellName) performSelector:judgeSel];
                                       if([num boolValue]) {
                                           return [(NSValue *)[NSClassFromString(self.cellName) performSelector:sel] CGSizeValue];
                                       }
                                      );
    
    TestBaseModel *model = self.dataArray[indexPath.row];
    return model.viewSize;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SEL sel = @selector(cellWithIndexPath:atCollectionView:);
    SuppressPerformSelectorLeakWarning(
                                       BaseCollectionCell *cell = [NSClassFromString(self.cellName)
                                                                       performSelector:sel
                                                                       withObject:indexPath
                                                                       withObject:collectionView];
                                       [cell performSelector:@selector(updateWithModel:) withObject:self.dataArray[indexPath.row]];
                                       return cell;
                                       );
}

@end
