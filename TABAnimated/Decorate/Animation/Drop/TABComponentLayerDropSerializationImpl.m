//
//  TABComponentLayerDropSerializationImpl.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/5/24.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "TABComponentLayerDropSerializationImpl.h"
#import "TABComponentLayer.h"
#import "TABComponentLayer+TABDropAnimation.h"
#import "TABComponentLayerSerializationInterface.h"

@implementation TABComponentLayerDropSerializationImpl

- (void)propertyBindWithNewLayer:(TABComponentLayer *)newLayer oldLayer:(TABComponentLayer *)oldLayer {
    newLayer.dropAnimationIndex = oldLayer.dropAnimationIndex;
    newLayer.dropAnimationStayTime = oldLayer.dropAnimationStayTime;
    newLayer.dropAnimationFromIndex = oldLayer.dropAnimationFromIndex;
    newLayer.removeOnDropAnimation = oldLayer.removeOnDropAnimation;
}

- (void)tab_encodeWithCoder:(NSCoder *)aCoder layer:(TABComponentLayer *)layer {
    [aCoder encodeInteger:layer.dropAnimationFromIndex forKey:@"dropAnimationFromIndex"];
    [aCoder encodeInteger:layer.dropAnimationIndex forKey:@"dropAnimationIndex"];
    [aCoder encodeFloat:layer.dropAnimationStayTime forKey:@"dropAnimationStayTime"];
    [aCoder encodeBool:layer.removeOnDropAnimation forKey:@"removeOnDropAnimation"];
}

- (id)tab_initWithCoder:(NSCoder *)aDecoder layer:(TABComponentLayer *)layer {
    layer.dropAnimationFromIndex = [aDecoder decodeIntForKey:@"dropAnimationFromIndex"];
    layer.dropAnimationIndex = [aDecoder decodeIntForKey:@"dropAnimationIndex"];
    layer.dropAnimationStayTime = [aDecoder decodeFloatForKey:@"dropAnimationStayTime"];
    layer.removeOnDropAnimation = [aDecoder decodeBoolForKey:@"removeOnDropAnimation"];
    return layer;
}

@end
