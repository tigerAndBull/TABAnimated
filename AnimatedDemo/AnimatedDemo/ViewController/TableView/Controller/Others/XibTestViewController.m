//
//  XibTestViewController.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/10/7.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "XibTestViewController.h"
#import "XIBTableViewCell.h"

#import "TABAnimated.h"
#import "Game.h"
#import <TABKit/TABKit.h>

@interface XibTestViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *dataArray;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation XibTestViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArray = [NSMutableArray array];
    [self initUI];
    
    [self.tableView tab_startAnimationWithCompletion:^{
        [self afterGetData];
    }];
}

- (void)reloadViewAnimated {
    _tableView.tabAnimated.canLoadAgain = YES;
    [_tableView tab_startAnimationWithCompletion:^{
        [self afterGetData];
    }];
}

#pragma mark - Target Methods

/**
 获取到数据后
 */
- (void)afterGetData {
    
    [dataArray removeAllObjects];
    // 模拟数据
    for (int i = 0; i < 20; i ++) {
        
        Game *game = [[Game alloc]init];
        game.gameId = [NSString stringWithFormat:@"%d",i];
        game.title = [NSString stringWithFormat:@"这里是赛事标题%d",i+1];
        game.cover = @"test.jpg";
        [dataArray addObject:game];
    }
    
    // 停止动画,并刷新数据
    [self.tableView tab_endAnimationEaseOut];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *str = @"XIBTableViewCell";
    XIBTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];

    if (!cell) {
        NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"XIBTableViewCell" owner:self options:nil];
        cell = [cellArray objectAtIndex:0];
    }
    [cell updateCell];
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
    [self.view addSubview:self.tableView];
}

#pragma mark - Lazy Methods

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 115;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor tab_normalDynamicBackgroundColor];
        
        _tableView.tabAnimated = [TABTableAnimated animatedWithCellClass:[XIBTableViewCell class] cellHeight:130];
        _tableView.tabAnimated.adjustBlock = ^(TABComponentManager * _Nonnull manager) {
            manager.animation(3).width(100);
        };
    }
    return _tableView;
}

@end
