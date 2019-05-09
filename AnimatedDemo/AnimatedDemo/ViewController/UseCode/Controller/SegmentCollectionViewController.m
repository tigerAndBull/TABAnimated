//
//  TemplateCategoryCollectionViewController.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/4/15.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "SegmentCollectionViewController.h"

#import "JXCategoryTitleView.h"
#import "JXCategoryIndicatorLineView.h"

#import "LawyerArticleCollectionViewCell.h"
#import "LawyerCollectionViewCell.h"

#import "TABAnimated.h"
#import <TABKit/TABKit.h>

#import "MJRefresh.h"

#define categoryCount (self.categoryTitleArray.count)

@interface SegmentCollectionViewController ()<JXCategoryViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) JXCategoryTitleView *categoryView;
@property (nonatomic,strong) UIScrollView *mainScrollView;
@property (nonatomic,strong) NSMutableArray <UICollectionView *> *collectionViewArray;

@property (nonatomic,strong) NSMutableArray <NSMutableArray *> *dataCenterArray;
@property (nonatomic,strong) NSMutableArray <NSNumber *> *currentPageArray;

@property (nonatomic,strong) NSArray <NSString *> *categoryTitleArray;

@property (nonatomic,strong) UICollectionView *currentCollectionView;
@property (nonatomic,assign) NSInteger currentIndex;

@end

@implementation SegmentCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentIndex = 0;
    [self initUI];
    [self.currentCollectionView tab_startAnimation];
    [self.currentCollectionView.mj_header beginRefreshing];
    // 解决与手势冲突
    NSArray *gestureArray = self.navigationController.view.gestureRecognizers;
    for (UIGestureRecognizer *gestureRecognizer in gestureArray) {
        if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
            [self.mainScrollView.panGestureRecognizer requireGestureRecognizerToFail:gestureRecognizer];
        }
    }
}

- (void)dealloc {
    NSLog(@"========== delloc =========");
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.currentIndex = index;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*0.1), dispatch_get_main_queue(), ^{
        [self.currentCollectionView tab_startAnimation];
        [self.currentCollectionView.mj_header beginRefreshing];
    });
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataCenterArray[self.currentIndex].count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return .1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:self.collectionViewArray[0]]) {
        return [LawyerCollectionViewCell cellSize];
    }
    return [LawyerArticleCollectionViewCell cellSize];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([collectionView isEqual:self.collectionViewArray[0]]) {
        LawyerCollectionViewCell *cell = [LawyerCollectionViewCell cellWithIndexPath:indexPath atCollectionView:collectionView];
        [cell updateWithModel:self.dataCenterArray[0][indexPath.row]];
        return cell;
    }
    
    LawyerArticleCollectionViewCell *cell = [LawyerArticleCollectionViewCell cellWithIndexPath:indexPath atCollectionView:collectionView];
    [cell updateWithModel:self.dataCenterArray[1][indexPath.row]];
    return cell;
}

#pragma mark - Network

- (void)requestData {
    [self performSelector:@selector(afterGetData) withObject:nil afterDelay:2.0];
}

- (void)afterGetData {
    
    [self.dataCenterArray[self.currentIndex] removeAllObjects];
    for (NSInteger i = 0; i < 8; i++) {
        [self.dataCenterArray[self.currentIndex] addObject:NSObject.new];
    }
    
    [self.currentCollectionView tab_endAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*0.1), dispatch_get_main_queue(), ^{
        [self.currentCollectionView.mj_header endRefreshing];
    });
}

#pragma mark - Init Method

