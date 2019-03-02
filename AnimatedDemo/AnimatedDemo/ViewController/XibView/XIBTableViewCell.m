//
//  XIBTableViewCell.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/10/7.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "XIBTableViewCell.h"

#import "UITableViewCell+TABLayoutSubviews.h"
#import "UIView+Animated.h"

@interface XIBTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *testLab;

@end

@implementation XIBTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if (_testLab) {
        _testLab.loadStyle = TABViewLoadAnimationLong;
    }
}

- (void)updateCell {
    self.testLab.text = @"测试数据";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
