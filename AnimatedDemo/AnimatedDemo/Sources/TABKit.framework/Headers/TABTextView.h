//
//  TABTextView.h
//  白噪音dai
//
//  Created by tigerAndBull on 2019/1/22.
//  Copyright © 2019年 yangyongnian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TABTextView : UITextView

@property (nonatomic,copy) NSString *placeholder;
@property (nonatomic,assign) NSInteger minCount;
@property (nonatomic,assign) NSInteger maxCount;

@property (nonatomic) BOOL isInputCondition;    // 超过最小值，满足输入条件

- (instancetype)initWithFrame:(CGRect)frame
                  placeholder:(NSString *)placeholder;

@end

NS_ASSUME_NONNULL_END
