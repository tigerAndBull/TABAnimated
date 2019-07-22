//
//  TABManagerMethod.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/2/21.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import "TABManagerMethod.h"
#import <CoreGraphics/CoreGraphics.h>

static NSString * const kShortDataString = @"tab_testtesttest";
static NSString * const kLongDataString = @"tab_testtesttesttesttesttesttesttesttesttesttest";

@implementation TABManagerMethod

+ (void)fullData:(UIView *)view {
    
    if ([view isKindOfClass:[UITableView class]] ||
        [view isKindOfClass:[UICollectionView class]]) {
        return;
    }
    
    NSArray *subViews = [view subviews];
    if ([subViews count] == 0) {
        return;
    }
    
    for (int i = 0; i < subViews.count;i++) {
        
        UIView *subV = subViews[i];
        [self fullData:subV];
        
        if ([subV isKindOfClass:[UITableView class]] ||
            [subV isKindOfClass:[UICollectionView class]]) {
            continue;
        }
        
        if ([subV isKindOfClass:[UILabel class]]) {
            UILabel *lab = (UILabel *)subV;
            if (lab.text == nil || [lab.text isEqualToString:@""]) {
                if (lab.numberOfLines == 1) {
                    lab.text = kShortDataString;
                }else {
                    lab.text = kLongDataString;
                }
            }
        }else {
            if ([subV isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)subV;
                if (btn.titleLabel.text == nil && btn.imageView.image == nil) {
                    [btn setTitle:kShortDataString forState:UIControlStateNormal];
                }
            }
        }
    }
}

+ (void)resetData:(UIView *)view {
    
    if ([view isKindOfClass:[UITableView class]] ||
        [view isKindOfClass:[UICollectionView class]]) {
        return;
    }
    
    NSArray *subViews = [view subviews];
    if ([subViews count] == 0) {
        return;
    }
    
    for (int i = 0; i < subViews.count;i++) {
        
        UIView *subV = subViews[i];
        [self resetData:subV];
        
        if ([subV isKindOfClass:[UILabel class]]) {
            UILabel *lab = (UILabel *)subV;
            if ([lab.text isEqualToString:kLongDataString] ||
                [lab.text isEqualToString:kShortDataString]) {
                lab.text = @"";
            }
        }else {
            if ([subV isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)subV;
                if ([btn.titleLabel.text isEqualToString:kLongDataString] ||
                    [btn.titleLabel.text isEqualToString:kShortDataString]) {
                    [btn setTitle:@"" forState:UIControlStateNormal];
                }
            }
        }
    }
}

+ (void)getNeedAnimationSubViews:(UIView *)view
                   withSuperView:(UIView *)superView
                    withRootView:(UIView *)rootView
               withRootSuperView:(UIView *)rootSuperView
                    isInNestView:(BOOL)isInNestView
                           array:(NSMutableArray <TABComponentLayer *> *)array {
    
    NSArray *subViews = [view subviews];
    if ([subViews count] == 0) {
        return;
    }
    
    if (view.tabComponentManager == nil
        && rootSuperView.tabComponentManager &&
        ![view isKindOfClass:[UIButton class]]
        && ![view isKindOfClass:[UITableViewCell class]]
        && ![view isKindOfClass:[UICollectionViewCell class]]) {
//        view.tabComponentManager = TABComponentManager.new;
        CALayer *layer = CALayer.new;
        layer.name = @"TABLayer";
        CGRect rect = [rootView convertRect:view.frame fromView:view.superview];
        layer.frame = rect;
        layer.backgroundColor = view.backgroundColor.CGColor;
        layer.shadowOffset = view.layer.shadowOffset;
        layer.shadowColor = view.layer.shadowColor;
        layer.shadowRadius = view.layer.shadowRadius;
        layer.shadowOpacity = view.layer.shadowOpacity;
        layer.cornerRadius = view.layer.cornerRadius;
        [rootSuperView.tabComponentManager.tabLayer addSublayer:layer];
    }
    
    for (int i = 0; i < subViews.count;i++) {
        
        UIView *subV = subViews[i];
        
        if (subV.tabAnimated.isNest &&
            ![subV isEqual:rootSuperView]) {
            rootView.tabComponentManager.nestView = subV;
            
            CGRect cutRect = [rootView convertRect:subV.frame fromView:subV.superview];
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:rootView.bounds];
            [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:cutRect cornerRadius:0.]bezierPathByReversingPath]];
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.path = path.CGPath;
            [rootView.tabComponentManager.tabLayer setMask:shapeLayer];
            
            isInNestView = YES;
        }
        
        [self getNeedAnimationSubViews:subV
                         withSuperView:subV.superview
                          withRootView:rootView
                     withRootSuperView:rootSuperView
                          isInNestView:isInNestView
                                 array:array];

        // remove lineView for the cell created by xib
        if ([subV isKindOfClass:[NSClassFromString(@"_UITableViewCellSeparatorView") class]]) {
            [subV removeFromSuperview];
        }
        
        if (isInNestView) {
            break;
        }
        
        if ([subV.superview isKindOfClass:[UITableViewCell class]] ||
            [subV.superview isKindOfClass:[UICollectionViewCell class]]) {
            if (i == 0) {
                continue;
            }
        }
        
        if ([TABManagerMethod judgeViewIsNeedAddAnimation:subV]) {
            
            TABComponentLayer *layer = TABComponentLayer.new;

            if (!CGSizeEqualToSize(subV.layer.shadowOffset, CGSizeMake(0, -3))) {
                rootView.tabComponentManager.cardOffset = CGPointMake(rootView.bounds.origin.x - subV.frame.origin.x, rootView.bounds.origin.y - subV.frame.origin.y);
                rootView.tabComponentManager.tabLayer.frame = subV.frame;
                rootView.tabComponentManager.tabLayer.shadowOffset = subV.layer.shadowOffset;
                rootView.tabComponentManager.tabLayer.shadowColor = subV.layer.shadowColor;
                rootView.tabComponentManager.tabLayer.shadowRadius = subV.layer.shadowRadius;
                rootView.tabComponentManager.tabLayer.shadowOpacity = subV.layer.shadowOpacity;
                rootView.tabComponentManager.tabLayer.cornerRadius = subV.layer.cornerRadius;
                rootView.tabComponentManager.tabLayer.masksToBounds = YES;
                continue;
            }
            
            CGRect rect = [rootView convertRect:subV.frame fromView:subV.superview];
            layer.cornerRadius = subV.layer.cornerRadius;
            layer.frame = rect;
            
            if ([subV isKindOfClass:[UILabel class]]) {
                UILabel *lab = (UILabel *)subV;
                
                if (lab.textAlignment == NSTextAlignmentCenter) {
                    layer.fromCenterLabel = YES;
                }else {
                    layer.fromCenterLabel = NO;
                }
                
                if (lab.numberOfLines == 0 || lab.numberOfLines > 1) {
                    layer.numberOflines = lab.numberOfLines;
                }else {
                    layer.numberOflines = 1;
                }
            }else {
                layer.fromCenterLabel = NO;
                layer.numberOflines = 1;
            }
            
            if ([subV isKindOfClass:[UIImageView class]]) {
                layer.fromImageView = YES;
            }else {
                layer.fromImageView = NO;
            }
            
            [array addObject:layer];
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
        
        if (subV.tabAnimated) {
            [subV tab_endAnimation];
        }
    }
}

