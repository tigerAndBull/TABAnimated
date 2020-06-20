//
//  LawyerTableViewCell.m
//  TABAnimatedDemo
//
//  Created by tigerAndBull on 2020/5/4.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "LawyerTableViewCell.h"

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

@interface LawyerTableViewCell()

@property (nonatomic,strong) UIImageView *leftImg;
@property (nonatomic,strong) TABLabel *nameLab;
@property (nonatomic,strong) UILabel *typeLab;
@property (nonatomic,strong) UILabel *areaLab;

@property (nonatomic,strong) UIView *lineView;

@end

@implementation LawyerTableViewCell

+ (CGFloat)cellHeight {
    return mTop+imgWidth+mTop;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.leftImg];
        [self.contentView addSubview:self.typeLab];
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.areaLab];
        
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
        _lineView.backgroundColor = [UIColor tab_getColorWithLightColor:kLineColor darkColor:UIColor.clearColor];
    }
    return _lineView;
}

@end
