//
//  BaseOptionViewController.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/10/2.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "BaseOptionViewController.h"
#import <TABKit/TABKit.h>
#import "AppDelegate.h"

@interface BaseOptionViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation BaseOptionViewController

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
        if ([className isEqualToString:@"BaseOptionViewController"]) {
            BaseOptionViewController *vc = (BaseOptionViewController *)class.new;
            vc.title = self.titleArray[indexPath.row];
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
    [self.view addSubview:self.tableView];
}

#pragma mark - Lazy Methods

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 44;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.backgroundColor = [UIColor tab_normalDynamicBackgroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


@end
