//
//  TemplateTableViewController.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/3/8.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import "TemplateTableViewController.h"

#import "TABAnimatedObject.h"
#import "TestTableViewCell.h"
#import "TABTemplateTableViewCell.h"
#import "TABAnimated.h"
#import "MJRefresh.h"

#import "Game.h"
#import <TABKit/TABKit.h>

@interface TemplateTableViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *dataArray;
}

@property (nonatomic,strong) UITableView *mainTV;

@end

@implementation TemplateTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self initUI];
    
    // 假设2秒后，获取到数据了，代码具体位置看你项目了。
    [self getData];
}

- (void)dealloc {
    NSLog(@"==========  dealloc  ==========");
}

#pragma mark - Target Methods

/**
 获取到数据后
 */
- (void)afterGetData {
    
    // 模拟数据
    for (int i = 0; i < 8; i ++) {
        Game *game = [[Game alloc]init];
        game.gameId = [NSString stringWithFormat:@"%d",i];
        game.title = [NSString stringWithFormat:@"这里是赛事标题%d",i+1];
        game.cover = @"test.jpg";
        [dataArray addObject:game];
    }
    
    // 停止动画,并刷新数据
    [self.mainTV tab_endAnimation];
    [self.mainTV.mj_header endRefreshing];
}

- (void)getData {
    [self performSelector:@selector(afterGetData) withObject:nil afterDelay:2.0];
}

#pragma mark - UITableViewDelegate & Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
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
    
    static NSString *str = @"TestTableViewCell";
    TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[TestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    TestTableViewCell *myCell = (TestTableViewCell *)cell;
    [myCell initWithData:dataArray[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Initize Methods

/**
 load data
 加载数据
 */
- (void)initData {
    dataArray = [NSMutableArray array];
}

/**
 initize view
 视图初始化
 */
- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainTV];
    [self.mainTV tab_startAnimation];   // 开启动画
    [self.mainTV.mj_header beginRefreshing];
}

#pragma mark - Lazy Methods

- (UITableView *)mainTV {
    if (!_mainTV) {
        _mainTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _mainTV.dataSource = self;
        _mainTV.delegate = self;
        _mainTV.estimatedRowHeight = 0;
        _mainTV.estimatedSectionFooterHeight = 0;
        _mainTV.estimatedSectionHeaderHeight = 0;
        _mainTV.backgroundColor = [UIColor whiteColor];
        _mainTV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTV.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    }
    return _mainTV;
}


@end