- (void)initUI {
    
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.categoryView];
    [self.view addSubview:self.mainScrollView];
    
    for (int i = 0; i < categoryCount; i ++) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                              collectionViewLayout:layout];
        collectionView.frame = CGRectMake(i*kScreenWidth, 0, kScreenWidth, self.mainScrollView.frame.size.height - 0);
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.bounces = YES;
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, kSafeAreaHeight+kNavigationHeight, 0);
        
        if (@available(iOS 11.0, *)) {
            collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        
        if (i == 0) {
            [collectionView registerClass:[LawyerCollectionViewCell class] forCellWithReuseIdentifier:[LawyerCollectionViewCell cellIdentifier]];
            collectionView.tabAnimated =
            [TABCollectionAnimated animatedWithCellClass:[LawyerCollectionViewCell class]
                                                cellSize:[LawyerCollectionViewCell cellSize]];
            collectionView.tabAnimated.canLoadAgain = YES;
            collectionView.tabAnimated.categoryBlock = ^(UIView * _Nonnull view) {
                view.animation(1).height(12).down(-2).reducedWidth(-90);
                view.animation(2).height(12).down(7).reducedWidth(-30);
                view.animation(3).height(12).down(-2).reducedWidth(150);
                view.animations(5,3).down(4).right(30);
            };
        }else {
            [collectionView registerClass:[LawyerArticleCollectionViewCell class] forCellWithReuseIdentifier:[LawyerArticleCollectionViewCell cellIdentifier]];
            collectionView.tabAnimated =
            [TABCollectionAnimated animatedWithCellClass:[LawyerArticleCollectionViewCell class]
                                                cellSize:[LawyerArticleCollectionViewCell cellSize]];
            collectionView.tabAnimated.canLoadAgain = YES;
            collectionView.tabAnimated.categoryBlock = ^(UIView * _Nonnull view) {
                view.animation(1).height(12).up(-3).width(60);
                view.animation(2).height(12).width(90).up(2);
                view.animation(3).up(10);
            };
        }
        
        collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
        collectionView.backgroundColor = UIColor.whiteColor;
        
        [self.collectionViewArray addObject:collectionView];
        [self.mainScrollView addSubview:collectionView];
    }
}

#pragma mark - Lazy Method

- (UICollectionView *)currentCollectionView {
    return self.collectionViewArray[self.currentIndex];
}

- (NSArray <NSString *> *)categoryTitleArray {
    return @[@"人物",@"文章"];
}

- (NSMutableArray *)collectionViewArray {
    if (!_collectionViewArray) {
        _collectionViewArray = [NSMutableArray array];
    }
    return _collectionViewArray;
}

- (NSMutableArray *)dataCenterArray {
    if (!_dataCenterArray) {
        _dataCenterArray = [NSMutableArray array];
        for (int i = 0; i < categoryCount; i++) {
            NSMutableArray *array = [NSMutableArray array];
            [_dataCenterArray addObject:array];
        }
    }
    return _dataCenterArray;
}

- (NSMutableArray *)currentPageArray {
    if (!_currentPageArray) {
        _currentPageArray = @[].mutableCopy;
        for (int i = 0; i < categoryCount; i++) {
            NSNumber *num = [[NSNumber alloc] initWithInteger:1];
            [_currentPageArray addObject:num];
        }
    }
    return _currentPageArray;
}

- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        UIScrollView *sv = [[UIScrollView alloc] init];
        [sv setFrame:CGRectMake(0,CGRectGetMaxY(self.categoryView.frame), self.view.bounds.size.width, self.view.bounds.size.height - self.categoryView.frame.size.height)];
        [sv setBackgroundColor:kBackColor];
        [sv setShowsVerticalScrollIndicator:NO];
        [sv setShowsHorizontalScrollIndicator:NO];
        [sv setPagingEnabled:YES];
        [sv setBounces:NO];
        [sv setDelegate:self];
        [sv setContentSize:CGSizeMake(kScreenWidth*categoryCount, sv.frame.size.height)];
        _mainScrollView = sv;
    }
    return _mainScrollView;
}

- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0,kNavigationHeight,kScreenWidth,40)];
        _categoryView.titleColorGradientEnabled = YES;
        _categoryView.titleLabelZoomEnabled = YES;
        _categoryView.titleLabelZoomScale = 1.0;
        _categoryView.titleColor = [UIColor grayColor];
        _categoryView.titleSelectedColor = [UIColor redColor];
        _categoryView.titles = self.categoryTitleArray;
        _categoryView.delegate = self;
        
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorLineWidth = 20;
        lineView.indicatorLineViewHeight = 3;
        lineView.indicatorLineViewColor = [UIColor redColor];
        _categoryView.indicators = @[lineView];
        _categoryView.contentScrollView = self.mainScrollView;
    }
    return _categoryView;
}

@end
