//
//  NestTableViewCell.m
//  TABAnimatedDemo
//
//  Created by tigerAndBull on 2020/5/5.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "NestTableViewCell.h"
#import "ImageCollectionViewCell.h"
#import "AppDelegate.h"
#import "TABAnimated.h"
#import "Masonry.h"
#import <TABKit/TABKit.h>

@interface NestTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSMutableArray *dataArray;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation NestTableViewCell

+ (CGFloat)cellHeight {
    return ((kScreenWidth-15*3-45)/2)*(3/2.0)+10;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
        make.top.mas_equalTo(self);
    }];
}

- (void)updateCellWithData:(NSMutableArray *)array {
    self->dataArray = array;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self->dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [ImageCollectionViewCell cellSize];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.1f;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = [ImageCollectionViewCell cellWithIndexPath:indexPath atCollectionView:collectionView];
    [cell.imgV setImage:[UIImage imageNamed:dataArray[indexPath.row]]];
    return cell;
}

#pragma mark - Init Method

- (void)initUI {
    self.contentView.backgroundColor = [UIColor tab_normalDynamicBackgroundColor];
    [self.contentView addSubview:self.collectionView];
    [ImageCollectionViewCell registerCellInCollectionView:self.collectionView];
}

#pragma mark - Lazy Method

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor tab_normalDynamicBackgroundColor];
        
        _collectionView.tabAnimated =
        [TABCollectionAnimated animatedWithCellClass:[ImageCollectionViewCell class]
                                            cellSize:[ImageCollectionViewCell cellSize]];
        // 如果不希望灰色背景，可以设置黑色（和背景相同的颜色，别设置透明色）
        if (@available(iOS 13.0, *)) {
            _collectionView.tabAnimated.darkAnimatedBackgroundColor = UIColor.systemBackgroundColor;
        }
        _collectionView.tabAnimated.isNest = YES;
        _collectionView.tabAnimated.animatedCount = 3;
    }
    return _collectionView;
}

@end
