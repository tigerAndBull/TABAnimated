//
//  BaseDemoViewController.m
//  TABAnimatedDemo
//
//  Created by tigerAndBull on 2019/10/1.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "BaseDemoViewController.h"
#import "TABAnimatedControllerUIInterface.h"
#import "TABAnimatedControllerUIImpl.h"

@interface BaseDemoViewController ()

@property (nonatomic, strong) id <TABAnimatedControllerUIInterface> rightButtonImpl;

@end

@implementation BaseDemoViewController

- (instancetype)init {
    if (self = [super init]) {
        _rightButtonImpl = TABAnimatedControllerUIImpl.new;
    }
    return self;
}

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
    
    __weak typeof(self) weakSelf = self;
    [_rightButtonImpl addReloadButtonWithController:self clickButtonBlock:^(UIButton *btn) {
        [weakSelf reloadViewAnimated];
    }];
}

- (void)reloadViewAnimated {
    
}

@end
