//
//  MainViewController.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/10/7.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "MainViewController.h"

#import "TABMethod.h"

#import "TestViewController.h"
#import "XibTestViewController.h"
#import "MoreViewController.h"
#import "MoreTableViewController.h"

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
    return 4;
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
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"UIView和UITableView纯代码 示例";
    }else {
        if (indexPath.row == 1) {
            cell.textLabel.text = @"cell xib 示例";
        }else {
            if (indexPath.row == 2) {
                cell.textLabel.text = @"多个UIView 示例";
            }else {
                if (indexPath.row == 3) {
                    cell.textLabel.text = @"多个UITableView 示例";
                }
            }
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        TestViewController *vc = [[TestViewController alloc]init];
        [kAPPDELEGATE.nav pushViewController:vc animated:YES];
    }else {
        if (indexPath.row == 1) {
            
            XibTestViewController *vc = [[XibTestViewController alloc]init];
            [kAPPDELEGATE.nav pushViewController:vc animated:YES];
        }else {
            if (indexPath.row == 2) {
                
                MoreViewController *vc = [[MoreViewController alloc]init];
                [kAPPDELEGATE.nav pushViewController:vc animated:YES];
            }else {
                if (indexPath.row == 3) {
                    
                    MoreTableViewController *vc = [[MoreTableViewController alloc]init];
                    [kAPPDELEGATE.nav pushViewController:vc animated:YES];
                }
            }
        }
    }
}


#pragma mark - Initize Methods

- (void)addNotification {
}

- (void)initData {
}

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
