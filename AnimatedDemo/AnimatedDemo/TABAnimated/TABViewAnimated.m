//
//  TABViewAnimated.m
//  lifeAndSport
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "TABViewAnimated.h"

#import "TABMethod.h"
#import "TABAnimationMethod.h"

#import "UIView+Animated.h"
#import "UITableView+Animated.h"
#import "UICollectionView+Animated.h"
#import "TABViewAnimated+ManagerCALayer.h"

#import <objc/runtime.h>

static CGFloat defaultDuration = 0.4f;

@interface TABViewAnimated()

@property (nonatomic,strong,readwrite) NSMutableArray *layerArray;

@end

@implementation TABViewAnimated

#pragma mark - Methods of starting and ending Animations

- (void)startOrEndViewAnimated:(UIView *)view {
    
    switch (view.animatedStyle) {
            
        case TABViewAnimationStart:
            
            // change status
            view.animatedStyle = TABViewAnimationRunning;
            // start animations
            if (self.animationType != TABAnimationTypeCustom || self.animationType != TABAnimationTypeDefault) {
                [self getNeedAnimationSubViewsOfView:view];
            }else {
                if (view.superAnimationType != TABViewSuperAnimationTypeDefault) {
                    [self getNeedAnimationSubViewsOfView:view];
                }
            }
            
            break;
            
        case TABViewAnimationEnd:
            
            // end animations
            [self removeAllTABLayersFromView:view];
            
            break;
            
        default:
            break;
    }
}


- (void)startOrEndTableAnimated:(UITableViewCell *)cell {
    
    UITableView *superView;
    // adept to different ios versions.
    if ([[[cell superview] superview] isKindOfClass:[UITableView class]]) {
        superView = (UITableView *)cell.superview.superview;
    }else {
        superView = (UITableView *)cell.superview;
    }

    switch (superView.animatedStyle) {
            
        case TABTableViewAnimationStart:

            // start animations
            if (self.animationType != TABAnimationTypeCustom) {
                [self getNeedAnimationSubViewsOfTableView:cell withSuperView:superView];
            }else {
                if (superView.superAnimationType != TABViewSuperAnimationTypeDefault) {
                    [self getNeedAnimationSubViewsOfTableView:cell withSuperView:superView];
                }
            }
            
            break;

        case TABTableViewAnimationEnd:
            
            // end animations
            [self removeAllTABLayersFromView:superView];
            
            break;
            
        default:
            break;
    }
}

- (void)startOrEndCollectionAnimated:(UICollectionViewCell *)cell {
    
    UICollectionView *superView = (UICollectionView *)cell.superview;

    switch (superView.animatedStyle) {
            
        case TABCollectionViewAnimationStart:

            // run animation
            if (self.animationType != TABAnimationTypeCustom) {
                [self getNeedAnimationSubViewsOfCollectionView:cell withSuperView:superView];
            }else {
                if (superView.superAnimationType != TABViewSuperAnimationTypeDefault) {
                    [self getNeedAnimationSubViewsOfCollectionView:cell withSuperView:superView];
                }
            }
            
            break;
            
        case TABCollectionViewAnimationEnd:
            
            // remove layers
            for (int i = 0; i < self.layerArray.count; i++) {
                CALayer *layer = self.layerArray[i];
                [layer removeFromSuperlayer];
            }
            [self.layerArray removeAllObjects];
            
            if (self.animationType == TABAnimationTypeShimmer ||
                (superView.superAnimationType == TABViewSuperAnimationTypeShimmer)) {
                if (cell.layer.mask != nil) {
                    [cell.layer.mask removeFromSuperlayer];
                }
            }
            
            break;
            
        default:
            break;
    }
}

#pragma mark - Private Methods

- (BOOL)judgeViewIsNeedAddAnimation:(UIView *)view {
    
    if ([view isKindOfClass:[UIButton class]]) {
        // UIButtonLabel has one CALayer.
        if (view.layer.sublayers.count >= 1) {
            return YES;
        }else {
            return NO;
        }
    }else {
        if (view.layer.sublayers.count == 0) {
            return YES;
        }else {
            if ([view isKindOfClass:[UILabel class]]) {
                UILabel *lab = (UILabel *)view;
                if (!lab.text) {
                    return YES;
                }
            }
            return NO;
        }
    }
}

