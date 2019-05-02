//
//  XIBTableViewCell.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/10/7.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "XIBTableViewCell.h"

#import "UITableViewCell+TABLayoutSubviews.h"
#import "UIView+TABAnimated.h"

@interface XIBTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *testImageView;
@property (weak, nonatomic) IBOutlet UILabel *testLab;
@property (weak, nonatomic) IBOutlet UILabel *testLab2;
@property (weak, nonatomic) IBOutlet UILabel *testLab3;
@property (weak, nonatomic) IBOutlet UILabel *testLab4;

@end

@implementation XIBTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateCell {
    self.testLab.text = @"测试数据";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
