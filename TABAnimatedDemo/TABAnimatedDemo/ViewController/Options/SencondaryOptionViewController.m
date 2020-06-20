//
//  SencondaryOptionViewController.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/10/2.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "SencondaryOptionViewController.h"
#import <TABKit/TABKit.h>
#import "AppDelegate.h"
#import "TABAnimatedControllerUIImpl.h"

@interface SencondaryOptionViewController()

@property (nonatomic, strong) id <TABAnimatedControllerUIInterface> rightButtonInterface;

@end

@implementation SencondaryOptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _rightButtonInterface = TABAnimatedControllerUIImpl.new;
    [_rightButtonInterface addRightButtonWithText:@"" controller:self clickButtonBlock:^(UIButton *btn) {
        
    }];
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

- (NSArray *)titleArray {
    
    switch (self.index) {
        case 0:
            return @[
                kText(@"单section单cell 不带tableHeaderView"),
                kText(@"单section单cell 带tableHeaderView"),
                kText(@"单section单cell 带headerForSection"),
                
                kText(@"多section多cell 不带headerForSection"),
                kText(@"多section多cell 带headerForSection"),
                
                kText(@"指定section配置动画 不带headerForSection"),
                kText(@"指定section配置动画 带headerForSection"),
                
                kText(@"动态section配置 不带headerForSection"),
                kText(@"动态section配置 带headerForSection"),
                
                kText(@"单section多cell 指定row配置动画"),
                
                kText(@"Xib"),
                kText(@"嵌套视图"),
                kText(@"卡片视图"),
                kText(@"自适应高度 属性"),
                kText(@"自适应高度 代理"),
                
                kText(@"上拉加载更多"),
            ];
            break;
        
        case 1:
            return @[
                kText(@"单section单cell"),
                kText(@"卡片视图"),
                kText(@"分段视图"),
                kText(@"嵌套视图"),
                kText(@"Sections"),
                kText(@"Xib"),
                kText(@"豆瓣动画"),
                kText(@"豆瓣动画 卡片式"),
            ];
            break;
        
        case 2:
            return @[
                kText(@"普通view"),
                kText(@"豆瓣动画"),
            ];
            break;
    }
    
    return nil;
}

- (NSArray *)controllerClassArray {
    
    switch (self.index) {
        case 0:
            return @[
                @"OneSectionViewController",
                @"OneSectionWithTableHeaderViewController",
                @"OneSectionWithHeaderSectionViewController",
                
                @"MutiSectionMutiCellTableViewController",
                @"MutiSectionsMutiCellWithHeaderViewController",
                
                @"PartialSectionViewController",
                @"PartialSectionWithHeaderViewController",
                
                @"TableDynamicSectionViewController",
                @"TableDynamicWithHeaderViewController",
                
                @"TableRowModeViewController",
                
                @"XibTestViewController",
                @"NestTableViewController",
                @"TableCardViewController",
                @"TestLayoutTableViewController",
                @"TestLayoutDelegateTableViewController",
                
                @"PullLoadingTableViewController"
            ];
            break;
        
        case 1:
            return @[
                @"TestCollectionViewController",
                @"CardViewController",
                @"SegmentCollectionViewController",
                @"NestCollectionViewController",
                @"SectionsCollectionViewController",
                @"XibCollectionViewController",
                @"DoubanCollectionViewController",
                @"DoubanCardViewController",
            ];
            break;
        
        case 2:
            return @[
                @"ViewExampleViewController",
                @"DoubanNormalViewController",
            ];
            break;
    }
    
    return nil;
}

@end
