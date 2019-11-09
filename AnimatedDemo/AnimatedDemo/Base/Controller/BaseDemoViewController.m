//
//  BaseDemoViewController.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/10/1.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "BaseDemoViewController.h"

@interface BaseDemoViewController ()

@end

@implementation BaseDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)dealloc {
    NSLog(@"==========  dealloc  ==========");
}

- (void)setupUI {
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return UIColor.systemBackgroundColor;
            }else {
                return UIColor.whiteColor;
            }
        }];
    } else {
        self.view.backgroundColor = UIColor.whiteColor;
    }
}

@end
