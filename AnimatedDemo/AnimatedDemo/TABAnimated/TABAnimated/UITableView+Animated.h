//
//  UITableView+Animated.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UITableViewAnimatedDelegate <NSObject>

@optional
- (NSInteger)tableView:(UITableView *)tableView numberOfAnimatedRowsInSection:(NSInteger)section;

@end

@interface UITableView (Animated)

@property (nonatomic,weak) id <UITableViewAnimatedDelegate> animatedDelegate;

@end
