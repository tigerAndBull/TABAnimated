//
//  TABComponentLayerSerializationInterface.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/5/24.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#ifndef TABComponentLayerSerializationInterface_h
#define TABComponentLayerSerializationInterface_h

@class NSCoder, TABComponentLayer;

@protocol TABComponentLayerSerializationInterface <NSObject>

- (void)propertyBindWithNewLayer:(TABComponentLayer *)newLayer oldLayer:(TABComponentLayer *)oldLayer;

- (void)tab_encodeWithCoder:(NSCoder *)aCoder layer:(TABComponentLayer *)layer;
- (id)tab_initWithCoder:(NSCoder *)aDecoder layer:(TABComponentLayer *)layer;

@end

#endif /* TABComponentLayerSerializationInterface_h */
