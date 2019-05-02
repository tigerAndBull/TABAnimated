//
//  LawyerCollectionViewCell.m
//  yifu
//
//  Created by tigerAndBull on 2019/2/25.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import "LawyerCollectionViewCell.h"

#import <TABKit/TABKit.h>
#import "Masonry.h"

#define mLeft 15
#define mTop 10
#define imgWidth 70
#define btnWidth 55

#define kLineColor kColor(0xE6E6E6FF)
#define kOrangeColor kColor(0xEFBB56FF)
#define kGrayColor kColor(0x999999FF)
#define kTextColor kColor(0x666666FF)

@interface LawyerCollectionViewCell()

@property (nonatomic,strong) UIImageView *leftImg;
@property (nonatomic,strong) TABLabel *nameLab;
@property (nonatomic,strong) UILabel *typeLab;
@property (nonatomic,strong) UILabel *areaLab;

@property (nonatomic,strong) NSMutableArray <TABLabel *> *labelArray;

@property (nonatomic,strong) UIView *lineView;

@end

@implementation LawyerCollectionViewCell

+ (CGSize)cellSize {
    return CGSizeMake(kScreenWidth, mTop+imgWidth+mTop);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self.contentView addSubview:self.leftImg];
        [self.contentView addSubview:self.typeLab];
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.areaLab];
        
        _labelArray = [NSMutableArray array];
        
        for (int i = 0; i < 3; i++) {
            TABLabel *lab = [[TABLabel alloc] init];
            lab.layer.borderColor = kOrangeColor.CGColor;
            lab.layer.borderWidth = 1.0;
            lab.font = kFont(13);
            lab.textColor = kOrangeColor;
            lab.hidden = YES;
            lab.text = @"xxxx";
            [_labelArray addObject:lab];
            [self addSubview:lab];
        }
        
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.leftImg.frame = CGRectMake(mLeft, mTop, imgWidth, imgWidth);
    self.leftImg.layer.cornerRadius = 5.0f;
    
    self.typeLab.frame = CGRectMake(CGRectGetMaxX(self.leftImg.frame)+kWidth(12), CGRectGetMinY(self.leftImg.frame)+(imgWidth - kHeight(20))/2.0, kWidth(100), kHeight(20));
    
    CGSize size = [self.nameLab getTextSize:CGSizeMake(MAXFLOAT, kHeight(30))];
    self.nameLab.frame = CGRectMake(CGRectGetMinX(self.typeLab.frame), CGRectGetMinY(self.typeLab.frame)-30, size.width, kHeight(30));
    
    [self.areaLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.typeLab.mas_bottom).mas_offset(2);
        make.left.mas_equalTo(self.typeLab);
        make.width.mas_offset(kScreenWidth - imgWidth - mLeft*2 - kWidth(12));
        make.height.mas_offset(kHeight(25));
    }];
    
    for (int i = 0; i < self.labelArray.count; i++) {
        TABLabel *lab = self.labelArray[i];
        CGSize size = [lab getTextSize:CGSizeMake(MAXFLOAT, kHeight(22))];
        if (i == 0) {
            lab.frame = CGRectMake(CGRectGetMaxX(self.nameLab.frame)+8, isIPhoneFill?8-1:8+2, size.width+5, size.height+2);
        }else {
            TABLabel *tempLab = self.labelArray[i-1];
            lab.frame = CGRectMake(CGRectGetMaxX(tempLab.frame)+kWidth(5), isIPhoneFill?8-1:8+2, size.width+5, size.height+2);
        }
        
        lab.layer.cornerRadius = 4.0f;
    }
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(mLeft);
        make.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self).mas_offset(-1);
        make.height.mas_offset(1);
    }];
}

- (void)updateWithModel:(id)model {
    self.leftImg.image = [UIImage imageNamed:@"comic.jpg"];
    self.nameLab.text = @"四月是你的谎言";
    self.typeLab.text = @"催泪 神剧";
    self.areaLab.text = @"日本漫画家新川直司作画的漫画";
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
        _nameLab.textColor = UIColor.blackColor;
        _nameLab.font = kFont(16);
        _nameLab.text = @"测试数据";
    }
    return _nameLab;
}

- (UILabel *)typeLab {
    if (!_typeLab) {
        _typeLab = [[UILabel alloc] init];
        _typeLab.textColor = kGrayColor;
        _typeLab.font = kFont(13);
    }
    return _typeLab;
}

- (UILabel *)areaLab {
    if (!_areaLab) {
        _areaLab = [[UILabel alloc] init];
        _areaLab.textColor = kTextColor;
        _areaLab.font = kFont(13.5);
    }
    return _areaLab;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = kLineColor;
    }
    return _lineView;
}

@end
