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

NS_ASSUME_NONNULL_BEGIN

/**
 链式语法相关的文件
 */

@class TABBaseComponent;

@interface NSArray (TABAnimated)

typedef NSArray <TABBaseComponent *> * _Nullable (^TABAnimatedArrayFloatBlock)(CGFloat);
typedef NSArray <TABBaseComponent *> * _Nullable (^TABAnimatedArrayIntBlock)(NSInteger);
typedef NSArray <TABBaseComponent *> * _Nullable (^TABAnimatedArrayBlock)(void);
typedef NSArray <TABBaseComponent *> * _Nullable (^TABAnimatedArrayStringBlock)(NSString *);
typedef NSArray <TABBaseComponent *> * _Nullable (^TABAnimatedArrayColorBlock)(UIColor *);

/**
 所有元素向左平移
 
 @return 目标动画元素数组
 */
- (TABAnimatedArrayFloatBlock)left;

/**
 所有元素向右平移

 @return 目标动画元素数组
 */
- (TABAnimatedArrayFloatBlock)right;

/**
 所有元素向上平移

 @return 目标动画元素数组
 */
- (TABAnimatedArrayFloatBlock)up;

/**
 所有元素向下平移

 @return 目标动画元素数组
 */
- (TABAnimatedArrayFloatBlock)down;

/**
 设置所有元素的宽度
 
 @return 目标动画元素数组
 */
- (TABAnimatedArrayFloatBlock)width;

/**
 设置所有元素的高度

 * @return 目标动画元素数组
 */
- (TABAnimatedArrayFloatBlock)height;

/**
 设置所有元素的圆角
 
 @return 目标动画元素数组
 */
- (TABAnimatedArrayFloatBlock)radius;

/**
 减少的宽度：与当前宽度相比，所减少的宽度，负数则增加。

 @return 目标动画元素数组
 */
- (TABAnimatedArrayFloatBlock)reducedWidth;

/**
 减少的高度：与当前高度相比，所减少的高度，负数则增加。

 @return 目标动画元素数组
 */
- (TABAnimatedArrayFloatBlock)reducedHeight;

/**
 减少的圆角：与当前圆角相比，所减少的圆角，负数则增加。
 
 @return 目标动画元素数组
 */
- (TABAnimatedArrayFloatBlock)reducedRadius;

/**
 设置行数
 
 @return 目标动画元素数组
 */
- (TABAnimatedArrayIntBlock)line;

/**
 间距，行数超过1时生效，默认为8.0。
 
 @return 目标动画元素数组
 */
- (TABAnimatedArrayFloatBlock)space;

/**
 移除该动画组件数组中的所有组件

 @return 目标动画元素数组
 */
- (TABAnimatedArrayBlock)remove;

/**
 添加占位图，不支持圆角，建议切图使用圆角

 @return 目标动画元素数组
 */
- (TABAnimatedArrayStringBlock)placeholder;

/**
 设置横坐标

 @return 目标动画元素数组
 */
- (TABAnimatedArrayFloatBlock)x;

/**
 设置纵坐标

 @return 目标动画元素数组
 */
- (TABAnimatedArrayFloatBlock)y;

/**
 设置动画数组颜色
 
 @return 目标动画元素数组
 */
- (TABAnimatedArrayColorBlock)color;

#pragma mark - Drop Animation 以下属性均针对豆瓣动画

/**
 豆瓣动画变色下标，一起变色的元素，设置同一个下标即可。
 
 @return 目标动画元素数组
 */
- (TABAnimatedArrayIntBlock)dropIndex;

/**
 适用于多行的动画元素,
 比如设置 dropFromIndex(3), 那么多行动画组中的第一个动画的下标是3，第二个就是4，依次类推。
 
 @return 目标动画元素数组
 */
- (TABAnimatedArrayIntBlock)dropFromIndex;

/**
 将动画层移出豆瓣动画队列，不参与变色。
 
 @return 目标动画元素数组
 */
- (TABAnimatedArrayBlock)removeOnDrop;

/**
 豆瓣动画变色停留时间比，默认是0.2。
 
 @return 目标动画元素数组
 */
- (TABAnimatedArrayFloatBlock)dropStayTime;

@end

NS_ASSUME_NONNULL_END
