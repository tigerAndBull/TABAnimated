//
//  TABComponentManager.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/7/16.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABComponentManager.h"
#import "TABAnimatedProduction.h"

@interface TABComponentManager()

@property (nonatomic, strong) NSMutableArray <TABBaseComponent *> *components;

@end

@implementation TABComponentManager

#pragma mark - Public

+ (instancetype)managerWithLayers:(NSArray<TABComponentLayer *> *)layers {
    TABComponentManager *manager = [[TABComponentManager alloc] initWithLayers:layers];
    return manager;
}

- (instancetype)initWithLayers:(NSArray<TABComponentLayer *> *)layers {
    if (self = [super init]) {
        _components = @[].mutableCopy;
        for (NSInteger i = 0; i < layers.count; i++) {
            TABComponentLayer *layer = layers[i];
            TABBaseComponent *component = [TABBaseComponent componentWithLayer:layer];
            [_components addObject:component];
        }
    }
    return self;
}

- (TABBaseComponentBlock _Nullable)animation {
    return ^TABBaseComponent *(NSInteger index) {
        if (index >= self.components.count) {
            NSAssert(NO, @"Array bound, please check it carefully.");
        }
        return self.components[index];
    };
}

- (TABBaseComponentArrayBlock _Nullable)animations {
    return ^NSArray <TABBaseComponent *> *(NSInteger location, NSInteger length) {
        
        if (location + length > self.components.count) {
            NSAssert(NO, @"Array bound, please check it carefully.");
        }
        
        NSMutableArray <TABBaseComponent *> *tempArray = @[].mutableCopy;
        if (length == 0 && location == 0) {
            tempArray = self.components.mutableCopy;
        }else {
            for (NSInteger i = location; i < location+length; i++) {
                TABBaseComponent *layer = self.components[i];
                [tempArray addObject:layer];
            }
        }
        return tempArray.copy;
    };
}

- (TABBaseComponentArrayWithIndexsBlock)animationsWithIndexs {

    return ^NSArray <TABBaseComponent *> * (NSInteger index, ...) {
        
        NSMutableArray <TABBaseComponent *> *resultArray = @[].mutableCopy;
        
        NSInteger arg = index;
        NSInteger temp = -1;
        va_list args;
        va_start(args, index);

        do {
            if (temp == arg) continue;
            if(arg < 0) continue;
            if (arg > 1000) break;
            NSAssert(arg < self.components.count, @"如果运行此断言，请取消使用该方法，请使用单个获取的方式");
            [resultArray addObject:self.components[arg]];
            temp = arg;
        }while ((arg = va_arg(args, NSInteger)));
        
        va_end(args);
        
        return resultArray.copy;
    };
}

@end
