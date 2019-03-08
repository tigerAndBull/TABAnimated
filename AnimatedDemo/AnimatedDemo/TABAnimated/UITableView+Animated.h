//
//  UITableView+Animated.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TABAnimatedObject;

@protocol UITableViewAnimatedDelegate <NSObject>

@optional

- (NSInteger)tableView:(UITableView *)tableView numberOfAnimatedRowsInSection:(NSInteger)section;

@end

@interface UITableView (Animated)

@property (nonatomic,strong) TABAnimatedObject *tabAnimated;

@property (nonatomic,weak) id<UITableViewAnimatedDelegate> animatedDelegate;

@property (nonatomic,assign) NSInteger animatedCount;    // default is three. count of cell during animating.

- (void)registerTemplateClass:(Class)templateClass;

- (void)registerTemplateClassArray:(NSArray <Class> *)classArray;

@end