+ (BOOL)judgeViewIsNeedAddAnimation:(UIView *)view {
    
    if ([view isKindOfClass:[UICollectionView class]] ||
        [view isKindOfClass:[UITableView class]]) {
        return NO;
    }
    
    // 将UIButton中的UILabel移除动画队列
    if ([view.superview isKindOfClass:[UIButton class]]) {
        return NO;
    }
    
    if ([view isKindOfClass:[UIButton class]]) {
        // UIButtonLabel has one subLayer.
        if (view.layer.sublayers.count >= 1) {
            return YES;
        }else {
            return NO;
        }
    }else {
        
        if (view.layer.sublayers.count == 0) {
            return YES;
        }else {
            if ([view isKindOfClass:[UILabel class]] ||
                [view isKindOfClass:[UIImageView class]]) {
                return YES;
            }else {
                if ([view isKindOfClass:[UIView class]] && !CGSizeEqualToSize(view.layer.shadowOffset, CGSizeMake(0, -3))) {
                    return YES;
                }
            }
            return NO;
        }
    }
}

+ (BOOL)canAddShimmer:(UIView *)view {
    
    if (view.tabAnimated.superAnimationType == TABViewSuperAnimationTypeShimmer) {
        return YES;
    }
    
    if ([TABAnimated sharedAnimated].animationType == TABAnimationTypeShimmer &&
        view.tabAnimated.superAnimationType == TABViewSuperAnimationTypeDefault) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)canAddBinAnimation:(UIView *)view {
    
    if (view.tabAnimated.superAnimationType == TABViewSuperAnimationTypeBinAnimation) {
        return YES;
    }
    
    if ([TABAnimated sharedAnimated].animationType == TABAnimationTypeBinAnimation &&
        view.tabAnimated.superAnimationType == TABViewSuperAnimationTypeDefault) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)canAddDropAnimation:(UIView *)view {
    
    if (view.tabAnimated.superAnimationType == TABViewSuperAnimationTypeDrop) {
        return YES;
    }
    
    if ([TABAnimated sharedAnimated].animationType == TABAnimationTypeDrop &&
        view.tabAnimated.superAnimationType == TABViewSuperAnimationTypeDefault) {
        return YES;
    }
    
    return NO;
}

+ (void)removeAllTABLayersFromView:(UIView *)view {
    
    NSArray *subViews = [view subviews];
    if ([subViews count] == 0) {
        return;
    }
    
    for (int i = 0; i < subViews.count; i++) {
        
        UIView *v = subViews[i];
        [self removeAllTABLayersFromView:v];
        
        if (v.layer.sublayers.count > 0) {
            NSArray<CALayer *> *subLayers = v.layer.sublayers;
            [self removeSubLayers:subLayers];
        }
    }
    
    [self removeMask:view];
}

+ (void)removeMask:(UIView *)view {
    
    if (view.tabComponentManager.tabLayer) {
        [view.tabComponentManager.tabLayer removeFromSuperlayer];
    }
    
    [view.layer removeAnimationForKey:kTABAlphaAnimation];
    [view.layer removeAnimationForKey:kTABLocationAnimation];
    [view.layer removeAnimationForKey:kTABShimmerAnimation];
    [view.layer removeAnimationForKey:kTABDropAnimation];
}

+ (void)removeSubLayers:(NSArray *)subLayers {
    
    NSArray <CALayer *> *removedLayers = [subLayers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return YES;
    }]];
    
    [removedLayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
    }];
}


@end
