//
//  MainViewController.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/10/7.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MainViewControllerMain = 0,
    MainViewControllerCode,
    MainViewControllerXib,
    MainViewControllerDouban,
    MainViewControllerAutoLayout,
} MainViewControllerType;

@interface MainViewController : UIViewController

@property (nonatomic) MainViewControllerType type;

@end

NS_ASSUME_NONNULL_END
