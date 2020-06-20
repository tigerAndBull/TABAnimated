//
//  NestCollectionViewController.m
//  TABAnimatedDemo
//
//  Created by tigerAndBull on 2018/12/31.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "NestCollectionViewController.h"
#import "NestCollectionViewCell.h"
#import "TestCollectionReusableView.h"

#import "TABAnimated.h"
#import <TABKit/TABKit.h>
#import "TestHeadView.h"

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

#pragma mark - Target Methods

- (void)afterGetData {
    for (NSInteger i = 0; i < 10; i++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [array addObject:@"test.jpg"];
        [array addObject:@"test.jpg"];
        [array addObject:@"test.jpg"];
        [array addObject:@"test.jpg"];
        [array addObject:@"test.jpg"];
        [array addObject:@"test.jpg"];
        [self.dataArray addObject:array];
        [self.collectionView registerClass:[NestCollectionViewCell class]
                forCellWithReuseIdentifier:[NSString stringWithFormat:@"NestCollectionViewCell %ld",i]];
    }
    [self.collectionView tab_endAnimationEaseOut];
}


#pragma mark - UICollectionViewDelegate & DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [NestCollectionViewCell cellSize];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return .1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return .1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NestCollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"NestCollectionViewCell %ld",(long)indexPath.row]
                                              forIndexPath:indexPath];;
    
    NSMutableArray *array = self.dataArray[indexPath.row];
    [cell updateCellWithData:array];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.frame.size.width, 60);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    TestCollectionReusableView *header =
    [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                       withReuseIdentifier:@"header"                                  forIndexPath:indexPath];
    header.titleLab.text = @"测试嵌套";
    return header;
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
}

#pragma mark - Lazy Methods

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight - kNavigationHeight) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor tab_normalDynamicBackgroundColor];
        
        [_collectionView registerClass:[TestCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        
        _collectionView.tabAnimated =
        [TABCollectionAnimated animatedWithCellClass:[NestCollectionViewCell class]
                                            cellSize:[NestCollectionViewCell cellSize]];
        // 如果不希望灰色背景，可以设置黑色（和背景相同的颜色，别设置透明色）
        if (@available(iOS 13.0, *)) {
            _collectionView.tabAnimated.darkAnimatedBackgroundColor = UIColor.systemBackgroundColor;
        }
        _collectionView.tabAnimated.animatedCount = 1;
        _collectionView.tabAnimated.animatedSectionCount = 3;
        _collectionView.tabAnimated.superAnimationType = TABViewSuperAnimationTypeShimmer;
        // 添加区头动画，UICollectionReusableView类型, 同时支持普通的UIView
        [_collectionView.tabAnimated addHeaderViewClass:[TestCollectionReusableView class] viewSize:CGSizeMake(kScreenWidth, 60)];
        _collectionView.tabAnimated.adjustWithClassBlock = ^(TABComponentManager * _Nonnull manager, Class  _Nonnull __unsafe_unretained targetClass) {
            if (targetClass == [TestCollectionReusableView class]) {
                manager.animation(0).height(16).down(16).reducedWidth(20);
            }
        };
    }
    return _collectionView;
}

@end
