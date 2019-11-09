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

+ (void)writeToFileWithData:(id)data
                   filePath:(NSString *)filePath {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [NSKeyedArchiver archiveRootObject:data toFile:filePath];
#pragma clang diagnostic pop
}

+ (id)getCacheData:(NSString *)filePath {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
#pragma clang diagnostic pop
}

+ (NSArray <NSString *> *)getAllFileNameWithFolderPath:(NSString *)folderPath {
    NSError *error = nil;
    NSArray *fileList = [kAnimatedFileManager contentsOfDirectoryAtPath:folderPath error:&error];
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
    return filePath;
}

+ (NSString *)getPathByCreateDocumentName:(NSString *)documentName {
    NSString *documentPath = [self documentPath];
    NSString *filePath = [documentPath stringByAppendingPathComponent:documentName];
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

@end
