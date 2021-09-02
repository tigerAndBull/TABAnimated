//
//  TABViewAnimatedDefines.h
//  TABAnimatedDemo
//
//  Created by tigerAndBull on 2020/4/21.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#ifndef TABViewAnimatedDefines_h
#define TABViewAnimatedDefines_h

#import "TABAnimatedChainDefines.h"

@class TABComponentManager;

/**
 * 动画状态枚举
 */
typedef NS_ENUM(NSInteger, TABViewAnimationStyle) {

    // 默认，无事发生
    TABViewAnimationDefault = 0,

    // 可以开启动画
    TABViewAnimationStart,

    // 动画加载完毕
    TABViewAnimationRunning,

    // 动画已关闭
    TABViewAnimationEnd,
};

/**
 控制视图设置此属性后，动画类型覆盖全局动画类型，加载该属性指定的动画
 */
typedef NS_ENUM(NSInteger, TABViewSuperAnimationType) {
    
    // 默认, 不覆盖全局属性处理，使用全局属性
    TABViewSuperAnimationTypeDefault = 0,
    
    // 骨架层
    TABViewSuperAnimationTypeOnlySkeleton,
    
    // 呼吸灯
    TABViewSuperAnimationTypeBinAnimation,
    
    // 闪光灯
    TABViewSuperAnimationTypeShimmer,
    
    // 豆瓣下坠动画
    TABViewSuperAnimationTypeDrop,
};

/**
 表格视图配置
 */
typedef NS_ENUM(NSInteger, TABAnimatedRunMode) {
    
    /**
     以section为单位配置动画 - Section Mode
     
     视图结构必须满足:
     section和cell样式一一对应
     */
    TABAnimatedRunBySection = 0,
    
    /**
    以row为单位配置动画 - Row Mode
     
    视图结构必须满足:
    1. 视图只有1个section
    2. 1个section对应多个cell
    3. row的数量必须要是定值
     */
    TABAnimatedRunByRow,
    
    TABAnimatedRunByPartSection, 
};

typedef NS_ENUM(NSInteger, TABAnimatedViewType) {
    
    // UIView
    TABAnimatedNormalView = 0,
    
    // TableViewCell
    TABAnimatedTableCell,
    
    // TableHeaderFooterView
    TABAnimatedTableHeaderFooterView,
    
    // TableHeaderFooterCell
    TABAnimatedTableHeaderFooterCell,
};

#endif /* TABViewAnimatedDefines_h */
