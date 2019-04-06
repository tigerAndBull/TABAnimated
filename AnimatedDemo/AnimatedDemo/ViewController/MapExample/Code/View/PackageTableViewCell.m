//
//  PackageTableViewCell.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/11/17.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "PackageTableViewCell.h"
#import "TestHeadView.h"
#import <TABKit/TABKit.h>

#import "Game.h"

@interface PackageTableViewCell()

@property (nonatomic,strong) TestHeadView *packView;

@end

@implementation PackageTableViewCell

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

- (void)updateWithGame:(Game *)game {
    [self.packView initWithData:game];
}

#pragma mark - Initize Methods

- (void)initUI {
    [self addSubview:self.packView];
}

#pragma mark - Lazy Methods

- (TestHeadView *)packView {
    if (!_packView) {
        _packView = [[TestHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    }
    return _packView;
}

@end
