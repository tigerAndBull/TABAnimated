//
//  TABCacheManager.m
//  TABAnimatedDemo
//
//  Created by tigerAndBull on 2019/9/14.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABAnimatedCacheManager.h"

#import "TABAnimatedCacheModel.h"
#import "TABAnimatedDocumentMethod.h"
#import "TABAnimated.h"

#import "TABAnimatedProduction.h"
#import "TABAnimatedProductHelper.h"
#import "TABFormAnimated.h"

NSString * const TABCacheManagerFolderName = @"TABAnimated";
NSString * const TABCacheManagerCacheModelFolderName = @"CacheModel";
NSString * const TABCacheManagerCacheManagerFolderName = @"CacheManager";
NSString * const TABCacheManagerCacheProductionFolderName = @"CacheProduction";

static const NSInteger kMemeoryModelMaxCount = 20;

@interface TABAnimatedCacheManager()

@property (nonatomic, strong) NSRecursiveLock *lock;

// 当前App版本
@property (nonatomic, copy, readwrite) NSString *currentSystemVersion;
// 本地的缓存
@property (nonatomic, strong, readwrite) NSMutableArray *cacheModelArray;
// 内存中的骨架屏管理单元
@property (nonatomic, strong, readwrite) NSMutableDictionary *cacheManagerDict;

@end

@implementation TABAnimatedCacheManager

+ (TABAnimatedCacheManager *)shareManager {
    static dispatch_once_t token;
    static TABAnimatedCacheManager *manager;
    dispatch_once(&token, ^{
        manager = [[TABAnimatedCacheManager alloc] init];
    });
    return manager;
}

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

#pragma mark - Public Methods

- (void)install {
    
    if ([TABAnimated sharedAnimated].closeCache) return;
    
    [TABAnimatedDocumentMethod createFile:TABCacheManagerFolderName isDir:YES];
    
    // 获取App版本
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (currentVersion == nil && currentVersion.length <= 0) {
        return;
    }
    _currentSystemVersion = currentVersion;
    
    NSString *documentDir = [TABAnimatedDocumentMethod getPathByFilePacketName:TABCacheManagerFolderName];
    if (![TABAnimatedDocumentMethod isExistFile:documentDir isDir:YES]) {
        [TABAnimatedDocumentMethod createFile:documentDir isDir:YES];
    }
    
    // 删除旧的manager文件夹
    NSString *managerDirPath = [documentDir stringByAppendingPathComponent:TABCacheManagerCacheManagerFolderName];

    [TABAnimatedDocumentMethod createFile:managerDirPath isDir:YES];
    if ([TABAnimatedDocumentMethod isExistFile:managerDirPath isDir:YES]) {
        [TABAnimatedDocumentMethod deleteFile:managerDirPath];
    }

    NSString *modelDirPath = [documentDir stringByAppendingPathComponent:TABCacheManagerCacheModelFolderName];
    
    NSString *productionDirPath = [documentDir stringByAppendingPathComponent:TABCacheManagerCacheProductionFolderName];
    
    if (![TABAnimatedDocumentMethod isExistFile:modelDirPath isDir:YES] ||
        ![TABAnimatedDocumentMethod isExistFile:productionDirPath isDir:YES]) {
        [TABAnimatedDocumentMethod createFile:modelDirPath isDir:YES];
        [TABAnimatedDocumentMethod createFile:productionDirPath isDir:YES];
    }else {
        dispatch_async([self.class updateQueue], ^{
            [self performSelector:@selector(_loadDataToMemory:)
                         onThread:[self.class updateThread]
                       withObject:modelDirPath
                    waitUntilDone:NO];
        });
    }
}

