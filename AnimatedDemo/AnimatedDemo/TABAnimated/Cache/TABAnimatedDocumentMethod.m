//
//  TABAnimatedDocumentMethod.m
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

+ (NSString *)getPathByFilePacketName:(NSString *)filePacketName {
    return [[self documentPath] stringByAppendingPathComponent:filePacketName];
}

+ (void)writeToFileWithData:(id)data filePath:(NSString *)filePath {
    if (@available(iOS 11.0, *)) {
        NSData *newData = [NSKeyedArchiver archivedDataWithRootObject:data requiringSecureCoding:YES error:NULL];
        if (newData) {
            [newData writeToFile:filePath atomically:YES];
        }
    }else {
        [NSKeyedArchiver archiveRootObject:data toFile:filePath];
    }
}

+ (id)getCacheData:(NSString *)filePath
       targetClass:(nonnull Class)targetClass {
    if (@available(iOS 11.0, *)) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        return [NSKeyedUnarchiver unarchivedObjectOfClass:targetClass
                                                 fromData:data
                                                    error:NULL];
    }
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
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

+ (BOOL)deleteFile:(NSString *)file {
    if ([kAnimatedFileManager removeItemAtPath:file error:NULL]) {
        return YES;
    }
    return NO;
}

@end
