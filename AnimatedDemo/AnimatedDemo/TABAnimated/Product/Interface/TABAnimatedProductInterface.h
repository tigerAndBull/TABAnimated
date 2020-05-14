//
//  TABAnimatedProductInterface.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/4/1.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#ifndef TABAnimatedProductInterface_h
#define TABAnimatedProductInterface_h

#import "TABAnimatedProductDefines.h"

@protocol TABAnimatedProductInterface <NSObject>

// 生产view并加工骨架元素
- (nonnull __kindof UIView *)productWithControlView:(nonnull UIView *)controlView
                                       currentClass:(nonnull Class)currentClass
                                          indexPath:(nullable NSIndexPath *)indexPath
                                             origin:(TABAnimatedProductOrigin)origin;
// 加工骨架元素
- (void)productWithView:(nonnull UIView *)view
            controlView:(nonnull UIView *)controlView
           currentClass:(nonnull Class)currentClass
              indexPath:(nullable NSIndexPath *)indexPath
                 origin:(TABAnimatedProductOrigin)origin;

- (void)syncProductions;

- (void)destory;

@end

#endif /* TABAnimatedProductInterface_h */
