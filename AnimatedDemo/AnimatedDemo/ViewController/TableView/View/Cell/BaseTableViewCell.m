//
//  BaseTableViewCell.m
//  yifu
//
//  Created by tigerAndBull on 2019/2/23.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (NSNumber *)cellSizeByClass {
    return @(YES);
}

+ (instancetype)cellFromTableView:(UITableView *)tableView {
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifier]];
    if (!cell) {
        cell = [[self alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:[self cellIdentifier]];
    }
    return cell;
}

+ (instancetype)cellFromTableView:(UITableView *)tableView
                        indexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifierWithIndexPath:indexPath]];
    if (!cell) {
        cell = [[self alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:[self cellIdentifierWithIndexPath:indexPath]];
    }
    return cell;
}

+ (CGFloat)cellHeight {
    return 55.f;
}

+ (NSNumber *)cellHeightNumber {
    return [NSNumber numberWithFloat:[self cellHeight]];
}

+ (NSString *)cellIdentifier {
    return [NSString stringWithFormat:@"%@", [self class]];
}

+ (NSString *)cellIdentifierWithIndexPath:(NSIndexPath *)indexPath {
    return [NSString stringWithFormat:@"%@%ld%ld", [self class],(long)indexPath.row,(long)indexPath.section];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)updateWithModel:(_Nullable id)model {
}

@end
