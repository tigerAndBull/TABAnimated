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
#import "TABComponentLayer.h"
#import "TABSentryView.h"

NS_ASSUME_NONNULL_BEGIN

@class TABViewAnimated, TABBaseComponent;

typedef TABBaseComponent * _Nullable (^TABBaseComponentBlock)(NSInteger);
typedef NSArray <TABBaseComponent *> * _Nullable (^TABBaseComponentArrayBlock)(NSInteger location, NSInteger length);
typedef NSArray <TABBaseComponent *> * _Nullable (^TABBaseComponentArrayWithIndexsBlock)(NSInteger index,...);

@interface TABComponentManager : NSObject <NSCopying, NSSecureCoding>

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

/**
 * 绑定的cell的class，用于在预处理回调中区分class
 */
@property (nonatomic) Class tabTargetClass;

/**
 * cell中覆盖在最底层的layer
 */
@property (nonatomic, strong) TABComponentLayer *tabLayer;

/**
 * 设置该属性后，统一设置该cell内所有动画元素的内容颜色
 * 优先级高于全局的内容颜色，低于动画元素自定义的内容颜色
 */
@property (nonatomic, strong) UIColor *animatedColor;

/**
 * 设置该属性后，统一设置该cell的背景颜色
 */
@property (nonatomic, strong) UIColor *animatedBackgroundColor;

/**
 * 设置该属性后，统一设置该cell内所有动画元素的高度
 * 优先级高于全局的高度，低于动画元素自定义的高度
 */
@property (nonatomic, assign) CGFloat animatedHeight;

/**
 * 设置该属性后，统一设置该cell内所有动画元素的圆角
 * 优先级高于全局的圆角，低于动画元素自定义的圆角
 */
@property (nonatomic, assign) CGFloat animatedCornerRadius;

/**
 * 设置该属性后，统一设置取消cell内所有动画元素的圆角
 * 优先级高于全局的取消圆角属性，低于动画元素自定义的取消圆角属性
 */
@property (nonatomic, assign) BOOL cancelGlobalCornerRadius;

/**
 * 哨兵视图，用于监听暗黑模式
 */
@property (nonatomic, weak, readonly, nullable) TABSentryView *sentryView;

/**
 * 最初始动画组
 */
@property (nonatomic, strong, readonly) NSMutableArray <TABComponentLayer *> *componentLayerArray;

/**
 * 最初的动画组包装类
 */
@property (nonatomic, strong, readonly) NSMutableArray <TABBaseComponent *> *baseComponentArray;

/**
 * 最终显示在屏幕上的动画组
 */
@property (nonatomic, strong, readonly) NSMutableArray <TABComponentLayer *> *resultLayerArray;

/**
 * 暂存被嵌套的表格视图
 */
@property (nonatomic, weak) UIView *nestView;

/**
 * 是否已经装载并加载过动画
 */
@property (nonatomic, assign) BOOL isLoad;

/**
 * 对于表格视图的cell和头尾视图，当前所处section
 */
@property (nonatomic, assign) NSInteger currentSection;

/**
 * 对于表格视图的cell和头尾视图，当前所处row
 * 用于对于某一个cell的特殊处理
 */
@property (nonatomic, assign) NSInteger currentRow;

/**
 * 豆瓣动画组动画元素的数量
 */
@property (nonatomic, assign, readonly) NSInteger dropAnimationCount;

/**
 * 豆瓣动画
 */
@property (nonatomic, strong) NSMutableArray <NSArray *> *entireIndexArray;

/**
 * 该cell类型存储到本地的文件名
 */
@property (nonatomic, copy) NSString *fileName;

/**
 * 该cell类型映射到本地文件的最后一次版本号
 */
@property (nonatomic, copy) NSString *version;

/**
 * 框架会自动为该属性赋值
 * 不要手动改变它的值
 */
@property (nonatomic, assign) BOOL needChangeRowStatus;

/**
 * 框架会自动为该属性赋值
 * 不要手动改变它的值
 */
@property (nonatomic, assign, readonly) BOOL needUpdate;

+ (instancetype)initWithView:(UIView *)view
                   superView:(UIView *)superView
                 tabAnimated:(TABViewAnimated *)tabAnimated;

- (void)installBaseComponentArray:(NSArray <TABComponentLayer *> *)array;

- (void)updateComponentLayers;

- (void)addSentryView:(UIView *)view
            superView:(UIView *)superView;

- (void)reAddToView:(UIView *)view
          superView:(UIView *)superView;

@end

NS_ASSUME_NONNULL_END
