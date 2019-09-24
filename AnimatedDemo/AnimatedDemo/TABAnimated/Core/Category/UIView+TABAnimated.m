//
//  UIView+Animated.m
//  lifeAndSport
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "UIView+TABAnimated.h"
#import "TABComponentLayer.h"

#import <objc/runtime.h>

#import "TABComponentManager.h"
#import "TABBaseComponent.h"

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
    return ^TABBaseComponent *(NSInteger index) {
        if (index >= self.tabComponentManager.baseComponentArray.count) {
            NSAssert(NO, @"Array bound, please check it carefully.");
            return [TABBaseComponent initWithComponentLayer:TABComponentLayer.new];
        }
        return self.tabComponentManager.baseComponentArray[index];
    };
}

- (TABSearchLayerArrayBlock)animations {
    return ^NSArray <TABBaseComponent *> *(NSInteger location, NSInteger length) {
        
        if (location + length > self.tabComponentManager.baseComponentArray.count) {
            NSAssert(NO, @"Array bound, please check it carefully.");
            return NSArray.new;
        }
        
        NSMutableArray <TABBaseComponent *> *tempArray = @[].mutableCopy;
        for (NSInteger i = location; i < location+length; i++) {
            TABBaseComponent *layer = self.tabComponentManager.baseComponentArray[i];
            [tempArray addObject:layer];
        }
        
        // 修改添加  需要查看数组内容   length == 0 && location == 0 是返回整个数组   xiaoxin
        if (length == 0 && location == 0) {
            tempArray = self.tabComponentManager.baseComponentArray.mutableCopy;
        }
        
        return tempArray.mutableCopy;
    };
}

@end

#import "TABTableAnimated.h"

@implementation UITableView (TABAnimated)

- (TABTableAnimated *)tabAnimated {
    return objc_getAssociatedObject(self, @selector(tabAnimated));
}

- (void)setTabAnimated:(TABTableAnimated *)tabAnimated {
    objc_setAssociatedObject(self, @selector(tabAnimated),tabAnimated, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (self.tableHeaderView != nil && self.tableHeaderView.tabAnimated == nil) {
        self.tableHeaderView.tabAnimated = TABViewAnimated.new;
        self.tabAnimated.tabHeadViewAnimated = self.tableHeaderView.tabAnimated;
    }
    
    if (self.tableFooterView != nil && self.tableFooterView.tabAnimated == nil) {
        self.tableFooterView.tabAnimated = TABViewAnimated.new;
        self.tabAnimated.tabFooterViewAnimated = self.tableFooterView.tabAnimated;
    }
}

@end

#import "TABCollectionAnimated.h"

@implementation UICollectionView (TABAnimated)

- (TABCollectionAnimated *)tabAnimated {
    return objc_getAssociatedObject(self, @selector(tabAnimated));
}

- (void)setTabAnimated:(TABCollectionAnimated *)tabAnimated {
    objc_setAssociatedObject(self, @selector(tabAnimated),tabAnimated, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

