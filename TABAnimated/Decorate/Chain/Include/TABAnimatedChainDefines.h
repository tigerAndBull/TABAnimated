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

typedef TABBaseComponent * _Nullable (^TABBaseComponentBlock)(NSInteger);
typedef void(^TABAdjustBlock)(TABComponentManager * _Nonnull manager);
typedef void(^TABAdjustWithClassBlock)(TABComponentManager * _Nonnull manager, Class _Nullable targetClass);

typedef void(^TABRecommendHeightBlock)(Class _Nullable targetClass, CGFloat recommendHeight);

typedef TABBaseComponent * _Nullable (^TABBaseComponentVoidBlock)(void);
typedef TABBaseComponent * _Nullable (^TABBaseComponentIntegerBlock)(NSInteger);
typedef TABBaseComponent * _Nullable (^TABBaseComponentFloatBlock)(CGFloat);
typedef TABBaseComponent * _Nullable (^TABBaseComponentStringBlock)(NSString * _Nonnull);
typedef TABBaseComponent * _Nullable (^TABBaseComponentColorBlock)(UIColor * _Nonnull);
typedef TABBaseComponent * _Nullable (^TABBaseComponentWithArrayBlock)(NSArray * _Nonnull);
typedef TABBaseComponent * _Nullable (^TABBaseComponentIntegerAndIntegerBlock)(NSInteger, NSInteger);


typedef NSArray <TABBaseComponent *> * _Nullable (^TABAnimatedArrayFloatBlock)(CGFloat);
typedef NSArray <TABBaseComponent *> * _Nullable (^TABAnimatedArrayIntBlock)(NSInteger);
typedef NSArray <TABBaseComponent *> * _Nullable (^TABAnimatedArrayBlock)(void);
typedef NSArray <TABBaseComponent *> * _Nullable (^TABAnimatedArrayStringBlock)(NSString * _Nonnull);
typedef NSArray <TABBaseComponent *> * _Nullable (^TABAnimatedArrayColorBlock)(UIColor * _Nonnull);

typedef NSArray <TABBaseComponent *> * _Nullable (^TABBaseComponentArrayBlock)(NSInteger location, NSInteger length);
typedef NSArray <TABBaseComponent *> * _Nullable (^TABBaseComponentArrayWithIndexsBlock)(NSInteger index, ...);

#pragma mark -

typedef TABBaseComponent * _Nullable (^TABBaseComponentOffsetBlock)(CGFloat offset);

typedef TABBaseComponent * _Nullable (^TABBaseComponentCompareBlock)(NSInteger index);
typedef TABBaseComponent * _Nullable (^TABBaseComponentCompareWithOffsetBlock)(NSInteger index, CGFloat value);
typedef TABBaseComponent * _Nullable (^TABBaseComponentRangeWithOffsetBlock)(NSInteger location, NSInteger length, CGFloat offset);

typedef NSArray <TABBaseComponent *> * _Nullable (^TABComponentArrayCompareBlock)(NSInteger index);
typedef NSArray <TABBaseComponent *> * _Nullable (^TABComponentArrayCompareWithOffsetBlock)(NSInteger index, CGFloat offset);

#endif /* TABAnimatedChainDefines_h */
