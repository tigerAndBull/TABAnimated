//
//  TABAnimatedControllerUIImpl.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/5/3.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "TABAnimatedControllerUIImpl.h"

@interface TABAnimatedControllerUIImpl()

@property (nonatomic, copy) RightButtonClickBlock clickButtonBlock;

@end

@implementation TABAnimatedControllerUIImpl

- (void)addRightButtonWithText:(NSString *)text
                    controller:(UIViewController *)controller
              clickButtonBlock:(RightButtonClickBlock)clickButtonBlock {
    self.clickButtonBlock = clickButtonBlock;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:text style:UIBarButtonItemStylePlain target:self action:@selector(didClickRightButton:)];
    controller.navigationItem.rightBarButtonItem = item;
}

- (void)addReloadButtonWithController:(UIViewController *)controller clickButtonBlock:(RightButtonClickBlock)clickButtonBlock {
    self.clickButtonBlock = clickButtonBlock;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"重新加载" style:UIBarButtonItemStylePlain target:self action:@selector(didClickReloadButton:)];
    item.tintColor = UIColor.blackColor;
    controller.navigationItem.rightBarButtonItem = item;
}

- (void)didClickRightButton:(UIButton *)button {
    if (self.clickButtonBlock) {
        self.clickButtonBlock(button);
    }
}

- (void)didClickReloadButton:(UIButton *)button {
    if (self.clickButtonBlock) {
        self.clickButtonBlock(button);
    }
}

@end
