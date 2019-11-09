//
//  TABAnimatedDocumentMethod.h
//
//  Created by tigerAndBull on 2019/2/15.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TABAnimatedDocumentMethod : NSObject

+ (void)writeToFileWithData:(id)data
                   filePath:(NSString *)filePath;

+ (id)getCacheData:(NSString *)filePath
       targetClass:(Class)targetClass;

+ (NSArray <NSString *> *)getAllFileNameWithFolderPath:(NSString *)folderPath;

// 获取Documents目录下对应一级目录和文件名，不创建
+ (NSString *)getPathByCreateDocumentFile:(NSString *)filePacketName
                             documentName:(NSString *)documentName;

// 获取Documents目录下对应的文件名，不创建
+ (NSString *)getPathByCreateDocumentName:(NSString *)documentName;

// 获取TABCache下对应filePacketName目录
+ (NSString *)getTABPathByFilePacketName:(NSString *)filePacketName;

// 创建文件/文件夹
+ (BOOL)createFile:(NSString *)file
             isDir:(BOOL)isdir;

// 判断文件/文件夹是否存在
+ (BOOL)isExistFile:(NSString *)path
              isDir:(BOOL)isDir;

@end

NS_ASSUME_NONNULL_END
