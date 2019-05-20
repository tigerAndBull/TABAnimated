//
//  SectionsCollectionViewController.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/5/1.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "SectionsCollectionViewController.h"

#import "NestCollectionViewCell.h"
#import "LawyerCollectionViewCell.h"

#import "TABAnimated.h"
#import <TABKit/TABKit.h>
#import "Game.h"

@interface SectionsCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource> {
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
    [self performSelector:@selector(afterGetData) withObject:nil afterDelay:1.];
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
    Game *game = [[Game alloc]init];
    game.title = [NSString stringWithFormat:@"进击的巨人part2"];
    game.cover = @"test.jpg";
    [dataArray addObject:game];
    
    // 停止动画,并刷新数据
    [self.collectionView tab_endAnimationWithSection:0];
    [self performSelector:@selector(afterGetDataSecond) withObject:nil afterDelay:0.5];
}

- (void)afterGetDataSecond {
    [self.collectionView tab_endAnimationWithSection:1];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return dataArray.count;
    }
    return 3;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return [LawyerCollectionViewCell cellSize];
    }
    return [NestCollectionViewCell cellSize];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        LawyerCollectionViewCell *cell = [LawyerCollectionViewCell cellWithIndexPath:indexPath atCollectionView:collectionView];
        [cell updateWithModel:[NSNull null]];
        return cell;
    }
    
    NestCollectionViewCell *cell = [NestCollectionViewCell cellWithIndexPath:indexPath atCollectionView:collectionView];

    NSMutableArray *array = @[].mutableCopy;
    for (int i = 0; i < 10; i ++) {
        [array addObject:[NSString stringWithFormat:@"test%ld.jpg",indexPath.row]];
    }
    
    [cell updateCellWithData:array];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.frame.size.width, 60);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                          withReuseIdentifier:@"header"
                                                                                 forIndexPath:indexPath];
    header.backgroundColor = [UIColor clearColor];
    
    for (UIView *view in header.subviews) {
        [view removeFromSuperview];
    }
    
    UILabel *lab = [header viewWithTag:1000];
    if (!lab) {
        lab = [[UILabel alloc] init];
        lab.frame = CGRectMake(kWidth(15)+3+4, 10, 100, 50);
        lab.font = kBlodFont(18);
        lab.textColor = [UIColor blackColor];
        lab.tag = 1000;
        [header addSubview:lab];
    }
    lab.text = [self headTitleArray][indexPath.section];
    
    UIView *view = [header viewWithTag:1001];
    if (!view) {
        view = [[UIView alloc] init];
        view.frame = CGRectMake(kWidth(15), 10+8+10, 3, 14);
        view.backgroundColor = kColor(0xE74E46FF);
        view.layer.cornerRadius = 1.5f;
        view.tag = 1001;
        [header addSubview:view];
    }
    
    return header;
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

- (NSArray <NSString *> *)headTitleArray {
    return @[
             @"推荐动漫",
             @"高清壁纸",
             ];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kScreenWidth, kScreenHeight-kNavigationHeight)            collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        
        NSArray *classArray = @[
                                [LawyerCollectionViewCell class],
                                [NestCollectionViewCell class],
                                ];
        NSArray *sizeArray = @[
                               [NSValue valueWithCGSize:[LawyerCollectionViewCell cellSize]],
                               [NSValue valueWithCGSize:[NestCollectionViewCell cellSize]],
                               ];
        
        _collectionView.tabAnimated = [TABCollectionAnimated
                                       animatedWithCellClassArray:classArray
                                       cellSizeArray:sizeArray
                                       animatedCountArray:@[@(1),@(3)]];
        _collectionView.tabAnimated.categoryBlock = ^(UIView * _Nonnull view) {
            
            if ([view isKindOfClass:[LawyerCollectionViewCell class]]) {
                view.animation(1).height(12).down(-2).reducedWidth(-90);
                view.animation(2).height(12).down(7).reducedWidth(-30);
                view.animation(3).height(12).down(-2).reducedWidth(150);
                view.animations(5,3).down(4).right(30);
            }
        };
    }
    return _collectionView;
}

@end
