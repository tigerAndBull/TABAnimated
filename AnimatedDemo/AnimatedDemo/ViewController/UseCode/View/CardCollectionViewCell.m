//
//  CourseListCollectionViewCell.m
//  yifu
//
//  Created by tigerAndBull on 2019/3/6.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import "CardCollectionViewCell.h"

#import <TABKit/TABKit.h>
#import "Game.h"
#import "Masonry.h"

#define mLeft kWidth(15)
#define aLeft 8
#define imgHeight imgWidth*(130/96.0)
#define imgWidth 110

@implementation CardCollectionViewCell

+ (CGSize)cellSize {
    return CGSizeMake(kScreenWidth, mLeft+aLeft+imgHeight+aLeft);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.shadowView];
        
        [self.shadowView addSubview:self.leftImg];
        [self.shadowView addSubview:self.infoLab];
        [self.shadowView addSubview:self.titleLab];
        [self.shadowView addSubview:self.contentLab];
        [self.shadowView addSubview:self.timeLab];
        [self.shadowView addSubview:self.priceLab];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(aLeft);
        make.top.mas_offset(aLeft);
        make.width.mas_offset(imgWidth);
        make.height.mas_offset(imgHeight);
    }];
    
    self.leftImg.layer.cornerRadius = 5.0f;
    
    [self.infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftImg.mas_right).mas_offset(8);
        make.top.mas_equalTo(self.leftImg).mas_offset(10);
        make.right.mas_equalTo(self.shadowView).mas_offset(-aLeft);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.infoLab);
        make.top.mas_equalTo(self.infoLab.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(self.shadowView).mas_offset(-aLeft);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLab);
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(self.shadowView).mas_offset(-aLeft);
        make.height.mas_offset(40);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentLab);
        make.bottom.mas_equalTo(self.leftImg.mas_bottom).mas_offset(-5);
    }];
    
    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.shadowView).mas_offset(-aLeft-3);
        make.centerY.mas_equalTo(self.timeLab);
    }];
}

- (void)updateWithModel:(id)model {
    Game *game = model;
    [self.leftImg setImage:[UIImage imageNamed:game.cover]];
    self.infoLab.text = [NSString stringWithFormat:@"卫红路99号"];
    self.titleLab.text = game.title;
    self.contentLab.text = game.content;
    self.priceLab.text = @"成功报名";
}

#pragma mark - Lazy Method

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc] initWithFrame:CGRectMake(mLeft, mLeft, kScreenWidth - mLeft*2, mLeft+aLeft+imgHeight+aLeft - mLeft)];
        _shadowView.layer.cornerRadius = kHeight(10.0);
        _shadowView.backgroundColor = [UIColor whiteColor];
        // 给bgView边框设置阴影
        _shadowView.layer.shadowOpacity = 1;
        _shadowView.layer.shadowColor = kBackColor.CGColor;
        _shadowView.layer.shadowRadius = 5;
        _shadowView.layer.shadowOffset = CGSizeMake(2,2);
    }
    return _shadowView;
}

- (UIImageView *)leftImg {
    if (!_leftImg) {
        _leftImg = [[UIImageView alloc] init];
        _leftImg.layer.masksToBounds = YES;
        _leftImg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _leftImg;
}

- (UILabel *)infoLab {
    if (!_infoLab) {
        _infoLab = [[UILabel alloc] init];
        _infoLab.font = kFont(14);
        _infoLab.text = @"张恒 南京中银律师事务所";
        _infoLab.textColor = kColor(0x666666FF);
    }
    return _infoLab;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = kFont(17);
        _titleLab.text = @"关于婚姻那点事";
        _titleLab.textColor = UIColor.blackColor;
    }
    return _titleLab;
}

- (UILabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = kFont(14);
        _contentLab.text = @"想必大家都想知道有关婚姻的方法，那如何";
        _contentLab.textColor = kColor(0x999999FF);
        _contentLab.numberOfLines = 0;
        _contentLab.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _contentLab;
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.font = kFont(13);
        _timeLab.text = @"更新于2019-01-11";
        _timeLab.textColor = kColor(0x999999FF);
    }
    return _timeLab;
}

- (UILabel *)priceLab {
    if (!_priceLab) {
        _priceLab = [[UILabel alloc] init];
        _priceLab.font = kFont(16);
        _priceLab.text = @"¥90";
        _priceLab.textColor = kColor(0xE85952FF);
    }
    return _priceLab;
}

@end
