//
//  TestCollectionViewCell.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/10/12.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "TestCollectionViewCell.h"

#import "TABAnimated.h"
#import "Masonry.h"
#import <TABKit/TABKit.h>

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
        
        self.gameImg = iv;
        [self.contentView addSubview:iv];
    }
    
    {
        UILabel *lab = [[UILabel alloc]init];
        [lab setFont:kFont(13)];
        [lab setTextColor:[UIColor blackColor]];
        
        self.titleLab = lab;
        [self.contentView addSubview:lab];
    }
    
    {
        UILabel *lab = [[UILabel alloc]init];
        [lab setFont:kFont(10)];
        [lab setTextColor:[UIColor grayColor]];
        
        self.timeLab = lab;
        [self.contentView addSubview:lab];
    }
}

@end
