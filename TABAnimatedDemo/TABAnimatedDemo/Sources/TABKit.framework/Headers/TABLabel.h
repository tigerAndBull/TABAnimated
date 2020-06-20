//
//  PrivacyPolicyLabel.h
//  白噪音dai
//
//  Created by tigerAndBull on 2019/2/12.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TABSafe.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LabelClickBlock)(void);

@interface TABLabel : UILabel

@property (nonatomic,assign) CGFloat lineSpace;   // set line space.
@property (nonatomic,assign) CGFloat fontSpace;   // set font space.

@property (nonatomic,assign) BOOL isCanClick;
@property (nonatomic,copy) LabelClickBlock labelClickBlock;

@property (nonatomic,assign) BOOL toNextResponder;

/**
 Change the foreColor of the string.

 @param color   foreColor
 @param string  target string
 */
- (void)updateTextColor:(UIColor *)color
                 string:(NSString *)string;

/**
 Chage the foreColor of the string in stringArray

 @param color        foreColor
 @param stringArray  target stringArray
 */
- (void)updateTextColor:(UIColor *)color
            stringArray:(NSArray <NSString *>*)stringArray;

/**
 Get the size of label.text by size.

 @param size    target size
 @return text   retrun showing size
 */
- (CGSize)getTextSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
