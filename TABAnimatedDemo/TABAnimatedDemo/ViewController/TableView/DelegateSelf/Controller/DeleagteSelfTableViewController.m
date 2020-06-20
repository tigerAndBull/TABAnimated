//
//  TestTableViewController.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "DeleagteSelfTableViewController.h"

#import "TABAnimated.h"
#import <TABKit/TABKit.h>

#import "Game.h"
#import "TestTableView.h"
#import "TestTableViewCell.h"

@interface DeleagteSelfTableViewController ()

@property (nonatomic,strong) TestTableView *tableView;

@end

@implementation DeleagteSelfTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    
    [self.tableView tab_startAnimationWithDelayTime:1. completion:^{
        [self afterGetData];
    }];
}

#pragma mark - Target Methods

/**
 获取到数据后
 */
- (void)afterGetData {
    
    // 模拟数据
    NSMutableArray *dataArray = @[].mutableCopy;
    for (int i = 0; i < 10; i ++) {
        Game *game = [[Game alloc]init];
        game.gameId = [NSString stringWithFormat:@"%d",i];
        game.title = [NSString stringWithFormat:@"这里是测试数据%d",i+1];
        game.cover = @"test.jpg";
        game.viewHeight = 90;
        [dataArray addObject:game];
    }
    self.tableView.dataArray = dataArray;
    // 停止动画,并刷新数据
    [self.tableView tab_endAnimationEaseOut];
}

#pragma mark - Initize Methods

/**
 initize view
 视图初始化
 */
- (void)initUI {
    [self.view addSubview:self.tableView];
}

#pragma mark - Lazy Methods

- (TestTableView *)tableView {
    if (!_tableView) {
        _tableView = [[TestTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.backgroundColor = [UIColor tab_normalDynamicBackgroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.cellName = @"TestTableViewCell";
        
        // 设置tabAnimated相关属性
        // 可以不进行手动初始化，将使用默认属性
        _tableView.tabAnimated = [TABTableAnimated animatedWithCellClass:[TestTableViewCell class]
                                                              cellHeight:90];
        _tableView.tabAnimated.animatedSectionCount = 3;
        _tableView.tabAnimated.showTableHeaderView = YES;
        _tableView.tabAnimated.superAnimationType = TABViewSuperAnimationTypeShimmer;
        
        // 新回调
        _tableView.tabAnimated.adjustBlock = ^(TABComponentManager * _Nonnull manager) {
            manager.animation(1).down(3).height(12);
            manager.animation(2).height(12).width(110);
            manager.animation(3).down(-5).height(12);
        };
    }
    return _tableView;
}

@end
