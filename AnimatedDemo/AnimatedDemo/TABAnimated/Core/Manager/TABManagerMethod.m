//
//  TABManagerMethod.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/2/21.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import "TABManagerMethod.h"

#import "TABAnimated.h"
#import "TABComponentLayer.h"

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

+ (void)hiddenAllView:(UIView *)view {
    
    NSArray *subViews = [view subviews];
    if ([subViews count] == 0) {
        return;
    }
    
    for (int i = 0; i < subViews.count;i++) {
        
        UIView *subV = subViews[i];
        [self hiddenAllView:subV];
        
        if (CGSizeEqualToSize(subV.layer.shadowOffset, CGSizeMake(0, -3))) {
            subV.hidden = YES;
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

        CALayer *layer = CALayer.new;
        layer.name = @"TABLayer";
        CGRect rect = [rootView convertRect:view.frame
                                   fromView:view.superview];
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
            
            CGRect cutRect = [rootView convertRect:subV.frame
                                          fromView:subV.superview];
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:rootView.bounds];
            [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:cutRect
                                                         cornerRadius:0.]bezierPathByReversingPath]];
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
        
        // 标记移除：生成动画对象，但是会被设置为移除状态
        BOOL needRemove = NO;
        
        // 分割线需要标记移除
        if ([subV isKindOfClass:[NSClassFromString(@"_UITableViewCellSeparatorView") class]] ||
            [subV isKindOfClass:[NSClassFromString(@"_UITableViewHeaderFooterContentView") class]] ||
            [subV isKindOfClass:[NSClassFromString(@"_UITableViewHeaderFooterViewBackground") class]]) {
            needRemove = YES;
        }
        
        // 通过过滤条件标记移除移除
        if (rootSuperView.tabAnimated.filterSubViewSize.width > 0) {
            if (subV.frame.size.width <= rootSuperView.tabAnimated.filterSubViewSize.width) {
                needRemove = YES;
            }
        }
        
        if (rootSuperView.tabAnimated.filterSubViewSize.height > 0) {
            if (subV.frame.size.height <= rootSuperView.tabAnimated.filterSubViewSize.height) {
                needRemove = YES;
            }
        }
        
        // 彻底移除：不生成动画对象
        // 移除默认的contentView
        if ([subV.superview isKindOfClass:[UITableViewCell class]] ||
            [subV.superview isKindOfClass:[UICollectionViewCell class]]) {
            if (i == 0) {
                continue;
            }
        }
        
        // 移除UITableView/UICollectionView的滚动条
        if ([view isKindOfClass:[UIScrollView class]]) {
            if (((subV.frame.size.height < 3.) || (subV.frame.size.width < 3.)) &&
                subV.alpha == 0.) {
                continue;
            }
        }
        
        if (isInNestView) {
            break;
        }
        
        if ([TABManagerMethod judgeViewIsNeedAddAnimation:subV]) {
            
            TABComponentLayer *layer = TABComponentLayer.new;
            
            if (needRemove) {
                layer.loadStyle = TABViewLoadAnimationRemove;
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
        // 判断view为tableview/collectionview时，若有设置骨架动画，则返回NO；否则返回YES，允许设置绘制骨架图
        if (view.tabAnimated) {
            return NO;
        }else {
            return YES;
        }
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

+ (void)runAnimationWithSuperView:(UIView *)superView
                       targetView:(UIView *)targetView
                          section:(NSInteger)section
                           isCell:(BOOL)isCell
                          manager:(TABComponentManager *)manager {
    
    if (superView.tabAnimated.state == TABViewAnimationStart &&
        [superView.tabAnimated currentSectionIsAnimatingWithSection:section] &&
        !targetView.tabComponentManager.isLoad) {
        
        NSMutableArray <TABComponentLayer *> *array = @[].mutableCopy;
        // start animations
        [TABManagerMethod getNeedAnimationSubViews:targetView
                                     withSuperView:superView
                                      withRootView:targetView
                                 withRootSuperView:superView
                                      isInNestView:NO
                                             array:array];
        
        [targetView.tabComponentManager installBaseComponent:array.copy];
        
        if (targetView.tabComponentManager.baseComponentArray.count != 0) {
            __weak typeof(targetView) weakSelf = targetView;
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            if (superView.tabAnimated.categoryBlock) {
                superView.tabAnimated.categoryBlock(weakSelf);
            }
#pragma clang diagnostic pop
            
            if (superView.tabAnimated.adjustBlock) {
                superView.tabAnimated.adjustBlock(weakSelf.tabComponentManager);
            }
            
            if (superView.tabAnimated.adjustWithClassBlock) {
                superView.tabAnimated.adjustWithClassBlock(weakSelf.tabComponentManager, weakSelf.tabComponentManager.tabTargetClass);
            }
        }
        
        [targetView.tabComponentManager updateComponentLayers];
        
        [TABManagerMethod addExtraAnimationWithSuperView:superView
                                              targetView:targetView
                                                 manager:targetView.tabComponentManager];
        
        if (isCell && !targetView.tabComponentManager.nestView) {
            [TABManagerMethod hiddenAllView:targetView];
        }else {
            [TABManagerMethod resetData:targetView];
        }
        targetView.tabComponentManager.isLoad = YES;
        
        if (targetView.tabComponentManager.nestView) {
            [targetView.tabComponentManager.nestView tab_startAnimation];
        }
    }

    // 结束动画
    if (superView.tabAnimated.state == TABViewAnimationEnd) {
        [TABManagerMethod endAnimationToSubViews:targetView];
        [TABManagerMethod removeMask:targetView];
    }
}

+ (void)addExtraAnimationWithSuperView:(UIView *)superView
                            targetView:(UIView *)targetView
                               manager:(TABComponentManager *)manager {
    // add shimmer animation
    if ([TABManagerMethod canAddShimmer:superView]) {
        
        for (NSInteger i = 0; i < manager.resultLayerArray.count; i++) {
            TABComponentLayer *layer = manager.resultLayerArray[i];
            UIColor *baseColor = [TABAnimated sharedAnimated].shimmerBackColor;
            CGFloat brigtness = [TABAnimated sharedAnimated].shimmerBrightness;
            layer.colors = @[
                             (id)baseColor.CGColor,
                             (id)[TABManagerMethod brightenedColor:baseColor brightness:brigtness].CGColor,
                             (id)baseColor.CGColor
                             ];
            [TABAnimationMethod addShimmerAnimationToLayer:layer
                                                  duration:[TABAnimated sharedAnimated].animatedDurationShimmer
                                                       key:TABAnimatedShimmerAnimation
                                                 direction:[TABAnimated sharedAnimated].shimmerDirection];
            
        }
    }
    
    if (!superView.tabAnimated.isNest) {
        
        // add bin animation
        if ([TABManagerMethod canAddBinAnimation:superView]) {
            [TABAnimationMethod addAlphaAnimation:targetView
                                         duration:[TABAnimated sharedAnimated].animatedDurationBin
                                              key:TABAnimatedAlphaAnimation];
        }
        
        // add drop animation
        if ([TABManagerMethod canAddDropAnimation:superView]) {
            
            UIColor *deepColor;
            if (superView.tabAnimated.dropAnimationDeepColor) {
                deepColor = superView.tabAnimated.dropAnimationDeepColor;
            }else {
                deepColor = [TABAnimated sharedAnimated].dropAnimationDeepColor;
            }
            
            CGFloat duration = 0;
            CGFloat cutTime = 0.02;
            CGFloat allCutTime = cutTime*(manager.resultLayerArray.count-1)*(manager.resultLayerArray.count)/2.0;
            if (superView.tabAnimated.dropAnimationDuration != 0.) {
                duration = superView.tabAnimated.dropAnimationDuration;
            }else {
                duration = [TABAnimated sharedAnimated].dropAnimationDuration;
            }
            
            for (NSInteger i = 0; i < manager.resultLayerArray.count; i++) {
                TABComponentLayer *layer = manager.resultLayerArray[i];
                if (layer.removeOnDropAnimation) {
                    continue;
                }
                [TABAnimationMethod addDropAnimation:layer
                                               index:layer.dropAnimationIndex
                                            duration:duration*(manager.dropAnimationCount+1)-allCutTime
                 
                                               count:manager.dropAnimationCount+1
                                            stayTime:layer.dropAnimationStayTime-i*cutTime
                                           deepColor:deepColor
                                                 key:TABAnimatedDropAnimation];
            }
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
        view.tabComponentManager.tabLayer.hidden = YES;
    }
}

+ (void)removeSubLayers:(NSArray *)subLayers {
    
    NSArray <CALayer *> *removedLayers = [subLayers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return YES;
    }]];
    
    [removedLayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
    }];
}

#pragma mark - Private Method

/**
 改变UIColor的亮度
 
 @param color 目标颜色
 @param brightness 亮度
 @return 改变亮度后颜色
 */
+ (UIColor *)brightenedColor:(UIColor *)color
                  brightness:(CGFloat)brightness {
    CGFloat h,s,b,a;
    [color getHue:&h saturation:&s brightness:&b alpha:&a];
    return [UIColor colorWithHue:h saturation:s brightness:b*brightness alpha:a];
}

@end
