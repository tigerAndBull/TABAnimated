//
//  CardTableViewCell.m
//  TABAnimatedDemo
//
//  Created by tigerAndBull on 2019/10/2.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "CardTableViewCell.h"

#import <TABKit/TABKit.h>
#import "Game.h"
#import "Masonry.h"

#define mLeft kWidth(10)
#define aLeft 10
#define imgHeight imgWidth*(130/96.0)
#define imgWidth 110

@implementation CardTableViewCell

+ (CGFloat)cellHeight {
    return aLeft+imgHeight+aLeft+10;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 10*2, [CardTableViewCell cellHeight]-10)];
        view.layer.cornerRadius = kHeight(10.0);
        view.backgroundColor = [UIColor tab_cardDynamicBackgroundColor];
        // 给bgView边框设置阴影
        view.layer.shadowOpacity = 0.1;
        view.layer.shadowColor = UIColor.blackColor.CGColor;
        view.layer.shadowRadius = 5;
        view.layer.shadowOffset = CGSizeMake(1,1);
        self.backView = view;
        [self addSubview:view];
        
        [view addSubview:self.leftImg];
        [view addSubview:self.infoLab];
        [view addSubview:self.titleLab];
        [view addSubview:self.contentLab];
        [view addSubview:self.timeLab];
        [view addSubview:self.priceLab];
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
        make.right.mas_equalTo(self.backView).mas_offset(-aLeft-10);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.infoLab);
        make.top.mas_equalTo(self.infoLab.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(self.backView).mas_offset(-aLeft-10);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLab);
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(10);
        make.right.mas_equalTo(self.backView).mas_offset(-aLeft-10-5);
        make.height.mas_offset(40);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentLab);
        make.bottom.mas_equalTo(self.leftImg.mas_bottom).mas_offset(-5);
    }];
    
    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.backView).mas_offset(-aLeft-3-10);
        make.centerY.mas_equalTo(self.timeLab);
    }];
}

- (void)updateWithModel:(id)model {
    Game *game = model;
    [self.leftImg setImage:[UIImage imageNamed:game.cover]];
    self.infoLab.text = [NSString stringWithFormat:@"卫红路99号"];
    self.titleLab.text = game.title;
    self.contentLab.text = game.content;
    self.priceLab.text = @"成功报名";
}

#pragma mark - Lazy Method

- (UIImageView *)leftImg {
    if (!_leftImg) {
        _leftImg = [[UIImageView alloc] init];
        _leftImg.layer.masksToBounds = YES;
        _leftImg.contentMode = UIViewContentModeScaleAspectFill;
        _leftImg.image = [UIImage imageNamed:@"test3.jpg"];
    }
    return _leftImg;
}

- (UILabel *)infoLab {
    if (!_infoLab) {
        _infoLab = [[UILabel alloc] init];
        _infoLab.font = kFont(14);
        _infoLab.text = @"罗志祥 时间管理大师";
        _infoLab.textColor = kColor(0x666666FF);
    }
    return _infoLab;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = kFont(17);
        _titleLab.text = @"我的多人运动";
        _titleLab.textColor = UIColor.blackColor;
    }
    return _titleLab;
}

- (UILabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = kFont(14);
        _contentLab.text = @"想必大家都想知道多人运动的秘诀";
        _contentLab.textColor = kColor(0x999999FF);
        _contentLab.numberOfLines = 0;
        _contentLab.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _contentLab;
}

- (UILabel *)timeLab {
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.font = kFont(13);
        _timeLab.text = @"更新于2019-01-11";
        _timeLab.textColor = kColor(0x999999FF);
    }
    return _timeLab;
}

- (UILabel *)priceLab {
    if (!_priceLab) {
        _priceLab = [[UILabel alloc] init];
        _priceLab.font = kFont(16);
        _priceLab.text = @"¥500";
        _priceLab.textColor = kColor(0xE85952FF);
    }
    return _priceLab;
}

@end
