//
//  DarkCardCollectionViewCell.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/4/24.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "DarkCardCollectionViewCell.h"
#import <TABKit/TABKit.h>

@implementation DarkCardCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.shadowView.backgroundColor = kColor(0x1C2031FF);
        self.shadowView.layer.shadowColor = UIColor.clearColor.CGColor;
    }
    return self;
}

@end
