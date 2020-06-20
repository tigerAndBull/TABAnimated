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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TABComponentLayerSerializationInterface;

@interface TABComponentLayer : CAGradientLayer <NSCopying, NSSecureCoding>

typedef NS_ENUM(NSInteger, TABViewLoadAnimationStyle) {
    
    // 默认
    TABViewLoadAnimationDefault = 0,
    
    // 标记移除，不显示
    TABViewLoadAnimationRemove,
};

typedef NS_ENUM(NSInteger, TABComponentLayerOrigin) {
    
    // 来自UIView、UILabel
    TABComponentLayerOriginViewOrLabel = 0,
    
    // 来自UIImageView
    TABComponentLayerOriginImageView,
    
    // 来自UIButton
    TABComponentLayerOriginButton,
    
    // 来自居中的UILabel
    TABComponentLayerOriginCenterLabel,
    
    // 来自多行的UILabel
    TABComponentLayerOriginLinesLabel,
};

#pragma mark - 属性

/**
 * 如果控制视图开启的动画，那么该控制视图下的所有subViews将被设置为`TABViewLoadAnimationWithOnlySkeleton`
 */
@property (nonatomic, assign) TABViewLoadAnimationStyle loadStyle;

/**
 * 动画元素来源的视图类型枚举
 */
@property (nonatomic, assign) TABComponentLayerOrigin origin;

/**
 * 该动画元素所处的index
 */
@property (nonatomic, assign) NSInteger tagIndex;

#pragma mark - 配置成多行的动画元素

/**
 * 此属性的值是根据UILabel组件的numberOflines属性的值映射出来的。
 * 由其他类型组件映射出的动画元素，该属性会被设置为1，你可以对其更改，达到多行的效果。
 */
@property (nonatomic, assign) NSInteger numberOflines;

/**
 * 对于`numberOflines` > 1的动画元素，设置行与行之间的间距，默认是8.0。
 */
@property (nonatomic, assign) CGFloat lineSpace;

/**
 * 对于`numberOflines` > 1的动画元素，设置最后一行的宽度比例，默认是0.5，即原宽度的一半。
 */
@property (nonatomic, assign) CGFloat lastScale;

/**
 * 该动画元素最终的frame
 */
@property (nonatomic, strong) NSValue *resultFrameValue;

/**
 * 该动画元素显示的图片名
 */
@property (nonatomic, copy) NSString *placeholderName;

/**
 * 是否将该元素从动画队列中移除
 */
@property (nonatomic, assign) BOOL withoutAnimation;

/**
 * 调整后需要同步的frame
 */
@property (nonatomic, assign) CGRect adjustingFrame;

/**
 * 是否调整过高度
 */
@property (nonatomic, assign) BOOL isChangedHeight;

/**
 * 多行layers
 */
@property (nonatomic, strong) NSMutableArray <TABComponentLayer *> *lineLayers;

/**
 * 序列化协议
 */
@property (nonatomic, strong) id <TABComponentLayerSerializationInterface> serializationImpl;

- (CGRect)resetFrameWithRect:(CGRect)rect animatedHeight:(CGFloat)animatedHeight;
- (void)addLayer:(TABComponentLayer *)layer viewWidth:(CGFloat)viewWidth animatedHeight:(CGFloat)animatedHeight;
    
@end

NS_ASSUME_NONNULL_END
