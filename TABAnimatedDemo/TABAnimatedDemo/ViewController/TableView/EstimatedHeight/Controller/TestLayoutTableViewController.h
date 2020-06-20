//
//  TestLayoutTableViewController.h
//  AnimatedDemo
//
//  Created by Dianshi on 2019/5/24.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Game;

NS_ASSUME_NONNULL_BEGIN

@interface TestLayoutTableViewController : BaseDemoViewController

@end

@interface TestLayoutCell : UITableViewCell

- (void)initWithData:(Game *)game;

@end

NS_ASSUME_NONNULL_END
