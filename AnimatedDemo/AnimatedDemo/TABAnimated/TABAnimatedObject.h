//
//  TABAnimatedObject.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/3/5.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// the animation status.
// 动画状态
typedef NS_ENUM(NSInteger,TABViewAnimationStyle) {
    TABViewAnimationDefault = 0,                             // 默认,没有动画
    TABViewAnimationStart,                                   // 开始动画
    TABViewAnimationRunning,                                 // 动画中  you don't need care the status.
    TABViewAnimationEnd,                                     // 结束动画
};

// the type of superAnimation. (1.8.7 新增)
typedef NS_ENUM(NSInteger,TABViewSuperAnimationType) {
    TABViewSuperAnimationTypeDefault = 0,                    // default, 不做降权处理
    TABViewSuperAnimationTypeOnlySkeleton,                   // 骨架层
    TABViewSuperAnimationTypeBinAnimation,                   // 呼吸灯
    TABViewSuperAnimationTypeShimmer,                        // 闪光灯
};

@class TABLayer;

@interface TABAnimatedObject : NSObject

/**
 单section表格组件初始化方式

 @param templateClass 模版cell
 @param animatedCount 动画时row值
 @return object
 */
+ (instancetype)animatedWithTemplateClass:(Class)templateClass
                            animatedCount:(NSInteger)animatedCount;

/**
 多section表格组件初始化方式

 @param templateClassArray 模版cell数组
 @param animatedCountArray 动画时row值的集合
 @return object
 */
+ (instancetype)animatedWithTemplateClassArray:(NSArray <Class> *)templateClassArray
                            animatedCountArray:(NSArray <NSNumber *> *)animatedCountArray;

// 一个section对应一个templateClass
@property (nonatomic,copy) NSArray <NSString *> *templateClassArray;

// 单个section使用该属性，设置动画时row数量
// 默认值为2
@property (nonatomic,assign) NSInteger animatedCount;

// 多个section使用该属性，设置动画时row数量
// 当数组数量大于section数量，多余数据将舍弃
// 当数组数量小于seciton数量，剩余部分动画时row的数量为默认值
@property (nonatomic,copy) NSArray <NSNumber *> *animatedCountArray;

// 使用该属性时，全局动画类型失效，目标视图将更改为当前属性指定的动画类型。
@property (nonatomic,assign) TABViewSuperAnimationType superAnimationType;

// 是否在动画中
@property (nonatomic,assign) BOOL isAnimating;                      // is runing animation or not.

// 是否是嵌套类型视图
@property (nonatomic,assign) BOOL isNest;

// you do not need care it.
@property (nonatomic,assign) TABViewAnimationStyle animatedStyle;   // 不要修改它，旧版可以使用，1.8.8以上不推荐使用

@property (nonatomic,copy) NSString *tabIdentifier;                 // A string that identifies the user interface element.

@end

NS_ASSUME_NONNULL_END
