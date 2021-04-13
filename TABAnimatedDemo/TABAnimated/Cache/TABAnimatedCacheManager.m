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

#import "TABAnimationMethod.h"

#define _safe_string(x) (x && x.length > 0)

// 一级目录
NSString * const TABCacheManagerFolderName = @"TABAnimated";

// 二级目录
// model文件夹
NSString * const TABCacheManagerCacheModelFolderName = @"CacheModel";
// production文件夹
NSString * const TABCacheManagerCacheProductionFolderName = @"CacheProduction";
// manager文件夹已废弃
NSString * const TABCacheManagerCacheManagerFolderName = @"CacheManager";

static const NSInteger kMemeoryModelMaxCount = 20;

@interface TABAnimatedCacheManager() {
    NSInteger _maxMemeoryCount;
}

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
        _lock = [NSRecursiveLock new];
        _cacheModelArray = @[].mutableCopy;
        _cacheManagerDict = @{}.mutableCopy;
        _maxMemeoryCount = kMemeoryModelMaxCount;
        _currentSystemVersion = [TABAnimationMethod appVersion];
    }
    return self;
}

#pragma mark - Public Methods

- (void)install {
    if ([TABAnimated sharedAnimated].closeDiskCache) return;
    
    NSString *currentVersion = [TABAnimationMethod appVersion];
    self.currentSystemVersion = currentVersion;
    
    NSString *modelDirPath = [self _getFolderPath];
    [self _startLoadData:modelDirPath];
}

- (void)cacheProduction:(TABAnimatedProduction *)production {
    
    if (![self _canCacheToMemoryWithProduction:production]) return;
    
    production.version = self.currentSystemVersion.copy;
    [self.cacheManagerDict setObject:production forKey:production.fileName];
    
    if (![self _canCacheToDiskWithProduction:production]) return;
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        TABAnimatedCacheModel *cacheModel = TABAnimatedCacheModel.new;
        cacheModel.fileName = production.fileName;
        [self.cacheModelArray addObject:cacheModel];
        
        if (!production) {
            return;
        }
        
        NSArray *writeArray = @[cacheModel, production];
        dispatch_async([strongSelf.class updateQueue], ^{
            [strongSelf performSelector:@selector(didReceiveWriteRequest:)
                         onThread:[strongSelf.class updateThread]
                       withObject:writeArray
                    waitUntilDone:NO];
        });
    });
}

- (nullable TABAnimatedProduction *)getProductionWithKey:(NSString *)key {
    if ([TABAnimated sharedAnimated].closeCache || !key) return nil;
    TABAnimatedProduction *production = [self _getProductionInMemoryWithKey:key];
    if (production) return production;
    if ([TABAnimated sharedAnimated].closeDiskCache) {
        return production;
    }
    production = [self _getProductionInDiskWithKey:key];
    return production;
}

- (void)updateCacheModelLoadCountWithFormAnimated:(TABFormAnimated *)viewAnimated frame:(CGRect)frame {
    if ([TABAnimated sharedAnimated].closeDiskCache || viewAnimated == nil) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *controllerName = viewAnimated.targetControllerClassName;
        for (Class class in viewAnimated.cellClassArray) {
            [self updateCacheModelLoadCountWithClass:class controllerName:controllerName frame:frame];
        }
        for (Class class in viewAnimated.headerClassArray) {
            [self updateCacheModelLoadCountWithClass:class controllerName:controllerName frame:frame];
        }
        for (Class class in viewAnimated.footerClassArray) {
            [self updateCacheModelLoadCountWithClass:class controllerName:controllerName frame:frame];
        }
    });
}

- (void)setMaxMemoryCount:(NSInteger)maxMemoryCount {
    _maxMemeoryCount = maxMemoryCount;
}

#pragma mark - Private Method

- (void)_startLoadData:(NSString *)modelDirPath {
    if (!_safe_string(modelDirPath)) return;
    dispatch_async([self.class updateQueue], ^{
        [self performSelector:@selector(_loadDataToMemory:)
                     onThread:[self.class updateThread]
                   withObject:modelDirPath
                waitUntilDone:NO];
    });
}

