//
//  DelegateSelfCollectionViewController.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/10/1.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "DelegateSelfCollectionViewController.h"

#import "Game.h"
#import "TestCollectionView.h"
#import "NewsCollectionViewCell.h"

#import "TABAnimated.h"
#import <TABKit/TABKit.h>

@interface DelegateSelfCollectionViewController ()

@property (nonatomic, strong) TestCollectionView *collectionView;

@end

@implementation DelegateSelfCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    
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

#pragma mark - Target Methods

/**
 获取到数据后
 */
- (void)afterGetData {
    
    // 模拟数据
    NSMutableArray *dataArray = @[].mutableCopy;
    for (int i = 0; i < 10; i ++) {
        Game *game = [[Game alloc]init];
        game.gameId = [NSString stringWithFormat:@"%d",i];
        game.title = [NSString stringWithFormat:@"这里是测试数据%d",i+1];
        game.cover = @"test.jpg";
        game.viewSize = [NewsCollectionViewCell cellSize];
        [dataArray addObject:game];
    }
    self.collectionView.dataArray = dataArray;
    // 停止动画,并刷新数据
    [self.collectionView tab_endAnimationEaseOut];
}

#pragma mark - Initize Methods

/**
 initialize view
 初始化视图
 */
- (void)initUI {
    [self.view addSubview:self.collectionView];
}

#pragma mark - Lazy Methods

- (TestCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[TestCollectionView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight-kNavigationHeight)            collectionViewLayout:layout];
        
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor tab_normalDynamicBackgroundColor];
        
        _collectionView.cellName = @"NewsCollectionViewCell";
        
        _collectionView.tabAnimated = [TABCollectionAnimated animatedWithCellClass:[NewsCollectionViewCell class] cellSize:[NewsCollectionViewCell cellSize]];
        
//        _collectionView.tabAnimated.animatedCount = 10;
        _collectionView.tabAnimated.canLoadAgain = YES;
        _collectionView.tabAnimated.adjustBlock = ^(TABComponentManager * _Nonnull manager) {
            manager.animation(1).reducedWidth(20).down(2);
            manager.animation(2).reducedWidth(-10).up(1);
            manager.animation(3).down(5).line(4);
            manager.animations(4,3).radius(3).down(5);
            manager.animations(4,3).placeholder(@"placeholder.png");
        };
    }
    return _collectionView;
}

@end
