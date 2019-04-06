//
//  TemplateCollectionViewCell.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/3/6.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import "TABTemplateCollectionViewCell.h"

#define mLeft 15
#define headImgWidth 40
#define imgCount 3
#define imgWidth ([UIScreen mainScreen].bounds.size.width - 10*2 - mLeft*2)/3

@interface TABTemplateCollectionViewCell()

@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UILabel *firstLab;
@property (nonatomic,strong) UILabel *secondLab;

@property (nonatomic,strong) UILabel *linesLab;

@property (nonatomic,strong) NSMutableArray <UIImageView *> *imageArray;

@end

@implementation TABTemplateCollectionViewCell

+ (NSValue *)cellSize {
    return [NSValue valueWithCGSize:CGSizeMake([UIScreen mainScreen].bounds.size.width,
                                               10+headImgWidth+80+10+([UIScreen mainScreen].bounds.size.width-10*2-15*2)/3+10)];
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
    
    self.firstLab.frame = CGRectMake(mLeft+headImgWidth+10, 13, 80, 15);
    self.secondLab.frame = CGRectMake(mLeft+headImgWidth+10, 15+15+1, 100, 15);
    self.linesLab.frame = CGRectMake(mLeft, CGRectGetMaxY(self.headImg.frame)+5, [UIScreen mainScreen].bounds.size.width - mLeft*2, 80);
    
    for (NSInteger i = 0; i < self.imageArray.count; i++) {
        UIImageView *img = self.imageArray[i];
        img.frame = CGRectMake(mLeft+(imgWidth+10)*i, CGRectGetMaxY(self.linesLab.frame)+5, imgWidth, imgWidth);
    }
}

#pragma mark - Lazy Method

- (UIImageView *)headImg {
    if (!_headImg) {
        _headImg = [[UIImageView alloc] init];
    }
    return _headImg;
}

- (UILabel *)firstLab {
    if (!_firstLab) {
        _firstLab = [[UILabel alloc] init];
    }
    return _firstLab;
}

- (UILabel *)secondLab {
    if (!_secondLab) {
        _secondLab = [[UILabel alloc] init];
    }
    return _secondLab;
}

- (UILabel *)linesLab {
    if (!_linesLab) {
        _linesLab = [[UILabel alloc] init];
        _linesLab.numberOfLines = 4;
    }
    return _linesLab;
}


@end
