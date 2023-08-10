//
//  NSArray+TABAnimated.m
//  TABAnimatedDemo
//
//  Created by tigerAndBull on 2021/4/2.
//  Copyright © 2021 tigerAndBull. All rights reserved.
//

#import "NSArray+TABAnimated.h"

@implementation NSArray (TABAnimated)

- (NSArray *)tab_map:(id (^)(id))block {
    NSCParameterAssert(block);
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:self.count];
    for (id value in self) {
        id mapedValue = block(value);
        if (mapedValue) {
            [array addObject:mapedValue];
        } else {
            NSAssert(NO, @"");
        }
    }
    return array;
}

@end