- (void)getNeedAnimationSubViewsOfView:(UIView *)superView {
    
    NSArray *subViews = [superView subviews];
    if ([subViews count] == 0) {
        return;
    }
    
    for (int i = 0; i < subViews.count;i++) {
        
        UIView *subV = subViews[i];
        
        [self getNeedAnimationSubViewsOfView:subV];
        
        if ((self.animationType == TABAnimationTypeShimmer) ||
            (self.animationType == TABAnimationTypeOnlySkeleton) ||
            ((self.animationType == TABAnimationTypeCustom) &&
             ((superView.superAnimationType == TABViewSuperAnimationTypeShimmer) ||
             (superView.superAnimationType == TABViewSuperAnimationTypeOnlySkeleton)))) {
            if ([subV.superview isKindOfClass:[UITableViewCell class]]) {
                // add animation without on contentView.
                if (i != 0) {
                    subV.loadStyle = TABViewLoadAnimationWithOnlySkeleton;
                }
            }else {
                subV.loadStyle = TABViewLoadAnimationWithOnlySkeleton;
            }
        }
        
        if ((subV.loadStyle != TABViewLoadAnimationDefault) && [self judgeViewIsNeedAddAnimation:subV]) {
            [self initLayerWithView:subV withSuperView:subV.superview withColor:self.animatedColor];
        }
        
        if ((self.animationType == TABAnimationTypeShimmer) ||
            (self.animationType == TABAnimationTypeCustom && (superView.superAnimationType == TABViewSuperAnimationTypeShimmer))) {
            if (![superView isKindOfClass:[UIButton class]]) {
                if ([subV isEqual:[subViews lastObject]]) {
                    [TABAnimationMethod addShimmerAnimationToView:subV.superview
                                                         duration:self.animatedDurationShimmer];
                }
            }
        }
    }
}

- (void)getNeedAnimationSubViewsOfTableView:(UIView *)view
                              withSuperView:(UIView *)superView{
    
    NSArray *subViews = [view subviews];
    if ([subViews count] == 0) {
        return;
    }

    for (int i = 0; i < subViews.count;i++) {

        UIView *subV = subViews[i];
        
        [self getNeedAnimationSubViewsOfTableView:subV withSuperView:subV.superview];
        
        if ((self.animationType == TABAnimationTypeShimmer) ||
            (self.animationType == TABAnimationTypeOnlySkeleton) ||
            ((self.animationType == TABAnimationTypeCustom) &&
             ((superView.superAnimationType == TABViewSuperAnimationTypeShimmer) ||
              (superView.superAnimationType == TABViewSuperAnimationTypeOnlySkeleton)))) {
            
            if ([subV.superview isKindOfClass:[UITableViewCell class]]) {
                // used to can not add animation to contentView
                if (i != 0) {
                    subV.loadStyle = TABViewLoadAnimationWithOnlySkeleton;
                }
            }else {
                subV.loadStyle = TABViewLoadAnimationWithOnlySkeleton;
            }
        }
        
        if ((subV.loadStyle != TABViewLoadAnimationDefault) && [self judgeViewIsNeedAddAnimation:subV]) {
            [self initLayerWithView:subV withSuperView:subV.superview withColor:self.animatedColor];
        }
        
        if ((self.animationType == TABAnimationTypeShimmer) ||
            ((self.animationType == TABAnimationTypeCustom) &&
             (superView.superAnimationType == TABViewSuperAnimationTypeShimmer))) {
            if (![subV.superview isKindOfClass:[UIButton class]]) {
                if ([subV isEqual:[subViews lastObject]]) {
                    [TABAnimationMethod addShimmerAnimationToView:subV.superview
                                                         duration:self.animatedDurationShimmer];
                }
            }
        }
    }
}

