//
//  TABViewAnimated.m
//  lifeAndSport
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "TABViewAnimated.h"

#import "TABMethod.h"

#import "UIView+Animated.h"
#import "UITableView+Animated.h"
#import "UICollectionView+Animated.h"

#import <objc/runtime.h>

static CGFloat defaultDuration = 0.4f;
static CGFloat defaultHeight = 25.f;           // used to label with row is not one
static CGFloat defaultSpaceWithLines = 10.f;   // used to label with row is not one

@interface TABViewAnimated () {
    @private
    NSMutableArray *layerArray;
}

@end

@implementation TABViewAnimated

#pragma mark - Methods of starting and ending Animations

- (void)startOrEndViewAnimated:(UIView *)view {
    
    switch (view.animatedStyle) {
            
        case TABViewAnimationStart:
            // change status
            view.animatedStyle = TABViewAnimationRunning;
            // start animations
            if (_animationType != TABAnimationTypeCustom) {
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
            if (_animationType != TABAnimationTypeCustom) {
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
            if (_animationType != TABAnimationTypeCustom) {
                [self getNeedAnimationSubViewsOfCollectionView:cell withSuperView:superView];
            }else {
                if (superView.superAnimationType != TABViewSuperAnimationTypeDefault) {
                    [self getNeedAnimationSubViewsOfCollectionView:cell withSuperView:superView];
                }
            }
            
            break;
            
        case TABCollectionViewAnimationEnd:
            
            // remove layers
            for (int i = 0; i < layerArray.count; i++) {
                CALayer *layer = layerArray[i];
                [layer removeFromSuperlayer];
            }
            [layerArray removeAllObjects];
            
            if (_animationType == TABAnimationTypeShimmer ||
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
        
        if ((_animationType == TABAnimationTypeShimmer) ||
            (_animationType == TABAnimationTypeOnlySkeleton) ||
            (superView.superAnimationType == TABViewSuperAnimationTypeShimmer) ||
            (superView.superAnimationType == TABViewSuperAnimationTypeOnlySkeleton)) {
            
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
            [self initLayerWithView:subV withSuperView:subV.superview withColor:_animatedColor];
        }
        
        if ((_animationType == TABAnimationTypeShimmer) ||
            (superView.superAnimationType == TABViewSuperAnimationTypeShimmer)) {
            if (![superView isKindOfClass:[UIButton class]]) {
                if ([subV isEqual:[subViews lastObject]]) {
                    [self shimmerAnimation:subV.superview];
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
        
        if ((_animationType == TABAnimationTypeShimmer) ||
            (_animationType == TABAnimationTypeOnlySkeleton) ||
            (superView.superAnimationType == TABViewSuperAnimationTypeShimmer) ||
            (superView.superAnimationType == TABViewSuperAnimationTypeOnlySkeleton)) {
            
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
            [self initLayerWithView:subV withSuperView:subV.superview withColor:_animatedColor];
        }
        
        if ((_animationType == TABAnimationTypeShimmer) ||
            (superView.superAnimationType == TABViewSuperAnimationTypeShimmer)) {
            if (![subV.superview isKindOfClass:[UIButton class]]) {
                if ([subV isEqual:[subViews lastObject]]) {
                    [self shimmerAnimation:subV.superview];
                }
            }
        }
    }
}

- (void)getNeedAnimationSubViewsOfCollectionView:(UIView *)view
                                   withSuperView:(UIView *)superView{
    
    NSArray *subViews = [view subviews];
    
    if ([subViews count] == 0) {
        return;
    }
    
    for (int i = 0; i < subViews.count;i++) {
        
        UIView *subV = subViews[i];
        
        [self getNeedAnimationSubViewsOfCollectionView:subV withSuperView:subV.superview];
        
        if (_animationType == TABAnimationTypeShimmer ||
            _animationType == TABAnimationTypeOnlySkeleton ||
            (superView.superAnimationType == TABViewSuperAnimationTypeShimmer) ||
            (superView.superAnimationType == TABViewSuperAnimationTypeOnlySkeleton)) {
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
            [self initLayerWithCollectionView:subV withSuperView:subV.superview withColor:_animatedColor];
        }
        
        if (_animationType == TABAnimationTypeShimmer ||
            (superView.superAnimationType == TABViewSuperAnimationTypeShimmer)) {
            if (![subV.superview isKindOfClass:[UIButton class]]) {
                if ([subV isEqual:[subViews lastObject]]) {
                    [self shimmerAnimation:subV.superview];
                }
            }
        }
    }
}

- (void)removeAllTABLayersFromView:(UIView *)view {
    
    NSArray *subViews = [view subviews];
    
    if ([subViews count] == 0) {
        return;
    }
    
    for (int i = 0; i < subViews.count; i++) {
        
        UIView *v = subViews[i];
        [self removeAllTABLayersFromView:v];
        
        if ( v.layer.sublayers.count > 0 ) {
            
            NSArray<CALayer *> *subLayers = v.layer.sublayers;
            [self removeSubLayers:subLayers];
        }
    }
    
    if (_animationType == TABAnimationTypeShimmer ||
        _animationType == TABAnimationTypeCustom) {
        if (view.layer.mask != nil) {
            [view.layer.mask removeFromSuperlayer];
        }
    }
}

- (void)removeSubLayers:(NSArray *)subLayers {
    
    NSArray<CALayer *> *removedLayers = [subLayers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        
        if ([evaluatedObject isKindOfClass:[CALayer class]]) {
            // remove CAlayers by name
            CALayer *layer = (CALayer *)evaluatedObject;
            if ([layer.name isEqualToString:@"TABLayer"]) {
                return YES;
            }
            return NO;
        }
        return NO;
    }]];
    
    [removedLayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
    }];
}

- (void)addLinesLabAnimated:(UILabel *)lab
                  withColor:(UIColor *)color
              withSuperView:(UIView *)superView
                  withWidth:(CGFloat)width
       withIsCollectionView:(BOOL)isCollectionView {
    
    CGFloat textHeight = [lab.text sizeWithAttributes:@{NSFontAttributeName:lab.font}].height*0.9;
    
    if (lab.numberOfLines == 0 ) {
        
        NSInteger lineCount = (superView.frame.size.height - (CGRectGetMinY(lab.frame) - CGRectGetMinY(superView.frame)))/(defaultHeight+defaultSpaceWithLines);
        
        for (int i = 0; i < ((lineCount > 4)?4:lineCount); i++) {
            
            CALayer *layer = [[CALayer alloc]init];
            layer.backgroundColor = color.CGColor;
            layer.anchorPoint = CGPointMake(0, 0);
            layer.position = CGPointMake(0, 0);
            layer.name = @"TABLayer";
            layer.frame = CGRectMake(0, (i == 0)?(0):(i*(textHeight+defaultSpaceWithLines)), width, textHeight);
            
            // If next layer's maxY is over superView, stop add layer.
            if ((layer.frame.origin.y+textHeight*2+defaultSpaceWithLines) >= CGRectGetMaxY(superView.frame)) {
                if (_animationType != TABAnimationTypeShimmer ||
                    superView.superAnimationType != TABAnimationTypeShimmer) {
                    [layer addAnimation:[self scaleXAnimation:TABViewLoadAnimationShort] forKey:@"TABScaleAnimation"];
                }
                [lab.layer addSublayer:layer];
            
                if (isCollectionView) {
                    [layerArray addObject:layer];
                }
                break;
            }
            
            if (i == (lineCount - 1)) {
                if (_animationType != TABAnimationTypeShimmer ||
                    superView.superAnimationType != TABAnimationTypeShimmer) {
                    [layer addAnimation:[self scaleXAnimation:TABViewLoadAnimationShort] forKey:@"TABScaleAnimation"];
                }
            }
            
            [lab.layer addSublayer:layer];
            
            if (isCollectionView) {
                [layerArray addObject:layer];
            }
        }
    } else {
        
        if (lab.numberOfLines == 2) {
            
            for (int i = 0; i < lab.numberOfLines; i++) {
                
                CALayer *layer = [[CALayer alloc]init];
                layer.backgroundColor = color.CGColor;
                layer.anchorPoint = CGPointMake(0, 0);
                layer.position = CGPointMake(0, 0);
                layer.name = @"TABLayer";
                
                if (_animationType != TABAnimationTypeShimmer ||
                    superView.superAnimationType != TABAnimationTypeShimmer) {
                    
                    layer.frame = CGRectMake(0, (i == 0)?(0):(i*(textHeight + defaultHeight)), width, textHeight);
                    
                    if (i == (lab.numberOfLines - 1)) {
                        [layer addAnimation:[self scaleXAnimation:TABViewLoadAnimationShort] forKey:@"TABScaleAnimation"];
                    } else {
                        [layer addAnimation:[self scaleXAnimation:TABViewLoadAnimationLong] forKey:@"TABScaleAnimation"];
                    }
                }else {
                    
                    if (i == (lab.numberOfLines - 1)) {
                        layer.frame = CGRectMake(0, (i == 0)?(0):(i*(textHeight + defaultHeight)), width*0.6, textHeight);
                    }else {
                        layer.frame = CGRectMake(0, (i == 0)?(0):(i*(textHeight + defaultHeight)), width, textHeight);
                    }
                }
                
                [lab.layer addSublayer:layer];
                
                if (isCollectionView) {
                    [layerArray addObject:layer];
                }
            }
        }else {
            
            if (lab.numberOfLines > 2) {
                
                // If the number of row exceeds four,I will use four.
                for (int i = 0; i < ((lab.numberOfLines > 4)?4:lab.numberOfLines); i++) {
                    
                    CALayer *layer = [[CALayer alloc]init];
                    layer.backgroundColor = color.CGColor;
                    layer.anchorPoint = CGPointMake(0, 0);
                    layer.position = CGPointMake(0, 0);
                    layer.name = @"TABLayer";
                    
                    if (_animationType == TABAnimationTypeDefault ||
                        superView.superAnimationType == TABViewSuperAnimationTypeClassic) {
                        
                        layer.frame = CGRectMake(0, (i == 0)?(0):(i*(textHeight+defaultSpaceWithLines)), width, textHeight);
                        
                        // If next layer's maxY is over superView, stop add layer.
                        if ((layer.frame.origin.y+textHeight*2+defaultSpaceWithLines*2) >= CGRectGetMaxY(superView.frame)) {
                            [layer addAnimation:[self scaleXAnimation:TABViewLoadAnimationShort] forKey:@"TABScaleAnimation"];
                            [lab.layer addSublayer:layer];
                            break;
                        }
                        if (i == (lab.numberOfLines - 1)) {
                            [layer addAnimation:[self scaleXAnimation:TABViewLoadAnimationShort] forKey:@"TABScaleAnimation"];
                        }
                    }else {
                        if (i == (lab.numberOfLines - 1)) {
                            layer.frame = CGRectMake(0, (i == 0)?(0):(i*(textHeight+defaultSpaceWithLines)), width*0.6, textHeight);
                        }else {
                            layer.frame = CGRectMake(0, (i == 0)?(0):(i*(textHeight+defaultSpaceWithLines)), width, textHeight);
                        }
                    }
                    
                    [lab.layer addSublayer:layer];
                    
                    if (isCollectionView) {
                        [layerArray addObject:layer];
                    }
                }
            }
        }
    }
}

/**
 Adaptive animation length
 自适应动画长度

 @param view 需要动画的view
 */
- (CGRect)changeFrameWithView:(UIView *)view
              withSuperView:(UIView *)superView {
    
    CGRect rect;
    CGFloat height;
    
    if (view.frame.size.height == 0.) {
        
        if (view.tabViewHeight == 0.) {
            height = 20.;
        }else {
            height = view.tabViewHeight;
        }
    }else {
        
        if (view.tabViewHeight != 0.) {
            height = view.tabViewHeight;
        }else {
            height = view.frame.size.height;
        }
    }
    
    // If the view's width is zero,set up it's width.
    // 如果组件宽度为0，则设置默认宽度
    if (view.frame.size.width == 0) {
        
        CGFloat viewX = view.frame.origin.x;                    // animation view's x
        CGFloat superViewWidth = superView.frame.size.width;    // super view's width
        
        CGFloat longAimatedWidth;                               // storage view's width which to long
        CGFloat shortAimatedWidth;                              // storage view's width which to short
        
        if (_animationType == TABAnimationTypeShimmer ||
            _animationType == TABAnimationTypeOnlySkeleton ||
            (superView.superAnimationType == TABViewSuperAnimationTypeOnlySkeleton) ||
            (superView.superAnimationType == TABViewSuperAnimationTypeShimmer)) {
            longAimatedWidth = (superViewWidth - viewX)*0.9;
        }else {
            longAimatedWidth = (superViewWidth - viewX)*0.7;
        }
        shortAimatedWidth = (superViewWidth - viewX)*0.5;
        
        if (view.loadStyle == TABViewLoadAnimationShort) {
            rect = CGRectMake(0, 0, view.tabViewWidth>0?view.tabViewWidth:longAimatedWidth, height);
        }else {
            if (view.loadStyle == TABViewLoadAnimationLong) {
                rect = CGRectMake(0, 0, view.tabViewWidth>0?view.tabViewWidth:shortAimatedWidth, height);
            }else {
                if (view.tabViewWidth > 0) {
                    rect = CGRectMake(0, 0, view.tabViewWidth, height);
                }else {
                    rect = CGRectMake(0, 0, longAimatedWidth, height);
                }
            }
        }
    }else {

        if (view.tabViewWidth > 0) {
            rect = CGRectMake(0, 0, view.tabViewWidth, height);
        }else {
            rect = CGRectMake(0, 0, view.frame.size.width, height);
        }
    }
    return rect;
}

- (CGFloat)changeFrameWithLabOfLines:(UILabel *)lab
                    withSuperView:(UIView *)superView {

    CGFloat width;
    // If the view's width is zero,set up it's width.
    // 如果组件宽度为0，则设置默认宽度
    if (lab.frame.size.width == 0) {

        CGFloat superViewX = superView.frame.origin.x;          // super view's x
        CGFloat viewX = lab.frame.origin.x;                     // animation view's width
        CGFloat superViewWidth = superView.frame.size.width;    // super view's width

        CGFloat aimatedWidth;                                   // storage view's width

        aimatedWidth = (superViewWidth - (viewX - superViewX))*0.9;
        width = (lab.tabViewWidth>0?lab.tabViewWidth:aimatedWidth);
        
    }else {
        if (lab.tabViewWidth > 0) {
            width = lab.tabViewWidth;
        }else {
            width = lab.frame.size.width;
        }
    }
    return width;
}

#pragma mark - Create Animation Methods

/**
 根据动画类型设置对应基础动画
 
 @param style 动画类型
 @return 动画
 */
- (CABasicAnimation *)scaleXAnimation:(TABViewLoadAnimationStyle)style {
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    anim.removedOnCompletion = NO;        // 保证从前台进入后台仍能执行
    anim.duration = _animatedDuration;
    anim.autoreverses = YES;              // 往返都有动画
    anim.repeatCount = HUGE_VALF;         // 执行次数
    
    switch (style) {
            
        case TABViewLoadAnimationShort:{
            anim.toValue = (_shortToValue == 0.)?@0.6:@(_shortToValue);
        }
        break;
            
        case TABViewLoadAnimationLong:{
            anim.toValue = (_longToValue == 0.)?@1.6:@(_longToValue);
        }
        break;
            
        default:{
            anim.toValue = @0.6;
        }
    }
    
    return anim;
}

- (void)shimmerAnimation:(UIView *)superView {
    
    // 创建渐变效果的layer
    CAGradientLayer *graLayer = [CAGradientLayer layer];
    graLayer.frame = superView.bounds;
    graLayer.name = @"TABLayer";
    
    graLayer.colors = @[
//                        (__bridge id)[[UIColor whiteColor]colorWithAlphaComponent:0.95].CGColor,
                        (__bridge id)[[UIColor whiteColor]colorWithAlphaComponent:0.90].CGColor,
                        (__bridge id)[[UIColor whiteColor]colorWithAlphaComponent:0.70].CGColor,
                        (__bridge id)[[UIColor whiteColor]colorWithAlphaComponent:0.50].CGColor,
                        (__bridge id)[[UIColor whiteColor]colorWithAlphaComponent:0.40].CGColor,
                        (__bridge id)[[UIColor whiteColor]colorWithAlphaComponent:0.40].CGColor,
                        (__bridge id)[[UIColor whiteColor]colorWithAlphaComponent:0.50].CGColor,
                        (__bridge id)[[UIColor whiteColor]colorWithAlphaComponent:0.70].CGColor,
                        (__bridge id)[[UIColor whiteColor]colorWithAlphaComponent:0.90].CGColor,
//                        (__bridge id)[[UIColor whiteColor]colorWithAlphaComponent:0.95].CGColor,
                         ];
    
    graLayer.startPoint = CGPointMake(0, 0.6);        // 设置渐变方向起点
    graLayer.endPoint = CGPointMake(1, 1);            // 设置渐变方向终点
    
    graLayer.locations = @[
//                           @(0),
                           @(0.3),
                           @(0.33),
                           @(0.36),
                           @(0.39),
                           @(0.42),
                           @(0.45),
                           @(0.48),
                           @(0.50),
//                           @(1)
                           ];                         // colors中各颜色对应的初始渐变点
    
    // 创建动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"locations"];
    animation.duration = (_animatedDurationShimmer > 0.)?_animatedDurationShimmer:1.5f;

    animation.fromValue = @[
//                            @(0-0.5),
                            @(0.3-0.5),
                            @(0.33-0.5),
                            @(0.36-0.5),
                            @(0.39-0.5),
                            @(0.42-0.5),
                            @(0.45-0.5),
                            @(0.48-0.5),
                            @(0.50-0.5),
//                            @(1)
                            ];

    animation.toValue = @[
//                          @(0+0.5),
                          @(0.3+0.5),
                          @(0.33+0.5),
                          @(0.36+0.5),
                          @(0.39+0.5),
                          @(0.42+0.5),
                          @(0.45+0.5),
                          @(0.48+0.5),
                          @(0.50+0.5),
//                          @(1+0.5)
                          ];
    
    animation.removedOnCompletion = NO;
    animation.repeatCount = HUGE_VALF;
    animation.fillMode = kCAFillModeForwards;
    [graLayer addAnimation:animation forKey:@"TABLocationsAnimation"];
    
    // 将graLayer设置成superView的遮罩
    superView.layer.mask = graLayer;
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
    
    self = [super init];
    
    if (self) {
        _animatedDuration = defaultDuration;
        _animatedColor = tab_kBackColor;
        _animationType = TABAnimationTypeDefault;
        self->layerArray = [NSMutableArray array];
    }
    return self;
}

- (void)initWithDefaultAnimated {
    _animatedDuration = defaultDuration;
    _animatedColor = tab_kBackColor;
    _animationType = TABAnimationTypeDefault;
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

/**
 加载CALayer,设置动画,同时启动
 
 @param view 需要动画的view
 @param color 动画颜色
 */
- (void)initLayerWithView:(UIView *)view
            withSuperView:(UIView *)superView
                withColor:(UIColor *)color {
    
    // adaptive the label with row is not one
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *lab = (UILabel *)view;
        if (lab.numberOfLines != 1) {
            
            [self addLinesLabAnimated:lab
                            withColor:color
                        withSuperView:superView
                             withWidth:[self changeFrameWithLabOfLines:lab withSuperView:superView]
                 withIsCollectionView:NO];
        } else {
            
            // add a layer with animation.
            // 添加动画图层
            CALayer *layer = [[CALayer alloc]init];
            layer.frame = [self changeFrameWithView:view withSuperView:superView];
            layer.backgroundColor = color.CGColor;
            layer.anchorPoint = CGPointMake(0, 0);
            layer.position = CGPointMake(0, 0);
            layer.name = @"TABLayer";
            
            if (view.loadStyle != TABViewLoadAnimationWithOnlySkeleton) {
                [layer addAnimation:[self scaleXAnimation:view.loadStyle] forKey:@"TABScaleAnimation"];
            }
            
            [view.layer addSublayer:layer];
        }
        
    } else {
        
        // add a layer with animation.
        // 添加动画图层
        CALayer *layer = [[CALayer alloc]init];
        layer.frame = [self changeFrameWithView:view withSuperView:superView];
        layer.backgroundColor = color.CGColor;
        layer.anchorPoint = CGPointMake(0, 0);
        layer.position = CGPointMake(0, 0);
        layer.name = @"TABLayer";
        
        if (view.loadStyle != TABViewLoadAnimationWithOnlySkeleton) {
            [layer addAnimation:[self scaleXAnimation:view.loadStyle] forKey:@"TABScaleAnimation"];
        }
        
        [view.layer addSublayer:layer];
    }
}


/**
 仅用于UICollectionView
 加载CALayer,设置动画,同时启动
 
 @param view 需要动画的view
 @param color 动画颜色
 */
- (void)initLayerWithCollectionView:(UIView *)view
                      withSuperView:(UIView *)superView
                          withColor:(UIColor *)color {
    
    
    // adaptive the label with row is not one
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *lab = (UILabel *)view;
        if (lab.numberOfLines != 1) {
            
            [self addLinesLabAnimated:lab
                            withColor:color
                        withSuperView:superView
                            withWidth:[self changeFrameWithLabOfLines:lab withSuperView:superView]
                 withIsCollectionView:YES];
        } else {
            
            // add a layer with animation.
            // 添加动画图层
            CALayer *layer = [[CALayer alloc]init];
            layer.frame = [self changeFrameWithView:view withSuperView:superView];
            layer.backgroundColor = color.CGColor;
            layer.anchorPoint = CGPointMake(0, 0);
            layer.position = CGPointMake(0, 0);
            layer.name = @"TABLayer";
            
            if (view.loadStyle != TABViewLoadAnimationWithOnlySkeleton) {
                [layer addAnimation:[self scaleXAnimation:view.loadStyle] forKey:@"TABScaleAnimation"];
            }
            [layerArray addObject:layer];
            [view.layer addSublayer:layer];
        }
        
    }else {
        
        // add a layer with animation.
        // 添加动画图层
        CALayer *layer = [[CALayer alloc]init];
        layer.frame = [self changeFrameWithView:view withSuperView:superView];
        layer.backgroundColor = color.CGColor;
        layer.anchorPoint = CGPointMake(0, 0);
        layer.position = CGPointMake(0, 0);
        layer.name = @"TABLayer";
        
        if (view.loadStyle != TABViewLoadAnimationWithOnlySkeleton) {
            [layer addAnimation:[self scaleXAnimation:view.loadStyle] forKey:@"TABScaleAnimation"];
        }
        [layerArray addObject:layer];
        [view.layer addSublayer:layer];
    }
}

@end
