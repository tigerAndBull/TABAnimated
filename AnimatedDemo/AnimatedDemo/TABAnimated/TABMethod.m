//
//  TABMethod.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBulll. All rights reserved.
//

#import "TABMethod.h"

@implementation TABMethod

+ (CGSize)tab_getSizeWithText:(NSString *)text sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    CGRect frame = [text boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attributesDictionary context:nil];
    
    return frame.size;
}

@end
