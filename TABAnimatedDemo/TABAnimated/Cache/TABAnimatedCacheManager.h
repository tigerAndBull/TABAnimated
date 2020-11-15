//
//  TABCacheManager.h
//  TABAnimatedDemo
//
//  Created by tigerAndBull on 2019/9/14.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TABFormAnimated, TABAnimatedProduction;

extern NSString * const TABCacheManagerFolderName;

@interface TABAnimatedCacheManager : NSObject

// 当前App版本
@property (nonatomic, copy, readonly) NSString *currentSystemVersion;

// 本地的缓存
@property (nonatomic, strong, readonly) NSMutableArray *cacheModelArray;

// 内存中的骨架屏
@property (nonatomic, strong, readonly) NSMutableDictionary *cacheManagerDict;

+ (TABAnimatedCacheManager *)shareManager;

/**
 * 加载该用户常点击的骨架屏到内存中
 * 按`loadCount`降序排列
 */
- (void)install;

/**
 * 存储骨架屏管理单元到指定沙盒目录
 * @param production 骨架屏产品
 */
- (void)cacheProduction:(TABAnimatedProduction *)production;

/**
 * 获取指定骨架屏产品
 * @param key  目标产品的唯一标识
 */
- (nullable TABAnimatedProduction *)getProductionWithKey:(NSString *)key;

/**
 * 更新该viewAnimated下所有骨架屏管理单元的loadCount
 * @param viewAnimated 骨架屏配置对象
 * @param frame  控制视图的坐标
 */
- (void)updateCacheModelLoadCountWithFormAnimated:(TABFormAnimated *)viewAnimated frame:(CGRect)frame;

/// 设置最大缓存在内存中的model数量
/// @param maxMemoryCount 最大数量
- (void)setMaxMemoryCount:(NSInteger)maxMemoryCount;

@end

NS_ASSUME_NONNULL_END
