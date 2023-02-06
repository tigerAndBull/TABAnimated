//
//  WaterFlowCollectionViewCell.m
//  TABAnimatedDemo
//
//  Created by anwenhu on 2023/2/6.
//  Copyright © 2023 tigerAndBull. All rights reserved.
//

#import "WaterFlowCollectionViewCell.h"

#import "TABDefine.h"
#import "Game.h"
#import "Masonry.h"

#define mLeft kWidth(10)
#define aLeft 8
#define imgHeight imgWidth * (100 / 96.0)
#define imgWidth 80

@implementation WaterFlowCollectionViewCell

+ (CGSize)cellSize {
    return CGSizeMake((kScreenWidth - 12 * 3) / 2, aLeft + imgHeight + aLeft);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        self.contentView.layer.cornerRadius = kHeight(10.0);
        self.contentView.backgroundColor = [UIColor tab_cardDynamicBackgroundColor];
        // 给bgView边框设置阴影
        self.contentView.layer.shadowOpacity = 0.1;
        self.contentView.layer.shadowRadius = 5;
        self.contentView.layer.shadowOffset = CGSizeMake(1, 1);
        
        [self.contentView addSubview:self.leftImg];
        [self.contentView addSubview:self.infoLab];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.contentLab];
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
        make.left.mas_equalTo(self.leftImg.mas_right).mas_offset(8);
        make.top.mas_equalTo(self.leftImg).mas_offset(10);
        make.right.mas_equalTo(self).mas_offset(-aLeft);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.infoLab);
        make.top.mas_equalTo(self.infoLab.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(self).mas_offset(-aLeft);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLab);
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(self).mas_offset(-aLeft);
        make.height.mas_offset(60);
    }];
}

- (void)updateWithModel:(id)model {
    Game *game = model;
    [self.leftImg setImage:[UIImage imageNamed:game.cover]];
    self.infoLab.text = [NSString stringWithFormat:@"卫红路99号"];
    self.titleLab.text = game.title;
    self.contentLab.text = game.content;
}

#pragma mark - Lazy Method

- (UIImageView *)leftImg {
    if (!_leftImg) {
        _leftImg = [[UIImageView alloc] init];
        _leftImg.layer.masksToBounds = YES;
        _leftImg.contentMode = UIViewContentModeScaleAspectFill;
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
        _contentLab.numberOfLines = 0;
        _contentLab.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _contentLab;
}

@end
