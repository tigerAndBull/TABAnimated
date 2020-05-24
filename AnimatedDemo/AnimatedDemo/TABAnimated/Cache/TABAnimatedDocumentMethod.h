//
//  TABAnimatedDocumentMethod.h
//
//  Created by tigerAndBull on 2019/2/15.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TABAnimatedDocumentMethod : NSObject

+ (void)writeToFileWithData:(id)data filePath:(NSString *)filePath;

+ (id)getCacheData:(NSString *)filePath targetClass:(Class)targetClass;

+ (NSString *)getPathByFilePacketName:(NSString *)filePacketName;

// 创建文件/文件夹
+ (BOOL)createFile:(NSString *)file isDir:(BOOL)isdir;

// 判断文件/文件夹是否存在
+ (BOOL)isExistFile:(NSString *)path isDir:(BOOL)isDir;

@end

NS_ASSUME_NONNULL_END
