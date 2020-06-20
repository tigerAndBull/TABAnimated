//
//  TestTableHeaderFooterView.h
//  TABAnimatedDemo
//
//  Created by tigerAndBull on 2019/8/2.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Game;

@interface TestTableHeaderFooterView : UITableViewHeaderFooterView

- (void)initWithData:(Game *)game;

@end

NS_ASSUME_NONNULL_END
