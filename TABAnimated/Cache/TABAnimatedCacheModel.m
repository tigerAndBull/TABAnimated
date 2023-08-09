//
//  TABAnimatedCacheModel.m
//  TABAnimatedDemo
//
//  Created by tigerAndBull on 2019/9/21.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABAnimatedCacheModel.h"

@implementation TABAnimatedCacheModel

- (instancetype)init {
    if (self = [super init]) {
        _loadCount = 1;
    }
    return self;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_fileName forKey:@"fileName"];
    [aCoder encodeInteger:_loadCount forKey:@"loadCount"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.fileName = [aDecoder decodeObjectForKey:@"fileName"];
        self.loadCount = [aDecoder decodeIntegerForKey:@"loadCount"];
    }
    return self;
}

@end
