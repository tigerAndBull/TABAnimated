//
//  LabWithLinesViewController.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/10/22.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "LabWithLinesViewController.h"

#import "TABAnimated.h"
#import "LabWithLinesViewCell.h"
#import <TABKit/TABKit.h>

#import "Game.h"

@interface LabWithLinesViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *dataArray;
}

@property (nonatomic,strong) UITableView *mainTV;

@end

@implementation LabWithLinesViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self initUI];
    
    // 假设3秒后，获取到数据了，代码具体位置看你项目了。
    [self performSelector:@selector(afterGetData) withObject:nil afterDelay:3.0];
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
    for (int i = 0; i < 20; i ++) {
        
        Game *game = [[Game alloc]init];
        game.gameId = [NSString stringWithFormat:@"%d",i];
        game.title = [NSString stringWithFormat:@"这里是赛事标题%d",i+1];
        game.cover = @"test.jpg";
        [dataArray addObject:game];
    }
    
    [self.mainTV tab_endAnimation];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

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
    
    static NSString *str = @"LabWithLinesViewCell";
    LabWithLinesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[LabWithLinesViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // 在加载动画的时候，即未获得数据时，不要走加载控件数据的方法
    if (!self.mainTV.isAnimating) {
        [cell initWithData:dataArray[indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    [self.view addSubview:self.mainTV];
    [self.mainTV tab_startAnimation];
}

#pragma mark - Lazy Methods

- (UITableView *)mainTV {
    if (!_mainTV) {
        _mainTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _mainTV.delegate = self;
        _mainTV.dataSource = self;
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
