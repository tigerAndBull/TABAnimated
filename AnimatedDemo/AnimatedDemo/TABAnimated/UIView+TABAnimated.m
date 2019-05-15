//
//  UIView+Animated.m
//  lifeAndSport
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "UIView+TABAnimated.h"
#import "TABViewAnimated.h"
#import "UIView+TABControlAnimation.h"
#import "TABLayer.h"

#import <objc/runtime.h>

@implementation UIView (TABAnimated)

#pragma mark - Getter/Setter

- (TABViewAnimated *)tabAnimated {
    return objc_getAssociatedObject(self, @selector(tabAnimated));
}

- (void)setTabAnimated:(TABViewAnimated *)tabAnimated {
    objc_setAssociatedObject(self, @selector(tabAnimated),tabAnimated, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TABLayer *)tabLayer {
    return objc_getAssociatedObject(self, @selector(tabLayer));
}

- (void)setTabLayer:(TABLayer *)tabLayer {
    objc_setAssociatedObject(self, @selector(tabLayer),tabLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TABSearchLayerBlock)animation {
    return ^TABComponentLayer *(NSInteger index) {
        if (index >= self.tabLayer.componentLayerArray.count) {
            NSAssert(NO, @"Array bound, please check it carefully.");
        }
        return self.tabLayer.componentLayerArray[index];
    };
}

- (TABSearchLayerArrayBlock)animations {
    return ^NSArray <TABComponentLayer *> *(NSInteger location, NSInteger length) {
        if (location + length > self.tabLayer.componentLayerArray.count) {
            NSAssert(NO, @"Array bound, please check it carefully.");
        }
        NSMutableArray <TABComponentLayer *> *tempArray = @[].mutableCopy;
        for (NSInteger i = location; i < location+length; i++) {
            TABComponentLayer *layer = self.tabLayer.componentLayerArray[i];
            [tempArray addObject:layer];
        }
        
        //修改添加  需要查看数组内容   length == 0 && location == 0 是返回整个数组   xiaoxin
        if (length == 0 && location == 0) {
            tempArray = self.tabLayer.componentLayerArray.mutableCopy;
        }
        
        return tempArray.mutableCopy;
    };
}

@end
