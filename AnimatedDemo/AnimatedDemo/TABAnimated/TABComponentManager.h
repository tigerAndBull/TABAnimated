//
//  TABComponentManager.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/7/16.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TABBaseComponent;
@class TABComponentLayer;

typedef TABBaseComponent * _Nullable (^TABBaseComponentBlock)(NSInteger);
typedef NSArray <TABBaseComponent *> * _Nullable (^TABBaseComponentArrayBlock)(NSInteger location, NSInteger length);

@interface TABComponentManager : NSObject

/**
 * 获取单个动画组件
 * 使用方式：.animation(x)
 *
 * @return return value description
 */
- (TABBaseComponentBlock _Nullable)animation;

/**
 * 获取多个动画组件，需要传递2个参数
 * 第一个参数为起始下标
 * 第二个参数长度
 * 使用方式：.animations(x,x)
 *
 * @return return value description
 */
- (TABBaseComponentArrayBlock _Nullable)animations;

#pragma mark - 相关属性

@property (nonatomic,strong) CALayer *tabLayer;

@property (nonatomic,strong) UIColor *animatedColor;

@property (nonatomic,strong) UIColor *animatedBackgroundColor;

@property (nonatomic,assign) CGFloat animatedHeight;

@property (nonatomic,assign) CGFloat animatedCornerRadius;

@property (nonatomic,assign) BOOL cancelGlobalCornerRadius;

@property (nonatomic,assign) CGPoint cardOffset;

/**
 * 兼容旧回调保留属性
 */
@property (nonatomic,strong,readonly) NSMutableArray <TABComponentLayer *> *componentLayerArray;

/**
 * 存放最终显示在屏幕上的动画组
 */
@property (nonatomic,strong,readonly) NSMutableArray <TABComponentLayer *> *resultLayerArray;

@property (nonatomic,strong,readonly) NSMutableArray <TABBaseComponent *> *baseComponentArray;

/**
 * 暂存被嵌套的表格视图
 */
@property (nonatomic,weak) UIView *nestView;

/**
 * 是否已经加载过
 */
@property (nonatomic,assign) BOOL isLoad;

/**
 * 对于表格视图，当前所处section
 */
@property (nonatomic,assign) NSInteger currentSection;

/**
 * 豆瓣动画组动画元素的数量
 */
@property (nonatomic,assign,readonly) NSInteger dropAnimationCount;

/**
 * 豆瓣动画
 */
@property (nonatomic,strong) NSMutableArray <NSArray *> *entireIndexArray;

+ (instancetype)initWithView:(UIView *)view;

- (void)installBaseComponent:(NSArray <TABComponentLayer *> *)array;

- (void)updateComponentLayers;

@end

NS_ASSUME_NONNULL_END
