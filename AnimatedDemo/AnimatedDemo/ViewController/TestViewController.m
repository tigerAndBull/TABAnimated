//
//  TestViewController.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBulll. All rights reserved.
//

#import "TestViewController.h"
#import "TestTableViewCell.h"
#import "TABAnimated.h"
#import "TestHeadView.h"
#import "Game.h"

@interface TestViewController () <UITableViewDelegate,UITableViewDataSource> {
    
    NSMutableArray *dataArray;
}

@property (nonatomic,strong) TestHeadView *headView;

@property (nonatomic, strong) UITableView *mainTV;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    [self loadData];
    
    // 假设3秒后，获取到数据了，代码具体位置看你项目了。
    [self performSelector:@selector(afterGetData) withObject:nil afterDelay:8.0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"测试页面";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"==========  dealloc  ==========");
}

#pragma mark - Private Methods

/**
 获取到数据后
 */
- (void)afterGetData {
    
    //模拟数据
    for (int i = 0; i < 20; i ++) {
        
        Game *game = [[Game alloc]init];
        game.gameId = [NSString stringWithFormat:@"%d",i];
        game.title = [NSString stringWithFormat:@"这里是赛事标题%d",i+1];
        game.cover = @"test.jpg";
        [dataArray addObject:game];
    }
    
    //省事，用了同一个类
    Game *headGame = [[Game alloc]init];
    headGame.title = [NSString stringWithFormat:@"头视图标题"];
    headGame.content = [NSString stringWithFormat:@"这里是头视图内容"];
    headGame.cover = @"head.jpg";
    
    //停止动画,并刷新数据
    _mainTV.animatedStyle = TABTableViewAnimationEnd;
    [_mainTV reloadData];
    
    _headView.animatedStyle = TABViewAnimationEnd;
    [_headView initWithData:headGame];
    [_headView layoutSubviews];
}

#pragma mark - UITableView Delegate & Datasource

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
    
    static NSString *str = @"TestTableViewCell";
    TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[TestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //在加载动画的时候，即未获得数据时，不要走加载控件数据的方法
    if (_mainTV.animatedStyle != TABTableViewAnimationStart) {
        [cell initWithData:dataArray[indexPath.row]];
    }

    return cell;
}

#pragma mark - Events

#pragma mark - Initialize Methods

/**
 load data
 加载数据
 */
- (void)loadData {
    
    dataArray = [NSMutableArray array];
}

/**
 initialize view
 视图初始化
 */
- (void)initUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.mainTV];
}

#pragma mark - Setters / Getters

- (UITableView *)mainTV {
    if (!_mainTV) {
        _mainTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, tab_kScreenWidth, tab_kScreenHeight) style:UITableViewStyleGrouped];
        _mainTV.animatedStyle = TABTableViewAnimationStart;  //开启动画
        _mainTV.delegate = self;
        _mainTV.dataSource = self;
        _mainTV.rowHeight = 100;
        _mainTV.backgroundColor = [UIColor whiteColor];
        _mainTV.estimatedRowHeight = 0;
        _mainTV.estimatedSectionFooterHeight = 0;
        _mainTV.estimatedSectionHeaderHeight = 0;
        _mainTV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTV.tableHeaderView = self.headView;
    }
    return _mainTV;
}

- (TestHeadView *)headView {
    if (!_headView) {
        _headView = [[TestHeadView alloc]initWithFrame:CGRectMake(0, 0, tab_kScreenWidth, 90)];
        _headView.animatedStyle = TABViewAnimationStart;
    }
    return _headView;
}

@end
