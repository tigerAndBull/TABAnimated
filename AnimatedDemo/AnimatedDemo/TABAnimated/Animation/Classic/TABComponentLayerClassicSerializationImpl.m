//
//  TABComponentLayerClassicSerializationImpl.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/5/24.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "TABComponentLayerClassicSerializationImpl.h"
#import "TABComponentLayer+TABClassicAnimation.h"
#import "TABComponentLayerSerializationInterface.h"

@implementation TABComponentLayerClassicSerializationImpl

- (void)propertyBindWithNewLayer:(TABComponentLayer *)newLayer oldLayer:(TABComponentLayer *)oldLayer {
    newLayer.baseAnimationType = oldLayer.baseAnimationType;
}

- (void)tab_encodeWithCoder:(NSCoder *)aCoder layer:(TABComponentLayer *)layer {
    [aCoder encodeInteger:layer.baseAnimationType forKey:@"baseAnimationType"];
}

- (id)tab_initWithCoder:(NSCoder *)aDecoder layer:(TABComponentLayer *)layer {
    layer.baseAnimationType = [aDecoder decodeIntegerForKey:@"baseAnimationType"];
    return layer;
}

@end
