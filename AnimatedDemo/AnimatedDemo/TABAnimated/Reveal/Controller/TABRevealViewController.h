//
//  RevealViewController.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/8/31.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TABRevealModel;

@interface TABRevealViewController : UIViewController

- (void)reloadWithCacheModel:(TABRevealModel *)model;

@end

NS_ASSUME_NONNULL_END
