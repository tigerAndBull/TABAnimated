//
//  TemplateSecondCollectionViewCell.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/3/8.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import "TemplateSecondCollectionViewCell.h"
#import "Masonry.h"
#import <TABKit/TABKit.h>

#define mLeft 0
#define headImgWidth 40

@interface TemplateSecondCollectionViewCell()

@property (nonatomic,strong) UIImageView *gameImg;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *timeLab;

@end

@implementation TemplateSecondCollectionViewCell

+ (NSValue *)cellSize {
    return [NSValue valueWithCGSize:CGSizeMake((kScreenWidth-30)/2.0, 10+headImgWidth+10)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.gameImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(mLeft);
        make.width.height.mas_offset(headImgWidth);
        make.top.mas_offset(10);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.gameImg.mas_right).mas_offset(10);
        make.top.mas_offset(15);
        make.right.mas_equalTo(self).mas_offset(-20);
        make.height.mas_offset(18);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLab);
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(2);
        make.right.mas_equalTo(self).mas_offset(-5);
        make.height.mas_offset(12);
    }];
}

- (void)initUI {
    
    {
        UIImageView *iv = [[UIImageView alloc] init];
        self.gameImg = iv;
        [self.contentView addSubview:iv];
    }
    
    {
        UILabel *lab = [[UILabel alloc]init];
        self.titleLab = lab;
        [self.contentView addSubview:lab];
    }
    
    {
        UILabel *lab = [[UILabel alloc]init];
        self.timeLab = lab;
        [self.contentView addSubview:lab];
    }
}


@end
