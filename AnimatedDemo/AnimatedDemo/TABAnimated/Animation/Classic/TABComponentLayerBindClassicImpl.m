//
//  TABComponentLayerBindClassicImpl.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/5/24.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "TABComponentLayerBindClassicImpl.h"
#import "TABComponentLayerBindInterface.h"
#import "TABComponentLayer.h"
#import "TABComponentLayer+TABClassicAnimation.h"

@implementation TABComponentLayerBindClassicImpl

- (void)propertyBindWithNewLayer:(TABComponentLayer *)newLayer
                        oldLayer:(TABComponentLayer *)oldLayer {
    newLayer.baseAnimationType = oldLayer.baseAnimationType;
}

@end
