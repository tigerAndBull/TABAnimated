//
//  LabWithLinesViewCell.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/10/22.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "LabWithLinesViewCell.h"

#import "TABAnimated.h"

#import "Game.h"
#import <TABKit/TABKit.h>

@interface LabWithLinesViewCell () {
    UIImageView *gameImg;
    TABLabel *titleLab;
}

@end

@implementation LabWithLinesViewCell

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
    
    // 获取对应组件文本大小
    CGSize titleSize = [titleLab getTextSize:CGSizeMake(kScreenWidth-(self.frame.size.height-20)*1.5-15-15-10, MAXFLOAT)];
    // 布局
    gameImg.frame = CGRectMake(15, 10, (self.frame.size.height-20)*1.5, (self.frame.size.height-20));
    gameImg.layer.cornerRadius = 5;
    
    titleLab.frame = CGRectMake(CGRectGetMaxX(gameImg.frame)+15, 10, titleSize.width, titleSize.height);
}

#pragma mark - Public Methods

- (void)initWithData:(Game *)game {
    titleLab.text = [NSString stringWithFormat:@"%@",game.title];
    [gameImg setImage:[UIImage imageNamed:@"test.jpg"]];
}

#pragma mark - Initize Methods

- (void)initUI {
    
    {
        UIImageView *iv = [[UIImageView alloc] init];
        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.layer.masksToBounds = YES;
        
        gameImg = iv;
        [self.contentView addSubview:iv];
    }
    
    {
        TABLabel *lab = [[TABLabel alloc]init];
        [lab setFont:kFont(15)];
        lab.lineSpace = 5.0f;
        lab.tag = 1000;
        lab.numberOfLines = 3;
        [lab setTextColor:[UIColor blackColor]];
        
        titleLab = lab;
        [self.contentView addSubview:lab];
    }
}

@end
