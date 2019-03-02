//
//  TABManagerMethod.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/2/21.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import "TABManagerMethod.h"

#import "UIView+Animated.h"
#import "TABViewAnimated.h"
#import "UIView+TABControlAnimation.h"

#import "TABManagerMethod+ManagerCALayer.h"

@interface TABManagerMethod ()

@property (nonatomic,strong) NSMutableArray <UIView *>*tempViewArray;
@property (nonatomic,strong) NSMutableArray <NSNumber *>*tempBorderArray;
@property (nonatomic,strong,readwrite) NSMutableArray <NSMutableArray *> *cacheArray;
@property (nonatomic,strong) NSMutableArray <NSString *>*cacheKeyArray;

@property (nonatomic,strong) NSMutableArray <UILabel *>*tempAlignArray;
@property (nonatomic,strong,readwrite) NSMutableArray <NSMutableArray *> *cacheAlignArray;
@property (nonatomic,strong) NSMutableArray <NSString *>*cacheAlignKeyArray;

@end

@implementation TABManagerMethod

+ (instancetype)sharedManager {
    static dispatch_once_t token;
    static TABManagerMethod *method = nil;
    dispatch_once(&token, ^{
        method = [[TABManagerMethod alloc] init];
    });
    return method;
}

- (instancetype)init {
    if (self = [super init]) {
        _cacheArray = [NSMutableArray array];
        _tempViewArray = [NSMutableArray array];
        _tempBorderArray = [NSMutableArray array];
        _cacheKeyArray = [NSMutableArray array];
        
        _cacheAlignArray = [NSMutableArray array];
        _cacheAlignKeyArray = [NSMutableArray array];
        _tempAlignArray = [NSMutableArray array];
    }
    return self;
}

- (void)cacheView:(UIView *)view {
    
    [self searchView:view];
    
    NSString *key = [self uuidString];
    
    if (self.tempAlignArray.count != 0) {
        [self.cacheAlignArray addObject:[[NSMutableArray alloc]initWithArray:self.tempAlignArray]];
        [self.cacheAlignKeyArray addObject:key];
        view.tabIdentifier = key;
        [self.tempAlignArray removeAllObjects];
    }
    
    if (self.tempViewArray.count != 0) {
        
        [self.cacheArray addObject:
         [NSMutableArray arrayWithObjects:
                                    [[NSMutableArray alloc]initWithArray:self.tempViewArray],
                                    [[NSMutableArray alloc]initWithArray:self.tempBorderArray], nil]];
        [self.cacheKeyArray addObject:key];
        view.tabIdentifier = key;
        [self.tempViewArray removeAllObjects];
        [self.tempBorderArray removeAllObjects];
    }
}

- (void)recoverView:(UIView *)view {
    
    if (view.tabIdentifier == nil || [view.tabIdentifier isEqualToString:@""] || view.tabIdentifier.length != 36) {
        return;
    }
    
    [self recoverAlignView:view];
    [self recoverBorderView:view];
}

- (void)recoverAlignView:(UIView *)view {
    if (self.cacheAlignArray.count == 0) {
        [self.tempAlignArray removeAllObjects];
        return;
    }
    
    for (int i = 0; i < self.cacheAlignKeyArray.count; i++) {
        
        NSString *str = self.cacheAlignKeyArray[i];
        if (![str isEqualToString:view.tabIdentifier]) {
            continue;
        }
        
        NSArray <UILabel *>*array = self.cacheAlignArray[i];
        if (array.count == 0) {
            array = nil;
            continue;
        }
        
        for (int j = 0; j < array.count; j++) {
            UILabel *view = array[j];
            view.textAlignment = NSTextAlignmentRight;
        }
        break;
    }
    
    NSInteger index = [self.cacheAlignKeyArray indexOfObject:view.tabIdentifier];
    if (index <= self.cacheAlignArray.count - 1) {
        [self.cacheAlignArray removeObjectAtIndex:index];
        [self.cacheAlignKeyArray removeObject:view.tabIdentifier];
    }
}

- (void)recoverBorderView:(UIView *)view {
    if (self.cacheArray.count == 0) {
        [self.tempViewArray removeAllObjects];
        [self.tempBorderArray removeAllObjects];
        return;
    }
    
    for (int i = 0; i < self.cacheKeyArray.count; i++) {
        
        NSString *str = self.cacheKeyArray[i];
        if (![str isEqualToString:view.tabIdentifier]) {
            continue;
        }
        
        NSArray *array = self.cacheArray[i];
        if (array.count != 2) {
            array = nil;
            continue;
        }
        
        NSMutableArray <UIView *>*viewArray = array[0];
        NSMutableArray <NSNumber *>*borderArray = array[1];
        
        for (int i = 0; i < viewArray.count; i++) {
            UIView *view = viewArray[i];
            CGFloat borderWidth = [borderArray[i] floatValue];
            view.layer.borderWidth = borderWidth;
        }
        break;
    }
    
    NSInteger index = [self.cacheKeyArray indexOfObject:view.tabIdentifier];
    if (index <= self.cacheArray.count - 1) {
        [self.cacheArray removeObjectAtIndex:index];
        [self.cacheKeyArray removeObject:view.tabIdentifier];
    }
}

