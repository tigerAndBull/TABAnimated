//
//  OptionViewController.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/3/8.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import "OptionViewController.h"

#import <TABKit/TABKit.h>
#import "AppDelegate.h"
#import "TABViewAnimated.h"

@interface OptionViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray <NSString *> *titleArray;
@property (nonatomic,strong) NSArray <NSString *> *controllerClassArray;
@property (nonatomic,strong) UITableView *mainTV;

@end

@implementation OptionViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"选择页面";
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

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
        if (indexPath.row == 0) {
            [TABViewAnimated sharedAnimated].isUseTemplate = NO;
        }else {
            [TABViewAnimated sharedAnimated].isUseTemplate = YES;
        }
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
    return @[@"普通模式",
             @"模版模式"];
}

- (NSArray *)controllerClassArray {
    return @[@"MainViewController",
             @"TemplateViewController"];
}

@end
