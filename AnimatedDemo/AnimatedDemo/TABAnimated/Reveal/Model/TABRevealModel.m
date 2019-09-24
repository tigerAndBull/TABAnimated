//
//  TABRevealModel.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/9/6.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABRevealModel.h"

@implementation TABRevealModel

- (instancetype)init {
    if (self = [super init]) {
        _chainManagerArray = @[].mutableCopy;
        _chainManagerCount = [NSNumber numberWithInteger:0];
    }
    return self;
}

- (void)updateArrayToCache {
    self.chainManagerCount = [NSNumber numberWithInteger:self.chainManagerArray.count];
}

- (void)managerAddObject:(TABRevealChainManager *)manager {
    [self.chainManagerArray addObject:manager];
    self.chainManagerCount = [NSNumber numberWithInteger:self.chainManagerArray.count];
}

- (void)managerRemoveObject:(NSInteger)index {
    [self.chainManagerArray removeObjectAtIndex:index];
    self.chainManagerCount = [NSNumber numberWithInteger:self.chainManagerArray.count];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_chainManagerArray forKey:@"chainManagerArray"];
    [aCoder encodeObject:_targetClassString forKey:@"targetClassString"];
    [aCoder encodeFloat:_targetHeight forKey:@"targetHeight"];
    [aCoder encodeFloat:_targetWidth forKey:@"targetWidth"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.chainManagerArray = [aDecoder decodeObjectForKey:@"chainManagerArray"];
        self.targetClassString = [aDecoder decodeObjectForKey:@"targetClassString"];
        self.targetHeight = [aDecoder decodeFloatForKey:@"targetHeight"];
        self.targetWidth = [aDecoder decodeFloatForKey:@"targetWidth"];
    }
    return self;
}

@end
