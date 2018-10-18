//
//  GameTableViewCell.m
//  lifeAndSport
//
//  Created by tigerAndBull on 2018/6/6.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "TestTableViewCell.h"
#import "TABMethod.h"
#import "UITableViewCell+Animated.h"
#import "UIView+Animated.h"
#import "Game.h"

@interface TestTableViewCell () {
    
    UIImageView *gameImg;
    UILabel *titleLab;
    UILabel *timeLab;
    UIButton *statusBtn;
}

@end

@implementation TestTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    //获取对应组件文本大小
    CGSize titleSize = [TABMethod tab_getSizeWithText:titleLab.text sizeWithFont:tab_kFont(15) constrainedToSize:CGSizeMake(MAXFLOAT, 25)];
    CGSize timeSize = [TABMethod tab_getSizeWithText:timeLab.text sizeWithFont:tab_kFont(12) constrainedToSize:CGSizeMake(MAXFLOAT, 25)];

    //布局
    gameImg.frame = CGRectMake(15, 10, (self.frame.size.height-20)*1.5, (self.frame.size.height-20));
    gameImg.layer.cornerRadius = 5;

    titleLab.frame = CGRectMake(CGRectGetMaxX(gameImg.frame)+15, 10, titleSize.width, titleSize.height);
    timeLab.frame = CGRectMake(CGRectGetMaxX(gameImg.frame)+15, CGRectGetMaxY(titleLab.frame)+5, timeSize.width,15);
    statusBtn.frame = CGRectMake(CGRectGetMaxX(gameImg.frame)+15, CGRectGetMaxY(timeLab.frame)+5+5,70, 20);

    if ( timeSize.width > 0 ) {
        statusBtn.layer.cornerRadius = 5;
    }
}

#pragma mark - Public Methods

- (void)initWithData:(Game *)game {
    
    titleLab.text = [NSString stringWithFormat:@"赛事标题赛事标题标题%@～",game.gameId];
    timeLab.text = @"报名时间：2018-09-12";
    [gameImg setImage:[UIImage imageNamed:@"test.jpg"]];
    
    [statusBtn setTitle:@"已结束" forState:UIControlStateNormal];
    [statusBtn setBackgroundColor:[UIColor grayColor]];
}

#pragma mark - Initize Methods

- (void)initUI {
    
    {
        UIImageView *iv = [[UIImageView alloc] init];
        iv.backgroundColor = tab_kBackColor;
        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.layer.masksToBounds = YES;
        
        gameImg = iv;
        [self.contentView addSubview:iv];
    }
    
    {
        UILabel *lab = [[UILabel alloc]init];
        [lab setFont:tab_kFont(15)];
        lab.loadStyle = TABViewLoadAnimationLong;
        [lab setTextColor:[UIColor blackColor]];
        [lab setText:@""];
        
        titleLab = lab;
        [self.contentView addSubview:lab];
    }
    
    {
        UILabel *lab = [[UILabel alloc]init];
        [lab setFont:tab_kFont(12)];
        lab.loadStyle = TABViewLoadAnimationShort;
        [lab setTextColor:[UIColor grayColor]];
        [lab setText:@""];

        timeLab = lab;
        [self.contentView addSubview:lab];
    }
    
    {
        UIButton *btn = [[UIButton alloc]init];
        [btn setTitle:@"" forState:UIControlStateNormal];
        btn.backgroundColor = tab_kBackColor;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:tab_kFont(12)];

        statusBtn = btn;
        [self.contentView addSubview:btn];
    }
}

@end
