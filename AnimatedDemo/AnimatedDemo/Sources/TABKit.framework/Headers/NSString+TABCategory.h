//
//  NSString+TABCategory.h
//  TABKit
//
//  Created by tigerAndBull on 2019/2/15.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (TABCategory)

/**
 Adapt to ios 8.0.

 @param string  be contained string
 @return        be contained or not
 */
- (BOOL)containsString:(NSString *)string;

/**
 Get string array by separator string.

 @param separatorStr   separator string
 @return               string array
 */
- (NSArray <NSString *> *)getStringArrayBySeparatorStr:(NSString *)separatorStr;

/**
 Compare the size of the current version and old version.
 string format (1.0.0)

 @param oldVersion     the old version
 @return               the current version is bigger the old version return 'YES'
 */
- (BOOL)compareCurrentVersionWithOldVersion:(NSString *)oldVersion;

@end

NS_ASSUME_NONNULL_END
