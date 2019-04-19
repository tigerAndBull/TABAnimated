//
//  CommentTemplateCollectionViewCell.m
//  yifu
//
//  Created by tigerAndBull on 2019/4/15.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "CommentTemplateCollectionViewCell.h"

#import <TABKit/TABKit.h>
#import "Masonry.h"

#define mLeft kWidth(15)
#define mTop kHeight(7)
#define iconWidth kHeight(30)

@interface CommentTemplateCollectionViewCell()

@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) TABLabel *nameLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) TABLabel *contentLab;

@end

@implementation CommentTemplateCollectionViewCell

+ (NSValue *)cellSize {
    return [NSValue valueWithCGSize:CGSizeMake(kScreenWidth, mTop+iconWidth+kHeight(8)+75)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.headImg];
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.contentLab];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(mLeft);
        make.top.mas_offset(mTop);
        make.width.height.mas_offset(iconWidth);
    }];
    
    self.headImg.layer.cornerRadius = iconWidth/2.0;
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImg.mas_right).mas_offset(kWidth(5));
        make.width.mas_offset(50);
        make.height.mas_offset(15);
        make.centerY.mas_equalTo(self.headImg.mas_centerY).mas_offset(2);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).mas_offset(-mLeft);
        make.centerY.mas_equalTo(self.headImg);
        make.height.mas_offset(kHeight(25));
        make.width.mas_offset(80);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImg.mas_bottom).mas_offset(kHeight(8));
        make.left.mas_offset(mLeft);
        make.right.mas_equalTo(self).mas_offset(-mLeft);
        make.bottom.mas_equalTo(self).mas_offset(-kHeight(8));
    }];
}

#pragma mark - Getter

- (UIImageView *)headImg {
    if (!_headImg) {
        _headImg = [[UIImageView alloc] init];
        _headImg.layer.masksToBounds = YES;
    }
    return _headImg;
}

- (TABLabel *)nameLab {
    if (!_nameLab) {
        _nameLab = [[TABLabel alloc] init];
        _nameLab.font = kFont(14);
        _nameLab.textColor = UIColor.grayColor;
    }
    return _nameLab;
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.textColor = UIColor.grayColor;
        _timeLab.font = kFont(14);
    }
    return _timeLab;
}

- (TABLabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [[TABLabel alloc] init];
        _contentLab.lineSpace = 3.0f;
        _contentLab.font = kFont(14);
        _contentLab.textColor = UIColor.grayColor;
        _contentLab.numberOfLines = 3;
    }
    return _contentLab;
}

@end
