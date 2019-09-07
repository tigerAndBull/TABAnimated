//
//  TABComponentManager.h
//  AnimatedDemo
//
//  github: https://github.com/tigerAndBull/TABAnimated
//  jianshu: https://www.jianshu.com/p/6a0ca4995dff
//
//  集成问答文档：https://www.jianshu.com/p/34417897915a
//  历史更新文档：https://www.jianshu.com/p/e3e9ea295e8a
//  动画下标说明：https://www.jianshu.com/p/8c361ba5aa18
//  豆瓣效果说明：https://www.jianshu.com/p/1a92158ce83a
//  嵌套视图说明：https://www.jianshu.com/p/cf8e37195c11
//
//  Created by tigerAndBull on 2019/7/16.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TABViewAnimated, TABBaseComponent, TABComponentLayer;

typedef TABBaseComponent * _Nullable (^TABBaseComponentBlock)(NSInteger);
typedef NSArray <TABBaseComponent *> * _Nullable (^TABBaseComponentArrayBlock)(NSInteger location, NSInteger length);
typedef NSArray <TABBaseComponent *> * _Nullable (^TABBaseComponentArrayWithIndexsBlock)(NSInteger index,...);

@interface TABComponentManager : NSObject

/**
 获取单个动画元素
 使用方式：.animation(x)
 
 @return TABBaseComponent对象
 */
- (TABBaseComponentBlock _Nullable)animation;

/**
 获取多个动画元素，需要传递2个参数
 第一个参数为起始下标
 第二个参数长度
 使用方式：.animations(x,x)
 
 @return 装有`TABBaseComponent`类型的数组
 */
- (TABBaseComponentArrayBlock _Nullable)animations;

/**
 获取不定量动画元素，参数 >= 1
 例如: animationsWithIndexs(1,5,7)，意为获取下标为1，5，7的动画元素
 
 @return 装有`TABBaseComponent`类型的数组
 */
- (TABBaseComponentArrayWithIndexsBlock)animationsWithIndexs;

#pragma mark - 相关属性

@property (nonatomic) Class tabTargetClass;

@property (nonatomic, strong) CALayer *tabLayer;

@property (nonatomic, strong) UIColor *animatedColor;

@property (nonatomic, strong) UIColor *animatedBackgroundColor;

@property (nonatomic, assign) CGFloat animatedHeight;

@property (nonatomic, assign) CGFloat animatedCornerRadius;

@property (nonatomic, assign) BOOL cancelGlobalCornerRadius;

/**
 兼容旧回调保留属性
 */
@property (nonatomic, strong, readonly) NSMutableArray <TABComponentLayer *> *componentLayerArray;

/**
 存放最终显示在屏幕上的动画组
 */
@property (nonatomic, strong, readonly) NSMutableArray <TABComponentLayer *> *resultLayerArray;

@property (nonatomic, strong, readonly) NSMutableArray <TABBaseComponent *> *baseComponentArray;

/**
 暂存被嵌套的表格视图
 */
@property (nonatomic, weak) UIView *nestView;

/**
 是否已经装载并加载过动画
 */
@property (nonatomic, assign) BOOL isLoad;

/**
 对于表格视图的cell和头尾视图，当前所处section
 */
@property (nonatomic, assign) NSInteger currentSection;

/**
 对于表格视图的cell，当前所处row
 */
@property (nonatomic, assign) NSInteger currentRow;

/**
 豆瓣动画组动画元素的数量
 */
@property (nonatomic, assign, readonly) NSInteger dropAnimationCount;

/**
 豆瓣动画
 */
@property (nonatomic, strong) NSMutableArray <NSArray *> *entireIndexArray;

+ (instancetype)initWithView:(UIView *)view
                 tabAnimated:(TABViewAnimated *)tabAnimated;

- (void)installBaseComponent:(NSArray <TABComponentLayer *> *)array;

- (void)updateComponentLayers;

@end

NS_ASSUME_NONNULL_END
