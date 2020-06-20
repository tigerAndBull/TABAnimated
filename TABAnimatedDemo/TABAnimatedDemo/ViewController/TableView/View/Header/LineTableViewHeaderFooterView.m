//
//  LineTableViewHeaderFooterView.m
//  TABAnimatedDemo
//
//  Created by tigerAndBull on 2020/5/4.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "LineTableViewHeaderFooterView.h"

@implementation LineTableViewHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        UIView *backView = UIView.new;
        backView.frame = self.bounds;
        backView.backgroundColor = UIColor.whiteColor;
        self.backView = backView;
        [self addSubview:backView];
        
        UILabel *lab = [[UILabel alloc] init];
        lab.frame = CGRectMake(kWidth(15)+3+4, 10, 100, 50);
        lab.font = kBlodFont(18);
        lab.textColor = [UIColor blackColor];
        lab.text = @"头视图";
        self.titleLab = lab;
        [self addSubview:lab];
        
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(kWidth(15), 10+8+10, 3, 14);
        view.backgroundColor = kColor(0xE74E46FF);
        view.layer.cornerRadius = 1.5f;
        self.lineView = lab;
        [self addSubview:view];
    }
    return self;
}

@end
