//
//  TABComponentMutiableKey.m
//  TABAnimatedDemo
//
//  Created by wenhuan on 2021/6/4.
//  Copyright © 2021 tigerAndBull. All rights reserved.
//

#import "TABComponentMutableKey.h"

@implementation TABComponentMutableKey

- (BOOL)isEqual:(id)object {
    
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[TABComponentMutableKey class]]) {
        return NO;
    }
    
    TABComponentMutableKey *newKeyObject = object;
    if (self.arrayIndex == newKeyObject.arrayIndex
        && [self.propertyName isEqualToString:newKeyObject.propertyName]) {
        return YES;
    }
    
    return NO;
}

- (NSUInteger)hash {
   return self.arrayIndex ^ [self.propertyName hash];
}

@end
