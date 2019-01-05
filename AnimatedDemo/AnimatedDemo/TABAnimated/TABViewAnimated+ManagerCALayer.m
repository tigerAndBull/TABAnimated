//
//  TABViewAnimated+ManagerCALayer.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/12/28.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "TABViewAnimated+ManagerCALayer.h"
#import "TABAnimationMethod.h"

static CGFloat defaultHeight = 25.f;           // used to label with row is not one
static CGFloat defaultSpaceWithLines = 10.f;   // used to label with row is not one

@implementation TABViewAnimated (ManagerCALayer)

#pragma mark - Remove Layer Methods

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
    
    if (self.animationType == TABAnimationTypeShimmer ||
        self.animationType == TABAnimationTypeCustom) {
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


- (CGFloat)getToValueByViewLoadStyle:(TABViewLoadAnimationStyle)style {
    switch (style) {
        case TABViewLoadAnimationShort:
            return self.shortToValue>0?self.shortToValue:0.6;
            break;
            
        case TABViewLoadAnimationLong:
            return self.longToValue>0?self.longToValue:1.6;
            break;
            
        default:
            return 0.6;
            break;
    }
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
                if (self.animationType == TABAnimationTypeDefault ||
                    superView.superAnimationType == TABViewSuperAnimationTypeClassic) {
                    [layer addAnimation:[TABAnimationMethod scaleXAnimationDuration:self.animatedDuration toValue:[self getToValueByViewLoadStyle:TABViewLoadAnimationShort]] forKey:@"TABScaleAnimation"];
                }
                [lab.layer addSublayer:layer];
                break;
            }
            
            if (i == (lineCount - 1)) {
                if (self.animationType == TABAnimationTypeDefault ||
                    superView.superAnimationType == TABViewSuperAnimationTypeClassic) {
                    [layer addAnimation:[TABAnimationMethod scaleXAnimationDuration:self.animatedDuration toValue:[self getToValueByViewLoadStyle:TABViewLoadAnimationShort]] forKey:@"TABScaleAnimation"];
                }
            }
            
            [lab.layer addSublayer:layer];
        }
    } else {
        
        if (lab.numberOfLines == 2) {
            
            for (int i = 0; i < lab.numberOfLines; i++) {
                
                CALayer *layer = [[CALayer alloc]init];
                layer.backgroundColor = color.CGColor;
                layer.anchorPoint = CGPointMake(0, 0);
                layer.position = CGPointMake(0, 0);
                layer.name = @"TABLayer";
                
                if (self.animationType == TABAnimationTypeDefault ||
                    superView.superAnimationType == TABViewSuperAnimationTypeClassic) {
                    
                    layer.frame = CGRectMake(0, (i == 0)?(0):(i*(textHeight + defaultHeight)), width, textHeight);
                    
                    if (i == (lab.numberOfLines - 1)) {
                        [layer addAnimation:[TABAnimationMethod scaleXAnimationDuration:self.animatedDuration toValue:[self getToValueByViewLoadStyle:TABViewLoadAnimationShort]] forKey:@"TABScaleAnimation"];
                    } else {
                        [layer addAnimation:[TABAnimationMethod scaleXAnimationDuration:self.animatedDuration toValue:[self getToValueByViewLoadStyle:TABViewLoadAnimationLong]] forKey:@"TABScaleAnimation"];
                    }
                }else {
                    
                    if (i == (lab.numberOfLines - 1)) {
                        layer.frame = CGRectMake(0, (i == 0)?(0):(i*(textHeight + defaultHeight)), width*0.6, textHeight);
                    }else {
                        layer.frame = CGRectMake(0, (i == 0)?(0):(i*(textHeight + defaultHeight)), width, textHeight);
                    }
                }
                
                [lab.layer addSublayer:layer];
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
                    
                    if (self.animationType == TABAnimationTypeDefault ||
                        superView.superAnimationType == TABViewSuperAnimationTypeClassic) {
                        
                        layer.frame = CGRectMake(0, (i == 0)?(0):(i*(textHeight+defaultSpaceWithLines)), width, textHeight);
                        
                        // If next layer's maxY is over superView, stop add layer.
                        if ((layer.frame.origin.y+textHeight*2+defaultSpaceWithLines*2) >= CGRectGetMaxY(superView.frame)) {
                            [layer addAnimation:[TABAnimationMethod scaleXAnimationDuration:self.animatedDuration toValue:[self getToValueByViewLoadStyle:TABViewLoadAnimationShort]] forKey:@"TABScaleAnimation"];
                            [lab.layer addSublayer:layer];
                            break;
                        }
                        if (i == (lab.numberOfLines - 1)) {
                            [layer addAnimation:[TABAnimationMethod scaleXAnimationDuration:self.animatedDuration toValue:[self getToValueByViewLoadStyle:TABViewLoadAnimationShort]] forKey:@"TABScaleAnimation"];
                        }
                    }else {
                        if (i == (lab.numberOfLines - 1)) {
                            layer.frame = CGRectMake(0, (i == 0)?(0):(i*(textHeight+defaultSpaceWithLines)), width*0.6, textHeight);
                        }else {
                            layer.frame = CGRectMake(0, (i == 0)?(0):(i*(textHeight+defaultSpaceWithLines)), width, textHeight);
                        }
                    }
                    
                    [lab.layer addSublayer:layer];
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
        
        if (self.animationType == TABAnimationTypeShimmer ||
            self.animationType == TABAnimationTypeOnlySkeleton ||
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

#pragma mark - Init Method

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
                [layer addAnimation:[TABAnimationMethod scaleXAnimationDuration:self.animatedDuration toValue:[self getToValueByViewLoadStyle:view.loadStyle]] forKey:@"TABScaleAnimation"];
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
            [layer addAnimation:[TABAnimationMethod scaleXAnimationDuration:self.animatedDuration toValue:[self getToValueByViewLoadStyle:view.loadStyle]] forKey:@"TABScaleAnimation"];
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
                [layer addAnimation:[TABAnimationMethod scaleXAnimationDuration:self.animatedDuration toValue:[self getToValueByViewLoadStyle:view.loadStyle]] forKey:@"TABScaleAnimation"];
            }
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
            [layer addAnimation:[TABAnimationMethod scaleXAnimationDuration:self.animatedDuration toValue:[self getToValueByViewLoadStyle:view.loadStyle]] forKey:@"TABScaleAnimation"];
        }
        [view.layer addSublayer:layer];
    }
}

@end
