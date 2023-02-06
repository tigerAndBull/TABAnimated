//
//  UILabel+TABCategory.m
//  TABAnimatedDemo
//
//  Created by anwenhu on 2023/2/6.
//  Copyright © 2023 tigerAndBull. All rights reserved.
//

#import "UILabel+TABCategory.h"

@implementation UILabel (TABCategory)

@dynamic lineSpace;

- (void)setLineSpace:(CGFloat)lineSpace {
    NSString *labelText = self.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:nil];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
}

@end
