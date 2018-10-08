//
//  MoreTableViewController.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/10/8.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "MoreTableViewController.h"

#import "TABAnimated.h"

#import "TestTableViewCell.h"

@interface MoreTableViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableOne;
@property (nonatomic,strong) UITableView *tableTwo;

@end

@implementation MoreTableViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"多个UITableView 示例";
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

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *lab = [[UILabel alloc]init];
    if ([tableView isEqual:_tableOne]) {
        lab.text = [NSString stringWithFormat:@"table 1"];
    }else {
        lab.text = [NSString stringWithFormat:@"table 2"];
    }
    lab.font = tab_kFont(16);
    return lab;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *str = @"TestTableViewCell";
    TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[TestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Initize Methods

/**
 initialize view
 初始化视图
 */
- (void)initUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableOne];
    [self.view addSubview:self.tableTwo];
}

#pragma mark - Lazy Methods

- (UITableView *)tableOne {
    if (!_tableOne) {
        _tableOne = [[UITableView alloc] initWithFrame:CGRectMake(0, 88+5, tab_kScreenWidth, 200) style:UITableViewStyleGrouped];
        _tableOne.animatedStyle = TABTableViewAnimationStart;  // 开启动画
        _tableOne.delegate = self;
        _tableOne.dataSource = self;
        _tableOne.rowHeight = 100;
        _tableOne.backgroundColor = [UIColor whiteColor];
        _tableOne.estimatedRowHeight = 0;
        _tableOne.estimatedSectionFooterHeight = 0;
        _tableOne.estimatedSectionHeaderHeight = 0;
        _tableOne.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableOne;
}

- (UITableView *)tableTwo {
    if (!_tableTwo) {
        _tableTwo = [[UITableView alloc] initWithFrame:CGRectMake(0, 88+200+20+5, tab_kScreenWidth, 200) style:UITableViewStyleGrouped];
        _tableTwo.animatedStyle = TABTableViewAnimationStart;  // 开启动画
        _tableTwo.delegate = self;
        _tableTwo.dataSource = self;
        _tableTwo.rowHeight = 100;
        _tableTwo.backgroundColor = [UIColor whiteColor];
        _tableTwo.estimatedRowHeight = 0;
        _tableTwo.estimatedSectionFooterHeight = 0;
        _tableTwo.estimatedSectionHeaderHeight = 0;
        _tableTwo.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableTwo;
}

@end