- (void)_loadDataToMemory:(NSString *)modelDirPath {
    NSError *error;
    NSArray <NSString *> *fileNameArray =
    [[NSFileManager defaultManager] contentsOfDirectoryAtPath:modelDirPath error:&error];
    
    if (error || fileNameArray.count == 0) return;
    
    @autoreleasepool {
        
        NSMutableArray *cacheModelArray = @[].mutableCopy;
        for (NSString *fileName in fileNameArray) {
            NSString *resultFilePath = [self _getCacheModelFilePathWithFileName:fileName];
            [_lock lock];
            TABAnimatedCacheModel *model =
            (TABAnimatedCacheModel *)[TABAnimatedDocumentMethod
                                           getCacheData:resultFilePath
                                            targetClass:[TABAnimatedCacheModel class]];
            if (model) {
                [cacheModelArray addObject:model];
            }
            [_lock unlock];
        }
        
        [_lock lock];
        _cacheModelArray = [NSMutableArray arrayWithArray:[cacheModelArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            TABAnimatedCacheModel *model1 = obj1;
            TABAnimatedCacheModel *model2 = obj2;
            if (model1.loadCount > model2.loadCount) {
                return NSOrderedAscending;
            }else {
                return NSOrderedDescending;
            }
        }]];
        [_lock unlock];
        
        if (_cacheModelArray == nil || _cacheModelArray.count == 0) return;
        
        NSInteger maxCount = [self _getModelArrayMaxCount];
        for (NSInteger i = 0; i < maxCount; i++) {
            
            [_lock lock];
            TABAnimatedCacheModel *model = _cacheModelArray[i];
            NSString *filePath = [self _getCacheProductionFilePathWithFileName:model.fileName];
            
            TABAnimatedProduction *production =
            (TABAnimatedProduction *)[TABAnimatedDocumentMethod getCacheData:filePath
                                                                 targetClass:[TABAnimatedProduction class]];
            if (production && production.fileName && production.fileName.length > 0) {
                [_cacheManagerDict setObject:production.copy forKey:production.fileName];
            }
            [_lock unlock];
        }
    }
}

- (void)updateCacheModelLoadCountWithClass:(Class)class
                            controllerName:(NSString *)controllerName
                                     frame:(CGRect)frame {
    if (!class) return;
    NSString *fileName = [TABAnimatedProductHelper getKeyWithControllerName:controllerName targetClass:class frame:frame];
    if (!_safe_string(fileName)) return;
    dispatch_async([self.class updateQueue], ^{
        [self performSelector:@selector(updateCacheModelLoadCountWithTargetFileName:)
                     onThread:[self.class updateThread]
                   withObject:fileName
                waitUntilDone:NO];
    });
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
    
    TABAnimatedCacheModel *cacheModel = array[0];
    TABAnimatedProduction *production = array[1];
    if (production && cacheModel) {
        [_lock lock];
        NSString *managerFilePath = [self _getCacheProductionFilePathWithFileName:production.fileName];
        [TABAnimatedDocumentMethod writeToFileWithData:production
                                              filePath:managerFilePath];
        NSString *modelFilePath = [self _getCacheModelFilePathWithFileName:production.fileName];
        [TABAnimatedDocumentMethod writeToFileWithData:cacheModel
                                              filePath:modelFilePath];
        [_lock unlock];
    }
}

#pragma mark -

