//
//  LabWithLinesViewCell.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/10/22.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Game;

@interface LabWithLinesViewCell : UITableViewCell

- (void)initWithData:(Game *)game;

@end

NS_ASSUME_NONNULL_END
