//
//  BaseTableViewCell.h
//  yifu
//
//  Created by tigerAndBull on 2019/2/23.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TABBaseTableViewCell : UITableViewCell

+ (NSNumber *)cellHeight;

+ (NSString *)cellIdentifier;
+ (instancetype)cellFromTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
