//
//  MainViewController.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/10/7.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "MainViewController.h"
#import "TestViewController.h"
#import "XibTestViewController.h"
#import "MoreViewController.h"
#import "MoreTableViewController.h"
#import "TestCollectionViewController.h"
#import "LabWithLinesViewController.h"
#import "ExampleOfPackageViewController.h"

#import "TABMethod.h"
#import "AppDelegate.h"

#define kAPPDELEGATE ((AppDelegate*)[[UIApplication sharedApplication] delegate])

@interface MainViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *mainTV;

@end

@implementation MainViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"主页面";
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

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
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
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"UIView和UITableView纯代码 示例";
            break;
        case 1:
            cell.textLabel.text = @"cell xib 示例";;
            break;
        case 2:
            cell.textLabel.text = @"多个UIView 示例";
            break;
        case 3:
            cell.textLabel.text = @"多个UITableView 示例";
            break;
        case 4:
            cell.textLabel.text = @"UICollectionView 示例";
            break;
        case 5:
            cell.textLabel.text = @"多行文本 示例";
            break;
        case 6:
            cell.textLabel.text = @"cell中使用封装组件 示例";
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0: {
            TestViewController *vc = [TestViewController new];
            [kAPPDELEGATE.nav pushViewController:vc animated:YES];
        }
            break;
        case 1: {
            XibTestViewController *vc =[XibTestViewController new];
            [kAPPDELEGATE.nav pushViewController:vc animated:YES];
        }
            break;
        case 2: {
            MoreViewController *vc = [MoreViewController new];
            [kAPPDELEGATE.nav pushViewController:vc animated:YES];
        }
            break;
        case 3: {
            MoreTableViewController *vc = [MoreTableViewController new];
            [kAPPDELEGATE.nav pushViewController:vc animated:YES];
        }
            break;
        case 4: {
            TestCollectionViewController *vc = [TestCollectionViewController new];
            [kAPPDELEGATE.nav pushViewController:vc animated:YES];
        }
            break;
        case 5: {
            LabWithLinesViewController *vc = [LabWithLinesViewController new];
            [kAPPDELEGATE.nav pushViewController:vc animated:YES];
        }
            break;
        case 6: {
            ExampleOfPackageViewController *vc = [ExampleOfPackageViewController new];
            [kAPPDELEGATE.nav pushViewController:vc animated:YES];
        }
            break;
    }
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
        _mainTV.delegate = self;
        _mainTV.dataSource = self;
        _mainTV.rowHeight = 44;
        _mainTV.backgroundColor = [UIColor whiteColor];
        _mainTV.estimatedRowHeight = 0;
        _mainTV.estimatedSectionFooterHeight = 0;
        _mainTV.estimatedSectionHeaderHeight = 0;
        _mainTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _mainTV;
}

@end
