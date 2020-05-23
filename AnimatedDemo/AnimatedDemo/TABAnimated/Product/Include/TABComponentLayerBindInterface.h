//
//  TABComponentLayerBindInterface.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/5/24.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#ifndef TABComponentLayerBindInterface_h
#define TABComponentLayerBindInterface_h

@class TABComponentLayer;

@protocol TABComponentLayerBindInterface <NSObject>

- (void)propertyBindWithNewLayer:(TABComponentLayer *)newLayer
                        oldLayer:(TABComponentLayer *)oldLayer;

@end

#endif /* TABComponentLayerBindInterface_h */
