//
//  DarkCardTemplateCollectionViewCell.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/4/24.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "DarkCardTemplateCollectionViewCell.h"
#import <TABKit/TABKit.h>

@implementation DarkCardTemplateCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.shadowView.backgroundColor = UIColor.clearColor;
        self.shadowView.layer.shadowColor = UIColor.clearColor.CGColor;
    }
    return self;
}

@end
