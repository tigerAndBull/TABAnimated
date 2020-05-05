//
//  TABConfigLayer.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/5/4.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    TABConfigLayerOriginCell,
    TABConfigLayerOriginCellContentView,
} TABConfigLayerOrigin;

@interface TABConfigLayer : CALayer

@property (nonatomic, assign) TABConfigLayerOrigin origin;

@end

NS_ASSUME_NONNULL_END
