//
//  TABRevealKeepDataUtil.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/9/6.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TABRevealKeepDataUtil : NSObject

+ (void)writeDataToFile:(id)data;
+ (id)getCacheData;

@end

NS_ASSUME_NONNULL_END
