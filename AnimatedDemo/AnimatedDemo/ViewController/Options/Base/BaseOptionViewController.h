//
//  BaseOptionViewController.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/10/2.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseOptionViewController : BaseDemoViewController

@property (nonatomic, strong) NSArray <NSString *> *titleArray;
@property (nonatomic, strong) NSArray <NSString *> *controllerClassArray;

@end

NS_ASSUME_NONNULL_END
