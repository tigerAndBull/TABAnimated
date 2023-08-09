//
//  NSArray+DropAnimation.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/3/14.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TABAnimatedChainDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (TABDropAnimation)

/**
 * 豆瓣动画变色下标，一起变色的元素，设置同一个下标即可。
 *
 * @return 目标动画元素数组
 */
- (TABAnimatedArrayIntBlock)dropIndex;

/**
 * 适用于多行的动画元素,
 * 比如设置 dropFromIndex(3), 那么多行动画组中的第一个动画的下标是3，第二个就是4，依次类推。
 *
 * @return 目标动画元素数组
 */
- (TABAnimatedArrayIntBlock)dropFromIndex;

/**
 * 将动画层移出豆瓣动画队列，不参与变色。
 *
 * @return 目标动画元素数组
 */
- (TABAnimatedArrayBlock)removeOnDrop;

/**
 * 豆瓣动画变色停留时间比，默认是0.2。
 *
 * @return 目标动画元素数组
 */
- (TABAnimatedArrayFloatBlock)dropStayTime;

@end

NS_ASSUME_NONNULL_END
