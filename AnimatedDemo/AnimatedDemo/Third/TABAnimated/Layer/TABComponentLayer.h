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
 如果控制视图开启的动画，那么该控制视图下的所有subViews将被设置为`TABViewLoadAnimationWithOnlySkeleton`
 You can set it to `TABViewLoadAnimationRemove` for canceling adding it to the animation queue.
 When the control view starts animation, all subViews' `loadStyle` onto the control view will be setted
 to `TABViewLoadAnimationWithOnlySkeleton`

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
 如果控制视图开启的动画，那么该控制视图下的所有subViews将被设置为`TABViewLoadAnimationWithOnlySkeleton`
 You can set it to `TABViewLoadAnimationRemove` for canceling adding it to the animation queue.
 When the control view starts animation, all subViews' `loadStyle` onto the control view will be setted
 to `TABViewLoadAnimationWithOnlySkeleton`
 */
@property (nonatomic,assign) TABViewLoadAnimationStyle loadStyle;

/**
 动画元素来自居中文本
 is from the UILabel of `NSTextAligentCenter`or not
 */
@property (nonatomic,assign) BOOL fromCenterLabel;

/**
 动画元素来自居中文本,取消居中显示
 If it is from the UILabel of `NSTextAligentCenter`,canceling show in center.
 */
@property (nonatomic,assign) BOOL isCancelAlignCenter;

/**
 动画来自UIImageView。
 is from UIImageView or not
 */
@property (nonatomic,assign) BOOL fromImageView;

/**
 动画时组件宽度，
 如果你觉得动画不够漂亮，可以使用这个属性进行调整
 Width of the animation appionted by yourself on subViews during animating.
 */
@property (nonatomic,assign) CGFloat tabViewWidth;

/**
 动画时组件高度，
 如果你觉得动画不够漂亮，可以使用这个属性进行调整。
 Height of the animation appionted by yourself on subViews.
 If the animation of the view is not beautiful, you can use it.
 */
@property (nonatomic,assign) CGFloat tabViewHeight;

#pragma mark - 一个组件映射多个动画元素

/**
 此属性的值是根据UILabel组件的numberOflines属性的值映射出来的。
 由其他类型组件映射出的动画元素，该属性会被设置为1，你可以对其更改，达到多行的效果。
 everyone can set it to more, then it will have the same effect as the UILabel which `numberOfLines` > 1.
 */
@property (nonatomic,assign) NSInteger numberOflines;

/**
 对于`numberOflines` > 1的动画元素，设置行与行之间的间距，默认是8.0。
 if numberOflines > 1, the property is used to setting the space of lines.
 */
@property (nonatomic,assign) CGFloat lineSpace;

/**
 对于`numberOflines` > 1的动画元素，设置最后一行的宽度比例，默认是0.5，即原宽度的一半。
 */
@property (nonatomic,assign) CGFloat lastScale;

#pragma mark - Only used to drop animation

/**
 该动画元素在豆瓣动画队列中的下标
 */
@property (nonatomic,assign) NSInteger dropAnimationIndex;

/**
 对于多行的动画元素，在豆瓣动画队列中，设置它的起点下标
 */
@property (nonatomic,assign) NSInteger dropAnimationFromIndex;

/**
 是否将该元素从豆瓣动画队列中移除
 */
@property (nonatomic,assign) BOOL removeOnDropAnimation;

/**
 豆瓣动画间隔时间，默认0.2。
 */
@property (nonatomic,assign) CGFloat dropAnimationStayTime;

#pragma mark - 链式语法

/**
 向左平移
 Translation to the left
 
 @return return value 向左平移的值
 */
- (TABComponentLayerBlock)left;

/**
 向右平移
 Translation to the right
 
 @return return value 向右平移的值
 */
- (TABComponentLayerBlock)right;

/**
 向上平移
 Upward translation
 
 @return return value 向上平移的值
 */
- (TABComponentLayerBlock)up;

/**
 向下平移
 Downward translation
 
 @return return value 向下平移的值
 */
- (TABComponentLayerBlock)down;

/**
 设置该动画组件的宽度，设置的是`tabViewWidth`这个属性
 set width
 
 @return return value 宽度
 */
- (TABComponentLayerBlock)width;

/**
 设置该动画组件的高度，设置的就是`tabViewHeight`这个属性
 set height
 
 @return return value 高度
 */
- (TABComponentLayerBlock)height;


/**
 设置该动画组件的圆角

 @return return value 圆角
 */
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
 设置动画组件的行数
 set numberOflines
 
 @return return value 设置的行数
 */
- (TABComponentLayerLinesBlock)line;

/**
 间距，行数超过1时生效，默认为8.0。
 set linespace
 
 @return return value 间距值
 */
- (TABComponentLayerBlock)space;

/**
 对于`numberOflines` > 1的动画元素，设置最后一行的宽度比例，默认是0.5，即原宽度的一半。

 @return return value 最后一行的宽度比例
 */
- (TABComponentLayerBlock)lastLineScale;

/**
 从骨架层中移除
 remve the layer
 
 @return return value description
 */
- (TABLoadStyleBlock)remove;

/**
 赋予该动画组件画由长到短的动画
 add the long animation to the layer
 */
- (TABLoadStyleBlock)toLongAnimation;

/**
 赋予该动画组件画由短到长的动画
 add the short animation to the layer
 */
- (TABLoadStyleBlock)toShortAnimation;

/**
 动画来自居中文本，设置后取消居中显示
 If it is from the UILabel of `NSTextAligentCenter`,canceling show in center.
 */
- (TABLoadStyleBlock)cancelAlignCenter;

/**
 豆瓣动画变色下标，一起变色的元素，设置同一个下标即可。
 */
- (TABComponentLayerLinesBlock)dropIndex;

/**
 适用于多行的动画组件,
 比如设置 dropFromIndex(3), 那么多行动画组中的第一行的下标是3，第二行就是4，依次类推。
 */
- (TABComponentLayerLinesBlock)dropFromIndex;

/**
 将动画层移出豆瓣动画队列，不参与变色。
 */
- (TABLoadStyleBlock)removeOnDrop;

/**
 豆瓣动画变色停留时间比，默认是0.2。
 */
- (TABComponentLayerBlock)dropStayTime;

@end

NS_ASSUME_NONNULL_END
