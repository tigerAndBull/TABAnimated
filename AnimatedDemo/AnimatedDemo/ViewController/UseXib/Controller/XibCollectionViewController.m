//
//  XibCollectionViewController.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/5/22.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "XibCollectionViewController.h"

#import "XibCollectionViewCell.h"

#import "MJRefresh.h"

@interface XibCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation XibCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = @[].mutableCopy;
    [self.view addSubview:self.collectionView];
    [self.collectionView tab_startAnimationWithCompletion:^{
        [self afterGetData];
    }];
}

/**
 获取到数据后
 */
- (void)afterGetData {
    
    // 模拟数据
    for (int i = 0; i < 20; i ++) {
        [self.dataArray addObject:NSObject.new];
    }
    
    [self.collectionView.mj_header endRefreshing];
    // 停止动画,并刷新数据
    [self.collectionView tab_endAnimation];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *str = @"XibCollectionViewCell";
    XibCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:str forIndexPath:indexPath];
    if (!cell) {
        NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:str owner:self options:nil];
        cell = [cellArray objectAtIndex:0];
    }
    cell.leftLab.text = @"111";
    cell.bottomLab.text = @"333";
    [cell.rightBtn setTitle:@"222" forState:UIControlStateNormal];
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth, 148);
}

#pragma mark - Lazy Methods

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)            collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        _collectionView.tabAnimated =
        [TABCollectionAnimated animatedWithCellClass:[XibCollectionViewCell class]
                                            cellSize:CGSizeMake(kScreenWidth, 148)];
        _collectionView.tabAnimated.canLoadAgain = YES;
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self.collectionView tab_startAnimationWithDelayTime:5. completion:^{
                // 请求数据
                // ...
                // 获得数据
                // ...
                [self afterGetData];
            }];
        }];
    }
    return _collectionView;
}


@end
