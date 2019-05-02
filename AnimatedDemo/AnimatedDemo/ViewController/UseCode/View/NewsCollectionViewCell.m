//
//  TemplateCollectionViewCell.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/3/6.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import "NewsCollectionViewCell.h"
#import "Masonry.h"

#define mLeft 15
#define headImgWidth 40
#define imgCount 3
#define imgWidth ([UIScreen mainScreen].bounds.size.width - 10*2 - mLeft*2)/3

@interface NewsCollectionViewCell()

@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UILabel *firstLab;
@property (nonatomic,strong) UILabel *secondLab;

@property (nonatomic,strong) UILabel *linesLab;

@property (nonatomic,strong) NSMutableArray <UIImageView *> *imageArray;

@end

@implementation NewsCollectionViewCell

+ (CGSize)cellSize {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width,
                      10+headImgWidth+80+10+([UIScreen mainScreen].bounds.size.width-10*2-15*2)/3+10);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self.contentView addSubview:self.headImg];
        [self.contentView addSubview:self.firstLab];
        [self.contentView addSubview:self.secondLab];
        [self.contentView addSubview:self.linesLab];
        
        self.imageArray = [NSMutableArray array];
        for (int i = 0; i < imgCount; i++) {
            UIImageView *img = [[UIImageView alloc] init];
            [self.imageArray addObject:img];
            [self.contentView addSubview:img];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.headImg.frame = CGRectMake(mLeft, 10, headImgWidth, headImgWidth);
    self.headImg.layer.cornerRadius = headImgWidth/2.0f;
    
    [self.firstLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImg.mas_right).mas_offset(10);
        make.top.mas_offset(13);
    }];
    
    [self.secondLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.firstLab);
        make.top.mas_equalTo(self.firstLab.mas_bottom).mas_offset(5);
    }];
    
    [self.linesLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImg);
        make.top.mas_equalTo(self.headImg.mas_bottom).mas_offset(5);
        make.right.mas_equalTo(self).mas_offset(-mLeft);
        make.height.mas_offset(80);
    }];
    
    for (NSInteger i = 0; i < self.imageArray.count; i++) {
        UIImageView *img = self.imageArray[i];
        img.contentMode = UIViewContentModeScaleToFill;
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.headImg).mas_offset((imgWidth+10)*i);
            make.top.mas_equalTo(self.linesLab.mas_bottom).mas_offset(5);
            make.width.height.mas_offset(imgWidth);
        }];
    }
}

- (void)updateWithModel:(id)model {
    self.headImg.image = [UIImage imageNamed:@"head.jpg"];
    self.firstLab.text = @"测试标题";
    self.secondLab.text = @"北京市xxx街道xxx小区";
    self.linesLab.text = @"测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据";
    for (NSInteger i = 0; i < self.imageArray.count; i++) {
        UIImageView *img = self.imageArray[i];
        img.image = [UIImage imageNamed:@"comic.jpg"];
    }
}

#pragma mark - Lazy Method

- (UIImageView *)headImg {
    if (!_headImg) {
        _headImg = [[UIImageView alloc] init];
        _headImg.layer.masksToBounds = YES;
    }
    return _headImg;
}

- (UILabel *)firstLab {
    if (!_firstLab) {
        _firstLab = [[UILabel alloc] init];
        _firstLab.font = [UIFont systemFontOfSize:14.0];
        _firstLab.textColor = UIColor.blackColor;
    }
    return _firstLab;
}

- (UILabel *)secondLab {
    if (!_secondLab) {
        _secondLab = [[UILabel alloc] init];
        _secondLab.font = [UIFont systemFontOfSize:13.0];
        _secondLab.textColor = UIColor.grayColor;
    }
    return _secondLab;
}

- (UILabel *)linesLab {
    if (!_linesLab) {
        _linesLab = [[UILabel alloc] init];
        _linesLab.numberOfLines = 0;
    }
    return _linesLab;
}

@end
