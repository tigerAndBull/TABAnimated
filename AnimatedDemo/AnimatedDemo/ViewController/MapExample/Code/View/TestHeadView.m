//
//  TestHeadView.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/9/20.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "TestHeadView.h"

#import "TABAnimated.h"
#import "Game.h"

#import "Masonry.h"
#import <TABKit/TABKit.h>

@interface TestHeadView ()

@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *contentLab;

@end

@implementation TestHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    // 布局
    [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(10);
        make.top.mas_offset(15);
        make.width.mas_offset(self.frame.size.height-20);
        make.height.mas_offset(self.frame.size.height-20);
    }];
    
    self.headImg.layer.cornerRadius = (self.frame.size.height-20)/2;
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImg.mas_right).mas_offset(10);
        make.top.mas_offset(25);
        make.right.mas_equalTo(self).mas_offset(-20);
        make.height.mas_offset(20);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImg.mas_right).mas_offset(10);
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(5);
        make.right.mas_equalTo(self).mas_offset(-20);
        make.height.mas_offset(20);
    }];
}

#pragma mark - Public Methods

- (void)initWithData:(Game *)game {
    self.titleLab.text = game.title;
    self.contentLab.text = game.content;
    self.headImg.image = [UIImage imageNamed:game.cover];
}

#pragma mark - Initize Methods

- (void)initUI {
    
    {
        UIImageView *img = [[UIImageView alloc] init];
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.layer.masksToBounds = YES;
        self.headImg = img;
        [self addSubview:img];
    }
    
    {
        UILabel *lab = [[UILabel alloc] init];
        lab.font = kFont(16);
        lab.textAlignment = NSTextAlignmentLeft;
        lab.textColor = [UIColor blackColor];
        self.titleLab = lab;
        [self addSubview:lab];
    }
    
    {
        UILabel *lab = [[UILabel alloc] init];
        lab.font = kFont(14);
        lab.textAlignment = NSTextAlignmentLeft;
        lab.textColor = [UIColor grayColor];
        self.contentLab = lab;
        [self addSubview:lab];
    }
}

@end
