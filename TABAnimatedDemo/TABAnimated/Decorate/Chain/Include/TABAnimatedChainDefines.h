//
//  TABAnimatedChainDefines.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/4/19.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#ifndef TABAnimatedChainDefines_h
#define TABAnimatedChainDefines_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TABBaseComponent, TABComponentManager;

typedef void(^TABAdjustBlock)(TABComponentManager * _Nonnull manager);
typedef void(^TABAdjustWithClassBlock)(TABComponentManager * _Nonnull manager, Class _Nullable targetClass);

typedef NSArray <TABBaseComponent *> * _Nullable (^TABAnimatedArrayFloatBlock)(CGFloat);
typedef NSArray <TABBaseComponent *> * _Nullable (^TABAnimatedArrayIntBlock)(NSInteger);
typedef NSArray <TABBaseComponent *> * _Nullable (^TABAnimatedArrayBlock)(void);
typedef NSArray <TABBaseComponent *> * _Nullable (^TABAnimatedArrayStringBlock)(NSString * _Nonnull);
typedef NSArray <TABBaseComponent *> * _Nullable (^TABAnimatedArrayColorBlock)(UIColor * _Nonnull);

typedef TABBaseComponent * _Nullable (^TABBaseComponentVoidBlock)(void);
typedef TABBaseComponent * _Nullable (^TABBaseComponentIntegerBlock)(NSInteger);
typedef TABBaseComponent * _Nullable (^TABBaseComponentFloatBlock)(CGFloat);
typedef TABBaseComponent * _Nullable (^TABBaseComponentStringBlock)(NSString * _Nonnull);
typedef TABBaseComponent * _Nullable (^TABBaseComponentColorBlock)(UIColor * _Nonnull);

typedef TABBaseComponent * _Nullable (^TABBaseComponentBlock)(NSInteger);
typedef NSArray <TABBaseComponent *> * _Nullable (^TABBaseComponentArrayBlock)(NSInteger location, NSInteger length);
typedef NSArray <TABBaseComponent *> * _Nullable (^TABBaseComponentArrayWithIndexsBlock)(NSInteger index, ...);

#endif /* TABAnimatedChainDefines_h */
