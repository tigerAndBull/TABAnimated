//
//  GameTableViewCell.m
//  TABAnimated
//
//  Created by tigerAndBull on 2018/6/6.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "TestTableViewCell.h"
#import "Game.h"
#import <TABKit/TABKit.h>

@interface TestTableViewCell ()

@property (nonatomic, strong) UIImageView *gameImg;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIButton *statusBtn;

@end

@implementation TestTableViewCell

+ (CGFloat)cellHeight {
    return 90;
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
    self.gameImg.layer.cornerRadius = 5;
    self.statusBtn.layer.cornerRadius = 5;
}

#pragma mark - Public Methods

- (void)initWithData:(Game *)game {
    self.titleLab.text = [NSString stringWithFormat:@"鬼灭之刃第%@集",game.gameId];
    self.timeLab.text = @"发布时间：2018-09-12";
    [self.gameImg setImage:[UIImage imageNamed:@"long.jpg"]];
    
    [self.statusBtn setTitle:@"未观看" forState:UIControlStateNormal];
    [self.statusBtn setBackgroundColor:[UIColor grayColor]];
}

- (void)updateWithModel:(id)model {
    Game *game = model;
    [self initWithData:game];
}

#pragma mark - Initize Methods

- (void)initUI {
    
    {
        UIImageView *iv = [[UIImageView alloc] init];
        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.layer.masksToBounds = YES;
        
        self.gameImg = iv;
        [self addSubview:iv];
    }
    
    {
        UILabel *lab = [[UILabel alloc]init];
        [lab setFont:kFont(15)];
        [lab setTextColor:[UIColor blackColor]];
        
        self.titleLab = lab;
        [self addSubview:lab];
    }
    
    {
        UILabel *lab = [[UILabel alloc]init];
        [lab setFont:kFont(12)];
        
        self.timeLab = lab;
        [self addSubview:lab];
    }
    
    {
        UIButton *btn = [[UIButton alloc]init];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:kFont(12)];
        
        self.statusBtn = btn;
        [self addSubview:btn];
    }
    
    [self.gameImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.top.mas_offset(10);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-10);
        make.width.mas_equalTo(self.gameImg.mas_height).multipliedBy(1.4);
    }];

    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.gameImg.mas_right).mas_offset(15);
        make.top.mas_offset(10);
        make.right.mas_equalTo(self).mas_offset(-20);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLab);
        make.top.mas_equalTo(self.titleLab.mas_bottom).mas_offset(5);
        make.right.mas_equalTo(self).mas_offset(-40);
    }];
    
    [self.statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.gameImg.mas_right).mas_offset(15);
        make.top.mas_equalTo(self.timeLab.mas_bottom).mas_offset(10);
        make.width.mas_offset(70);
        make.height.mas_offset(20);
    }];
}

@end
