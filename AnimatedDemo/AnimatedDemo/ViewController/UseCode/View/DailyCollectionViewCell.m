//
//  DailyCollectionViewCell.m
//  yifu
//
//  Created by tigerAndBull on 2019/2/25.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import "DailyCollectionViewCell.h"
#import <TABKit/TABKit.h>
#import "Masonry.h"

#define mLeft kWidth(15)
#define imgWidth kHeight(100)

@interface DailyCollectionViewCell()

@property (nonatomic,strong) UIImageView *leftImg;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UILabel *otherInfoLab;

@end

@implementation DailyCollectionViewCell

+ (CGSize)cellSize {
    return CGSizeMake(kScreenWidth, kHeight(100)+kWidth(10)*2);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.leftImg];
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.otherInfoLab];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_offset(mLeft);
        make.width.height.mas_offset(imgWidth);
    }];
    
    self.leftImg.layer.cornerRadius = 5.0f;
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftImg.mas_right).mas_offset(kWidth(10));
        make.centerY.mas_equalTo(self.leftImg.mas_centerY).mas_offset(kHeight(3));
        make.right.mas_equalTo(self).mas_offset(-mLeft*2);
        make.height.mas_offset(kHeight(25));
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentLab);
        make.right.mas_equalTo(self.contentLab);
        make.bottom.mas_equalTo(self.contentLab.mas_top);
        make.height.mas_offset(kHeight(30));
    }];
    
    [self.otherInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentLab);
        make.right.mas_equalTo(self.contentLab);
        make.height.mas_offset(kHeight(20));
        make.top.mas_equalTo(self.contentLab.mas_bottom).mas_offset(kHeight(2));
    }];
}

- (void)updateWithModel:(id)model {
    [self.leftImg setImage:[UIImage imageNamed:@"comic.jpg"]];
    self.titleLab.text = @"今天晚上你撸代码了吗？";
    self.contentLab.text = @"如果你没撸代码，那你还不赶紧动起来～";
    self.otherInfoLab.text = @"地址：西伯利亚东1000米";
}

#pragma mark - Init Method

- (UIImageView *)leftImg {
    if (!_leftImg) {
        _leftImg = [[UIImageView alloc] init];
        _leftImg.backgroundColor = UIColor.greenColor;
    }
    return _leftImg;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = kFont(15);
        _titleLab.text = @"关于婚姻那点事";
        _titleLab.textColor = UIColor.blackColor;
    }
    return _titleLab;
}

- (UILabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = kFont(14);
        _contentLab.text = @"关于婚姻那点事关于婚姻那点事";
        _contentLab.textColor = UIColor.grayColor;
    }
    return _contentLab;
}

- (UILabel *)otherInfoLab {
    if (!_otherInfoLab) {
        _otherInfoLab = [[UILabel alloc] init];
        _otherInfoLab.text = @"2019-01-11   203人阅读";
        _otherInfoLab.textColor = UIColor.lightGrayColor;
        _otherInfoLab.font = kFont(12);
    }
    return _otherInfoLab;
}

@end
