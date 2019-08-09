//
//  estimatedTableViewDelegate.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/6/20.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "EstimatedTableViewDelegate.h"

@implementation EstimatedTableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
    return UITableViewAutomaticDimension;
}

@end