- (void)cacheProduction:(TABAnimatedProduction *)production {
    if ([TABAnimated sharedAnimated].closeCache) return;
    if (production == nil || production.fileName == nil || production.fileName.length == 0) return;
    if (_currentSystemVersion == nil || _currentSystemVersion.length == 0) return;
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) self = weakSelf;
        [self.lock lock];
        production.version = self.currentSystemVersion.copy;
        [self.cacheManagerDict setObject:production forKey:production.fileName];

        TABAnimatedCacheModel *cacheModel = TABAnimatedCacheModel.new;
        cacheModel.fileName = production.fileName;
        [self.cacheModelArray addObject:cacheModel];
        [self.lock unlock];

        NSArray *writeArray = @[cacheModel, production];
        dispatch_async([self.class updateQueue], ^{
            [self performSelector:@selector(didReceiveWriteRequest:)
                         onThread:[self.class updateThread]
                       withObject:writeArray
                    waitUntilDone:NO];
        });
    });
}

- (nullable TABAnimatedProduction *)getProductionWithKey:(NSString *)key {
    
    if ([TABAnimated sharedAnimated].closeCache) return nil;

    // 从内存中查找
    TABAnimatedProduction *production;
    production = [self.cacheManagerDict objectForKey:key];
    if (production) {
        if (![self _judgeIsNeedUpdateWithProduction:production]) {
            return production.copy;
        }
        return nil;
    }

    // 从沙盒中读取，并存储到内存中
    NSString *filePath = [self _getCacheProductionFilePathWithFileName:key];
    if (filePath != nil && filePath.length > 0) {
        TABAnimatedProduction *production = (TABAnimatedProduction *)[TABAnimatedDocumentMethod getCacheData:filePath targetClass:[TABAnimatedProduction class]];
        if (production) {
            if (![self _judgeIsNeedUpdateWithProduction:production]) {
                [self.cacheManagerDict setObject:production.copy forKey:production.fileName];
                return production.copy;
            }else {
                return nil;
            }
        }else {
            return nil;
        }
    }
    return nil;
}

- (void)updateCacheModelLoadCountWithFormAnimated:(TABFormAnimated *)viewAnimated {
    if ([TABAnimated sharedAnimated].closeCache) return;
    if (viewAnimated == nil) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *controllerName = viewAnimated.targetControllerClassName;
        for (Class class in viewAnimated.cellClassArray) {
            [self updateCacheModelLoadCountWithClass:class controllerName:controllerName];
        }
        for (Class class in viewAnimated.headerClassArray) {
            [self updateCacheModelLoadCountWithClass:class controllerName:controllerName];
        }
        for (Class class in viewAnimated.footerClassArray) {
            [self updateCacheModelLoadCountWithClass:class controllerName:controllerName];
        }
    });
}

#pragma mark - Private Method

- (void)_loadDataToMemory:(NSString *)modelDirPath {

    if (modelDirPath == nil || modelDirPath.length == 0) return;
    
    NSError *error;
    NSArray <NSString *> *fileArray =
    [[NSFileManager defaultManager] contentsOfDirectoryAtPath:modelDirPath error:&error];
    
    if (error) return;
    
    @autoreleasepool {
        
        [_lock lock];
        
        NSMutableArray *cacheModelArray = @[].mutableCopy;
        for (NSString *filePath in fileArray) {
            NSString *resultFilePath = [[TABAnimatedDocumentMethod getPathByFilePacketName:TABCacheManagerFolderName] stringByAppendingString:[NSString stringWithFormat:@"/%@/%@",TABCacheManagerCacheModelFolderName,filePath]];
            TABAnimatedCacheModel *model =
            (TABAnimatedCacheModel *)[TABAnimatedDocumentMethod
                                           getCacheData:resultFilePath
                                            targetClass:[TABAnimatedCacheModel class]];
            if (model) {
                [cacheModelArray addObject:model];
            }
        }
        
        _cacheModelArray = [NSMutableArray arrayWithArray:[cacheModelArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            TABAnimatedCacheModel *model1 = obj1;
            TABAnimatedCacheModel *model2 = obj2;
            if (model1.loadCount > model2.loadCount) {
                return NSOrderedAscending;
            }else{
                return NSOrderedDescending;
            }
        }]];

        [_lock unlock];
        
        if (_cacheModelArray == nil || _cacheModelArray.count == 0) return;
        
        NSInteger maxCount = (_cacheModelArray.count > kMemeoryModelMaxCount) ? kMemeoryModelMaxCount : _cacheModelArray.count;
        
        for (NSInteger i = 0; i < maxCount; i++) {
            
            TABAnimatedCacheModel *model = _cacheModelArray[i];
            NSString *filePath = [self _getCacheProductionFilePathWithFileName:model.fileName];
            
            [_lock lock];
            TABAnimatedProduction *production =
            (TABAnimatedProduction *)[TABAnimatedDocumentMethod getCacheData:filePath
                                                                 targetClass:[TABAnimatedProduction class]];
            if (production &&
                production.fileName &&
                production.fileName.length > 0) {
                [_cacheManagerDict setObject:production.copy forKey:production.fileName];
            }
            [_lock unlock];
        }
    }
}

