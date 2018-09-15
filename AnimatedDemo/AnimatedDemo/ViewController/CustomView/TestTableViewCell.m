//
//  GameTableViewCell.m
//  lifeAndSport
//
//  Created by tigerAndBull on 2018/6/6.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "TestTableViewCell.h"
#import "TABAnimated.h"
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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //获取对应组件文本大小
    CGSize titleSize = [TABMethod tab_getSizeWithText:titleLab.text sizeWithFont:kFont(15) constrainedToSize:CGSizeMake(MAXFLOAT, 25)];
    CGSize timeSize = [TABMethod tab_getSizeWithText:timeLab.text sizeWithFont:kFont(12) constrainedToSize:CGSizeMake(MAXFLOAT, 25)];
    
    //布局
    gameImg.frame = CGRectMake(15, 10, (self.frame.size.height-20)*1.5, (self.frame.size.height-20));
    gameImg.layer.cornerRadius = 5;
    
    titleLab.frame = CGRectMake(CGRectGetMaxX(gameImg.frame)+15, 10, titleSize.width>0?self.frame.size.width-(CGRectGetMaxX(gameImg.frame)+15):130, 25);
    timeLab.frame = CGRectMake(CGRectGetMaxX(gameImg.frame)+15, CGRectGetMaxY(titleLab.frame)+5, timeSize.width>0?self.frame.size.width-(CGRectGetMaxX(gameImg.frame)+15):200, 15);
    statusBtn.frame = CGRectMake(CGRectGetMaxX(gameImg.frame)+15, CGRectGetMaxY(timeLab.frame)+5+5,70, 20);
    
    if ( timeSize.width > 0 ) {
        statusBtn.layer.cornerRadius = 5;
    }
    
    //运行动画/移除动画
    [TABViewAnimated startOrEndAnimated:self];
}

#pragma mark -  Public Methods

- (void)initWithData:(Game *)game {
    
    [statusBtn setBackgroundColor:[UIColor whiteColor]];
    
    titleLab.text = game.title;
    timeLab.text = @"报名时间：2018-09-12";
    [gameImg setImage:[UIImage imageNamed:game.cover]];
    
    [statusBtn setTitle:@"已结束" forState:UIControlStateNormal];
    [statusBtn setBackgroundColor:[UIColor grayColor]];
}

#pragma mark - Initialize Methods

- (void)initUI {
    
    {
        UIImageView *iv = [[UIImageView alloc] init];
        iv.backgroundColor = kBackColor;
        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.layer.masksToBounds = YES;
        
        gameImg = iv;
        [self.contentView addSubview:iv];
    }
    
    {
        UILabel *lab = [[UILabel alloc]init];
        [lab setFont:kFont(15)];
        lab.loadStyle = TABViewLoadAnimationLong;
        [lab setTextColor:[UIColor blackColor]];
        [lab setText:@""];
        
        titleLab = lab;
        [self.contentView addSubview:lab];
    }
    
    {
        UILabel *lab = [[UILabel alloc]init];
        [lab setFont:kFont(12)];
        lab.loadStyle = TABViewLoadAnimationShort;
        [lab setTextColor:[UIColor grayColor]];
        [lab setText:@""];
        
        timeLab = lab;
        [self.contentView addSubview:lab];
    }
    
    {
        UIButton *btn = [[UIButton alloc]init];
        [btn setTitle:@"" forState:UIControlStateNormal];
        btn.backgroundColor = kBackColor;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:kFont(12)];
        
        statusBtn = btn;
        [self.contentView addSubview:btn];
    }
}

@end
