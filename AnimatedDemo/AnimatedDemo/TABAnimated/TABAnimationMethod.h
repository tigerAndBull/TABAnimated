//
//  TABAnimationMethod.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/12/28.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+TABAnimated.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Methods in the file are about to animation type.
 **/
@interface TABAnimationMethod : NSObject

//修改  xiaoxin  增加轮播变色 动画  计时器 xiaoxin
@property (nonatomic,strong)dispatch_source_t timer;

- (void)addChangeColorAnimationWith:(NSArray<TABComponentLayer *>*)layerArr Duration:(CGFloat)duration
                                key:(NSString *)key;
- (void)destoryTimer;

+ (CABasicAnimation *)scaleXAnimationDuration:(CGFloat)duration
                                      toValue:(CGFloat)toValue;

+ (void)addShimmerAnimationToView:(UIView *)view
                         duration:(CGFloat)duration
                              key:(NSString *)key;

+ (void)addAlphaAnimation:(UIView *)view
                 duration:(CGFloat)duration
                      key:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
