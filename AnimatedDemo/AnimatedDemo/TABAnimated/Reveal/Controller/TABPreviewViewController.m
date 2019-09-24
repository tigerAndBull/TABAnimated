//
//  TABPreviewViewController.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/9/1.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABPreviewViewController.h"
#import "TABRevealChainManager.h"
#import "TABRevealChainModel.h"

#import "TABAnimated.h"

@interface TABPreviewViewController ()
<UITableViewDelegate,
UITableViewDataSource,
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation TABPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.closeBtn];
    
    NSObject *object = self.targetClass.new;
    if ([object isKindOfClass:[UITableViewCell class]]) {
        
        [self.view addSubview:self.tableView];
        TABTableAnimated *animated = [TABTableAnimated animatedWithCellClass:self.targetClass cellHeight:self.targetHeight];
        self.tableView.tabAnimated = animated;
        
        __weak typeof(self) weakSelf = self;
        self.tableView.tabAnimated.adjustBlock = ^(TABComponentManager * _Nonnull manager) {
            [weakSelf addChainCode:manager];
        };
        [self.tableView tab_startAnimation];
        
    }else {
        if ([object isKindOfClass:[UICollectionViewCell class]]) {
            
            CGFloat width = self.targetWidth > 0 ? self.targetWidth : [UIScreen mainScreen].bounds.size.width;
            
            [self.view addSubview:self.collectionView];
            TABCollectionAnimated *animated =
            [TABCollectionAnimated animatedWithCellClass:self.targetClass
                                                cellSize:CGSizeMake(width, self.targetHeight)];
            self.collectionView.tabAnimated = animated;
            
            __weak typeof(self) weakSelf = self;
            self.collectionView.tabAnimated.adjustBlock = ^(TABComponentManager * _Nonnull manager) {
                [weakSelf addChainCode:manager];
            };
            [self.collectionView tab_startAnimation];
            
        }else {
            
            CGFloat top = 100;
            UIView *view = (UIView *)object;
            if (self.targetWidth > 0. &&
                self.targetHeight > 0.) {
                view.frame = CGRectMake(0, top, self.targetWidth, self.targetHeight);
            }else {
                if (self.targetHeight > 0) {
                    view.frame = CGRectMake(0, top, [UIScreen mainScreen].bounds.size.width, self.targetHeight);
                }
            }
            
            [self.view addSubview:view];
            view.tabAnimated = TABViewAnimated.new;
            
            __weak typeof(self) weakSelf = self;
            view.tabAnimated.adjustBlock = ^(TABComponentManager * _Nonnull manager) {
                [weakSelf addChainCode:manager];
            };
            [view tab_startAnimation];
        }
    }
}

- (void)addChainCode:(TABComponentManager *)componentManager {
    for (TABRevealChainManager *chainManager in self.chainManagerArray) {
        switch (chainManager.managerType) {
            case TABRevealChainManagerOne:
                for (TABRevealChainModel *model in chainManager.chainModelArray) {
                    [self changeComponentLayerWithManager:componentManager
                                                withModel:model
                                                withIndex:[chainManager.targetString integerValue]];
                }
                break;
            case TABRevealChainManagerMoreAndContinuous:{
                NSArray <NSString *> *valueArray = [chainManager.targetString componentsSeparatedByString:@","];
                if (valueArray.count == 2) {
                    NSInteger index = [valueArray[0] integerValue];
                    NSInteger length = [valueArray[1] integerValue];
                    for (TABRevealChainModel *model in chainManager.chainModelArray) {
                        for (NSInteger i = index; i < index+length; i++) {
                            [self changeComponentLayerWithManager:componentManager
                                                        withModel:model
                                                        withIndex:i];
                        }
                    }
                }
            }
                break;
            case TABRevealChainManagerMoreNotContinuous:{
                NSArray <NSString *> *valueArray = [chainManager.targetString componentsSeparatedByString:@","];
                if (valueArray.count > 0) {
                    for (TABRevealChainModel *model in chainManager.chainModelArray) {
                        for (NSString *indexString in valueArray) {
                            [self changeComponentLayerWithManager:componentManager
                                                        withModel:model
                                                        withIndex:[indexString integerValue]];
                        }
                    }
                }
            }
                break;
        }
    }
}

- (void)changeComponentLayerWithManager:(TABComponentManager *)componentManager
                              withModel:(TABRevealChainModel *)model
                              withIndex:(NSInteger)index {
    NSString *chainName;
    TABBaseComponent *component = componentManager.baseComponentArray[index];
    if (model.chainType == TABRevealChainVoid) {
        chainName = [NSString stringWithFormat:@"preview_%@",model.chainName];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [component performSelector:NSSelectorFromString(chainName)];
#pragma clang diagnostic pop
    }else {
        chainName = [NSString stringWithFormat:@"preview_%@:",model.chainName];
        NSString *chainValue = (NSString *)model.chainValue;
        if (model.chainType == TABRevealChainColor) {
            NSArray <NSString *> *rgbArray = [model.chainValue componentsSeparatedByString:@","];
            if (rgbArray.count == 3) {
                UIColor *color = [UIColor colorWithRed:[rgbArray[0] floatValue]/255. green:[rgbArray[1] floatValue]/255. blue:[rgbArray[2] floatValue]/255. alpha:1.];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [component performSelector:NSSelectorFromString(chainName) withObject:color];
#pragma clang diagnostic pop
            }
        }else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [component performSelector:NSSelectorFromString(chainName) withObject:chainValue];
#pragma clang diagnostic pop
        }
    }
}

#pragma mark - UITableViewDelegate & Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *str = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return .1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = UICollectionViewCell.new;
    return cell;
}

#pragma mark - Target Methods

- (void)closeAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:
                      CGRectMake(0,
                                 CGRectGetMaxY(self.closeBtn.frame) + 5,
                                 [UIScreen mainScreen].bounds.size.width,
                                 [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(self.closeBtn.frame) - 5)
                                                  style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc]
                           initWithFrame:CGRectMake(0,
                                                    CGRectGetMaxY(self.closeBtn.frame) + 5,
                                                    [UIScreen mainScreen].bounds.size.width,
                                                    [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(self.closeBtn.frame) - 5)
                    collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
    }
    return _collectionView;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        CGFloat width = 45;
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - width - 10, 30, width, 45)];
        [_closeBtn setImage:[UIImage imageNamed:@"tab_reveal_close_bigger"] forState:UIControlStateNormal];
        [_closeBtn sizeToFit];
        [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

@end
