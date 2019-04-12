//
//  TABManagerMethod.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/2/21.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import "TABManagerMethod.h"

#import "TABLayer.h"
#import "UIView+Animated.h"
#import "TABViewAnimated.h"
#import "UIView+TABControlAnimation.h"

#import "TABAnimatedObject.h"

@implementation TABManagerMethod

+ (void)getNeedAnimationSubViews:(UIView *)view
                   withSuperView:(UIView *)superView
                    withRootView:(UIView *)rootView {
    
    NSArray *subViews = [view subviews];
    if ([subViews count] == 0) {
        return;
    }
    
    for (int i = 0; i < subViews.count;i++) {
        
        UIView *subV = subViews[i];
        [self getNeedAnimationSubViews:subV withSuperView:subV.superview withRootView:rootView];
        
        if ([subV isKindOfClass:[NSClassFromString(@"_UITableViewCellSeparatorView") class]]) {
            [subV removeFromSuperview];
        }
        
        // 如果父视图中嵌套了表格组件，为表格组件开启动画
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
        
        if ([subV.superview isKindOfClass:[UITableViewCell class]] ||
            [subV.superview isKindOfClass:[UICollectionViewCell class]]) {
            // used to can not add animation to contentView
            if (i != 0) {
                if (subV.loadStyle != TABViewLoadAnimationRemove) {
                    subV.loadStyle = TABViewLoadAnimationWithOnlySkeleton;
                }
            }else {
                subV.loadStyle = TABViewLoadAnimationRemove;
            }
        }else {
            if (subV.loadStyle != TABViewLoadAnimationRemove) {
                subV.loadStyle = TABViewLoadAnimationWithOnlySkeleton;
            }
        }
        
        if ((subV.loadStyle == TABViewLoadAnimationWithOnlySkeleton) &&
            [TABManagerMethod judgeViewIsNeedAddAnimation:subV]) {
            
            if (nil == rootView.tabLayer) {
                rootView.tabLayer = TABLayer.new;
                rootView.tabLayer.frame = rootView.bounds;
                [rootView.layer addSublayer:rootView.tabLayer];
            }
            
            [rootView.tabLayer.tabWidthArray addObject:[NSNumber numberWithFloat:subV.tabViewWidth]];
            [rootView.tabLayer.tabHeightArray addObject:[NSNumber numberWithFloat:subV.tabViewHeight]];
            
            CGRect rect = [rootView convertRect:subV.frame fromView:subV.superview];
            [rootView.tabLayer.valueArray addObject:[NSValue valueWithCGRect:rect]];
            
            [rootView.tabLayer.cornerRadiusArray addObject:[NSNumber numberWithFloat:subV.layer.cornerRadius]];
            
            if ([subV isKindOfClass:[UILabel class]]) {
                UILabel *lab = (UILabel *)subV;
                
                if (lab.textAlignment == NSTextAlignmentCenter) {
                    [rootView.tabLayer.judgeCenterLabelArray addObject:@(YES)];
                }else {
                    [rootView.tabLayer.judgeCenterLabelArray addObject:@(NO)];
                }
                
                if (lab.numberOfLines == 0 ||
                    lab.numberOfLines > 1) {
                    if (lab.frame.size.width == 0 ||
                        lab.frame.size.height == 0) {
                        lab.text = @"测试测试测试测试测试测试测试测试测试测试测试测试测试测试";
                    }
                    [rootView.tabLayer.labelLinesArray addObject:@(lab.numberOfLines)];
                }else {
                    if (lab.frame.size.width == 0 ||
                        lab.frame.size.height == 0) {
                        lab.text = @"测试测试测试测试";
                    }
                    [rootView.tabLayer.labelLinesArray addObject:@(1)];
                }
            }else {
                [rootView.tabLayer.judgeCenterLabelArray addObject:@(NO)];
                [rootView.tabLayer.labelLinesArray addObject:@(1)];
            }
            
            if ([subV isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)subV;
                if (btn.frame.size.width == 0 ||
                    btn.frame.size.height == 0) {
                    [btn setTitle:@"测试测试" forState:UIControlStateNormal];
                }
            }
            
            if ([subV isKindOfClass:[UIImageView class]]) {
                [rootView.tabLayer.judgeImageViewArray addObject:@(YES)];
            }else {
                [rootView.tabLayer.judgeImageViewArray addObject:@(NO)];
            }
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
            if (subV.tabAnimated.isAnimating) {
                [subV tab_endAnimation];
            }
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
            if ([view isKindOfClass:[UILabel class]]) {
                return YES;
            }
            return NO;
        }
    }
}

+ (BOOL)canAddShimmer:(UIView *)view {
    
    if (view.tabAnimated.superAnimationType == TABViewSuperAnimationTypeShimmer) {
        return YES;
    }
    
    if ([TABViewAnimated sharedAnimated].animationType == TABAnimationTypeShimmer) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)canAddBinAnimation:(UIView *)view {
    
    if (view.tabAnimated.superAnimationType == TABViewSuperAnimationTypeBinAnimation) {
        return YES;
    }
    
    if ([TABViewAnimated sharedAnimated].animationType == TABAnimationTypeBinAnimation) {
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
    
    [view.layer removeAnimationForKey:@"TABAlphaAnimation"];
    [view.layer removeAnimationForKey:@"TABLocationsAnimation"];
    
    if (view.layer.mask != nil) {
        [view.layer.mask removeFromSuperlayer];
    }
    
    [view.tabLayer removeFromSuperlayer];
}

+ (void)removeSubLayers:(NSArray *)subLayers {
    
    NSArray <CALayer *> *removedLayers = [subLayers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        
        CALayer *layer = (CALayer *)evaluatedObject;
        if ([layer.name isEqualToString:@"TABLayer"]) {
            return YES;
        }
        return NO;
    }]];
    
    [removedLayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
    }];
}


@end
