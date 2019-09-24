//
//  CommonMethod.h
//  Puzzle
//
//  Created by tigerAndBull on 2018/12/6.
//  Copyright © 2018年 zhilehuo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TABCommonMethod : NSObject

+ (CGSize)tab_getLabelSizeLineSpaceWithText:(NSString *)text
                               sizeWithFont:(UIFont *)font
                          constrainedToSize:(CGSize)size
                                  lineSpace:(CGFloat)lineSpace
                                  fontSpace:(CGFloat)fontSpace;

+ (CGSize)tab_getLabelSizeWithText:(NSString *)text
                      sizeWithFont:(UIFont *)font
                 constrainedToSize:(CGSize)size;

#pragma mark - UUID

+ (NSString *)uuidString;

#pragma mark - JSON

+ (NSString *)jsonObjectToString:(id)data;

@end

NS_ASSUME_NONNULL_END
