//
//  MoreViewController.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/10/8.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "MoreViewController.h"

#import "TestHeadView.h"

#import "TABAnimated.h"

@interface MoreViewController ()

@property (nonatomic,strong) TestHeadView *viewOne;
@property (nonatomic,strong) TestHeadView *viewTwo;

@end

@implementation MoreViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"多个UIView 示例";
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

#pragma mark - Initize Methods

/**
 initialize view
 初始化视图
 */
- (void)initUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.viewOne];
    [self.view addSubview:self.viewTwo];
}

#pragma mark - Lazy Methods

- (TestHeadView *)viewOne {
    if (!_viewOne) {
        _viewOne = [[TestHeadView alloc]initWithFrame:CGRectMake(0, 88, tab_kScreenWidth, 90)];
        _viewOne.animatedStyle = TABViewAnimationStart;    // 开启动画
    }
    return _viewOne;
}

- (TestHeadView *)viewTwo {
    if (!_viewTwo) {
        _viewTwo = [[TestHeadView alloc]initWithFrame:CGRectMake(0, 88+90+20, tab_kScreenWidth, 90)];
        _viewTwo.animatedStyle = TABViewAnimationStart;    // 开启动画
    }
    return _viewTwo;
}

@end
