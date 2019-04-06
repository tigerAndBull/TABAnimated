//
//  GameTableViewCell.h
//  lifeAndSport
//
//  Created by tigerAndBull on 2018/6/6.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TABBaseTableViewCell.h"

@class Game;

@interface TestTableViewCell : TABBaseTableViewCell

- (void)initWithData:(Game *)game;

@end
