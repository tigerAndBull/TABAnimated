//
//  TemplateCardViewController.m
//  TABAnimatedDemo
//
//  Created by tigerAndBull on 2019/4/15.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "CardViewController.h"

#import <TABKit/TABKit.h>
#import "TABAnimated.h"
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
    [self.view addSubview:self.collectionView];
    dataArray = @[].mutableCopy;
    
    // 启动动画
    // 默认延迟时间0.4s
    [self.collectionView tab_startAnimationWithCompletion:^{
        // 请求数据
        // ...
        // 获得数据
        // ...
        [self afterGetData];
    }];
}

- (void)reloadViewAnimated {
    _collectionView.tabAnimated.canLoadAgain = YES;
    [_collectionView tab_startAnimationWithCompletion:^{
        [self afterGetData];
    }];
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
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [CardCollectionViewCell cellSize];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(12, 12, 0, 12);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 12;
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
        _collectionView.backgroundColor = [UIColor tab_normalDynamicBackgroundColor];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, kSafeAreaHeight+10, 0);
        
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        // 初始化并设置动画相关属性
        _collectionView.tabAnimated =
        [TABCollectionAnimated animatedWithCellClass:[CardCollectionViewCell class]
                                            cellSize:[CardCollectionViewCell cellSize]];
        _collectionView.tabAnimated.adjustBlock = ^(TABComponentManager * _Nonnull manager) {
            manager.animation(1).width(60);
            manager.animation(2).height(12).down(-5).reducedWidth(45);
            manager.animation(3).up(5);
            manager.animation(4).reducedWidth(40);
            manager.animation(5).width(40).left(10);
        };
        
    }
    return _collectionView;
}

@end
