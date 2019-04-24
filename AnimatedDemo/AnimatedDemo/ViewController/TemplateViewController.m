//
//  TemplateViewController.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/3/8.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import "TemplateViewController.h"

#import <TABKit/TABKit.h>
#import "AppDelegate.h"

@interface TemplateViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray <NSString *> *titleArray;
@property (nonatomic,strong) NSArray <NSString *> *controllerClassArray;
@property (nonatomic,strong) UITableView *mainTV;

@end

@implementation TemplateViewController

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
        UIViewController *vc = class.new;
        vc.title = self.titleArray[indexPath.row];
        [kAPPDELEGATE.nav pushViewController:vc animated:YES];
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
        _mainTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
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

- (NSArray *)titleArray {
    return @[@"UICollectionView and 多section",
             @"UITableView and 单section",
             @"UICollectionView categoryView",
             @"阴影卡片",
             @"深色系"];
}

- (NSArray *)controllerClassArray {
    return @[@"TemplateCollectionViewController",
             @"TemplateTableViewController",
             @"TemplateCategoryCollectionViewController",
             @"TemplateCardViewController",
             @"TemplateDarkCardViewController"];
}

@end
