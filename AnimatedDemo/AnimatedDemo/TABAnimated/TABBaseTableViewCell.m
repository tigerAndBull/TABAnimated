//
//  BaseTableViewCell.m
//  yifu
//
//  Created by tigerAndBull on 2019/2/23.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import "TABBaseTableViewCell.h"

@interface TABBaseTableViewCell()

@end

@implementation TABBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (instancetype)cellFromTableView:(UITableView *)tableView {
    TABBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifier]];
    if (!cell) {
        cell = [[self alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:[self cellIdentifier]];
    }
    return cell;
}

+ (NSNumber *)cellHeight {
    return [NSNumber numberWithFloat:0.];
}

+ (NSString *)cellIdentifier {
    return [NSString stringWithFormat:@"%@", [self class]];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