- (NSString *)_getFolderPath {
    
    BOOL isSuccess = YES;
    
    NSString *documentDir = [TABAnimatedDocumentMethod getPathByFilePacketName:TABCacheManagerFolderName];
    if (![TABAnimatedDocumentMethod isExistFile:documentDir isDir:YES]) {
        isSuccess = [TABAnimatedDocumentMethod createFile:documentDir isDir:YES];
    }
    
    if (!isSuccess) return nil;
    
    // 删除旧的manager文件夹
    NSString *managerDirPath = [documentDir stringByAppendingPathComponent:TABCacheManagerCacheManagerFolderName];
    if ([TABAnimatedDocumentMethod isExistFile:managerDirPath isDir:YES]) {
        [TABAnimatedDocumentMethod deleteFile:managerDirPath];
    }
    
    NSString *modelDirPath = [documentDir stringByAppendingPathComponent:TABCacheManagerCacheModelFolderName];
    if (![TABAnimatedDocumentMethod isExistFile:modelDirPath isDir:YES]) {
        isSuccess = [TABAnimatedDocumentMethod createFile:modelDirPath isDir:YES];
    }
    
    if (!isSuccess) return nil;
    
    NSString *productionDirPath = [documentDir stringByAppendingPathComponent:TABCacheManagerCacheProductionFolderName];
    if (![TABAnimatedDocumentMethod isExistFile:productionDirPath isDir:YES]) {
        isSuccess = [TABAnimatedDocumentMethod createFile:productionDirPath isDir:YES];
    }
    
    if (!isSuccess) return nil;
    
    return modelDirPath;
}

- (NSInteger)_getModelArrayMaxCount {
    return _cacheModelArray.count > _maxMemeoryCount ? _maxMemeoryCount : _cacheModelArray.count;
}

- (NSString *)_getCacheProductionFilePathWithFileName:(NSString *)fileName {
    return [TABAnimatedDocumentMethod getPathByFilePacketName:[NSString stringWithFormat:@"/%@/%@/%@.plist",TABCacheManagerFolderName,TABCacheManagerCacheProductionFolderName,fileName]];
}

- (NSString *)_getCacheModelFilePathWithFileName:(NSString *)fileName {
    return [TABAnimatedDocumentMethod getPathByFilePacketName:[NSString stringWithFormat:@"/%@/%@/%@.plist",TABCacheManagerFolderName,TABCacheManagerCacheModelFolderName,fileName]];
}

- (BOOL)_judgeProdcutionIsNeedUpdate:(TABAnimatedProduction *)production {
    if (production.version && production.version.length > 0 &&
        [TABAnimatedCacheManager shareManager].currentSystemVersion &&
        [TABAnimatedCacheManager shareManager].currentSystemVersion.length > 0) {
        if ([production.version isEqualToString:[TABAnimatedCacheManager shareManager].currentSystemVersion]) {
            return NO;
        }
    }
    return YES;
}

- (nullable TABAnimatedProduction *)_getProductionInMemoryWithKey:(NSString *)key {
    TABAnimatedProduction *production;
    production = [self.cacheManagerDict objectForKey:key];
    if (!production || [self _judgeProdcutionIsNeedUpdate:production]) return nil;
    return production.copy;
}

- (nullable TABAnimatedProduction *)_getProductionInDiskWithKey:(NSString *)key {
    NSString *filePath = [self _getCacheProductionFilePathWithFileName:key];
    if (!_safe_string(filePath)) return nil;
    
    TABAnimatedProduction *production = (TABAnimatedProduction *)[TABAnimatedDocumentMethod getCacheData:filePath targetClass:[TABAnimatedProduction class]];
    if (!production || [self _judgeProdcutionIsNeedUpdate:production]) return nil;
    [self.cacheManagerDict setObject:production.copy forKey:production.fileName];
    return production.copy;
}
 
- (BOOL)_canCacheToMemoryWithProduction:(TABAnimatedProduction *)production {
    if ([TABAnimated sharedAnimated].closeCache) return NO;
    if (production == nil || production.fileName == nil || production.fileName.length == 0) return NO;
    if (_currentSystemVersion == nil || _currentSystemVersion.length == 0) return NO;
    return YES;
}

- (BOOL)_canCacheToDiskWithProduction:(TABAnimatedProduction *)production {
    if ([TABAnimated sharedAnimated].closeDiskCache) return NO;
    if (production == nil || production.fileName == nil || production.fileName.length == 0) return NO;
    if (_currentSystemVersion == nil || _currentSystemVersion.length == 0) return NO;
    return YES;
}

@end
