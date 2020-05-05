//
//  NSMutableArray+TABAnimatedProduction.m
//  AnimatedDemo
//
//  Created by wenhuan on 2020/4/29.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "NSMutableArray+TABAnimatedProduction.h"

@implementation NSMutableArray (TABAnimatedProduction)

- (BOOL)tab_removeObjectAtIndex:(NSUInteger)idx {
    [self removeObjectAtIndex:idx];
    if (self.count == 0) {
        return YES;
    }
    return NO;
}

@end
