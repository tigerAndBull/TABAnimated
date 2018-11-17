//
//  TestCollectionViewCell.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/10/12.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "TestCollectionViewCell.h"

#import "TABAnimated.h"

#import "Game.h"

@interface TestCollectionViewCell () {
    
    UIImageView *gameImg;
    UILabel *titleLab;
    UILabel *timeLab;
}

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
    CGSize titleSize = [TABMethod tab_getSizeWithText:titleLab.text sizeWithFont:tab_kFont(13) constrainedToSize:CGSizeMake(MAXFLOAT, 25)];
    CGSize timeSize = [TABMethod tab_getSizeWithText:timeLab.text sizeWithFont:tab_kFont(10) constrainedToSize:CGSizeMake(MAXFLOAT, 25)];
    
    //布局
    gameImg.frame = CGRectMake(15, 10, 40, 40);
    gameImg.layer.cornerRadius = 5;
    
    titleLab.frame = CGRectMake(CGRectGetMaxX(gameImg.frame)+15, 12, titleSize.width, titleSize.height);
    timeLab.frame = CGRectMake(CGRectGetMaxX(gameImg.frame)+15, CGRectGetMaxY(titleLab.frame)+5, timeSize.width,15);
}

#pragma mark - Public Methods

- (void)initWithData:(Game *)game {
    
    titleLab.text = game.content;
    timeLab.text = @"报名时间：2018-09-12";
    [gameImg setImage:[UIImage imageNamed:@"test.jpg"]];
}

#pragma mark - Initize Methods

- (void)initUI {
    
    {
        UIImageView *iv = [[UIImageView alloc] init];
        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.layer.masksToBounds = YES;
        iv.loadStyle = TABViewLoadAnimationWithOnlySkeleton;
        
        gameImg = iv;
        [self addSubview:iv];
    }
    
    {
        UILabel *lab = [[UILabel alloc]init];
        [lab setFont:tab_kFont(13)];
        [lab setTextColor:[UIColor blackColor]];
        [lab setText:@""];
        lab.loadStyle = TABViewLoadAnimationWithOnlySkeleton;
        
        titleLab = lab;
        [self addSubview:lab];
    }
    
    {
        UILabel *lab = [[UILabel alloc]init];
        [lab setFont:tab_kFont(10)];
        [lab setTextColor:[UIColor grayColor]];
        [lab setText:@""];
        lab.loadStyle = TABViewLoadAnimationWithOnlySkeleton;
        
        timeLab = lab;
        [self addSubview:lab];
    }
}

@end
