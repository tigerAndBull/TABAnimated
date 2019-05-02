//
//  NestCollectionViewController.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/12/31.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "NestCollectionViewController.h"

#import "NestCollectionViewCell.h"

#import "TABAnimated.h"

#import <TABKit/TABKit.h>

@interface NestCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation NestCollectionViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initUI];
    
    // 假设3秒后，获取到数据了，代码具体位置看你项目了。
    [self performSelector:@selector(afterGetData) withObject:nil afterDelay:3.0];
}

#pragma mark - Target Methods

- (void)afterGetData {
    for (int i = 0; i < 10; i++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [array addObject:@"test.jpg"];
        [array addObject:@"test.jpg"];
        [array addObject:@"test.jpg"];
        [array addObject:@"test.jpg"];
        [array addObject:@"test.jpg"];
        [array addObject:@"test.jpg"];
        [self.dataArray addObject:array];
    }
    [self.collectionView tab_endAnimation];
}


#pragma mark - UICollectionViewDelegate & DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (collectionView.tabAnimated.isAnimating) {
        return 3;
    }
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [NestCollectionViewCell cellSize];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NestCollectionViewCell *cell = [NestCollectionViewCell cellWithIndexPath:indexPath atCollectionView:collectionView];
    
    NSMutableArray *array = self.dataArray[indexPath.section];
    [cell updateCellWithData:array];
    
    return cell;
}

#pragma mark - Initize Methods

- (void)initData {
    _dataArray = [NSMutableArray array];
}

/**
 initialize view
 初始化视图
 */
- (void)initUI {
    [self.view addSubview:self.collectionView];
    [NestCollectionViewCell registerCellInCollectionView:self.collectionView];
    [self.collectionView tab_startAnimation];
}

#pragma mark - Lazy Methods

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight - kNavigationHeight) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        _collectionView.tabAnimated = [TABCollectionAnimated animatedWithCellClass:[NestCollectionViewCell class] cellSize:[NestCollectionViewCell cellSize]];
    }
    return _collectionView;
}

@end
