//
//  TABAnimatedProduction.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/4/1.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "TABAnimatedProduction.h"
#import "TABComponentLayer.h"
#import "TABWeakDelegateManager.h"

@implementation TABAnimatedProduction

+ (instancetype)productWithState:(TABAnimatedProductionState)state {
    TABAnimatedProduction *production = [[TABAnimatedProduction alloc] initWithState:state];
    return production;
}

- (instancetype)initWithState:(TABAnimatedProductionState)state {
    if (self = [super init]) {
        _state = state;
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        _layers = @[].mutableCopy;
    }
    return self;
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.backgroundLayer forKey:@"backgroundLayer"];
    [aCoder encodeObject:self.layers forKey:@"layers"];
    [aCoder encodeObject:self.fileName forKey:@"fileName"];
    [aCoder encodeObject:self.version forKey:@"version"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.backgroundLayer = [aDecoder decodeObjectForKey:@"backgroundLayer"];
        self.layers = [aDecoder decodeObjectForKey:@"layers"];
        self.fileName = [aDecoder decodeObjectForKey:@"fileName"];
        self.version = [aDecoder decodeObjectForKey:@"version"];
        self.state = TABAnimatedProductionProcess;
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    TABAnimatedProduction *production = [[[self class] allocWithZone:zone] init];
    production.backgroundLayer = self.backgroundLayer.copy;
    production.fileName = self.fileName;
    production.version = self.version;
    production.state = TABAnimatedProductionProcess;
    production.layers = @[].mutableCopy;
    for (TABComponentLayer *layer in self.layers) {
        [production.layers addObject:layer.copy];
    }
    return production;
}

#pragma mark - Getter / Setter

- (TABWeakDelegateManager *)syncDelegateManager {
    if (!_syncDelegateManager) {
        _syncDelegateManager = [[TABWeakDelegateManager alloc] init];
    }
    return _syncDelegateManager;
}

- (CGFloat)recommendHeight {
    CGFloat minY = CGRectGetMinY(self.backgroundLayer.frame);
    CGFloat minYWithSpace = [self tab_minY];
    CGFloat space = minYWithSpace - minY;
    CGFloat maxY = [self tab_maxY];
    return maxY - minY + space * 2;
}

- (CGFloat)tab_minY {
    if (self.layers.count == 0) return 0;
    CGFloat result = [self.layers[0] tab_minY];
    for (NSInteger i = 0; i < self.layers.count; i++) {
        TABComponentLayer *layer = self.layers[i];
        result = MIN(result, [layer tab_minY]);
    }
    return result;
}

- (CGFloat)tab_maxY {
    if (self.layers.count == 0) return 0;
    CGFloat result = [self.layers[0] tab_maxY];
    for (NSInteger i = 0; i < self.layers.count; i++) {
        TABComponentLayer *layer = self.layers[i];
        result = MAX(result, [layer tab_maxY]);
    }
    return result;
}

@end
