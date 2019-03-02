//
//  TestCollectionViewController.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/10/12.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "TestCollectionViewController.h"

#import "DailyCollectionViewCell.h"
#import "CourseCollectionViewCell.h"

#import "TABAnimated.h"

#import "Game.h"
#import <TABKit/TABKit.h>

@interface TestCollectionViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewAnimatedDelegate> {
    NSMutableArray *dataArray;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation TestCollectionViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self initUI];
    
    // 假设3秒后，获取到数据了，代码具体位置看你项目了。
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

// 注意看!!!!!! UICollectionViewAnimatedDelegate
// 注意看!!!!!! UICollectionViewAnimatedDelegate
// 注意看!!!!!! UICollectionViewAnimatedDelegate
#pragma mark - UICollectionViewAnimatedDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfAnimatedItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 4;
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
        return [CourseCollectionViewCell cellSizeWithWidth:kScreenWidth];
    }
    return [DailyCollectionViewCell cellSize];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        CourseCollectionViewCell *cell = [CourseCollectionViewCell cellWithIndexPath:indexPath atCollectionView:collectionView];
        return cell;
    }
    
    DailyCollectionViewCell *cell = [DailyCollectionViewCell cellWithIndexPath:indexPath atCollectionView:collectionView];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[CourseCollectionViewCell class]]) {
        CourseCollectionViewCell *myCell = (CourseCollectionViewCell *)cell;
        [myCell updateWithModel:nil];
    }
    DailyCollectionViewCell *myCell = (DailyCollectionViewCell *)cell;
    [myCell updateWithModel:nil];
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
    
    [self.collectionView registerClass:[CourseCollectionViewCell class] forCellWithReuseIdentifier:[CourseCollectionViewCell cellIdentifier]];
    [self.collectionView registerClass:[DailyCollectionViewCell class] forCellWithReuseIdentifier:[DailyCollectionViewCell cellIdentifier]];
    
    [self.collectionView tab_startAnimation];
}

#pragma mark - Lazy Methods

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight-kNavigationHeight)            collectionViewLayout:layout];
        _collectionView.animatedCount = 10;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.animatedDelegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}

@end
