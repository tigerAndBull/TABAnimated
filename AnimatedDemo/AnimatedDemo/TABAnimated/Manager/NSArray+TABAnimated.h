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
 * 链式语法相关的文件
 */

@class TABBaseComponent;

@interface NSArray (TABAnimated)

typedef NSArray <TABBaseComponent *> * _Nullable (^TABAnimatedArrayFloatBlock)(CGFloat);
typedef NSArray <TABBaseComponent *> * _Nullable (^TABAnimatedArrayIntBlock)(NSInteger);
typedef NSArray <TABBaseComponent *> * _Nullable (^TABAnimatedArrayBlock)(void);
typedef NSArray <TABBaseComponent *> * _Nullable (^TABAnimatedArrayStringBlock)(NSString *);

/**
 * 链式语法：向左平移
 * Translation to the left
 *
 * @return return value 向左平移的值
 */
- (TABAnimatedArrayFloatBlock)left;

/**
 * 链式语法：向右平移
 * Translation to the right
 *
 * @return return value 向右平移的值
 */
- (TABAnimatedArrayFloatBlock)right;

/**
 * 链式语法：向上平移
 * Upward translation
 *
 * @return return value 向上平移的值
 */
- (TABAnimatedArrayFloatBlock)up;

/**
 * 链式语法：向下平移
 * Downward translation
 *
 * @return return value 向下平移的值
 */
- (TABAnimatedArrayFloatBlock)down;

/**
 * 链式语法：设置该动画组件数组所有组件的宽度，设置的是`tabViewWidth`这个属性。
 * Set width
 *
 * @return return value 宽度
 */
- (TABAnimatedArrayFloatBlock)width;

/**
 * 链式语法：设置该动画组件数组所有组件的高度，设置的就是`tabViewHeight`这个属性。
 * Set height
 *
 * @return return value 高度
 */
- (TABAnimatedArrayFloatBlock)height;

/**
 * 链式语法：设置该动画组件数组所有组件的圆角
 * Set animation cornerRadius
 *
 * @return return value 圆角
 */
- (TABAnimatedArrayFloatBlock)radius;

/**
 * 链式语法：减少的宽度：与当前宽度相比，所减少的宽度，负数则增加。
 *
 * @return return value 减少的宽度
 */
- (TABAnimatedArrayFloatBlock)reducedWidth;

/**
 * 链式语法：减少的高度：与当前高度相比，所减少的高度，负数则增加。
 *
 * @return return value 减少的高度
 */
- (TABAnimatedArrayFloatBlock)reducedHeight;

/**
 * 链式语法：设置行数
 * set numberOflines
 *
 * @return return value 设置的行数
 */
- (TABAnimatedArrayIntBlock)line;

/**
 * 链式语法：间距，行数超过1时生效，默认为8.0。
 * set linespace
 *
 * @return return value 间距值
 */
- (TABAnimatedArrayFloatBlock)space;

/**
 * 链式语法：移除该动画组件数组中的所有组件
 * remve the layer
 *
 * @return return value description
 */
- (TABAnimatedArrayBlock)remove;

/**
 * 链式语法：添加占位图，不支持圆角，建议切图使用圆角
 *
 * @return 占位图名称
 */
- (TABAnimatedArrayStringBlock)placeholder;

/**
 * 链式语法：横坐标
 *
 * @return return value 设置横坐标的值
 */
- (TABAnimatedArrayFloatBlock)x;

/**
 * 链式语法：纵坐标
 *
 * @return return value 设置纵坐标的值
 */
- (TABAnimatedArrayFloatBlock)y;

#pragma mark - Drop Animation

/**
 * 链式语法：豆瓣动画变色下标，一起变色的元素，设置同一个下标即可。
 */
- (TABAnimatedArrayIntBlock)dropIndex;

/**
 * 链式语法：适用于多行文本类型动画,
 * 比如设置 dropFromIndex(3), 那么多行动画组中的第一个动画的下标是3，第二个就是4，依次类推。
 */
- (TABAnimatedArrayIntBlock)dropFromIndex;

/**
 * 链式语法：将动画层移出豆瓣动画队列，不参与变色。
 */
- (TABAnimatedArrayBlock)removeOnDrop;

/**
 * 链式语法：豆瓣动画变色停留时间比，默认是0.2。
 */
- (TABAnimatedArrayFloatBlock)dropStayTime;

@end

NS_ASSUME_NONNULL_END
