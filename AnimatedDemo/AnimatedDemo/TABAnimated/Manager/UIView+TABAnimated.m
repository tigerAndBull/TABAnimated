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
#import "TABComponentManager.h"

#import <objc/runtime.h>

@implementation UIView (TABAnimated)

#pragma mark - Getter/Setter

- (TABViewAnimated *)tabAnimated {
    return objc_getAssociatedObject(self, @selector(tabAnimated));
}

- (void)setTabAnimated:(TABViewAnimated *)tabAnimated {
    objc_setAssociatedObject(self, @selector(tabAnimated),tabAnimated, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TABComponentManager *)tabComponentManager {
    return objc_getAssociatedObject(self, @selector(tabComponentManager));
}

- (void)setTabComponentManager:(TABComponentManager *)tabComponentManager {
    objc_setAssociatedObject(self, @selector(tabComponentManager),tabComponentManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TABSearchLayerBlock)animation {
    return ^TABComponentLayer *(NSInteger index) {
        if (index >= self.tabComponentManager.componentLayerArray.count) {
            NSAssert(NO, @"Array bound, please check it carefully.");
        }
        return self.tabComponentManager.componentLayerArray[index];
    };
}

- (TABSearchLayerArrayBlock)animations {
    return ^NSArray <TABComponentLayer *> *(NSInteger location, NSInteger length) {
        if (location + length > self.tabComponentManager.componentLayerArray.count) {
            NSAssert(NO, @"Array bound, please check it carefully.");
        }
        NSMutableArray <TABComponentLayer *> *tempArray = @[].mutableCopy;
        for (NSInteger i = location; i < location+length; i++) {
            TABComponentLayer *layer = self.tabComponentManager.componentLayerArray[i];
            [tempArray addObject:layer];
        }
        
        // 修改添加  需要查看数组内容   length == 0 && location == 0 是返回整个数组   xiaoxin
        if (length == 0 && location == 0) {
            tempArray = self.tabComponentManager.componentLayerArray.mutableCopy;
        }
        
        return tempArray.mutableCopy;
    };
}

@end
