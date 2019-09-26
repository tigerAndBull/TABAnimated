//
//  TABCacheManager.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/9/14.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABAnimatedCacheManager.h"

#import "TABAnimatedCacheModel.h"
#import "TABComponentManager.h"
#import "TABAnimatedDocumentMethod.h"
#import "TABAnimated.h"

NSString * const TABCacheManagerFolderName = @"TABAnimated";
NSString * const TABCacheManagerCacheModelFolderName = @"CacheModel";
NSString * const TABCacheManagerCacheManagerFolderName = @"CacheManager";

static const NSInteger kMemeoryModelMaxCount = 20;

@interface TABAnimatedCacheManager()

@property (nonatomic, strong) NSRecursiveLock *lock;

@end

@implementation TABAnimatedCacheManager

+ (dispatch_queue_t)updateQueue {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.tigerAndBull.TABAnimated.updateQueue", DISPATCH_QUEUE_SERIAL);
        dispatch_set_target_queue(queue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    });
    return queue;
}

+ (void)updateThreadMain:(id)object {
    @autoreleasepool {
        [[NSThread currentThread] setName:@"com.tigerAndBull.TABAnimated.updateThread"];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}

+ (NSThread *)updateThread {
    static NSThread *thread = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        thread = [[NSThread alloc] initWithTarget:self selector:@selector(updateThreadMain:) object:nil];
        if ([thread respondsToSelector:@selector(setQualityOfService:)]) {
            thread.qualityOfService = NSQualityOfServiceBackground;
        }
        [thread start];
    });
    return thread;
}

- (instancetype)init {
    if (self = [super init]) {
        _cacheModelArray = @[].mutableCopy;
        _cacheManagerDict = @{}.mutableCopy;
        
        _lock = [NSRecursiveLock new];
    }
    return self;
}

- (void)install {
    
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (currentVersion == nil && currentVersion.length <= 0) {
        return;
    }
    _currentSystemVersion = currentVersion;
    
    NSString *documentDir = [TABAnimatedDocumentMethod getTABPathByFilePacketName:TABCacheManagerFolderName];
    if (![TABAnimatedDocumentMethod isExistFile:documentDir
                                          isDir:YES]) {
        [TABAnimatedDocumentMethod createFile:documentDir
                                        isDir:YES];
    }

    NSString *modelDirPath = [documentDir stringByAppendingPathComponent:TABCacheManagerCacheModelFolderName];
    NSString *managerDirPath = [documentDir stringByAppendingPathComponent:TABCacheManagerCacheManagerFolderName];
    
    if (![TABAnimatedDocumentMethod isExistFile:modelDirPath
                                          isDir:YES] ||
        ![TABAnimatedDocumentMethod isExistFile:managerDirPath
                                          isDir:YES]) {
        [TABAnimatedDocumentMethod createFile:modelDirPath
                                        isDir:YES];
        [TABAnimatedDocumentMethod createFile:managerDirPath
                                        isDir:YES];
            
    }else {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            __weak typeof(self) weakSelf = self;
            dispatch_async([self.class updateQueue], ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                
                if (!strongSelf) return;
                
                NSError *error;
                NSArray <NSString *> *fileArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:modelDirPath error:&error];
                
                if (error) return;
                
                @autoreleasepool {
                    
                    [strongSelf.lock lock];
                    
                    NSMutableArray *cacheModelArray = @[].mutableCopy;
                    for (NSString *filePath in fileArray) {
                        NSString *resultFilePath = [[TABAnimatedDocumentMethod getTABPathByFilePacketName:TABCacheManagerFolderName] stringByAppendingString:[NSString stringWithFormat:@"/%@/%@",TABCacheManagerCacheModelFolderName,filePath]];
                        TABAnimatedCacheModel *model = (TABAnimatedCacheModel *)[TABAnimatedDocumentMethod
                                                        getCacheData:resultFilePath];
                        if (model) {
                            [cacheModelArray addObject:model];
                        }
                    }
                    
                    strongSelf.cacheModelArray = [NSMutableArray arrayWithArray:[cacheModelArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                        TABAnimatedCacheModel *model1 = obj1;
                        TABAnimatedCacheModel *model2 = obj2;
                        if (model1.loadCount > model2.loadCount){
                            return NSOrderedAscending;
                        }else{
                            return NSOrderedDescending;
                        }
                    }]];

                    [strongSelf.lock unlock];
                    
                    if (strongSelf.cacheModelArray == nil || strongSelf.cacheModelArray.count == 0) {
                        return;
                    }
                    
                    NSInteger maxCount = (strongSelf.cacheModelArray.count > kMemeoryModelMaxCount) ? kMemeoryModelMaxCount : strongSelf.cacheModelArray.count;
                    
                    for (NSInteger i = 0; i < maxCount; i++) {
                        
                        TABAnimatedCacheModel *model = strongSelf.cacheModelArray[i];
                        NSString *filePath = [strongSelf getCacheManagerFilePathWithFileName:model.fileName];
                        
                        [strongSelf.lock lock];
                        TABComponentManager *manager = (TABComponentManager *)[TABAnimatedDocumentMethod getCacheData:filePath];
                        if (manager &&
                            manager.fileName &&
                            manager.fileName.length > 0) {
                            [strongSelf.cacheManagerDict setObject:manager.copy forKey:manager.fileName];
                        }
                        [strongSelf.lock unlock];
                    }
                }
            });
        });
    }
}

