//
//  DoubanCollectionViewController.m
//  TABAnimatedDemo
//
//  Created by tigerAndBull on 2019/5/15.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "DoubanCollectionViewController.h"
#import "NewsCollectionViewCell.h"

#import "TABAnimated.h"
#import "Game.h"
#import <TABKit/TABKit.h>

@interface DoubanCollectionViewController () <UICollectionViewDelegate,UICollectionViewDataSource> {
    NSMutableArray *dataArray;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation DoubanCollectionViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self initUI];
    
    // 假设3秒后，获取到数据
    [self performSelector:@selector(afterGetData) withObject:nil afterDelay:5.];
}

- (void)reloadViewAnimated {
    _collectionView.tabAnimated.canLoadAgain = YES;
    [_collectionView tab_startAnimationWithCompletion:^{
        [self afterGetData];
    }];
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [NewsCollectionViewCell cellSize];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsCollectionViewCell *cell = [NewsCollectionViewCell cellWithIndexPath:indexPath atCollectionView:collectionView];
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
    [self.view addSubview:self.collectionView];
    [self.collectionView tab_startAnimation];
}

#pragma mark - Lazy Methods

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight-kNavigationHeight)            collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        _collectionView.tabAnimated = [TABCollectionAnimated animatedWithCellClass:[NewsCollectionViewCell class] cellSize:[NewsCollectionViewCell cellSize]];
        _collectionView.tabAnimated.cancelGlobalCornerRadius = YES;
        _collectionView.tabAnimated.animatedHeight = 6.0;
        _collectionView.tabAnimated.superAnimationType = TABViewSuperAnimationTypeDrop;
        _collectionView.tabAnimated.animatedColor = kColor(0xF3F3F3FF);
        _collectionView.tabAnimated.animatedBackgroundColor = UIColor.whiteColor;
        
        if (@available(iOS 13.0, *)) {
            _collectionView.backgroundColor = [UIColor tab_getColorWithLightColor:kColor(0xEDEDEDFF) darkColor:UIColor.systemBackgroundColor];
            _collectionView.tabAnimated.darkAnimatedBackgroundColor = UIColor.secondarySystemBackgroundColor;
        } else {
            _collectionView.backgroundColor = kColor(0xEDEDEDFF);
        }
        _collectionView.tabAnimated.adjustBlock = ^(TABComponentManager * _Nonnull manager) {
            // 一旦动画队列中 其中一个元素的dropIndex被修改了，那么其他元素大概率需要重新设置
            // 设置0,1,2三个动画元素 第一个变色
            manager.animations(0,3).dropIndex(0);
            manager.animation(1).down(5).reducedWidth(20);
            manager.animation(2).reducedWidth(30);
            
            // 设置多行文本类型的动画组，变色下标从1开始
            manager.animation(3).line(3).height(6.0).down(12).space(12).dropFromIndex(1);
            manager.animations(4,3).remove();
        };
    }
    return _collectionView;
}

@end
