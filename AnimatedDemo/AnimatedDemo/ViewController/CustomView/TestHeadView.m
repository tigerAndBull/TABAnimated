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

@interface TestHeadView () {
    
    UIImageView *headImg;
    UILabel *titleLab;
    UILabel *contentLab;
}

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

    // 获取对应组件文本大小
    CGSize titleSize = [TABMethod tab_getSizeWithText:titleLab.text sizeWithFont:tab_kFont(16) constrainedToSize:CGSizeMake(MAXFLOAT, 20)];
    CGSize contentSize = [TABMethod tab_getSizeWithText:contentLab.text sizeWithFont:tab_kFont(14) constrainedToSize:CGSizeMake(MAXFLOAT, 20)];

    headImg.frame = CGRectMake(10, 10, self.frame.size.height-20, self.frame.size.height-20);
    headImg.layer.cornerRadius = headImg.frame.size.height/2;
    // 布局
    titleLab.frame = CGRectMake(CGRectGetMaxX(headImg.frame)+10, 15, titleSize.width, 20);
    contentLab.frame = CGRectMake(CGRectGetMaxX(headImg.frame)+10, 15+20+10, contentSize.width, 20);
}

#pragma mark - Public Methods

- (void)initWithData:(Game *)game {
    
    titleLab.text = game.title;
    contentLab.text = game.content;
    headImg.image = [UIImage imageNamed:game.cover];
}

#pragma mark - Initize Methods

- (void)initUI {
    
    {
        UIImageView *img = [[UIImageView alloc] init];
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.layer.masksToBounds = YES;
        img.loadStyle = TABViewLoadAnimationWithOnlySkeleton;
        
        headImg = img;
        [self addSubview:img];
    }
    
    {
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"";
        lab.font = tab_kFont(16);
        lab.textAlignment = NSTextAlignmentLeft;
        lab.textColor = [UIColor blackColor];
        lab.loadStyle = TABViewLoadAnimationShort;
        
        titleLab = lab;
        [self addSubview:lab];
    }
    
    {
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"";
        lab.font = tab_kFont(14);
        lab.textAlignment = NSTextAlignmentLeft;
        lab.textColor = [UIColor grayColor];
        lab.loadStyle = TABViewLoadAnimationLong;
        
        contentLab = lab;
        [self addSubview:lab];
    }
}

@end
