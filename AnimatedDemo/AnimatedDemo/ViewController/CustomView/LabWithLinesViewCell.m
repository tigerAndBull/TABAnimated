//
//  LabWithLinesViewCell.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/10/22.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "LabWithLinesViewCell.h"

#import "MyLabel.h"

#import "TABAnimated.h"
#import "TABMethod.h"

#import "Game.h"

@interface LabWithLinesViewCell () {
    
    UIImageView *gameImg;
    UILabel *titleLab;
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
    
    //获取对应组件文本大小
    CGSize titleSize = [TABMethod tab_getSizeWithText:titleLab.text sizeWithFont:tab_kFont(15) constrainedToSize:CGSizeMake(tab_kScreenWidth-(self.frame.size.height-20)*1.5-15-15-10, MAXFLOAT)];
    
    //布局
    gameImg.frame = CGRectMake(15, 10, (self.frame.size.height-20)*1.5, (self.frame.size.height-20));
    gameImg.layer.cornerRadius = 5;
    
    titleLab.frame = CGRectMake(CGRectGetMaxX(gameImg.frame)+15, 10, titleSize.width, titleSize.height);
}

#pragma mark - Public Methods

- (void)initWithData:(Game *)game {
    
    titleLab.text = [NSString stringWithFormat:@"赛事标题赛事标题标题赛事标题赛事标题标题赛事标题赛事标题标题赛事标题赛事标题标题赛事标题赛%@～",game.gameId];
    [gameImg setImage:[UIImage imageNamed:@"test.jpg"]];
}

#pragma mark - Initize Methods

- (void)initUI {
    
    {
        UIImageView *iv = [[UIImageView alloc] init];
        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.loadStyle = TABViewLoadAnimationWithOnlySkeleton;
        iv.layer.masksToBounds = YES;
        
        gameImg = iv;
        [self.contentView addSubview:iv];
    }
    
    {
        MyLabel *lab = [[MyLabel alloc]init];
        [lab setFont:tab_kFont(15)];
        lab.loadStyle = TABViewLoadAnimationLong;        // 需要设置，长短属性效果
        lab.numberOfLines = 3;                           // 也可以为0,有超出父视图判断，无视图间重叠判断
        lab.verticalAlignment = VerticalAlignmentTop;    // 多行文本 一个简单例子
        [lab setTextColor:[UIColor blackColor]];
        [lab setText:@""];
        
        titleLab = lab;
        [self.contentView addSubview:lab];
    }
}

@end
