//
//  NSObject+TABSafe.h
//  TABBaseProject
//
//  Created by tigerAndBull on 2018/10/4.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (TABSafe)

/**
 验证NSString是否为空
 
 @return YES or NO
 */
- (BOOL)tab_isValue;

@end

@interface NSData (TABSafe)

/**
 验证NSData是否为空
 
 @return YES or NO
 */
- (BOOL)tab_isValue;

@end

@interface NSObject (TABSafe)

/**
 验证NSString是否为空
 
 @return YES or NO
 */
- (BOOL)tab_isValue;

@end

@interface NSArray (TABSafe)

/**
 验证NSArray是否为空
 
 @return YES or NO
 */
- (BOOL)tab_isValue;

/**
 获取数组中指定索引对应的对象
 @param index 索引值
 @return 对象
 */
- (id)tab_safeObjectAtIndex:(NSUInteger)index;

@end

@interface NSMutableArray (TABSafe)

/**
 添加对象
 @param object object对象
 */
- (void)tab_addObject:(id)object;

/**
 添加一个对象到指定位置
 @param object 对象
 @param index 索引位置
 */
- (void)tab_insertObject:(id)object atIndex:(NSUInteger)index;

@end

@interface NSDictionary (TABSafe)
/**
 验证NSDictionary是否为空
 
 @return YES or NO
 */
- (BOOL)tab_isValue;

/**
 根据key获取int值
 
 @param key key值
 @return int值
 */
- (int)tab_safeIntForKey:(NSString *)key;

/**
 根据key获取BOOL值
 
 @param key key值
 @return bool值
 */
- (BOOL)tab_safeBoolForKey:(NSString *)key;

/**
 根据key获取float值
 
 @param key key值
 @return float值
 */
- (float)tab_safeFloatForKey:(NSString *)key;

/**
 根据key获取double值
 
 @param key key值
 @return double值
 */
- (double)tab_safeDoubleForKey:(NSString *)key;

/**
 根据key值获取long long值
 
 @param key key值
 @return long long值
 */
- (long long)tab_safeLongLongForKey:(NSString *)key;

/**
 根据key获取NSString对象
 
 @param key key值
 @return NSString对象
 */
- (NSString *)tab_safeStringForKey:(NSString *)key;

/**
 根据key获取NSDictionary对象
 
 @param key key值
 @return NSDictionary对象
 */
- (NSDictionary *)tab_safeDictionaryForKey:(NSString *)key;

/**
 根据key获取NSArray对象
 
 @param key key值
 @return NSArray对象
 */
- (NSArray *)tab_safeArrayForKey:(NSString *)key;

/**
 根据key获取Object对象
 
 @param key key值
 @return Object对象
 */
- (id)tab_safeObjectForKey:(NSString *)key;

@end

@interface NSMutableDictionary(TABSafe)

/**
 根据key设置Object对象
 
 @param object Object对象
 @param key key值
 */
- (void)tab_setObject:(id)object Key:(NSString *)key;

@end

@interface NSNumber (TABSafe)

/**
 验证NSNumber是否为空
 
 @return YES or NO
 */
- (BOOL)tab_isValue;

@end

NS_ASSUME_NONNULL_END
