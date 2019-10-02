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

@implementation SencondaryOptionViewController

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
                kText(@"简单场景"),
                kText(@"指定section开启动画"),
                kText(@"动态section配置"),
                kText(@"以row为单位配置"),
                kText(@"Xib"),
                kText(@"`self.delegate = self`"),
                kText(@"自适应高度 属性"),
                kText(@"自适应高度 代理"),
            ];
            break;
        
        case 1:
            return @[
                kText(@"简单场景"),
                kText(@"卡片视图"),
                kText(@"分段视图"),
                kText(@"嵌套视图"),
                kText(@"Sections"),
                kText(@"Xib"),
                kText(@"豆瓣动画"),
                kText(@"豆瓣动画 卡片式"),
                kText(@"`self.delegate = self`"),
            ];
            break;
        
        case 2:
            return @[
                kText(@"简单场景"),
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
                @"TableNormalViewController",
                @"TableSectionsViewController",
                @"TableDynamicSectionViewController",
                @"TableRowModeViewController",
                @"XibTestViewController",
                @"DeleagteSelfTableViewController",
                @"TestLayoutTableViewController",
                @"TestLayoutDelegateTableViewController",
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
                @"DelegateSelfCollectionViewController",
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