- (void)updateCacheModelLoadCountWithClass:(Class)class
                            controllerName:(NSString *)controllerName {
    if (class) {
        NSString *fileName = [TABAnimatedProductHelper getKeyWithControllerName:controllerName targetClass:class];
        if (fileName) {
            dispatch_async([self.class updateQueue], ^{
                [self performSelector:@selector(updateCacheModelLoadCountWithTargetFileName:)
                             onThread:[self.class updateThread]
                           withObject:fileName
                        waitUntilDone:NO];
            });
        }
    }
}

- (void)updateCacheModelLoadCountWithTargetFileName:(NSString *)targetFileName {
    
    if (targetFileName == nil || targetFileName.length == 0) return;
    
    [_lock lock];
    
    TABAnimatedCacheModel *targetCacheModel;
    for (TABAnimatedCacheModel *model in self.cacheModelArray) {
        if ([model.fileName isEqualToString:targetFileName]) {
            targetCacheModel = model;
            break;
        }
    }
    
    if (targetCacheModel) {
        
        ++targetCacheModel.loadCount;
        
        NSString *filePath = [self _getCacheModelFilePathWithFileName:targetCacheModel.fileName];
        if (filePath && filePath.length > 0) {
            if ([TABAnimatedDocumentMethod isExistFile:filePath isDir:NO]) {
                [TABAnimatedDocumentMethod writeToFileWithData:targetCacheModel filePath:filePath];
            }
        }
    }
    
    [_lock unlock];
}

- (void)didReceiveWriteRequest:(NSArray *)array {
    
    if (array == nil || array.count != 2) return;
    
    [_lock lock];
    TABAnimatedCacheModel *cacheModel = array[0];
    TABAnimatedProduction *production = array[1];
    if (production && cacheModel) {
        NSString *managerFilePath = [self _getCacheProductionFilePathWithFileName:production.fileName];
        [TABAnimatedDocumentMethod writeToFileWithData:production
                                              filePath:managerFilePath];
        NSString *modelFilePath = [self _getCacheModelFilePathWithFileName:production.fileName];
        [TABAnimatedDocumentMethod writeToFileWithData:cacheModel
                                              filePath:modelFilePath];
    }
    [_lock unlock];
}

- (NSString *)_getCacheProductionFilePathWithFileName:(NSString *)fileName {
    return [TABAnimatedDocumentMethod getPathByFilePacketName:[NSString stringWithFormat:@"/%@/%@/%@.plist",TABCacheManagerFolderName,TABCacheManagerCacheProductionFolderName,fileName]];
}

- (NSString *)_getCacheModelFilePathWithFileName:(NSString *)fileName {
    return [TABAnimatedDocumentMethod getPathByFilePacketName:[NSString stringWithFormat:@"/%@/%@/%@.plist",TABCacheManagerFolderName,TABCacheManagerCacheModelFolderName,fileName]];
}

- (BOOL)_judgeIsNeedUpdateWithProduction:(TABAnimatedProduction *)production {
    if (production.version && production.version.length > 0 &&
        [TABAnimatedCacheManager shareManager].currentSystemVersion &&
        [TABAnimatedCacheManager shareManager].currentSystemVersion.length > 0) {
        if ([production.version isEqualToString:[TABAnimatedCacheManager shareManager].currentSystemVersion]) {
            return NO;
        }
        return YES;
    }
    return YES;
}

@end
