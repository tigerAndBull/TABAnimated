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
#import "SencondaryOptionViewController.h"

#import "TABAnimatedControllerUIInterface.h"
#import "TABAnimatedControllerUIImpl.h"

@interface MainViewController()

@property (nonatomic, strong) id <TABAnimatedControllerUIInterface> rightButtonInterface;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _rightButtonInterface = TABAnimatedControllerUIImpl.new;
    [_rightButtonInterface addRightButtonWithText:@"" controller:self clickButtonBlock:^(UIButton *btn) {
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SencondaryOptionViewController *vc = SencondaryOptionViewController.new;
    vc.index = indexPath.row;
    vc.title = self.titleArray[indexPath.row];
    [kAPPDELEGATE.nav pushViewController:vc animated:YES];
}

- (NSArray *)titleArray {
    return @[
        kText(@"UITableView 示例"),
        kText(@"UICollectionView 示例"),
        kText(@"自定义UIView 示例"),
    ];
}

- (NSArray *)controllerClassArray {
    return @[
        @"SencondaryOptionViewController",
        @"SencondaryOptionViewController",
        @"SencondaryOptionViewController",
    ];
}

@end
