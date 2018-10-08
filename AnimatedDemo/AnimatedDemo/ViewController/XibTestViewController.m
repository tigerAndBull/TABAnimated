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

@interface XibTestViewController () <UITableViewDelegate,UITableViewDataSource> {
    
    NSMutableArray *dataArray;
}

@property (nonatomic, strong) UITableView *mainTV;

@end

@implementation XibTestViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self initUI];
    
    // 假设3秒后，获取到数据了，代码具体位置看你项目了。
    [self performSelector:@selector(afterGetData) withObject:nil afterDelay:3.0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Xib 示例";
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)dealloc {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Target Methods

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
    
    //停止动画,并刷新数据
    _mainTV.animatedStyle = TABTableViewAnimationEnd;
    [_mainTV reloadData];
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
    
    //在加载动画的时候，即未获得数据时，不要走加载控件数据的方法
    if (_mainTV.animatedStyle != TABTableViewAnimationStart) {
        //这里刷新走刷新视图的方法
        
    }
    
    return cell;
}

#pragma mark - Initize Methods

- (void)addNotification {
    
}

- (void)initData {
    
    dataArray = [NSMutableArray array];
}

/**
 initialize view
 初始化视图
 */
- (void)initUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.mainTV];
}

#pragma mark - Lazy Methods

- (UITableView *)mainTV {
    if (!_mainTV) {
        _mainTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, tab_kScreenWidth, tab_kScreenHeight) style:UITableViewStyleGrouped];
        _mainTV.animatedStyle = TABTableViewAnimationStart;  //开启动画
        _mainTV.delegate = self;
        _mainTV.dataSource = self;
        _mainTV.rowHeight = 44;
        _mainTV.backgroundColor = [UIColor whiteColor];
        _mainTV.estimatedRowHeight = 0;
        _mainTV.estimatedSectionFooterHeight = 0;
        _mainTV.estimatedSectionHeaderHeight = 0;
        _mainTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mainTV;
}

@end