- (void)getNeedAnimationSubViewsOfCollectionView:(UIView *)view
                                   withSuperView:(UIView *)superView {
    
    NSArray *subViews = [view subviews];
    if ([subViews count] == 0) {
        return;
    }
    
    for (int i = 0; i < subViews.count;i++) {
        
        UIView *subV = subViews[i];
        
        [self getNeedAnimationSubViewsOfCollectionView:subV withSuperView:subV.superview];
        
        if (self.animationType == TABAnimationTypeShimmer ||
            self.animationType == TABAnimationTypeOnlySkeleton ||
            (self.animationType == TABAnimationTypeCustom &&
             ((superView.superAnimationType == TABViewSuperAnimationTypeShimmer) ||
             (superView.superAnimationType == TABViewSuperAnimationTypeOnlySkeleton)))) {
            if ([subV.superview isKindOfClass:[UICollectionViewCell class]]) {
                // used to can not add animation to contentView
                if (i == 0) {
                    subV.loadStyle = TABViewLoadAnimationDefault;
                }
            }else {
                subV.loadStyle = TABViewLoadAnimationWithOnlySkeleton;
            }
        }
        
        if ((subV.loadStyle != TABViewLoadAnimationDefault) && [self judgeViewIsNeedAddAnimation:subV]) {
            [self initLayerWithCollectionView:subV withSuperView:subV.superview withColor:self.animatedColor];
        }
        
        if (self.animationType == TABAnimationTypeShimmer ||
            ((self.animationType == TABAnimationTypeCustom &&
            (superView.superAnimationType == TABViewSuperAnimationTypeShimmer)))) {
            if (![subV.superview isKindOfClass:[UIButton class]]) {
                if ([subV isEqual:[subViews lastObject]]) {
                    [TABAnimationMethod addShimmerAnimationToView:subV.superview
                                                         duration:self.animatedDurationShimmer];
                }
            }
        }
    }
}

#pragma mark - Initize Methods

+ (TABViewAnimated *)sharedAnimated {
    
    static TABViewAnimated *tabAnimated;
    
    if (tabAnimated == nil){
        tabAnimated = [[TABViewAnimated alloc] init];
    }
    return tabAnimated;
}

- (instancetype)init {
    
    if ( self = [super init]) {
        _animationType = TABAnimationTypeDefault;
        self.layerArray = [NSMutableArray array];
    }
    return self;
}

- (void)initWithDefaultAnimated {
    
    if (self) {
        _animatedDuration = defaultDuration;
        _animatedColor = tab_kBackColor;
        _animationType = TABAnimationTypeDefault;
    }
}

- (void)initWithAnimatedDuration:(CGFloat)duration
                       withColor:(UIColor *)color {
    
    if (self) {
        _animatedDuration = duration;
        _animatedColor = color;
        _animationType = TABAnimationTypeDefault;
    }
}

- (void)initWithAnimatedDuration:(CGFloat)duration
                       withColor:(UIColor *)color
                 withLongToValue:(CGFloat)longToValue
                withShortToValue:(CGFloat)shortToValue {
    
    if (self) {
        _animatedDuration = duration;
        _animatedColor = color;
        _shortToValue = shortToValue;
        _longToValue = longToValue;
        _animationType = TABAnimationTypeDefault;
    }
}

- (void)initWithShimmerAnimated {
    
    if (self) {
        _animationType = TABAnimationTypeShimmer;
        _animatedDurationShimmer = 1.5f;
    }
}

- (void)initWithShimmerAnimatedDuration:(CGFloat)duration
                              withColor:(UIColor *)color {
    
    if (self) {
        _animatedDurationShimmer = duration;
        _animatedColor = color;
        _animationType = TABAnimationTypeShimmer;
    }
}

- (void)initWithOnlySkeleton {
    
    if (self) {
        _animationType = TABAnimationTypeOnlySkeleton;
        _animatedColor = tab_kBackColor;
    }
}

- (void)initWithCustomAnimation {
    
    if (self) {
        _animationType = TABAnimationTypeCustom;
        _animatedDurationShimmer = 1.5f;
        _animatedDuration = defaultDuration;
    }
}

- (void)initWithDefaultDurationAnimation:(CGFloat)defaultAnimationDuration
                 withLongToValue:(CGFloat)longToValue
                withShortToValue:(CGFloat)shortToValue
    withShimmerAnimationDuration:(CGFloat)shimmerAnimationDuration
                       withColor:(UIColor *)color {
    
    if (self) {
        _animationType = TABAnimationTypeCustom;
        _animatedDurationShimmer = shimmerAnimationDuration;
        _animatedDuration = defaultAnimationDuration;
        _animatedColor = color;
        _shortToValue = shortToValue;
        _longToValue = longToValue;
    }
}

@end
