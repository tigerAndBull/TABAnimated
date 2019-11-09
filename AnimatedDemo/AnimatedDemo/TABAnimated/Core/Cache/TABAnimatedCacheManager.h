//
//  TABCacheManager.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/9/14.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TABComponentManager, TABTableAnimated, TABCollectionAnimated;

extern NSString * const TABCacheManagerFolderName;

@interface TABAnimatedCacheManager : NSObject

// 当前App版本
@property (nonatomic, copy, readonly) NSString *currentSystemVersion;
// 本地的缓存
@property (nonatomic, strong, readonly) NSMutableArray *cacheModelArray;
// 内存中的骨架屏管理单元
@property (nonatomic, strong, readonly) NSMutableDictionary *cacheManagerDict;

/**
 * 加载该用户常点击的骨架屏plist文件到内存
 * 按`loadCount`降序排列
 */
- (void)install;

/**
 * 存储骨架屏管理单元到指定沙盒目录
 * @param manager 骨架屏管理单元
 */
- (void)cacheComponentManager:(TABComponentManager *)manager;

/**
 * 获取指定骨架屏管理单元
 * @param fileName 文件名
 */
- (nullable TABComponentManager *)getComponentManagerWithFileName:(NSString *)fileName;

/**
 * 更新该viewAnimated下所有骨架屏管理单元的loadCount
 * @param viewAnimated 骨架屏配置对象
 */
- (void)updateCacheModelLoadCountWithTableAnimated:(TABTableAnimated *)viewAnimated;

/**
 * 更新该viewAnimated下所有骨架屏管理单元的loadCount
 * @param viewAnimated 骨架屏配置对象
 */
- (void)updateCacheModelLoadCountWithCollectionAnimated:(TABCollectionAnimated *)viewAnimated;

@end

NS_ASSUME_NONNULL_END
