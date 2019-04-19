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

/**
 子类需要重写，设置固定值

 @return package of animateding cell height
 */
+ (NSNumber *)cellHeight;

// 开发者不需要关心
+ (NSString *)cellIdentifier;
+ (instancetype)cellFromTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
