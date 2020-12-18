//
//  NSArray+TABAnimated.h
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
//  Created by tigerAndBull on 2019/5/1.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TABAnimatedChainDefines.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 链式语法相关的文件
 */
@class TABBaseComponent;

@interface NSArray (TABAnimatedChain)

/**
 * 所有元素向左平移
 *
 * @return 目标动画元素数组
 */
- (TABAnimatedArrayFloatBlock)left;

/**
 * 所有元素向右平移
 *
 * @return 目标动画元素数组
 */
- (TABAnimatedArrayFloatBlock)right;

/**
 * 所有元素向上平移
 *
 * @return 目标动画元素数组
 */
- (TABAnimatedArrayFloatBlock)up;

/**
 * 所有元素向下平移
 *
 * @return 目标动画元素数组
 */
- (TABAnimatedArrayFloatBlock)down;

/**
 * 设置所有元素的宽度
 *
 * @return 目标动画元素数组
 */
- (TABAnimatedArrayFloatBlock)width;

/**
 * 设置所有元素的高度
 *
 * @return 目标动画元素数组
 */
- (TABAnimatedArrayFloatBlock)height;

/**
 * 设置所有元素的圆角
 *
 * @return 目标动画元素数组
 */
- (TABAnimatedArrayFloatBlock)radius;

/**
 * 减少的宽度：与当前宽度相比，所减少的宽度，负数则增加。
 *
 * @return 目标动画元素数组
 */
- (TABAnimatedArrayFloatBlock)reducedWidth;

/**
 * 减少的高度：与当前高度相比，所减少的高度，负数则增加。
 *
 * @return 目标动画元素数组
 */
- (TABAnimatedArrayFloatBlock)reducedHeight;

/**
 * 减少的圆角：与当前圆角相比，所减少的圆角，负数则增加。
 *
 * @return 目标动画元素数组
 */
- (TABAnimatedArrayFloatBlock)reducedRadius;

/**
 * 设置行数
 *
 * @return 目标动画元素数组
 */
- (TABAnimatedArrayIntBlock)line;

/**
 * 间距，行数超过1时生效，默认为8.0。
 *
 * @return 目标动画元素数组
 */
- (TABAnimatedArrayFloatBlock)space;

/**
 * 移除该动画组件数组中的所有组件
 *
 * @return 目标动画元素数组
 */
- (TABAnimatedArrayBlock)remove;

/**
 * 添加占位图，不支持圆角，建议切图使用圆角
 *
 * @return 目标动画元素数组
 */
- (TABAnimatedArrayStringBlock)placeholder;

/**
 * 设置横坐标
 *
 * @return 目标动画元素数组
 */
- (TABAnimatedArrayFloatBlock)x;

/**
 * 设置纵坐标
 *
 * @return 目标动画元素数组
 */
- (TABAnimatedArrayFloatBlock)y;

/**
 * 设置动画数组颜色
 *
 * @return 目标动画元素数组
 */
- (TABAnimatedArrayColorBlock)color;

/**
 * 该元素不添加附加动画
 *
 * @return 目标动画元素数组
 */
- (TABAnimatedArrayBlock)withoutAnimation;

/// 穿透组件
/// 在骨架屏期间暴露出该组件
- (TABAnimatedArrayBlock)penetrate;

#pragma mark - 接口作用说明见TABBaseComponent.h

- (TABComponentArrayCompareBlock)leftEqualTo;
- (TABComponentArrayCompareBlock)rightEqualTo;
- (TABComponentArrayCompareBlock)topEqualTo;
- (TABComponentArrayCompareBlock)bottomEqualTo;
- (TABComponentArrayCompareBlock)widthEqualTo;
- (TABComponentArrayCompareBlock)heightEqualTo;
- (TABComponentArrayCompareBlock)leftEqualToRight;
- (TABComponentArrayCompareBlock)rightEqualToLeft;
- (TABComponentArrayCompareBlock)topEqualToBottom;
- (TABComponentArrayCompareBlock)bottomEqualToTop;

#pragma mark -

- (TABComponentArrayCompareWithOffsetBlock)leftEqualTo_offset;
- (TABComponentArrayCompareWithOffsetBlock)rightEqualTo_offset;
- (TABComponentArrayCompareWithOffsetBlock)topEqualTo_offset;
- (TABComponentArrayCompareWithOffsetBlock)bottomEqualTo_offset;
- (TABComponentArrayCompareWithOffsetBlock)widthEqualTo_offset;
- (TABComponentArrayCompareWithOffsetBlock)heightEqualTo_offset;
- (TABComponentArrayCompareWithOffsetBlock)leftEqualToRight_offset;
- (TABComponentArrayCompareWithOffsetBlock)rightEqualToLeft_offset;
- (TABComponentArrayCompareWithOffsetBlock)topEqualToBottom_offset;
- (TABComponentArrayCompareWithOffsetBlock)bottomEqualToTop_offset;

@end

NS_ASSUME_NONNULL_END
