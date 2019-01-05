//
//  TestCollectionViewCell.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/10/12.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "TestCollectionViewCell.h"

#import "TABAnimated.h"
#import "TABMethod.h"
#import "Masonry.h"

#import "Game.h"

@interface TestCollectionViewCell ()

@property (nonatomic,strong) UIImageView *gameImg;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *timeLab;

@end

@implementation TestCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    //获取对应组件文本大小
//    CGSize titleSize = [TABMethod tab_getSizeWithText:titleLab.text sizeWithFont:tab_kFont(13) constrainedToSize:CGSizeMake(MAXFLOAT, 25)];
//    CGSize timeSize = [TABMethod tab_getSizeWithText:timeLab.text sizeWithFont:tab_kFont(10) constrainedToSize:CGSizeMake(MAXFLOAT, 25)];
    
    //布局
//    self.gameImg.frame = CGRectMake(15, 10, 40, 40);
//    self.gameImg.layer.cornerRadius = 5;
    
//    titleLab.frame = CGRectMake(CGRectGetMaxX(gameImg.frame)+15, 12, titleSize.width, titleSize.height);
//    timeLab.frame = CGRectMake(CGRectGetMaxX(gameImg.frame)+15, CGRectGetMaxY(titleLab.frame)+5, timeSize.width,15);
    [self.gameImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.top.mas_offset(10);
        make.width.mas_offset(40);
        make.height.mas_offset(40);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.gameImg.mas_right).mas_offset(15);
        make.top.mas_equalTo(self.contentView.mas_top).mas_offset(12);
        make.height.mas_offset(15);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.gameImg.mas_right).mas_offset(15);
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(10);
        make.height.mas_offset(15);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
    }];
}

#pragma mark - Public Methods

- (void)initWithData:(Game *)game {
    
    [self.gameImg setImage:[UIImage imageNamed:@"test.jpg"]];
    self.titleLab.text = game.content;
    self.timeLab.text = @"报名时间：2018-09-12";
}

#pragma mark - Initize Methods

- (void)initUI {
    
    {
        UIImageView *iv = [[UIImageView alloc] init];
        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.layer.masksToBounds = YES;
        iv.loadStyle = TABViewLoadAnimationWithOnlySkeleton;
        
        self.gameImg = iv;
        [self.contentView addSubview:iv];
    }
    
    {
        UILabel *lab = [[UILabel alloc]init];
        [lab setFont:tab_kFont(13)];
        [lab setTextColor:[UIColor blackColor]];
        lab.loadStyle = TABViewLoadAnimationWithOnlySkeleton;
        
        self.titleLab = lab;
        [self.contentView addSubview:lab];
    }
    
    {
        UILabel *lab = [[UILabel alloc]init];
        [lab setFont:tab_kFont(10)];
        [lab setTextColor:[UIColor grayColor]];
        lab.loadStyle = TABViewLoadAnimationWithOnlySkeleton;
        
        self.timeLab = lab;
        [self.contentView addSubview:lab];
    }
}

@end
