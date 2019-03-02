//
//  TABViewAnimated+ManagerCALayer.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/12/28.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "TABManagerMethod.h"

NS_ASSUME_NONNULL_BEGIN

@interface TABManagerMethod (ManagerCALayer)

+ (void)initLayerWithView:(UIView *)view
            withSuperView:(UIView *)superView
                withColor:(UIColor *)color;

+ (void)removeAllTABLayersFromView:(UIView *)view;

+ (void)removeMask:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
