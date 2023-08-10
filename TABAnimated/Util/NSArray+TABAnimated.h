//
//  NSArray+TABAnimated.h
//  TABAnimatedDemo
//
//  Created by tigerAndBull on 2021/4/2.
//  Copyright © 2021 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (TABAnimated)

- (NSArray *)tab_map:(id (^)(id))block;

@end

NS_ASSUME_NONNULL_END
