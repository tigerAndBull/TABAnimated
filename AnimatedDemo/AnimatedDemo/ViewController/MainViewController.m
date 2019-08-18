//
//  MainViewController.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/10/7.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "MainViewController.h"
#import <TABKit/TABKit.h>
#import "AppDelegate.h"

@interface MainViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray <NSString *> *titleArray;
@property (nonatomic, strong) NSArray <NSString *> *controllerClassArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MainViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *str = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.titleArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = self.controllerClassArray[indexPath.row];
    Class class = NSClassFromString(className);
    if (class) {
        if ([className isEqualToString:@"MainViewController"]) {
            MainViewController *vc = (MainViewController *)class.new;
            vc.title = self.titleArray[indexPath.row];
            vc.type = indexPath.row+1;
            [kAPPDELEGATE.nav pushViewController:vc animated:YES];
        }else {
            UIViewController *vc = class.new;
            vc.title = self.titleArray[indexPath.row];
            [kAPPDELEGATE.nav pushViewController:vc animated:YES];
        }
    }
}


#pragma mark - Initize Methods

/**
 initialize view
 初始化视图
 */
- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

#pragma mark - Lazy Methods

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 44;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSArray *)titleArray {
    
    switch (self.type) {
            
        case MainViewControllerMain: {
            
            return @[
                     kText(@"纯代码构建、Masonry布局 示例"),
                     kText(@"Xib 示例"),
                     kText(@"豆瓣动画 示例"),
                     kText(@"自适应高度 示例"),
                     kText(@"`self.delegate = self` 示例"),
                     ];
        }
            
            break;
            
        case MainViewControllerCode:
            
            return @[
                     kText(@"UITableView 示例"),
                     kText(@"多行文本 示例"),
                     kText(@"UICollectionView 示例"),
                     kText(@"UIView 示例"),
                     kText(@"卡片投影视图 示例"),
                     kText(@"分段视图 示例"),
                     kText(@"cell中使用多级view 示例"),
                     kText(@"嵌套表格 示例"),
                     kText(@"UICollectionView 指定section结束动画"),
                     kText(@"UITableView 指定section开启动画"),
                     ];
            
            break;
            
        case MainViewControllerXib:
            
            return @[
                     kText(@"UITableView 示例"),
                     kText(@"UICollectionView 示例"),
                     ];
            
            break;
            
        case MainViewControllerDouban:
            
            return @[
                     kText(@"UICollectionView 示例"),
                     kText(@"卡片投影视图 示例"),
                     kText(@"UIView 示例"),
                     ];
            
            break;
            
        case MainViewControllerAutoLayout:
            
            return @[
                     kText(@"UITableView 自适应高度 属性示例"),
                     kText(@"UITableView 自适应高度 代理示例"),
                     ];
            
            break;
            
        case MainViewControllerDelegateSelf:
            
            return @[
                     kText(@"`self.delegate = self` 示例"),
                     kText(@"`self.delegate = self` 示例二")
                     ];
            
            break;
            
        default:
            break;
    }
    
    return @[
             kText(@"纯代码与Masonry 示例"),
             kText(@"xib 示例"),
             kText(@"自适应高度 示例"),
             kText(@"豆瓣动画 示例"),
             ];
}

- (NSArray *)controllerClassArray {
    
    switch (self.type) {
        case MainViewControllerMain: {

            return @[
                     @"MainViewController",
                     @"MainViewController",
                     @"MainViewController",
                     @"MainViewController",
                     @"MainViewController",
                     ];
        }
            
            break;
            
        case MainViewControllerCode:
            
            return @[
                     @"TestTableViewController",
                     @"LabWithLinesViewController",
                     @"TestCollectionViewController",
                     @"ViewExampleViewController",
                     @"CardViewController",
                     @"SegmentCollectionViewController",
                     @"ExampleOfPackageViewController",
                     @"NestCollectionViewController",
                     @"SectionsCollectionViewController",
                     @"SectionsTableViewController",
                     ];
            
            break;
            
        case MainViewControllerXib:
            
            return @[
                     @"XibTestViewController",
                     @"XibCollectionViewController",
                     ];
            
            break;
            
        case MainViewControllerDouban:
            
            return @[
                     @"DoubanCollectionViewController",
                     @"DoubanCardViewController",
                     @"DoubanNormalViewController",
                     ];
            
            break;
            
        case MainViewControllerAutoLayout:
            
            return @[
                     @"TestLayoutTableViewController",
                     @"TestLayoutDelegateTableViewController",
                     ];
            
            break;
            
        case MainViewControllerDelegateSelf:
            
            return @[
                     @"DeleagteSelfTableViewController",
                     @"DeleagteSelfSecondExampleViewController"
                     ];
            
            break;
            
        default:
            break;
    }
    
    return @[
             @"MainViewController",
             @"MainViewController",
             @"MainViewController",
             @"MainViewController",
             ];
}

@end
