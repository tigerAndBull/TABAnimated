//
//  TABViewAnimated.m
//  lifeAndSport
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "TABViewAnimated.h"

#import "TABAnimationMethod.h"

#import "UIView+Animated.h"
#import "UITableView+Animated.h"
#import "UICollectionView+Animated.h"
#import "TABViewAnimated+ManagerCALayer.h"

#import <objc/runtime.h>

static CGFloat defaultDuration = 0.4f;

@interface TABViewAnimated()

@property (nonatomic) BOOL isNestShimmer;        // 嵌套表格 用于禁用闪光灯
@property (nonatomic) BOOL isNestShimmerToTable; // 嵌套表格 用于禁用闪光灯
@property (nonatomic) BOOL isNestShimmerToView;  // 嵌套表格 用于禁用闪光灯

@end

@implementation TABViewAnimated

#pragma mark - Methods of starting and ending Animations

- (void)startOrEndViewAnimated:(UIView *)view {
    
    switch (view.animatedStyle) {
            
        case TABViewAnimationStart:
            
            // change status
            view.animatedStyle = TABViewAnimationRunning;
            [self judgeNestTable:view superView:view.superview];
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
            
            [self endAnimationToSubViews:view];
            // end animations
            [self removeAllTABLayersFromView:view];
            
            break;
            
        default:
            break;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.isNestShimmerToTable) {
            weakSelf.isNestShimmerToTable = NO;
        }
        if (weakSelf.isNestShimmer) {
            weakSelf.isNestShimmer = NO;
        }
    });
}


- (void)startOrEndTableAnimated:(UITableViewCell *)cell {
    
    UITableView *superView;
    // adept to different ios versions.
    if ([[[cell superview] superview] isKindOfClass:[UITableView class]]) {
        superView = (UITableView *)cell.superview.superview;
    }else {
        superView = (UITableView *)cell.superview;
    }
    
    [self judgeNestTable:cell superView:superView];

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
            
            [self endAnimationToSubViews:cell];
            // end animations
            [self removeAllTABLayersFromView:superView];
            
            break;
            
        default:
            break;
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.isNestShimmerToTable) {
            weakSelf.isNestShimmerToTable = NO;
        }
        if (weakSelf.isNestShimmer) {
            weakSelf.isNestShimmer = NO;
        }
    });
}

- (void)startOrEndCollectionAnimated:(UICollectionViewCell *)cell {
    
    UICollectionView *superView = (UICollectionView *)cell.superview;
    
    [self judgeNestTable:cell superView:superView];
    
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
            
            [self endAnimationToSubViews:cell];
            // end animations
            [self removeAllTABLayersFromView:superView];
            
            break;
            
        default:
            break;
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.isNestShimmerToTable) {
            weakSelf.isNestShimmerToTable = NO;
        }
        if (weakSelf.isNestShimmer) {
            weakSelf.isNestShimmer = NO;
        }
    });
}

#pragma mark - Private Methods

- (void)judgeNestTable:(UIView *)view superView:(UIView *)superView {
    
    if ([superView.superview isKindOfClass:[UICollectionViewCell class]] ||
        [superView.superview.superview isKindOfClass:[UICollectionViewCell class]] ||
        [superView.superview isKindOfClass:[UITableViewCell class]] ||
        [superView.superview.superview isKindOfClass:[UITableViewCell class]]) {
        if ([view isKindOfClass:[UITableViewCell class]]) {
            self.isNestShimmerToTable = YES;
        }else {
            self.isNestShimmer = YES;
        }
        return;
    }
    
    BOOL shouldExe = YES;
    for (UIView *sub in view.subviews) {
        if (shouldExe) {
            if ([sub isEqual:[view.subviews firstObject]]) {
                if (sub.subviews.count > 0) {
                    for (UIView *v in sub.subviews) {
                        if ([v isKindOfClass:[UICollectionView class]] ||
                            [v isKindOfClass:[UITableView class]]) {
                            shouldExe = NO;
                            if ([view isKindOfClass:[UITableViewCell class]]) {
                                self.isNestShimmerToTable = YES;
                            }else {
                                self.isNestShimmer = YES;
                            }
                            return;
                        }
                    }
                }
            }
        }
        shouldExe = NO;
        if ([sub isKindOfClass:[UICollectionView class]] ||
            [sub isKindOfClass:[UITableView class]]) {
            if ([view isKindOfClass:[UITableViewCell class]]) {
                self.isNestShimmerToTable = YES;
            }else {
                self.isNestShimmer = YES;
            }
            return;
        }
    }
}

