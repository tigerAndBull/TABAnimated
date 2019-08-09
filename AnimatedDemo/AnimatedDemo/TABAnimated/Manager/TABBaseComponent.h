//
//  TABBaseComponent.h
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

@class TABComponentLayer;

@interface TABBaseComponent : NSObject

typedef TABBaseComponent * _Nullable (^TABBaseComponentVoidBlock)(void);
typedef TABBaseComponent * _Nullable (^TABBaseComponentIntegerBlock)(NSInteger);
typedef TABBaseComponent * _Nullable (^TABBaseComponentFloatBlock)(CGFloat);
typedef TABBaseComponent * _Nullable (^TABBaseComponentStringBlock)(NSString *);
typedef TABBaseComponent * _Nullable (^TABBaseComponentColorBlock)(UIColor *);

#pragma mark - 基础属性

/**
 * 向左平移
 * Translation to the left
 *
 * @return return value 向左平移的值
 */
- (TABBaseComponentFloatBlock)left;

/**
 * 向右平移
 * Translation to the right
 *
 * @return return value 向右平移的值
 */
- (TABBaseComponentFloatBlock)right;

/**
 * 向上平移
 * Upward translation
 *
 * @return return value 向上平移的值
 */
- (TABBaseComponentFloatBlock)up;

/**
 * 向下平移
 * Downward translation
 *
 * @return return value 向下平移的值
 */
- (TABBaseComponentFloatBlock)down;

/**
 * 设置动画组件的宽度
 * Set width
 *
 * @return return value 宽度
 */
- (TABBaseComponentFloatBlock)width;

/**
 * 设置动画组件的高度
 * Set height
 *
 * @return return value 高度
 */
- (TABBaseComponentFloatBlock)height;

/**
 * 设置动画组件的圆角
 *
 * @return return value 圆角
 */
- (TABBaseComponentFloatBlock)radius;

/**
 * 需要减少的宽度：与当前宽度相比，所减少的宽度
 * 负数则为增加
 *
 * @return return value 减少的宽度
 */
- (TABBaseComponentFloatBlock)reducedWidth;

/**
 * 减少的高度：与当前高度相比，所减少的高度
 * 负数则为增加
 *
 * @return return value 减少的高度
 */
- (TABBaseComponentFloatBlock)reducedHeight;

/**
 * 减少的圆角
 *
 * @return return value 减少的圆角值
 */
- (TABBaseComponentFloatBlock)reducedRadius;

/**
 * 横坐标
 *
 * @return return value 设置横坐标的值
 */
- (TABBaseComponentFloatBlock)x;

/**
 * 纵坐标
 *
 * @return return value 设置纵坐标的值
 */
- (TABBaseComponentFloatBlock)y;

/**
 * 设置动画组件的行数
 * Set numberOflines
 *
 * @return return value 设置的行数
 */
- (TABBaseComponentIntegerBlock)line;

/**
 * 设置多行动画组件的间距，即行数超过1时生效，默认为8.0。
 * Set linespace
 *
 * @return return value 间距值
 */
- (TABBaseComponentFloatBlock)space;

/**
 * 对于`行数` > 1的动画元素，设置最后一行的宽度比例，默认是0.5，即原宽度的一半。
 *
 * @return return value 最后一行的宽度比例
 */
- (TABBaseComponentFloatBlock)lastLineScale;

/**
 * 从动画组中移除
 * Remve the layer
 *
 * @return return value description
 */
- (TABBaseComponentVoidBlock)remove;

/**
 * 添加占位图，不支持圆角，建议切图使用圆角
 *
 * @return 占位图名称
 */
- (TABBaseComponentStringBlock)placeholder;

/**
 * 赋予动画组件画由长到短的动画
 * Add the long animation to the layer
 */
- (TABBaseComponentVoidBlock)toLongAnimation;

/**
 * 赋予动画组件画由短到长的动画
 * Add the short animation to the layer
 */
- (TABBaseComponentVoidBlock)toShortAnimation;

/**
 * 如果动画组件来自居中文本，设置后取消居中显示，
 * If it is from the UILabel of `NSTextAligentCenter`,canceling show in center.
 */
- (TABBaseComponentVoidBlock)cancelAlignCenter;

/**
 * 设置动画组件颜色
 *
 * @return return value UIColor对象
 */
- (TABBaseComponentColorBlock)color;

//- (TABBaseComponentStringBlock)fill;

#pragma mark - 豆瓣动画需要用到的属性

/**
 * 豆瓣动画 - 变色下标，一起变色的元素，设置同一个下标即可。
 */
- (TABBaseComponentIntegerBlock)dropIndex;

/**
 * 豆瓣动画 - 用于多行的动画组件,
 * 比如设置 dropFromIndex(3), 那么多行动画组中的第一行的下标是3，第二行就是4，依次类推。
 */
- (TABBaseComponentIntegerBlock)dropFromIndex;

/**
 * 豆瓣动画 - 将动画层移出豆瓣动画队列，不参与变色。
 */
- (TABBaseComponentVoidBlock)removeOnDrop;

/**
 * 豆瓣动画 - 豆瓣动画变色停留时间比，默认是0.2。
 */
- (TABBaseComponentFloatBlock)dropStayTime;

+ (instancetype)initWithComponentLayer:(TABComponentLayer *)layer;

@property (nonatomic,strong,readonly) TABComponentLayer *layer;

@end

NS_ASSUME_NONNULL_END
