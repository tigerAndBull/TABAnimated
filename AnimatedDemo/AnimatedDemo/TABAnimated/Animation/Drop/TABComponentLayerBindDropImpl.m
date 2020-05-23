//
//  TABComponentLayerBindDropImpl.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/5/24.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "TABComponentLayerBindDropImpl.h"

#import "TABComponentLayerBindInterface.h"
#import "TABComponentLayer+TABDropAnimation.h"

@implementation TABComponentLayerBindDropImpl

- (void)propertyBindWithNewLayer:(TABComponentLayer *)newLayer
                        oldLayer:(TABComponentLayer *)oldLayer {
    newLayer.dropAnimationIndex = oldLayer.dropAnimationIndex;
    newLayer.dropAnimationStayTime = oldLayer.dropAnimationStayTime;
    newLayer.dropAnimationFromIndex = oldLayer.dropAnimationFromIndex;
    newLayer.removeOnDropAnimation = oldLayer.removeOnDropAnimation;
}

@end
