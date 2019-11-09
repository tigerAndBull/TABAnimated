//
//  TTTViewController.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/6/20.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "Game.h"
#import "TABAnimated.h"
#import <TABKit/TABKit.h>
#import "Masonry.h"
#import "TestLayoutTableViewController.h"
#import "TestLayoutDelegateTableViewController.h"

@interface TestLayoutDelegateTableViewController ()
<UITableViewDelegate,
UITableViewDataSource
>
{
    NSMutableArray *dataArray;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TestLayoutDelegateTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self initUI];
    
    // 假设3秒后，获取到数据了，代码具体位置看你项目了。
    [self performSelector:@selector(afterGetData) withObject:nil afterDelay:3.0];
}

#pragma mark - Target Methods

/**
 获取到数据后
 */
- (void)afterGetData {
    
    // 模拟数据
    for (int i = 0; i < 10; i ++) {
        NSInteger times = arc4random()%3;
        NSString *titleStr = @"这里是测试数据";
        for (int idx = 0; idx < times; idx ++) {
            titleStr = [NSString stringWithFormat:@"%@\n这里是测试数据%d",titleStr,idx+1];
        }
        Game *game = [[Game alloc]init];
        game.gameId = [NSString stringWithFormat:@"%d",i];
        game.title = titleStr;
        game.cover = @"test.jpg";
        [dataArray addObject:game];
    }
    // 停止动画,并刷新数据
    [self.tableView tab_endAnimation];
}

#pragma mark - UITableViewDelegate & Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *str = @"TestLayoutCell";
    TestLayoutCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[TestLayoutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
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
    dataArray = [NSMutableArray array];
}

/**
 initize view
 视图初始化
 */
- (void)initUI {
    [self.view addSubview:self.tableView];
    [self.tableView tab_startAnimation];   // 开启动画
}

#pragma mark - Lazy Methods

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor tab_normalDynamicBackgroundColor];
        
        // 设置tabAnimated相关属性
        // 可以不进行手动初始化，将使用默认属性
        _tableView.tabAnimated = [TABTableAnimated animatedWithCellClass:[TestLayoutCell class]
                                                              cellHeight:100];
        _tableView.tabAnimated.superAnimationType = TABViewSuperAnimationTypeShimmer;
    }
    return _tableView;
}

@end
