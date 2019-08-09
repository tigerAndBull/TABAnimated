//
//  TABComponentLayer.h
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
//  Created by tigerAndBull on 2019/4/26.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface TABComponentLayer : CAGradientLayer

/**
 * 如果控制视图开启的动画，那么该控制视图下的所有subViews将被设置为`TABViewLoadAnimationWithOnlySkeleton`
 * You can set it to `TABViewLoadAnimationRemove` for canceling adding it to the animation queue.
 * When the control view starts animation, all subViews' `loadStyle` onto the control view will be setted
 * to `TABViewLoadAnimationWithOnlySkeleton`

 * - TABViewLoadAnimationWithOnlySkeleton: add to the animation queue
 * - TABViewLoadAnimationToLong: add the long animation
 * - TABViewLoadAnimationToShort: add the short animation
 * - TABViewLoadAnimationRemove: remove frome the animation queue
 */
typedef NS_ENUM(NSInteger,TABViewLoadAnimationStyle) {
    TABViewLoadAnimationWithOnlySkeleton,
    TABViewLoadAnimationToLong,
    TABViewLoadAnimationToShort,
    TABViewLoadAnimationRemove,
};

#pragma mark - 属性

/**
 * 如果控制视图开启的动画，那么该控制视图下的所有subViews将被设置为`TABViewLoadAnimationWithOnlySkeleton`
 * You can set it to `TABViewLoadAnimationRemove` for canceling adding it to the animation queue.
 * When the control view starts animation, all subViews' `loadStyle` onto the control view will be setted
 * to `TABViewLoadAnimationWithOnlySkeleton`
 */
@property (nonatomic,assign) TABViewLoadAnimationStyle loadStyle;

/**
 * 动画元素来自居中文本
 * Is from the UILabel of `NSTextAligentCenter`or not.
 */
@property (nonatomic,assign) BOOL fromCenterLabel;

/**
 * 动画元素来自居中文本,取消居中显示
 * If it is from the UILabel of `NSTextAligentCenter`,canceling show in center.
 */
@property (nonatomic,assign) BOOL isCancelAlignCenter;

/**
 * 动画来自UIImageView。
 * Is from UIImageView or not.
 */
@property (nonatomic,assign) BOOL fromImageView;

/**
 * 动画时组件高度，
 * 如果你觉得动画不够漂亮，可以使用这个属性进行调整。
 * Height of the animation appionted by yourself on subViews.
 * If the animation of the view is not beautiful, you can use it.
 */
@property (nonatomic,assign) CGFloat tabViewHeight;

#pragma mark - 一个组件映射多个动画元素

/**
 * 此属性的值是根据UILabel组件的numberOflines属性的值映射出来的。
 * 由其他类型组件映射出的动画元素，该属性会被设置为1，你可以对其更改，达到多行的效果。
 * Everyone can set it to more, then it will have the same effect as the UILabel which `numberOfLines` > 1.
 */
@property (nonatomic,assign) NSInteger numberOflines;

/**
 * 对于`numberOflines` > 1的动画元素，设置行与行之间的间距，默认是8.0。
 * If numberOflines > 1, the property is used to setting the space of lines.
 */
@property (nonatomic,assign) CGFloat lineSpace;

/**
 * 对于`numberOflines` > 1的动画元素，设置最后一行的宽度比例，默认是0.5，即原宽度的一半。
 */
@property (nonatomic,assign) CGFloat lastScale;

#pragma mark - Only used to drop animation

/**
 * 该动画元素在豆瓣动画队列中的下标
 */
@property (nonatomic,assign) NSInteger dropAnimationIndex;

/**
 * 对于多行的动画元素，在豆瓣动画队列中，设置它的起点下标
 */
@property (nonatomic,assign) NSInteger dropAnimationFromIndex;

/**
 * 是否将该元素从豆瓣动画队列中移除
 */
@property (nonatomic,assign) BOOL removeOnDropAnimation;

/**
 * 豆瓣动画间隔时间，默认0.2。
 */
@property (nonatomic,assign) CGFloat dropAnimationStayTime;

@end

NS_ASSUME_NONNULL_END