- (void)searchView:(UIView *)view {
    
    NSArray *subViews = [view subviews];
    if ([subViews count] == 0) {
        return;
    }
    
    for (int i = 0; i < subViews.count;i++) {
        UIView *subV = subViews[i];
        [self searchView:subV];
        
        if ([subV isKindOfClass:[UILabel class]]) {
            UILabel *lab = (UILabel *)subV;
            if (lab.textAlignment == NSTextAlignmentRight) {
                [self.tempAlignArray addObject:lab];
                lab.textAlignment = NSTextAlignmentLeft;
            }
        }
        
        if (subV.layer.borderWidth > 0) {
            [self.tempViewArray addObject:subV];
            [self.tempBorderArray addObject:[NSNumber numberWithFloat:subV.layer.borderWidth]];
            subV.layer.borderWidth = 0.f;
        }
    }
}

- (NSString *)uuidString {
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    return [uuid lowercaseString];
}

+ (void)managerAnimationSubViewsOfView:(UIView *)superView {
    
    NSArray *subViews = [superView subviews];
    if ([subViews count] == 0) {
        return;
    }
    
    for (int i = 0; i < subViews.count;i++) {
        UIView *subV = subViews[i];
        [self managerAnimationSubViewsOfView:subV];
        
        if ([subV isKindOfClass:[UITableView class]]) {
            UITableView *view = (UITableView *)subV;
            [view tab_startAnimation];
            [view reloadData];
        }else {
            if ([subV isKindOfClass:[UICollectionView class]]) {
                UICollectionView *view = (UICollectionView *)subV;
                [view tab_startAnimation];
                [view reloadData];
            }
        }
        
        if (([TABViewAnimated sharedAnimated].animationType == TABAnimationTypeShimmer) ||
            ([TABViewAnimated sharedAnimated].animationType == TABAnimationTypeOnlySkeleton) ||
            (([TABViewAnimated sharedAnimated].animationType == TABAnimationTypeCustom) &&
             ((superView.superAnimationType == TABViewSuperAnimationTypeShimmer) ||
              (superView.superAnimationType == TABViewSuperAnimationTypeOnlySkeleton)))) {
                 if ([subV.superview isKindOfClass:[UITableViewCell class]]) {
                     // add animation without on contentView.
                     if (i != 0) {
                         if (subV.loadStyle != TABViewLoadAnimationRemove) {
                             subV.loadStyle = TABViewLoadAnimationWithOnlySkeleton;
                         }
                     }
                 }else {
                     if (subV.loadStyle != TABViewLoadAnimationRemove) {
                         subV.loadStyle = TABViewLoadAnimationWithOnlySkeleton;
                     }
                 }
        }
        
        if ((subV.loadStyle != TABViewLoadAnimationDefault) &&
            [TABManagerMethod judgeViewIsNeedAddAnimation:subV]) {
            [TABManagerMethod initLayerWithView:subV
                                  withSuperView:subV.superview
                                      withColor:[TABViewAnimated sharedAnimated].animatedColor];
        }
    }
}

+ (void)endAnimationToSubViews:(UIView *)view {
    
    NSArray *subViews = [view subviews];
    if ([subViews count] == 0) {
        return;
    }
    
    for (int i = 0; i < subViews.count;i++) {
        
        UIView *subV = subViews[i];
        [self endAnimationToSubViews:subV];
        
        if (subV.isAnimating) {
            [subV tab_endAnimation];
        }
    }
}

+ (BOOL)judgeViewIsNeedAddAnimation:(UIView *)view {
    
    if ([view isKindOfClass:[UIButton class]]) {
        // UIButtonLabel has one CALayer.
        if (view.layer.sublayers.count >= 1) {
            return YES;
        }else {
            return NO;
        }
    }else {
        if ([view isKindOfClass:[UICollectionView class]] ||
            [view isKindOfClass:[UITableView class]]) {
            return NO;
        }else {
            if (view.layer.sublayers.count == 0) {
                return YES;
            }else {
                if ([view isKindOfClass:[UILabel class]]) {
                    return YES;
                }
                return NO;
            }
        }
    }
}

@end
