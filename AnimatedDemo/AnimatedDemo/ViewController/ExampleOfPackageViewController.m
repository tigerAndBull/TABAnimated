//
//  ExampleOfPackageViewController.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/11/17.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "ExampleOfPackageViewController.h"

#import "PackageTableViewCell.h"

#import "TABAnimated.h"
#import "TABMethod.h"

#import "Game.h"

@interface ExampleOfPackageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *mainTV;

@end

@implementation ExampleOfPackageViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    
    // 假设3秒后，获取到数据了，代码具体位置看你项目了。
    [self performSelector:@selector(afterGetData) withObject:nil afterDelay:3.0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"cell中使用封装组件 示例";
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

- (void)afterGetData {
    self.mainTV.animatedStyle = TABTableViewAnimationEnd;
    [self.mainTV reloadData];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *str = @"PackageTableViewCell";
    PackageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[PackageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (tableView.animatedStyle != TABTableViewAnimationStart) {
        // 省事，用了同一个类
        Game *headGame = [[Game alloc]init];
        headGame.title = [NSString stringWithFormat:@"头视图标题"];
        headGame.content = [NSString stringWithFormat:@"这里是头视图内容"];
        headGame.cover = @"head.jpg";
        [cell updateWithGame:headGame];
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
    [self.view addSubview:self.mainTV];
}

#pragma mark - Lazy Methods

- (UITableView *)mainTV {
    if (!_mainTV) {
        _mainTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, tab_kScreenWidth, tab_kScreenHeight) style:UITableViewStyleGrouped];
        _mainTV.animatedStyle = TABTableViewAnimationStart;  // 开启动画
        _mainTV.dataSource = self;
        _mainTV.delegate = self;
        _mainTV.rowHeight = 100;
        _mainTV.backgroundColor = [UIColor whiteColor];
        _mainTV.estimatedRowHeight = 0;
        _mainTV.estimatedSectionFooterHeight = 0;
        _mainTV.estimatedSectionHeaderHeight = 0;
        _mainTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mainTV;
}

@end
