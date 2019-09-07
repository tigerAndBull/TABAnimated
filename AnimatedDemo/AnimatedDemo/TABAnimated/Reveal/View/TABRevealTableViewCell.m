//
//  TABRevealTableViewCell.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/9/1.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABRevealTableViewCell.h"

@implementation TABRevealTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.editBtn];
    [self.contentView addSubview:self.deleteBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat mLeft = 20;
    CGFloat mTop = 10;
    CGSize textSize = [self.nameLab.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:nil
                                                      context:nil].size;
    self.nameLab.frame = CGRectMake(mLeft, mTop, textSize.width, textSize.height);
    self.deleteBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 20 - 40, mTop, 40, 20);
    self.editBtn.frame = CGRectMake(CGRectGetMinX(self.deleteBtn.frame) - (10 + 40), mTop, 40, 20);
}

- (void)clickAction:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickButton:targetClass:indexPath:)]) {
        UITableView *superView;
        if ([[[self superview] superview] isKindOfClass:[UITableView class]]) {
            superView = (UITableView *)self.superview.superview;
        }else {
            superView = (UITableView *)self.superview;
        }
        [self.delegate clickButton:button targetClass:self.class indexPath:[superView indexPathForCell:self]];
    }
}

- (UILabel *)nameLab {
    if (!_nameLab) {
        _nameLab = UILabel.new;
        _nameLab.font = [UIFont systemFontOfSize:14.];
        _nameLab.textColor = UIColor.blackColor;
    }
    return _nameLab;
}

- (UIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = UIButton.new;
        _editBtn.titleLabel.font = [UIFont systemFontOfSize:14.];
        [_editBtn setTitleColor:UIColor.redColor forState:UIControlStateNormal];
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        _editBtn.tag = 1000;
        [_editBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = UIButton.new;
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14.];
        [_deleteBtn setTitleColor:UIColor.redColor forState:UIControlStateNormal];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        _deleteBtn.tag = 1001;
        [_deleteBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

@end
