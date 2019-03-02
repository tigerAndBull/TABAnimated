//
//  TestCollectionViewCell.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/10/12.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCollectionCell.h"

NS_ASSUME_NONNULL_BEGIN

@class Game;

@interface TestCollectionViewCell : BaseCollectionCell

- (void)initWithData:(Game *)game;

@end

NS_ASSUME_NONNULL_END
