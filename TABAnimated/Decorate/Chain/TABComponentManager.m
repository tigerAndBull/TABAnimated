//
//  TABComponentManager.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/7/16.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABComponentManager.h"
#import "TABAnimatedProduction.h"
#import "UIView+TABAnimated.h"

@interface TABComponentManager()

//@property (nonatomic, strong) NSMutableArray <TABBaseComponent *> *components;
@property (nonatomic, strong) NSMutableArray <TABComponentLayer *> *layers;

@property (nonatomic, strong) NSMutableDictionary <NSString *, TABBaseComponent *> *componentDict;

@property (nonatomic, strong) UIColor *animatedColor;

@end

@implementation TABComponentManager

#pragma mark - Public

+ (instancetype)managerWithBackgroundLayer:(TABComponentLayer *)backgroundLayer
                                    layers:(NSMutableArray <TABComponentLayer *> *)layers
                             animatedColor:(UIColor *)animatedColor {
    TABComponentManager *manager = [[TABComponentManager alloc] initWithBackgroundLayer:backgroundLayer layers:layers animatedColor:animatedColor];
    return manager;
}


- (instancetype)initWithBackgroundLayer:(TABComponentLayer *)backgroundLayer
                                 layers:(NSMutableArray <TABComponentLayer *> *)layers
                          animatedColor:(UIColor *)animatedColor {
    if (self = [super init]) {
        _animatedColor = animatedColor;
        _componentDict = @{}.mutableCopy;
        _layers = layers;
        _backgroundComponent = [TABBaseComponent componentWithLayer:backgroundLayer manager:self];
        
        for (NSInteger i = 0; i < layers.count; i++) {
            TABComponentLayer *layer = layers[i];
            TABBaseComponent *component = [TABBaseComponent componentWithLayer:layer manager:self];
            NSString *key = tab_NSStringFromIndex(layer.tagIndex);
            self.componentDict[key] = component;
            if (layer.tagName.length > 0) {
                self.componentDict[layer.tagName] = component;
            }
        }
    }
    return self;
}

- (TABBaseComponentStringBlock _Nullable)animationN {
    return [self animationWithName];
}

- (TABBaseComponentStringBlock _Nullable)animationWithName {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(NSString *name) {
        if (!weakSelf.componentDict[name]) {
            NSAssert(NO, @"The name is not exist, please check it carefully.");
            TABComponentLayer *layer = TABComponentLayer.new;
            layer.loadStyle = TABViewLoadAnimationRemove;
            return [TABBaseComponent componentWithLayer:layer manager:weakSelf];
        }
        TABBaseComponent *component = weakSelf.componentDict[name];
        return component;
    };
}

- (TABBaseComponentBlock _Nullable)animation {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(NSInteger index) {
        NSString *key = tab_NSStringFromIndex(index);
        if (!weakSelf.componentDict[key]) {
            NSAssert(NO, @"Array bound, please check it carefully.");
            TABComponentLayer *layer = TABComponentLayer.new;
            layer.loadStyle = TABViewLoadAnimationRemove;
            return [TABBaseComponent componentWithLayer:layer manager:weakSelf];
        }
        return weakSelf.componentDict[key];
    };
}

- (TABBaseComponentArrayBlock _Nullable)animations {
    __weak typeof(self) weakSelf = self;
    return ^NSArray <TABBaseComponent *> *(NSInteger location, NSInteger length) {
        NSMutableArray <TABBaseComponent *> *tempArray = @[].mutableCopy;
        BOOL canUseDict = YES;
        for (NSInteger i = location; i < location + length; i++) {
            NSString *key = tab_NSStringFromIndex(i);
            if (!weakSelf.componentDict[key]) {
                canUseDict = NO;
                break;
            }else {
                TABBaseComponent *layer = weakSelf.componentDict[key];
                [tempArray addObject:layer];
            }
        }
        if (!canUseDict) {
            NSAssert(NO, @"Useless location and length, please check it carefully.");
            return @[];
        }
        return tempArray.copy;
    };
}

- (TABBaseComponentArrayWithIndexsBlock)animationsWithIndexs {
    
    __weak typeof(self) weakSelf = self;
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
            
            NSString *key = tab_NSStringFromIndex(arg);
            if (!weakSelf.componentDict[key]) {
                NSAssert(NO, @"如果运行到此断言，先检查是否调用了超过数组下标的index。若是确定没有，请取消使用该方法，使用单个获取的方式");
                break;
            }
            
            [resultArray addObject:weakSelf.componentDict[key]];
            temp = arg;
        }while ((arg = va_arg(args, NSInteger)));
        
        va_end(args);
        
        return resultArray.copy;
    };
}

- (TABBaseComponentIntegerBlock)create {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent * (NSInteger index) {
        TABComponentLayer *layer = TABComponentLayer.new;
        layer.tagIndex = index;
        layer.numberOflines = 1;
        layer.origin = TABComponentLayerOriginCreate;
        layer.backgroundColor = weakSelf.animatedColor.CGColor;
        TABBaseComponent *baseComponent = [TABBaseComponent componentWithLayer:layer manager:weakSelf];
        NSString *key = tab_NSStringFromIndex(index);
        weakSelf.componentDict[key] = baseComponent;
        [weakSelf.layers addObject:layer];
        return baseComponent;
    };
}

- (TABBaseComponentStringBlock)createN {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent * (NSString *key) {
        TABComponentLayer *layer = TABComponentLayer.new;
        layer.numberOflines = 1;
        layer.origin = TABComponentLayerOriginCreate;
        layer.backgroundColor = weakSelf.animatedColor.CGColor;
        TABBaseComponent *baseComponent = [TABBaseComponent componentWithLayer:layer manager:weakSelf];
        weakSelf.componentDict[key] = baseComponent;
        [weakSelf.layers addObject:layer];
        return baseComponent;
    };
}

@end
