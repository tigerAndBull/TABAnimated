//
//  TABCacheManager.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/9/14.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TABComponentManager;

extern NSString * const TABCacheManagerFolderName;

@interface TABAnimatedCacheManager : NSObject

@property (nonatomic, copy) NSString *currentSystemVersion;
@property (nonatomic, strong) NSMutableArray *cacheModelArray;
@property (nonatomic, strong) NSMutableDictionary *cacheManagerDict;

- (void)install;

- (void)cacheComponentManager:(TABComponentManager *)manager;

- (nullable TABComponentManager *)getComponentManagerWithFileName:(NSString *)fileName;

- (void)updateCacheModelLoadCountWithTargetFileName:(NSString *)targetFileName;

@end

NS_ASSUME_NONNULL_END
