//
//  DoubanCardViewController.m
//  TABAnimatedDemo
//
//  Created by tigerAndBull on 2019/5/15.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "DoubanCardViewController.h"

#import <TABKit/TABKit.h>
#import "TABAnimated.h"
#import "Game.h"

#import "CardCollectionViewCell.h"

@interface DoubanCardViewController ()<UICollectionViewDelegate,UICollectionViewDataSource> {
    NSMutableArray *dataArray;
}

@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation DoubanCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColor(0xEEEEEEFF);
    [self.view addSubview:self.collectionView];
    dataArray = @[].mutableCopy;
    [self.collectionView tab_startAnimation];
    
    [self performSelector:@selector(afterGetData) withObject:nil afterDelay:5.0];
}

- (void)reloadViewAnimated {
    _collectionView.tabAnimated.canLoadAgain = YES;
    [_collectionView tab_startAnimationWithCompletion:^{
        [self afterGetData];
    }];
}

#pragma mark - Target

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
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, kSafeAreaHeight+10, 0);
        
        if (@available(iOS 13.0, *)) {
            _collectionView.backgroundColor = [UIColor tab_getColorWithLightColor:kColor(0xEEEEEEFF) darkColor:UIColor.systemBackgroundColor];
        } else {
            _collectionView.backgroundColor = kColor(0xEEEEEEFF);
        }
        
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        // 初始化并设置动画相关属性
        _collectionView.tabAnimated =
        [TABCollectionAnimated animatedWithCellClass:[CardCollectionViewCell class]
                                            cellSize:[CardCollectionViewCell cellSize]];
        _collectionView.tabAnimated.superAnimationType = TABViewSuperAnimationTypeDrop;
        _collectionView.tabAnimated.animatedHeight = 6.0;
        _collectionView.tabAnimated.cancelGlobalCornerRadius = YES;
        _collectionView.tabAnimated.animatedColor = kColor(0xF3F3F3FF);
        _collectionView.tabAnimated.animatedBackViewCornerRadius = 5.;
        
//        _collectionView.tabAnimated.dropAnimationDuration = 0.34;
//        _collectionView.tabAnimated.dropAnimationDeepColor = kColor(0xEBEBEBFF);

        _collectionView.tabAnimated.adjustBlock = ^(TABComponentManager * _Nonnull manager) {
            // 一旦豆瓣动画队列中 其中一个元素的dropIndex被修改了，那么其他元素大概率需要重新设置
            // 将左侧图片移除豆瓣动画变色队列
            manager.animation(0).removeOnDrop();
            manager.animations(1,2).remove();
            manager.animations(4,2).remove();
            manager.animation(3).up(50).lastLineScale(0.7).width(200).dropFromIndex(0).space(10.);
        };
        
    }
    return _collectionView;
}

@end
