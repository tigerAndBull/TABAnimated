//
//  MyTestTableViewCell.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/3/5.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import "MyTestTableViewCell.h"
#import <TABKit/TABKit.h>

#define mLeft 15
#define headImgWidth 40
#define imgCount 3
#define imgWidth (kScreenWidth - 10*2 - mLeft*2)/3

@interface MyTestTableViewCell()

@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UILabel *firstLab;
@property (nonatomic,strong) UILabel *secondLab;

//@property (nonatomic,strong) UILabel *nameLab;
//
@property (nonatomic,strong) UILabel *linesLab;

@property (nonatomic,strong) NSMutableArray <UIImageView *> *imageArray;

@end

@implementation MyTestTableViewCell

+ (NSNumber *)cellHeight {
    return [NSNumber numberWithFloat:10+headImgWidth+5+80+10+imgWidth];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
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
    self.linesLab.frame = CGRectMake(mLeft, CGRectGetMaxY(self.headImg.frame)+5, kScreenWidth - mLeft*2, 80);
    
    for (int i = 0; i < self.imageArray.count; i++) {
        UIImageView *img = self.imageArray[i];
        img.frame = CGRectMake(mLeft+(imgWidth+10)*i, CGRectGetMaxY(self.linesLab.frame)+10, imgWidth, imgWidth);
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
        _firstLab.font = [UIFont systemFontOfSize:15.0];
    }
    return _firstLab;
}

- (UILabel *)secondLab {
    if (!_secondLab) {
        _secondLab = [[UILabel alloc] init];
        _secondLab.font = [UIFont systemFontOfSize:14.0];
    }
    return _secondLab;
}

- (UILabel *)linesLab {
    if (!_linesLab) {
        _linesLab = [[UILabel alloc] init];
        _linesLab.font = [UIFont systemFontOfSize:14.0];
        _linesLab.numberOfLines = 4;
    }
    return _linesLab;
}

@end
