//
//  LawyerArticleCollectionViewCell.m
//  yifu
//
//  Created by tigerAndBull on 2019/2/27.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import "LawyerArticleCollectionViewCell.h"

#import <TABKit/TABKit.h>
#import "Masonry.h"

#define mLeft kHeight(20)
#define mTop kHeight(20)
#define imgWidth kHeight(85)
#define imgHeight kHeight(120)

@interface LawyerArticleCollectionViewCell()

@property (nonatomic,strong) UIImageView *leftImg;
@property (nonatomic,strong) UILabel *infoLab;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) TABLabel *contentLab;

@end

@implementation LawyerArticleCollectionViewCell

+ (CGSize)cellSize {
    return CGSizeMake(kScreenWidth, mTop+imgHeight+mTop);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(mLeft);
        make.top.mas_offset(mTop);
        make.width.mas_offset(imgWidth);
        make.height.mas_offset(imgHeight);
    }];
    
    self.leftImg.layer.cornerRadius = 5.0f;
    
    [self.infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftImg.mas_right).mas_offset(kWidth(10));
        make.top.mas_equalTo(self.leftImg);
        make.right.mas_equalTo(self).mas_offset(-mLeft);
        make.height.mas_offset(kHeight(20));
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.infoLab);
        make.top.mas_equalTo(self.infoLab.mas_bottom).mas_offset(kHeight(10));
        make.right.mas_equalTo(self).mas_offset(-mLeft);
        make.height.mas_offset(kHeight(30));
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.infoLab);
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(kHeight(10));
        make.right.mas_equalTo(self.infoLab);
        make.height.mas_offset(kHeight(50));
    }];
}

- (void)updateWithModel:(id)model {
    self.leftImg.image = [UIImage imageNamed:@"test.jpg"];
    self.titleLab.text = @"盘点四月新番";
    self.infoLab.text = @"鸡你太美";
    self.contentLab.text = @"大家好，我是练习时长两年半的个人练习生，我会唱，跳，rap，篮球。";
}

#pragma mark - Init Method

- (void)initUI {
    
    self.contentView.backgroundColor = UIColor.whiteColor;
    
    [self.contentView addSubview:self.leftImg];
    [self.contentView addSubview:self.infoLab];
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.contentLab];
}

#pragma mark - Lazy Method

- (UIImageView *)leftImg {
    if (!_leftImg) {
        _leftImg = [[UIImageView alloc] init];
        _leftImg.layer.masksToBounds = YES;
    }
    return _leftImg;
}

- (UILabel *)infoLab {
    if (!_infoLab) {
        _infoLab = [[UILabel alloc] init];
        _infoLab.font = kFont(15);
        _infoLab.textColor = UIColor.grayColor;
    }
    return _infoLab;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"关于婚姻那点事";
        _titleLab.font = kFont(18);
        _titleLab.textColor = UIColor.blackColor;
    }
    return _titleLab;
}

- (TABLabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [[TABLabel alloc] init];
        _contentLab.font = kFont(15);
        _contentLab.textColor = UIColor.lightGrayColor;
        _contentLab.numberOfLines = 0;
    }
    return _contentLab;
}

@end
