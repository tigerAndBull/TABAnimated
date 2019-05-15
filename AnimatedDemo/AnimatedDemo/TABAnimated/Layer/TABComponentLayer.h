//
//  TABComponentLayer.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/4/26.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface TABComponentLayer : CALayer

/**
 You can set it to `TABViewLoadAnimationRemove` for canceling adding it to the animation queue.
 When the control view starts animation, all subViews' `loadStyle` onto the control view will be setted
 to `TABViewLoadAnimationWithOnlySkeleton`
 如果控制视图开启的动画，那么该控制视图下的所有subViews将被设置为`TABViewLoadAnimationWithOnlySkeleton`

 - TABViewLoadAnimationWithOnlySkeleton: add to the animation queue
 - TABViewLoadAnimationToLong: add the long animation
 - TABViewLoadAnimationToShort: add the short animation
 - TABViewLoadAnimationRemove: remove frome the animation queue
 */
typedef NS_ENUM(NSInteger,TABViewLoadAnimationStyle) {
    TABViewLoadAnimationWithOnlySkeleton,
    TABViewLoadAnimationToLong,
    TABViewLoadAnimationToShort,
    TABViewLoadAnimationRemove
};

typedef TABComponentLayer *_Nullable(^TABComponentLayerBlock)(CGFloat);
typedef TABComponentLayer *_Nullable(^TABComponentLayerLinesBlock)(NSInteger);
typedef TABComponentLayer *_Nullable(^TABLoadStyleBlock)(void);

/**
 You can set it to `TABViewLoadAnimationRemove` for canceling adding it to the animation queue.
 When the control view starts animation, all subViews' `loadStyle` onto the control view will be setted
 to `TABViewLoadAnimationWithOnlySkeleton`
 如果控制视图开启的动画，那么该控制视图下的所有subViews将被设置为`TABViewLoadAnimationWithOnlySkeleton`
 */
@property (nonatomic,assign) TABViewLoadAnimationStyle loadStyle;

/**
 is from the UILabel of `NSTextAligentCenter`or not
 动画来自居中文本
 */
@property (nonatomic,assign) BOOL fromCenterLabel;

/**
 If it is from the UILabel of `NSTextAligentCenter`,canceling show in center.
 动画来自居中文本,取消居中显示
 */
@property (nonatomic,assign) BOOL isCancelAlignCenter;

/**
 is from UIImageView or not
 动画来自UIImageView
 */
@property (nonatomic,assign) BOOL fromImageView;

/**
 Width of the animation appionted by yourself on subViews during animating.
 动画时组件宽度
 如果你觉得动画不够漂亮，可以使用这个属性进行调整
 */
@property (nonatomic,assign) CGFloat tabViewWidth;

/**
 Height of the animation appionted by yourself on subViews.
 If the animation of the view is not beautiful, you can use it.
 动画时组件高度
 如果你觉得动画不够漂亮，可以使用这个属性进行调整
 */
@property (nonatomic,assign) CGFloat tabViewHeight;

#pragma mark - 一个组件映射多个动画元素

/**
 everyone can set it to more, then it will have the same effect as the UILabel which `numberOfLines` > 1.
 此属性可以根据UILabel组件的numberOflines属性进行调整
 其他类型组件会被设置为1，你可以对其更改，达到和多行文本一样的效果
 当然，你可以在预处理动画的时候更改此属性，对于每一个`TABComponentLayer`都会生效
 */
@property (nonatomic,assign) NSInteger numberOflines;

/**
 if numberOflines > 1, the property is used to setting the space of lines.
 对于numberOflines > 1，每一行的间距，默认是8.0。
 */
@property (nonatomic,assign) CGFloat lineSpace;

@property (nonatomic,assign) CGFloat lastScale;

@property (nonatomic,assign) NSInteger dropAnimationFromIndex;

#pragma mark - Only used to drop animation

@property (nonatomic,assign) NSInteger dropAnimationIndex;

@property (nonatomic,assign) BOOL removeOnDropAnimation;

/**
 默认0.2
 */
@property (nonatomic,assign) CGFloat dropAnimationStayTime;

#pragma mark - 链式语法

/**
 Translation to the left
 向左平移
 
 @return return value 向左平移的值
 */
- (TABComponentLayerBlock)left;

/**
 Translation to the right
 向右平移
 
 @return return value 向右平移的值
 */
- (TABComponentLayerBlock)right;

/**
 Upward translation
 向上平移
 
 @return return value 向上平移的值
 */
- (TABComponentLayerBlock)up;

/**
 Downward translation
 向下平移
 
 @return return value 向下平移的值
 */
- (TABComponentLayerBlock)down;

/**
 set width
 设置该动画组件的宽度，设置的是`tabViewWidth`这个属性
 @return return value 宽度
 */
- (TABComponentLayerBlock)width;

/**
 set height
 
 设置该动画组件的高度，设置的就是`tabViewHeight`这个属性
 @return return value 高度
 */
- (TABComponentLayerBlock)height;

- (TABComponentLayerBlock)radius;

/**
 减少的宽度，与当前宽度相比，所减少的宽度
 负数则为增加
 
 @return return value 减少的宽度
 */
- (TABComponentLayerBlock)reducedWidth;

/**
 减少的高度，与当前高度相比，所减少的高度
 负数则为增加
 
 @return return value 减少的高度
 */
- (TABComponentLayerBlock)reducedHeight;

/**
 set numberOflines
 行数
 
 @return return value 设置的行数
 */
- (TABComponentLayerLinesBlock)line;

/**
 set linespace
 间距，行数超过1时生效
 
 @return return value 间距值
 */
- (TABComponentLayerBlock)space;

- (TABComponentLayerBlock)lastLineScale;

/**
 remve the layer
 移除该动画组件
 
 @return return value description
 */
- (TABLoadStyleBlock)remove;

/**
 add the long animation to the layer
 赋予该动画组件画由长到短的动画
 */
- (TABLoadStyleBlock)toLongAnimation;

/**
 add the short animation to the layer
 赋予该动画组件画由短到长的动画
 */
- (TABLoadStyleBlock)toShortAnimation;

/**
 If it is from the UILabel of `NSTextAligentCenter`,canceling show in center.
 动画来自居中文本，取消居中显示
 */
- (TABLoadStyleBlock)cancelAlignCenter;

/**
 豆瓣动画变色下标，一起变色的元素，设置同一个下标即可
 */
- (TABComponentLayerLinesBlock)dropIndex;

/**
 适用于多行文本类型动画,
 比如设置 dropFromIndex(3), 那么多行动画组中的第一个动画的下标是3，第二个就是4
 */
- (TABComponentLayerLinesBlock)dropFromIndex;

/**
 将动画层移出豆瓣动画队列，不参与变色
 */
- (TABLoadStyleBlock)removeOnDrop;

/**
 豆瓣动画变色停留时间比，默认是0.2
 */
- (TABComponentLayerBlock)dropStayTime;

@end

NS_ASSUME_NONNULL_END
