//
//  BaseTableViewCell.h
//  yifu
//
//  Created by tigerAndBull on 2019/2/23.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BaseViewController;

@protocol BaseTableViewCellDelegate <NSObject>

@end

@interface BaseTableViewCell : UITableViewCell

- (void)updateWithModel:(_Nullable id)model;

+ (NSNumber *)cellSizeByClass;
+ (NSString *)cellIdentifier;
+ (CGFloat)cellHeight;
+ (NSNumber *)cellHeightNumber;

+ (instancetype)cellFromTableView:(UITableView *)tableView;

+ (instancetype)cellFromTableView:(UITableView *)tableView
                        indexPath:(NSIndexPath *)indexPath;

@property (nonatomic,strong) BaseViewController *currentController;
@property (nonatomic,weak) id <BaseTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
