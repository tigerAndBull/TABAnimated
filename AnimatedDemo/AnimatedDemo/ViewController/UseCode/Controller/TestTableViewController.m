//
//  TestTableViewController.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "TestTableViewController.h"
#import "TestTableViewCell.h"
#import "XIBTableViewCell.h"
#import "TestHeadView.h"

#import "TABAnimated.h"
#import <TABKit/TABKit.h>

#import "Game.h"

@interface TestTableViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *dataArray;
}

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIImageView *topImg;

@end

@implementation TestTableViewController

- (instancetype)init {
    if (self = [super init]) {
        [self tableView];
    }
    return self;
}

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
    [self.tableView tab_endAnimation];
}

#pragma mark - UITableViewDelegate & Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
//    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 80)/2.0, 20, 80, 80)];
//    imageV.image = [UIImage imageNamed:@"comic.jpg"];
//    imageV.layer.cornerRadius = 80/2.0;
//    imageV.layer.masksToBounds  = YES;
//    [view addSubview:imageV];
//    return view;
//}
//
//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
//    view.tabAnimated = TABViewAnimated.new;
//    [view tab_startAnimation];
//}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 100;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 120;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    dataArray = [NSMutableArray array];
}

/**
 initize view
 视图初始化
 */
- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView tab_startAnimation];   // 开启动画
}

#pragma mark - Lazy Methods

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
//        _tableView.estimatedRowHeight = 100;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 80)/2.0, 20, 80, 80)];
        imageV.image = [UIImage imageNamed:@"comic.jpg"];
        imageV.layer.cornerRadius = 80/2.0;
        imageV.layer.masksToBounds = YES;
        [view addSubview:imageV];
        _tableView.tableHeaderView = view;
        
        // 设置tabAnimated相关属性
        // 可以不进行手动初始化，将使用默认属性
        _tableView.tabAnimated = [TABTableAnimated animatedWithCellClass:[TestTableViewCell class]
                                                              cellHeight:100];
        _tableView.tabAnimated.categoryBlock = ^(UIView * _Nonnull view) {
            view.animation(1).down(3).height(12).toShortAnimation();
            view.animation(2).height(12).width(110).toLongAnimation();
            view.animation(3).down(-5).height(12);
        };
        
        // 头视图扩展回调使用方法
        _tableView.tableHeaderView.tabAnimated.categoryBlock = ^(UIView * _Nonnull view) {
            
        };
    }
    return _tableView;
}

@end
