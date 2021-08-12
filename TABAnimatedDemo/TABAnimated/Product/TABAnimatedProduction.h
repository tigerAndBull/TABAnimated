//
//  TABAnimatedProduction.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/4/1.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TABAnimatedProductDefines.h"

NS_ASSUME_NONNULL_BEGIN

@class TABWeakDelegateManager, TABComponentLayer;

@interface TABAnimatedProduction : NSObject <NSCopying, NSSecureCoding>

// 产品当前所处状态
@property (nonatomic, assign) TABAnimatedProductionState state;

// 背景layer
@property (nonatomic, strong) TABComponentLayer *backgroundLayer;

// 子layers
@property (nonatomic, strong) NSMutableArray <TABComponentLayer *> *layers;

// 来源的class类型
@property (nonatomic) Class targetClass;

// 注：section和row大多不会在同一场景里同时用到, 所以未使用NSIndexPath进行包装
// 控制视图为表格时，该产品所在的section
@property (nonatomic) NSInteger currentSection;

// 控制视图为表格时，该产品所在的row
@property (nonatomic) NSInteger currentRow;

// 存储到本地的文件名, 也是其唯一标识
@property (nonatomic, copy) NSString *fileName;

// 序列化到本地文件时的版本号
@property (nonatomic, copy) NSString *version;

@property (nonatomic, strong) TABWeakDelegateManager *syncDelegateManager;

+ (instancetype)productWithState:(TABAnimatedProductionState)state;
- (instancetype)initWithState:(TABAnimatedProductionState)state;

+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;

- (CGFloat)recommendHeight;

@end

NS_ASSUME_NONNULL_END
