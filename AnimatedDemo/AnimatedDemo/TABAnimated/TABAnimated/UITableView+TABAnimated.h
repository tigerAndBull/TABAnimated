//
//  UITableView+Animated.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UITableViewAnimatedDelegate <NSObject>

- (NSInteger)tab_tableView:(UITableView *_Nonnull)tableView numberOfAnimatedRowsInSection:(NSInteger)section;

@end

@class TABTableAnimated;

@interface UITableView (TABAnimated)

// To the control view
@property (nonatomic,strong) TABTableAnimated * _Nullable tabAnimated;

@property (nonatomic,weak) id <UITableViewAnimatedDelegate> _Nullable animatedDelegate;

@end
