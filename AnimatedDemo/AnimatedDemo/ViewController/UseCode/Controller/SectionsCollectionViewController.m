//
//  SectionsCollectionViewController.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/5/1.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "SectionsCollectionViewController.h"
#import "DailyCollectionViewCell.h"
#import "CourseCollectionViewCell.h"

#import "TABAnimated.h"
#import <TABKit/TABKit.h>

@interface SectionsCollectionViewController () <UICollectionViewDelegate,UICollectionViewDataSource> {
    NSMutableArray *dataArray;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation SectionsCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initUI];
    
    // 假设3秒后，获取到数据
    [self performSelector:@selector(afterGetData) withObject:nil afterDelay:3];
}

- (void)dealloc {
    NSLog(@"========= delloc =========");
}

#pragma mark - Target Methods

/**
 获取到数据后
 */
- (void)afterGetData {
    
    // 模拟数据
    for (int i = 0; i < 5; i ++) {
        [dataArray addObject:[NSObject new]];
    }
    
    // 停止动画,并刷新数据
    [self.collectionView tab_endAnimation];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [CourseCollectionViewCell cellSize];
    }
    return [DailyCollectionViewCell cellSize];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        CourseCollectionViewCell *cell = [CourseCollectionViewCell cellWithIndexPath:indexPath atCollectionView:collectionView];
        [cell updateWithModel:nil];
        return cell;
    }
    
    DailyCollectionViewCell *cell = [DailyCollectionViewCell cellWithIndexPath:indexPath atCollectionView:collectionView];
    [cell updateWithModel:nil];
    return cell;
}

#pragma mark - Initize Methods

- (void)initData {
    dataArray = [NSMutableArray array];
}

/**
 initialize view
 初始化视图
 */
- (void)initUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView tab_startAnimation];
}

#pragma mark - Lazy Methods

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight-kNavigationHeight)            collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        NSArray *classArray = @[[CourseCollectionViewCell class],[DailyCollectionViewCell class]];
        NSArray *sizeArray = @[[NSValue valueWithCGSize:[CourseCollectionViewCell cellSize]],
                               [NSValue valueWithCGSize:[DailyCollectionViewCell cellSize]]];
        _collectionView.tabAnimated = [TABCollectionAnimated
                                       animatedWithCellClassArray:classArray
                                       cellSizeArray:sizeArray
                                       animatedCountArray:@[@(1),@(1)]];
        _collectionView.tabAnimated.categoryBlock = ^(UIView * _Nonnull view) {
            
            if ([view isKindOfClass:[CourseCollectionViewCell class]]) {

            }
            
            if ([view isKindOfClass:[DailyCollectionViewCell class]]) {
                view.animations(1,3).height(14);
                view.animation(2).down(6);
                view.animation(1).up(1);
                view.animation(3).up(6);
            }
        };
        
    }
    return _collectionView;
}


@end
