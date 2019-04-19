//
//  CourseTemplateCollectionViewCell.m
//  yifu
//
//  Created by tigerAndBull on 2019/4/15.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "CardTemplateCollectionViewCell.h"

#import <TABKit/TABKit.h>
#import "Masonry.h"
#import "Game.h"

#define mLeft kWidth(12)
#define aLeft 8
#define imgHeight imgWidth*(130/96.0)
#define imgWidth 110

@interface CardTemplateCollectionViewCell()

@property (nonatomic,strong) UIImageView *leftImg;
@property (nonatomic,strong) UILabel *infoLab;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *priceLab;

@property (nonatomic,strong) UIView *shadowView;

@end

@implementation CardTemplateCollectionViewCell

+ (NSValue *)cellSize {
    return [NSValue valueWithCGSize:CGSizeMake(kScreenWidth, mLeft+aLeft+imgHeight+aLeft)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
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
        make.left.mas_equalTo(self.leftImg.mas_right).mas_offset(10);
        make.top.mas_equalTo(self.leftImg).mas_offset(10);
        make.width.mas_offset(60);
        make.height.mas_offset(15);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.infoLab);
        make.top.mas_equalTo(self.infoLab.mas_bottom).mas_offset(10);
        make.width.mas_offset(150);
        make.height.mas_offset(15);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLab);
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(self.shadowView).mas_offset(-aLeft);
        make.height.mas_offset(75);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentLab);
        make.bottom.mas_equalTo(self.leftImg.mas_bottom).mas_offset(-5);
        make.width.mas_offset(40);
    }];
    
    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.shadowView).mas_offset(-mLeft-3);
        make.width.mas_offset(60);
        make.height.mas_offset(20);
        make.centerY.mas_equalTo(self.timeLab);
    }];
}

- (void)updateWithModel:(id)model {
    Game *game = model;
    [self.leftImg setImage:[UIImage imageNamed:game.cover]];
    self.infoLab.text = [NSString stringWithFormat:@"卫红路99号"];
    self.titleLab.text = game.title;
    self.contentLab.text = game.content;
    self.priceLab.text = @"已报名";
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
        _contentLab.numberOfLines = 3;
        _contentLab.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _contentLab;
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.font = kFont(13);
        _timeLab.text = @"时间：2019-01-11";
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
