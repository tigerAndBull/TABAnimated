//
//  TABClassicAnimation.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/5/4.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TABClassicAnimation : NSObject

/**
 * 来回时长
 */
@property (nonatomic, assign) CGFloat duration;

/**
 * 变长伸缩比例
 */
@property (nonatomic, assign) CGFloat longToValue;

/**
 * 变短伸缩比例
 */
@property (nonatomic, assign) CGFloat shortToValue;

@end

NS_ASSUME_NONNULL_END