- (void)updateCacheModelLoadCountWithTargetFileName:(NSString *)targetFileName {
    
    if (targetFileName == nil && targetFileName.length <= 0) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        __weak typeof(self) weakSelf = self;
        dispatch_async([self.class updateQueue], ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            if (!strongSelf) return;
            
            [strongSelf.lock lock];
            
            TABAnimatedCacheModel *targetCacheModel;
            for (TABAnimatedCacheModel *model in strongSelf.cacheModelArray) {
                if ([model.fileName isEqualToString:targetFileName]) {
                    targetCacheModel = model;
                    break;
                }
            }
            
            ++targetCacheModel.loadCount;
            
            if (targetCacheModel) {
                [self performSelector:@selector(didReceiveUpdateRequest:) onThread:[self.class updateThread] withObject:targetCacheModel waitUntilDone:NO];
            }
            
            [strongSelf.lock unlock];
        });
    });
}

- (void)didReceiveUpdateRequest:(TABAnimatedCacheModel *)model {
    [_lock lock];
    if (model) {
        NSString *filePath = [self getCacheModelFilePathWithFileName:model.fileName];
        if (filePath && filePath.length > 0) {
            if ([TABAnimatedDocumentMethod isExistFile:filePath
                                                  isDir:NO]) {
                [TABAnimatedDocumentMethod writeToFileWithData:model
                                                      filePath:filePath];
            }
        }
    }
    [_lock unlock];
}

- (void)didReceiveWriteRequest:(NSArray *)array {
    [_lock lock];
    if (array && array.count == 2) {
        
        TABAnimatedCacheModel *cacheModel = array[0];
        TABComponentManager *manager = array[1];
        
        NSString *managerFilePath = [self getCacheManagerFilePathWithFileName:manager.fileName];
        [TABAnimatedDocumentMethod writeToFileWithData:manager
                                              filePath:managerFilePath];
        
        NSString *modelFilePath = [self getCacheModelFilePathWithFileName:manager.fileName];
        [TABAnimatedDocumentMethod writeToFileWithData:cacheModel
                                              filePath:modelFilePath];
    }
    [_lock unlock];
}


- (void)cacheComponentManager:(TABComponentManager *)manager {
    if (manager &&
        (manager.fileName != nil) &&
        (manager.fileName.length > 0)) {
        
        [_lock lock];
        manager.version = [TABAnimated sharedAnimated].cacheManager.currentSystemVersion.copy;
        [_cacheManagerDict setObject:manager.copy forKey:manager.fileName];
        TABAnimatedCacheModel *cacheModel = TABAnimatedCacheModel.new;
        cacheModel.fileName = manager.fileName;
        [_cacheModelArray addObject:cacheModel];
        [_lock unlock];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            __weak typeof(self) weakSelf = self;
            dispatch_async([self.class updateQueue], ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                
                if (!strongSelf) return;
                
                NSArray *writeArray = @[cacheModel,manager];
                [self performSelector:@selector(didReceiveWriteRequest:) onThread:[self.class updateThread] withObject:writeArray waitUntilDone:NO];
            });
        });
    }
}

#pragma mark - Public Method

- (nullable TABComponentManager *)getComponentManagerWithFileName:(NSString *)fileName {
    
    if ([TABAnimated sharedAnimated].closeCache) {
        return nil;
    }
    
    // 从内存中查找
    TABComponentManager *manager;
    manager = [self.cacheManagerDict objectForKey:fileName];
    if (manager) {
        if (!manager.needUpdate) {
            return manager.copy;
        }
        return nil;
    }
    
    // 从沙盒中读取，并存储到内存中
    NSString *filePath = [self getCacheManagerFilePathWithFileName:fileName];
    if (filePath != nil && filePath.length > 0) {
        TABComponentManager *manager = (TABComponentManager *)[TABAnimatedDocumentMethod getCacheData:filePath];
        if (manager) {
            if (!manager.needUpdate) {
                [self.cacheManagerDict setObject:manager.copy forKey:manager.fileName];
                return manager.copy;
            }else {
                return nil;
            }
        }else {
            return nil;
        }
    }
    
    return nil;
}

#pragma mark - Private Method

- (NSString *)getCacheManagerFilePathWithFileName:(NSString *)fileName {
    return [TABAnimatedDocumentMethod getTABPathByFilePacketName:[NSString stringWithFormat:@"/%@/%@/%@.plist",TABCacheManagerFolderName,TABCacheManagerCacheManagerFolderName,fileName]];
}

- (NSString *)getCacheModelFilePathWithFileName:(NSString *)fileName {
    return [TABAnimatedDocumentMethod getTABPathByFilePacketName:[NSString stringWithFormat:@"/%@/%@/%@.plist",TABCacheManagerFolderName,TABCacheManagerCacheModelFolderName,fileName]];
}

@end
