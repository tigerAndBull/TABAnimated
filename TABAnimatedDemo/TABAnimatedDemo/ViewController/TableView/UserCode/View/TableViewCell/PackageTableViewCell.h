//
//  PackageTableViewCell.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/11/17.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Game;

@interface PackageTableViewCell : UITableViewCell

- (void)updateWithGame:(Game *)game;

@end

NS_ASSUME_NONNULL_END