- (void)endAnimationToSubViews:(UIView *)view {
    
    NSArray *subViews = [view subviews];
    if ([subViews count] == 0) {
        return;
    }
    
    for (int i = 0; i < subViews.count;i++) {
        
        UIView *subV = subViews[i];
        [self endAnimationToSubViews:subV];
        
        if ([subV isKindOfClass:[UICollectionView class]]) {
            if (subV.animatedStyle == TABCollectionViewAnimationStart) {
                UICollectionView *collectionView = (UICollectionView *)subV;
                collectionView.animatedStyle = TABCollectionViewAnimationEnd;
                [collectionView reloadData];
            }
        }else {
            if ([subV isKindOfClass:[UITableView class]]) {
                if (subV.animatedStyle == TABTableViewAnimationStart) {
                    UITableView *tableView = (UITableView *)subV;
                    tableView.animatedStyle = TABTableViewAnimationEnd;
                    [tableView reloadData];
                }
            }
        }
    }
}

- (BOOL)judgeViewIsNeedAddAnimation:(UIView *)view {
    
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
                    UILabel *lab = (UILabel *)view;
                    if (!lab.text || [lab.text isEqualToString:@""]) {
                        return YES;
                    }
                }
                return NO;
            }
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
        
        if ([subV isKindOfClass:[UITableView class]]) {
            UITableView *view = (UITableView *)subV;
            subV.animatedStyle = TABTableViewAnimationStart;
            [view reloadData];
        }else {
            if ([subV isKindOfClass:[UICollectionView class]]) {
                UICollectionView *view = (UICollectionView *)subV;
                subV.animatedStyle = TABCollectionViewAnimationStart;
                [view reloadData];
            }
        }
        
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
        
        if (self.isNestShimmerToTable || self.isNestShimmer) {
            continue;
        }
        
        if ((self.animationType == TABAnimationTypeShimmer) ||
            (self.animationType == TABAnimationTypeCustom && (superView.superAnimationType == TABViewSuperAnimationTypeShimmer))) {
            if (![superView isKindOfClass:[UIButton class]]) {
                if ([subV isEqual:[subViews lastObject]]) {
                    [TABAnimationMethod addShimmerAnimationToView:subV.superview                                           duration:self.animatedDurationShimmer];
                }
            }
        }
    }
}

- (void)getNeedAnimationSubViewsOfTableView:(UIView *)view
                              withSuperView:(UIView *)superView {
    
    NSArray *subViews = [view subviews];
    if ([subViews count] == 0) {
        return;
    }

    for (int i = 0; i < subViews.count;i++) {

        UIView *subV = subViews[i];
        
        [self getNeedAnimationSubViewsOfTableView:subV withSuperView:subV.superview];
        
        if ([subV isKindOfClass:[UITableView class]]) {
            UITableView *view = (UITableView *)subV;
            subV.animatedStyle = TABTableViewAnimationStart;
            [view reloadData];
        }else {
            if ([subV isKindOfClass:[UICollectionView class]]) {
                UICollectionView *view = (UICollectionView *)subV;
                subV.animatedStyle = TABCollectionViewAnimationStart;
                [view reloadData];
            }
        }
        
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
        
        if (self.isNestShimmerToTable || self.isNestShimmer) {
            continue;
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
        
        // 如果有嵌套表格组件，将嵌套的表格组件调整为启动动画状态
        if ([subV isKindOfClass:[UITableView class]]) {
            UITableView *view = (UITableView *)subV;
            subV.animatedStyle = TABTableViewAnimationStart;
            [view reloadData];
        }else {
            if ([subV isKindOfClass:[UICollectionView class]]) {
                UICollectionView *view = (UICollectionView *)subV;
                subV.animatedStyle = TABCollectionViewAnimationStart;
                [view reloadData];
            }
        }
        
        // 如果是闪光灯模式 或者是 骨架屏模式，将所有view动画属性调整为骨架屏
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
        
        // 判断是否需要加入基础动画
        if ((subV.loadStyle != TABViewLoadAnimationDefault) && [self judgeViewIsNeedAddAnimation:subV]) {
            [self initLayerWithCollectionView:subV withSuperView:subV.superview withColor:self.animatedColor];
        }
        
        if (self.isNestShimmerToTable || self.isNestShimmer) {
            continue;
        }
        
        // 判断是否需要加入闪光灯
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
    
    if (tabAnimated == nil) {
        tabAnimated = [[TABViewAnimated alloc] init];
    }
    return tabAnimated;
}

- (instancetype)init {
    if ( self = [super init]) {
        _animationType = TABAnimationTypeDefault;
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
        _animatedColor = tab_kBackColor;
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
