//
//  TemplateCardViewController.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/4/15.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "CardViewController.h"

#import <TABKit/TABKit.h>
#import "TABAnimated.h"
#import "MJRefresh.h"
#import "Game.h"

#import "CardCollectionViewCell.h"

@interface CardViewController ()<UICollectionViewDelegate,UICollectionViewDataSource> {
    NSMutableArray *dataArray;
}

@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation CardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColor(0xEEEEEEFF);
    [self.view addSubview:self.collectionView];
    dataArray = @[].mutableCopy;
    [self.collectionView tab_startAnimation];
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark - Target

- (void)loadData {
    [self performSelector:@selector(afterGetData) withObject:nil afterDelay:2.0];
}

- (void)afterGetData {
    
    [dataArray removeAllObjects];
    // 模拟数据
    for (int i = 0; i < 10; i ++) {
        Game *game = [[Game alloc]init];
        game.gameId = [NSString stringWithFormat:@"%d",i];
        game.title = [NSString stringWithFormat:@"新赛事开始啦《%d》",i+1];
        game.cover = @"test.jpg";
        game.content = @"ACM国际大学生程序设计竞赛已经发展成为全球最具影响力的大学生程序设计竞赛。赛事目前由方正集团赞助";
        [dataArray addObject:game];
    }
    
    [self.collectionView tab_endAnimation];
    // 解决结束刷新闪动问题
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*0.1), dispatch_get_main_queue(), ^{
        [self.collectionView.mj_header endRefreshing];
    });
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [CardCollectionViewCell cellSize];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return .1;
    }
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CardCollectionViewCell *cell = [CardCollectionViewCell cellWithIndexPath:indexPath atCollectionView:collectionView];
    [cell updateWithModel:dataArray[indexPath.row]];
    return cell;
}

#pragma mark - Getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight-kNavigationHeight)
                                             collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.bounces = YES;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, kSafeAreaHeight, 0);
        _collectionView.backgroundColor = kColor(0xEEEEEEFF);
        _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        // 初始化并设置动画相关属性
        _collectionView.tabAnimated =
        [TABCollectionAnimated animatedWithCellClass:[CardCollectionViewCell class]
                                            cellSize:[CardCollectionViewCell cellSize]];
        _collectionView.tabAnimated.categoryBlock = ^(UIView * _Nonnull view) {
            view.animation(1).width(60);
            view.animation(2).height(12).down(-5).reducedWidth(45);
            view.animation(3).up(5);
            view.animation(4).reducedWidth(40);
            view.animation(5).width(40).left(10);
        };
        
    }
    return _collectionView;
}

@end
