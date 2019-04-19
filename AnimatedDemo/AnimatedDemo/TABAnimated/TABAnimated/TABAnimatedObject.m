//
//  TABAnimatedObject.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/3/5.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import "TABAnimatedObject.h"

#import "TABLayer.h"

#import "TABBaseTableViewCell.h"
#import "TABBaseCollectionViewCell.h"

@implementation TABAnimatedObject

- (instancetype)init {
    if (self = [super init]) {
        _animatedCountArray = @[].mutableCopy;
        _templateClassArray = @[].mutableCopy;
        _animatedCount = 2;
        _superAnimationType = TABViewSuperAnimationTypeDefault;
        _isNest = NO;
    }
    return self;
}

+ (instancetype)animatedWithTemplateClass:(Class)templateClass {
    
    TABAnimatedObject *obj = [[TABAnimatedObject alloc] init];
    [obj assertAboutTemplate:templateClass];
    
    obj.templateClassArray = @[NSStringFromClass(templateClass)];
    
    return obj;
}

+ (instancetype)animatedWithTemplateClass:(Class)templateClass
                            animatedCount:(NSInteger)animatedCount {
    
    TABAnimatedObject *obj = [[TABAnimatedObject alloc] init];
    [obj assertAboutTemplate:templateClass];
    
    obj.animatedCountArray = @[@(animatedCount)];
    obj.templateClassArray = @[NSStringFromClass(templateClass)];
    
    return obj;
}

+ (instancetype)animatedWithTemplateClassArray:(NSArray<Class> *)templateClassArray
                            animatedCountArray:(NSArray<NSNumber *> *)animatedCountArray {
    
    TABAnimatedObject *obj = [[TABAnimatedObject alloc] init];
    
    NSMutableArray *array = @[].mutableCopy;
    for (Class templateClass in templateClassArray) {
        [obj assertAboutTemplate:templateClass];
        [array addObject:NSStringFromClass(templateClass)];
    }
    
    obj.animatedCountArray = animatedCountArray;
    obj.templateClassArray = array.mutableCopy;
    
    return obj;
}

- (void)assertAboutTemplate:(Class)templateClass {
    if (![self canRegisterTemplateClass:templateClass]) {
        NSAssert(NO,@"TABAnimated强制提醒 - 注册的cell中包含未继承模版类:TABBaseTableViewCell/TABBaseCollectionViewCell");
    }
}

- (BOOL)canRegisterTemplateClass:(Class)templateClass {
    
    if ([templateClass.new isKindOfClass:[TABBaseTableViewCell class]]) {
        return YES;
    }
    
    if ([templateClass.new isKindOfClass:[TABBaseCollectionViewCell class]]) {
        return YES;
    }
    
    return NO;
}

@end
