//
//  TABComponentLayer+TABClassicAnimation.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/4/24.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TABComponentLayer.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TABComponentLayerBaseAnimationType) {
    TABComponentLayerBaseAnimationNone,
    TABComponentLayerBaseAnimationToLong,
    TABComponentLayerBaseAnimationToShort,
};

@interface TABComponentLayer (TABClassicAnimation)

@property (nonatomic, assign) TABComponentLayerBaseAnimationType baseAnimationType;

@end

NS_ASSUME_NONNULL_END
