//
//  TABAnimatedObject.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/3/5.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface TABAnimatedObject : NSObject

@property (nonatomic,copy) NSString *className;
@property (nonatomic,copy) NSArray <NSString *> *classNameArray;

@end

NS_ASSUME_NONNULL_END
