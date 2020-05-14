//
//  TABBackgroundLayer.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/5/15.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TABBackgroundLayer : CAGradientLayer <NSCopying, NSSecureCoding>

@property (nonatomic, strong) CALayer *shadowLayer;

@end

NS_ASSUME_NONNULL_END
