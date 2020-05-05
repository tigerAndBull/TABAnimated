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
    controller.navigationController.navigationItem.rightBarButtonItem = item;
}

- (void)didClickRightButton:(UIButton *)button {
    if (self.clickButtonBlock) {
        self.clickButtonBlock(button);
    }
}

@end
