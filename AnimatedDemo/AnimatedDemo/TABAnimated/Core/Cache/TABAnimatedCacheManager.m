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

// 当前App版本
@property (nonatomic, copy, readwrite) NSString *currentSystemVersion;
// 本地的缓存
@property (nonatomic, strong, readwrite) NSMutableArray *cacheModelArray;
// 内存中的骨架屏管理单元
@property (nonatomic, strong, readwrite) NSMutableDictionary *cacheManagerDict;

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

#pragma mark - Public Methods

- (void)install {
    
    // 获取App版本
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
        dispatch_async([self.class updateQueue], ^{
            [self performSelector:@selector(_loadDataToMemory:)
                         onThread:[self.class updateThread]
                       withObject:modelDirPath
                    waitUntilDone:NO];
        });
    }
}

- (void)cacheComponentManager:(TABComponentManager *)manager {
    
    if ((manager == nil) ||
        (manager.fileName == nil) ||
        (manager.fileName.length == 0)) return;
    
    if ((_currentSystemVersion == nil) ||
        (_currentSystemVersion.length == 0)) return;
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) self = weakSelf;
        [self.lock lock];
        manager.version = self.currentSystemVersion.copy;
        [self.cacheManagerDict setObject:manager.copy forKey:manager.fileName];
        
        TABAnimatedCacheModel *cacheModel = TABAnimatedCacheModel.new;
        cacheModel.fileName = manager.fileName;
        [self.cacheModelArray addObject:cacheModel];
        [self.lock unlock];
        
        NSArray *writeArray = @[cacheModel,manager];
        dispatch_async([self.class updateQueue], ^{
            [self performSelector:@selector(didReceiveWriteRequest:)
                         onThread:[self.class updateThread]
                       withObject:writeArray
                    waitUntilDone:NO];
        });
    });
}

- (nullable TABComponentManager *)getComponentManagerWithFileName:(NSString *)fileName {
    
    if ([TABAnimated sharedAnimated].closeCache) return nil;
    
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
    NSString *filePath = [self _getCacheManagerFilePathWithFileName:fileName];
    if (filePath != nil && filePath.length > 0) {
        TABComponentManager *manager = (TABComponentManager *)[TABAnimatedDocumentMethod getCacheData:filePath targetClass:[TABComponentManager class]];
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

- (void)updateCacheModelLoadCountWithTableAnimated:(TABTableAnimated *)viewAnimated {

    if (viewAnimated == nil) return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (viewAnimated == nil) return;
        
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

- (void)updateCacheModelLoadCountWithCollectionAnimated:(TABCollectionAnimated *)viewAnimated {
    
    if (viewAnimated == nil) return;
    
    dispatch_async(dispatch_get_main_queue(), ^{

        if (viewAnimated == nil) return;
        
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

    if (modelDirPath == nil ||
        modelDirPath.length == 0) return;
    
    NSError *error;
    NSArray <NSString *> *fileArray =
    [[NSFileManager defaultManager] contentsOfDirectoryAtPath:modelDirPath
                                                        error:&error];
    
    if (error) return;
    
    @autoreleasepool {
        
        [_lock lock];
        
        NSMutableArray *cacheModelArray = @[].mutableCopy;
        for (NSString *filePath in fileArray) {
            NSString *resultFilePath = [[TABAnimatedDocumentMethod getTABPathByFilePacketName:TABCacheManagerFolderName] stringByAppendingString:[NSString stringWithFormat:@"/%@/%@",TABCacheManagerCacheModelFolderName,filePath]];
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
            NSString *filePath = [self _getCacheManagerFilePathWithFileName:model.fileName];
            
            [_lock lock];
            TABComponentManager *manager =
            (TABComponentManager *)[TABAnimatedDocumentMethod getCacheData:filePath
                                                               targetClass:[TABComponentManager class]];
            if (manager &&
                manager.fileName &&
                manager.fileName.length > 0) {
                [_cacheManagerDict setObject:manager.copy forKey:manager.fileName];
            }
            [_lock unlock];
        }
    }
}

- (void)updateCacheModelLoadCountWithClass:(Class)class
                            controllerName:(NSString *)controllerName {
    if (class) {
        NSString *fileName = [NSStringFromClass(class) stringByAppendingString:[NSString stringWithFormat:@"_%@",controllerName]];
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
            if ([TABAnimatedDocumentMethod isExistFile:filePath
                                                  isDir:NO]) {
                [TABAnimatedDocumentMethod writeToFileWithData:targetCacheModel
                                                      filePath:filePath];
            }
        }
    }
    
    [_lock unlock];
}

- (void)didReceiveWriteRequest:(NSArray *)array {
    
    if (array == nil || array.count != 2) return;
    
    [_lock lock];
    TABAnimatedCacheModel *cacheModel = array[0];
    TABComponentManager *manager = array[1];
    if (manager && cacheModel) {
        NSString *managerFilePath = [self _getCacheManagerFilePathWithFileName:manager.fileName];
        [TABAnimatedDocumentMethod writeToFileWithData:manager
                                              filePath:managerFilePath];
        NSString *modelFilePath = [self _getCacheModelFilePathWithFileName:manager.fileName];
        [TABAnimatedDocumentMethod writeToFileWithData:cacheModel
                                              filePath:modelFilePath];
    }
    [_lock unlock];
}

- (NSString *)_getCacheManagerFilePathWithFileName:(NSString *)fileName {
    return [TABAnimatedDocumentMethod getTABPathByFilePacketName:[NSString stringWithFormat:@"/%@/%@/%@.plist",TABCacheManagerFolderName,TABCacheManagerCacheManagerFolderName,fileName]];
}

- (NSString *)_getCacheModelFilePathWithFileName:(NSString *)fileName {
    return [TABAnimatedDocumentMethod getTABPathByFilePacketName:[NSString stringWithFormat:@"/%@/%@/%@.plist",TABCacheManagerFolderName,TABCacheManagerCacheModelFolderName,fileName]];
}

@end
