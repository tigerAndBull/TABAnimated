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
#import <TABKit/TABKit.h>

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

- (void)afterGetData {
    [self.mainTV tab_endAnimation];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

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
    
    // 省事，用了同一个类
    Game *headGame = [[Game alloc]init];
    headGame.title = [NSString stringWithFormat:@"头视图标题"];
    headGame.content = [NSString stringWithFormat:@"这里是头视图内容"];
    headGame.cover = @"head.jpg";
    [cell updateWithGame:headGame];
    
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
    [self.mainTV tab_startAnimation];
}

#pragma mark - Lazy Methods

- (UITableView *)mainTV {
    if (!_mainTV) {
        _mainTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _mainTV.dataSource = self;
        _mainTV.delegate = self;
        _mainTV.rowHeight = 80;
        _mainTV.backgroundColor = [UIColor whiteColor];
        _mainTV.estimatedRowHeight = 0;
        _mainTV.estimatedSectionFooterHeight = 0;
        _mainTV.estimatedSectionHeaderHeight = 0;
        _mainTV.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _mainTV.tabAnimated = [TABTableAnimated animatedWithCellClass:[PackageTableViewCell class] cellHeight:80];
    }
    return _mainTV;
}

@end
