//
//  TABRevealKeepDataUtil.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/9/6.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABRevealKeepDataUtil.h"

@implementation TABRevealKeepDataUtil

+ (void)writeDataToFile:(id)data {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [NSKeyedArchiver archiveRootObject:data toFile:[self getFilePath]];
#pragma clang diagnostic pop
}

+ (id)getCacheData {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self getFilePath]];
#pragma clang diagnostic pop
}

+ (NSString *)getFilePath {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *targetPath = [docPath stringByAppendingPathComponent:@"tabRevealData.plist"];
    return targetPath;
}

@end
