//
//  NSArray+TABAnimated.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/5/1.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TABAnimated.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (TABAnimated)

typedef NSArray <TABComponentLayer *> *_Nullable(^TABAnimatedArrayFloatBlock)(CGFloat);
typedef NSArray <TABComponentLayer *> *_Nullable(^TABAnimatedArrayIntBlock)(NSInteger);
typedef NSArray <TABComponentLayer *> *_Nullable(^TABAnimatedArrayBlock)(void);

/**
 Translation to the left
 向左平移
 
 @return return value 向左平移的值
 */
- (TABAnimatedArrayFloatBlock)left;

/**
 Translation to the right
 向右平移
 
 @return return value 向右平移的值
 */
- (TABAnimatedArrayFloatBlock)right;

/**
 Upward translation
 向上平移
 
 @return return value 向上平移的值
 */
- (TABAnimatedArrayFloatBlock)up;

/**
 Downward translation
 向下平移
 
 @return return value 向下平移的值
 */
- (TABAnimatedArrayFloatBlock)down;

/**
 set width
 设置该动画组件数组所有组件的宽度，设置的是`tabViewWidth`这个属性
 
 @return return value 宽度
 */
- (TABAnimatedArrayFloatBlock)width;

/**
 set height
 设置该动画组件数组所有组件的高度，设置的就是`tabViewHeight`这个属性
 
 @return return value 高度
 */
- (TABAnimatedArrayFloatBlock)height;

/**
 set animation cornerRadius
 设置该动画组件数组所有组件的圆角

 @return return value 圆角
 */
- (TABAnimatedArrayFloatBlock)radius;

/**
 减少的宽度：与当前宽度相比，所减少的宽度
 
 @return return value 减少的宽度
 */
- (TABAnimatedArrayFloatBlock)reducedWidth;

/**
 减少的高度：与当前高度相比，所减少的高度
 
 @return return value 减少的高度
 */
- (TABAnimatedArrayFloatBlock)reducedHeight;

/**
 set numberOflines
 设置行数
 
 @return return value 设置的行数
 */
- (TABAnimatedArrayIntBlock)line;

/**
 set linespace
 间距，行数超过1时生效
 
 @return return value 间距值
 */
- (TABAnimatedArrayFloatBlock)space;

/**
 remve the layer
 移除该动画组件数组中的所有组件
 
 @return return value description
 */
- (TABAnimatedArrayBlock)remove;

#pragma mark - Drop Animation

/**
 豆瓣动画变色下标，一起变色的元素，设置同一个下标即可
 */
- (TABAnimatedArrayIntBlock)dropIndex;

/**
 适用于多行文本类型动画,
 比如设置 dropFromIndex(3), 那么多行动画组中的第一个动画的下标是3，第二个就是4
 */
- (TABAnimatedArrayIntBlock)dropFromIndex;

/**
 将动画层移出豆瓣动画队列，不参与变色
 */
- (TABAnimatedArrayBlock)removeOnDrop;

/**
 豆瓣动画变色停留时间比，默认是0.2
 */
- (TABAnimatedArrayFloatBlock)dropStayTime;

@end

NS_ASSUME_NONNULL_END
