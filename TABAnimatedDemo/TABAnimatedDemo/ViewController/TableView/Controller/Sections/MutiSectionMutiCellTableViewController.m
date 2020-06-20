//
//  SectionsTableViewController.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/5/4.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "MutiSectionMutiCellTableViewController.h"

#import "TestTableViewCell.h"
#import "LabWithLinesViewCell.h"
#import "LawyerTableViewCell.h"
#import "LineTableViewHeaderFooterView.h"

#import "Game.h"
#import <TABKit/TABKit.h>

@interface MutiSectionMutiCellTableViewController ()<UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *dataArray;
    NSMutableArray *dataTwoArray;
}

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation MutiSectionMutiCellTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self initUI];
    
    // 假设3秒后，获取到数据了，代码具体位置看你项目了。
    [self performSelector:@selector(afterGetData) withObject:nil afterDelay:3.0];
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
    [dataTwoArray removeAllObjects];
    
    // 模拟数据
    for (int i = 0; i < 3; i ++) {
        Game *game = [[Game alloc]init];
        game.gameId = [NSString stringWithFormat:@"%d",i];
        game.title = [NSString stringWithFormat:@"这里是测试数据%d",i+1];
        game.cover = @"test.jpg";
        [dataArray addObject:game];
    }
    
    for (int i = 0; i < 3; i ++) {
        Game *game = [[Game alloc]init];
        game.gameId = [NSString stringWithFormat:@"%d",i];
        game.title = [NSString stringWithFormat:@"这里是测试数据%d",i+1];
        game.cover = @"test.jpg";
        [dataTwoArray addObject:game];
    }
    
    // 停止动画,并刷新数据
    [self.tableView tab_endAnimationWithIndex:0];
    [self performSelector:@selector(afterGetDataTwo) withObject:nil afterDelay:3.0];
}

- (void)afterGetDataTwo {
    [self.tableView tab_endAnimationWithIndex:1];
}

#pragma mark - UITableViewDelegate & Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return dataArray.count;
    }
    return dataTwoArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *str = @"LineTableViewHeaderFooterView";
    LineTableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:str];
    if (!headerView) {
        headerView = [[LineTableViewHeaderFooterView alloc] initWithReuseIdentifier:str];
    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *str = @"TestTableViewCell";
        TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[TestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell initWithData:dataArray[indexPath.row]];
        return cell;
    }
    
    static NSString *str = @"LawyerTableViewCell";
    LawyerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[LawyerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell updateWithModel:nil];
    return cell;
}

#pragma mark - Initize Methods

/**
 load data
 加载数据
 */
- (void)initData {
    dataArray = @[].mutableCopy;
    dataTwoArray = @[].mutableCopy;
}

/**
 initize view
 视图初始化
 */
- (void)initUI {
    [self.view addSubview:self.tableView];
    [self.tableView tab_startAnimation];   // 开启动画
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor tab_normalDynamicBackgroundColor];
        
        // 设置tabAnimated相关属性
        // 部分section有动画
        _tableView.tabAnimated =
        [TABTableAnimated animatedWithCellClassArray:@[[TestTableViewCell class], [LawyerTableViewCell class]]
           cellHeightArray:@[@([TestTableViewCell cellHeight]), @([LawyerTableViewCell cellHeight])]
        animatedCountArray:@[@2, @2]];
        _tableView.tabAnimated.adjustWithClassBlock = ^(TABComponentManager *manager, __unsafe_unretained Class targetClass) {
            if (targetClass == TestTableViewCell.class) {
               manager.animation(1).down(3).height(12);
               manager.animation(2).height(12).width(110);
               manager.animation(3).down(-5).height(12);
            }else if (targetClass == LawyerTableViewCell.class) {
                manager.animations(1, 3).height(12);
                manager.animation(2).down(8).reducedWidth(-90);
            }
        };
    }
    return _tableView;
}

@end
