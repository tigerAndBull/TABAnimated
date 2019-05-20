//
//  SectionsTableViewController.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/5/9.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "SectionsTableViewController.h"
#import "TestTableViewCell.h"
#import "LabWithLinesViewCell.h"

#import "Game.h"
#import <TABKit/TABKit.h>

@interface SectionsTableViewController ()<UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *dataArray;
}

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation SectionsTableViewController

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
    for (int i = 0; i < 10; i ++) {
        Game *game = [[Game alloc]init];
        game.gameId = [NSString stringWithFormat:@"%d",i];
        game.title = [NSString stringWithFormat:@"这里是测试数据%d",i+1];
        game.cover = @"test.jpg";
        [dataArray addObject:game];
    }
    
    // 停止动画,并刷新数据
    [self.tableView tab_endAnimationWithSection:1];
}

#pragma mark - UITableViewDelegate & Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 5.;
    }
    return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *str = @"LabWithLinesViewCell";
        LabWithLinesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[LabWithLinesViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        Game *game = Game.new;
        game.title = @"这里是不需要动画的section";
        [cell initWithData:game];
        return cell;
    }
    
    static NSString *str = @"TestTableViewCell";
    TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[TestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell initWithData:dataArray[indexPath.row]];
    return cell;
}

#pragma mark - Initize Methods

/**
 load data
 加载数据
 */
- (void)initData {
    dataArray = @[].mutableCopy;
}

/**
 initize view
 视图初始化
 */
- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView tab_startAnimation];   // 开启动画
    NSLog(@"数量 %ld",self.tableView.tabAnimated.runAnimationSectionArray.count);
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // 设置tabAnimated相关属性
        // 部分section有动画
        _tableView.tabAnimated =
        [TABTableAnimated animatedWithCellClassArray:@[[TestTableViewCell class]]
                                     cellHeightArray:@[@(100)]
                                  animatedCountArray:@[@(1)]
                                animatedSectionArray:@[@(1)]];
        
        _tableView.tabAnimated.categoryBlock = ^(UIView * _Nonnull view) {
            if ([view isKindOfClass:[TestTableViewCell class]]) {
                view.animation(1).down(3).height(12);
                view.animation(2).height(12).width(110);
                view.animation(3).down(-5).height(12);
            }
        };
    }
    return _tableView;
}

@end
