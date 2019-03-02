//
//  TABDocumentMethod.h
//  TABKit
//
//  Created by tigerAndBull on 2019/2/15.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 写文件回调
 
 @param path 文件写入路径
 @param isSuccess 是否写入成功
 */
typedef void(^WriteBackDocPathBlock)(NSString *path,BOOL isSuccess);

@interface TABDocumentMethod : NSObject

/**
 写入文件带回调
 
 @param filePacketName TABCaches目录下的文件夹名
 @param documentName 文件名
 @param fileType 文件类型
 @param data 文件二进制数据
 @param finishBlock 回调
 */
+ (void)writeFileToTABDocPathByFilePacketName:(NSString *)filePacketName
                                 documentName:(NSString *)documentName
                                     fileType:(NSString *)fileType
                                         data:(NSData *)data
                                  finishBlock:(WriteBackDocPathBlock)finishBlock;

/**
 写入文件
 
 @param filePacketName TABCaches目录下的文件夹名
 @param documentName 文件名
 @param fileType 文件类型
 @param data 文件二进制数据
 @return 是否写入成功
 */
+ (BOOL)writeFileToTABDocPathByFilePacketName:(NSString *)filePacketName
                                 documentName:(NSString *)documentName
                                     fileType:(NSString *)fileType
                                         data:(NSData *)data;

// 创建归属Documents目录下的TABCaches的文件夹，并返回对应路径
+ (NSString *)getAndCreateTABDocPathByFilePacketName:(NSString *)filePacketName
                                        documentName:(NSString *)documentName
                                            fileType:(NSString *)fileType;

// 获取Documents目录下对应一级目录和文件名，不创建
+ (NSString *)getPathByCreateDocumentFile:(NSString *)filePacketName
                             documentName:(NSString *)documentName;

// 获取Documents目录下对应的文件名，不创建
+ (NSString *)getPathByCreateDocumentName:(NSString *)documentName;

// 获取TABCaches下对应filePacketName目录
+ (NSString *)getTABPathByFilePacketName:(NSString *)filePacketName;

// 获取TABCaches路径
+ (NSString *)tabDocPath;

// 创建文件或文件夹
+ (BOOL)createFile:(NSString *)file isDir:(BOOL)isdir data:(nullable NSData *)data;

// 判断文件是否存在
+ (BOOL)isExistFile:(NSString *)path;

// 删除指定文件
+ (BOOL)deleteFile:(NSString *)path;

// 写入沙盒
+ (BOOL)writeFile:(NSString *)path data:(NSData *)data;

// 删除文件夹
+ (BOOL)removeTABPathByFilePacketName:(NSString *)filePacketName;

@end

NS_ASSUME_NONNULL_END
