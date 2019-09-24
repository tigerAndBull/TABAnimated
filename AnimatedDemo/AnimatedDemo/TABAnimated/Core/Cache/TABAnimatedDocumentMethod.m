//
//  TABAnimatedDocumentMethod.m
//  TABKit
//
//  Created by tigerAndBull on 2019/2/15.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABAnimatedDocumentMethod.h"
#import "TABAnimated.h"

#define kAnimatedFileManager [NSFileManager defaultManager]

@implementation TABAnimatedDocumentMethod

+ (NSString *)documentPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)getTABPathByFilePacketName:(NSString *)filePacketName {
    return [[self documentPath] stringByAppendingPathComponent:filePacketName];
}

+ (NSString *)getAndCreateTABDocPathByFilePacketName:(NSString *)filePacketName
                                        documentName:(NSString *)documentName
                                            fileType:(NSString *)fileType {
    
    NSString *documentPath = [self documentPath];
    NSString *path = [documentPath stringByAppendingPathComponent:filePacketName];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",documentName,fileType]];
    
    // 判断文件夹是否存在
    if ([kAnimatedFileManager fileExistsAtPath:path]) {
        tabAnimatedLog(@"TABAnimatedDocumentMethod提醒 - 文件夹存在");
    }else {
        BOOL isSuccess = [self createFile:path isDir:YES];
        if (isSuccess) {
            tabAnimatedLog(@"TABAnimatedDocumentMethod提醒 - 文件路径为：创建文件夹成功");
        }else {
            tabAnimatedLog(@"TABAnimatedDocumentMethod提醒 - 文件路径为：创建文件夹失败");
        }
    }

    return filePath;
}

+ (BOOL)writeFileToTABDocPathByFilePacketName:(NSString *)filePacketName
                                 documentName:(NSString *)documentName
                                     fileType:(NSString *)fileType
                                         data:(NSData *)data {
    
    NSString *path = [TABAnimatedDocumentMethod getAndCreateTABDocPathByFilePacketName:filePacketName
                                                                documentName:documentName
                                                                    fileType:fileType];
    
    if ([TABAnimatedDocumentMethod isExistFile:path isDir:NO]) {
        [TABAnimatedDocumentMethod deleteFile:path];
    }
    
    return [TABAnimatedDocumentMethod writeFile:path
                                 data:data];
}

+ (void)writeFileToTABDocPathByFilePacketName:(NSString *)filePacketName
                                 documentName:(NSString *)documentName
                                     fileType:(NSString *)fileType
                                         data:(NSData *)data
                                  finishBlock:(WriteBackDocPathBlock)finishBlock {
    
    NSString *path = [TABAnimatedDocumentMethod getAndCreateTABDocPathByFilePacketName:filePacketName
                                                                documentName:documentName
                                                                    fileType:fileType];
    
    if ([TABAnimatedDocumentMethod isExistFile:path isDir:NO]) {
        [TABAnimatedDocumentMethod deleteFile:path];
    }
    
    if (finishBlock) {
        return finishBlock(path,
                           [TABAnimatedDocumentMethod writeFile:path
                                                 data:data]);
    }
}

+ (void)writeToFileWithData:(id)data
                   filePath:(NSString *)filePath {
    [NSKeyedArchiver archiveRootObject:data toFile:filePath];
}

+ (id)getCacheData:(NSString *)filePath {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

+ (NSArray <NSString *> *)getAllFileNameWithFolderPath:(NSString *)folderPath {
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    fileList = [kAnimatedFileManager contentsOfDirectoryAtPath:folderPath error:&error];
    
    if (error) {
        return nil;
    }
    
    return fileList;
}

+ (NSString *)getPathByCreateDocumentFile:(NSString *)filePacketName
                             documentName:(NSString *)documentName {
    NSString *documentPath = [self documentPath];
    NSString *path = [documentPath stringByAppendingPathComponent:filePacketName];
    NSString *filePath = [path stringByAppendingPathComponent:documentName];
    NSLog(@"TABAnimatedDocumentMethod提醒 - 文件路径为：%@",filePath);
    return filePath;
}

+ (NSString *)getPathByCreateDocumentName:(NSString *)documentName {
    NSString *documentPath = [self documentPath];
    NSString *filePath = [documentPath stringByAppendingPathComponent:documentName];
    NSLog(@"TABAnimatedDocumentMethod提醒 - 文件路径为：%@",filePath);
    return filePath;
}

+ (BOOL)createFile:(NSString *)file
             isDir:(BOOL)isDir {
    
    if (![TABAnimatedDocumentMethod isExistFile:file
                                          isDir:isDir]) {
        if (isDir) {
            return [kAnimatedFileManager createDirectoryAtPath:file
                                   withIntermediateDirectories:YES
                                                    attributes:nil
                                                         error:nil];
        }else {
            return [kAnimatedFileManager createFileAtPath:file
                                                 contents:nil
                                               attributes:nil];
        }
    }
    
    return YES;
}

+ (BOOL)isExistFile:(NSString *)path
              isDir:(BOOL)isDir {
    isDir = [kAnimatedFileManager fileExistsAtPath:path
                                 isDirectory:&isDir];
    return isDir;
}

+ (BOOL)deleteFile:(NSString *)path {
    BOOL isDelete = NO;
    isDelete = [kAnimatedFileManager removeItemAtPath:path
                                          error:nil];
    if (isDelete) {
        NSLog(@"TABAnimated - 文件已删除");
    }else {
        NSLog(@"TABAnimated - 文件未删除");
    }
    return isDelete;
}

+ (BOOL)writeFile:(NSString *)path
             data:(NSData *)data {
    BOOL isSuccess;
    isSuccess = [data writeToFile:path atomically:YES];
    if (isSuccess) {
        NSLog(@"TABAnimatedDocumentMethod提醒 - 文件写入成功");
    }else {
        NSLog(@"TABAnimatedDocumentMethod提醒 - 文件写入失败");
    }
    return isSuccess;
}

+ (BOOL)removeTABPathByFilePacketName:(NSString *)filePacketName {
    NSString *path = [self getTABPathByFilePacketName:filePacketName];
    BOOL isSuccess = [kAnimatedFileManager removeItemAtPath:path error:nil];
    if (isSuccess) {
        NSLog(@"TABAnimatedDocumentMethod提醒 - 文件夹删除成功");
    }else {
        NSLog(@"TABAnimatedDocumentMethod提醒 - 文件夹删除失败");
    }
    return isSuccess;
}

@end
