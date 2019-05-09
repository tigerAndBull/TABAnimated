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

@property (nonatomic, strong) UITableView *mainTV;

@end

@implementation XibTestViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArray = [NSMutableArray array];
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
    
    // 停止动画,并刷新数据
    [self.mainTV tab_endAnimation];
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
        _mainTV.rowHeight = 115;
        _mainTV.backgroundColor = [UIColor whiteColor];
        _mainTV.estimatedSectionFooterHeight = 0;
        _mainTV.estimatedSectionHeaderHeight = 0;
        _mainTV.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // 注意！！！
        // xib 动画数组的顺序是组件关联xib文件的顺序。
        // 这里做了一个错误示范，有坑慎入。
        _mainTV.tabAnimated = [TABTableAnimated animatedWithCellClass:[XIBTableViewCell class] cellHeight:115];
        _mainTV.tabAnimated.cancelGlobalCornerRadius = YES;
        _mainTV.tabAnimated.animatedHeight = 14.f;
        _mainTV.tabAnimated.categoryBlock = ^(UIView * _Nonnull view) {
            
            // 注意！！！
            // xib 动画数组的顺序是组件关联xib文件的顺序。
            // 这里做了一个错误示范，有坑慎入。
            view.animation(4).width(80).down(4);
            view.animation(3).width(110).up(2);
        };
    }
    return _mainTV;
}

@end
