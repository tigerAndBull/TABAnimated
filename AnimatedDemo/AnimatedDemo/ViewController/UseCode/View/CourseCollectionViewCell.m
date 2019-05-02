//
//  CourseCollectionViewCell.m
//  yifu
//
//  Created by tigerAndBull on 2019/2/25.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import "CourseCollectionViewCell.h"
#import "Masonry.h"
#import <TABKit/TABKit.h>

#define mLeft kWidth(15)

@interface CourseCollectionViewCell()

@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UILabel *otherInfoLab;

@property (nonatomic,strong) UILabel *priceLab;
@property (nonatomic,strong) UILabel *dateLab;

@end

@implementation CourseCollectionViewCell

+ (CGSize)cellSize {
    return CGSizeMake(kScreenWidth,
                      mLeft+kHeight(20)+kHeight(2)+kHeight(20)+kHeight(10)+kHeight(30)+kHeight(2)+kHeight(20));
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.headImg];
        [self.contentView addSubview:self.priceLab];
        [self.contentView addSubview:self.otherInfoLab];
        [self.contentView addSubview:self.dateLab];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self).mas_offset(mLeft);
        make.width.mas_offset(kWidth(100));
        make.height.mas_offset(kHeight(20));
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLab);
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(kHeight(2));
        make.height.mas_offset(kHeight(20));
        make.width.mas_offset(kScreenWidth/2.0);
    }];
    
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLab);
        make.width.height.mas_offset(kHeight(30));
        make.top.mas_equalTo(self.contentLab.mas_bottom).mas_offset(kHeight(10));
    }];
    
    self.headImg.layer.cornerRadius = kHeight(30)/2.0;
    
    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).mas_offset(-mLeft-10);
        make.bottom.mas_equalTo(self.headImg.mas_bottom);
    }];
    
    [self.otherInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLab);
        make.top.mas_equalTo(self.headImg.mas_bottom).mas_offset(kHeight(2));
        make.width.mas_offset(kScreenWidth/2.0);
        make.height.mas_offset(kHeight(20));
    }];
    
    [self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.priceLab);
        make.top.mas_equalTo(self.otherInfoLab);
        make.width.mas_offset(kScreenWidth/2.0);
        make.height.mas_offset(kHeight(20));
    }];
}

- (void)updateWithModel:(id)model {
    self.titleLab.text = @"骨架屏";
    self.contentLab.text = @"不好用没关系，我们一起优化吧～";
    self.otherInfoLab.text = @"家住在卫红路 来啊";
    self.headImg.image = [UIImage imageNamed:@"comic.jpg"];
    self.priceLab.text = @"$18";
    self.dateLab.text = @"更新于2019-01-11";
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"婚姻法律课";
        _titleLab.font = kFont(15);
        _titleLab.textColor = UIColor.blackColor;
    }
    return _titleLab;
}

- (UILabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.text = @"离婚协议约定的房产赠予孩子与否";
        _contentLab.font = kFont(15);
        _contentLab.textColor = UIColor.grayColor;
    }
    return _contentLab;
}

- (UILabel *)otherInfoLab {
    if (!_otherInfoLab) {
        _otherInfoLab = [[UILabel alloc] init];
        _otherInfoLab.font = kFont(13);
        _otherInfoLab.text = @"卫红路 婚姻家庭律师";
        _otherInfoLab.textColor = UIColor.grayColor;
    }
    return _otherInfoLab;
}

- (UIImageView *)headImg {
    if (!_headImg) {
        _headImg = [[UIImageView alloc] init];
        _headImg.backgroundColor = UIColor.redColor;
    }
    return _headImg;
}

- (UILabel *)priceLab {
    if (!_priceLab) {
        _priceLab = [[UILabel alloc] init];
        _priceLab.font = kFont(16);
        _priceLab.textAlignment = NSTextAlignmentRight;
    }
    return _priceLab;
}

- (UILabel *)dateLab {
    if (!_dateLab) {
        _dateLab = [[UILabel alloc] init];
        _dateLab.font = kFont(13);
        _dateLab.text = @"更新于2019-01-11";
        _dateLab.textColor = UIColor.grayColor;
        _dateLab.textAlignment = NSTextAlignmentRight;
    }
    return _dateLab;
}

@end
