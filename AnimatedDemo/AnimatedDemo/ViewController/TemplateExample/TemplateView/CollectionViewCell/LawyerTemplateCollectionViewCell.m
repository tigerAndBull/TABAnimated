//
//  LawyerTemplateCollectionViewCell.m
//  yifu
//
//  Created by tigerAndBull on 2019/4/15.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "LawyerTemplateCollectionViewCell.h"

#import <TABKit/TABKit.h>
#import "Masonry.h"

#define mLeft 15
#define mTop 10
#define imgWidth 70
#define btnWidth 55

@interface LawyerTemplateCollectionViewCell()

@property (nonatomic,strong) UIImageView *leftImg;
@property (nonatomic,strong) TABLabel *nameLab;
@property (nonatomic,strong) UILabel *typeLab;
@property (nonatomic,strong) UILabel *areaLab;

@end

@implementation LawyerTemplateCollectionViewCell

+ (NSValue *)cellSize {
    return [NSValue valueWithCGSize:CGSizeMake(kScreenWidth, mTop+imgWidth+mTop)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.leftImg];
        [self.contentView addSubview:self.typeLab];
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.areaLab];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.leftImg.frame = CGRectMake(mLeft, mTop, imgWidth, imgWidth);
    self.leftImg.layer.cornerRadius = 5.0f;
    
    self.typeLab.frame = CGRectMake(CGRectGetMaxX(self.leftImg.frame)+kWidth(12), CGRectGetMaxY(self.leftImg.frame) - imgWidth/2.0 - 15/2.0, 160, 15);
    
    self.nameLab.frame = CGRectMake(CGRectGetMinX(self.typeLab.frame), CGRectGetMinY(self.typeLab.frame)-15-5, kScreenWidth - imgWidth - mLeft*2 - kWidth(12) - 10, 15);
    
    [self.areaLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.typeLab.mas_bottom).mas_offset(2);
        make.left.mas_equalTo(self.typeLab);
        make.width.mas_offset(90);
        make.height.mas_offset(15);
    }];
}

#pragma mark - Lazy Method

- (UIImageView *)leftImg {
    if (!_leftImg) {
        _leftImg = [[UIImageView alloc] init];
        _leftImg.layer.masksToBounds = YES;
    }
    return _leftImg;
}

- (TABLabel *)nameLab {
    if (!_nameLab) {
        _nameLab = [[TABLabel alloc] init];
        _nameLab.font = kFont(16);
    }
    return _nameLab;
}

- (UILabel *)typeLab {
    if (!_typeLab) {
        _typeLab = [[UILabel alloc] init];
        _typeLab.font = kFont(13);
    }
    return _typeLab;
}

- (UILabel *)areaLab {
    if (!_areaLab) {
        _areaLab = [[UILabel alloc] init];
        _areaLab.font = kFont(13.5);
    }
    return _areaLab;
}

@end
