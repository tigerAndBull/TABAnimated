//
//  TABViewAnimated+ManagerCALayer.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/12/28.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "TABManagerMethod+ManagerCALayer.h"
#import "TABAnimationMethod.h"
#import "TABViewAnimated.h"

static CGFloat defaultHeight = 20.f;                     // used to label with row is not one.
static CGFloat defaultSpaceWithLines = 8.f;              // used to label with row is not one.

@implementation TABManagerMethod (ManagerCALayer)

#pragma mark - Remove Layer Methods

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
    if ([TABViewAnimated sharedAnimated].animationType == TABAnimationTypeShimmer ||
        [TABViewAnimated sharedAnimated].animationType == TABAnimationTypeCustom) {
        if (view.layer.mask != nil) {
            [view.layer.mask removeFromSuperlayer];
        }
    }
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

+ (void)addLinesLabAnimated:(UILabel *)lab
                  withColor:(UIColor *)color
              withSuperView:(UIView *)superView
                  withWidth:(CGFloat)width
       withIsCollectionView:(BOOL)isCollectionView {
    
    CGFloat textHeight = [lab.text sizeWithAttributes:@{NSFontAttributeName:lab.font}].height*[TABViewAnimated sharedAnimated].animatedHeightCoefficient;
    
    if (lab.numberOfLines == 0) {
        
        NSInteger lineCount = (superView.frame.size.height - (CGRectGetMinY(lab.frame) - CGRectGetMinY(superView.frame)))/(defaultHeight+defaultSpaceWithLines);
        
        for (int i = 0; i < lineCount; i++) {
            
            CALayer *layer = [[CALayer alloc]init];
            layer.backgroundColor = color.CGColor;
            layer.anchorPoint = CGPointMake(0, 0);
            layer.position = CGPointMake(0, 0);
            layer.name = @"TABLayer";
            
            if (i == lineCount - 1) {
                layer.frame = CGRectMake(0, (i == 0)?(0):(i*(textHeight+defaultSpaceWithLines)), width*0.5, textHeight);
            }else {
                layer.frame = CGRectMake(0, (i == 0)?(0):(i*(textHeight+defaultSpaceWithLines)), width, textHeight);
            }
            
            if (lab.textAlignment == NSTextAlignmentCenter) {
                layer.position = CGPointMake((lab.frame.size.width - layer.frame.size.width)/2.0, 0);
            }
            
            // If next layer's maxY is over superView, stop add layer.
            if ((layer.frame.origin.y+textHeight*2+defaultSpaceWithLines) >= CGRectGetMaxY(superView.frame)) {
                if ([TABViewAnimated sharedAnimated].animationType == TABAnimationTypeDefault ||
                    superView.superAnimationType == TABViewSuperAnimationTypeClassic) {
                    
                     [layer addAnimation:[TABAnimationMethod scaleXAnimationDuration:[TABViewAnimated sharedAnimated].animatedDuration viewLoadStyle:TABViewLoadAnimationShort]
                                  forKey:@"TABScaleAnimation"];
                }
                [lab.layer addSublayer:layer];
                break;
            }
            
            if (i == (lineCount - 1)) {
                if ([TABViewAnimated sharedAnimated].animationType == TABAnimationTypeDefault ||
                    superView.superAnimationType == TABViewSuperAnimationTypeClassic) {
                    
                    [layer addAnimation:[TABAnimationMethod scaleXAnimationDuration:[TABViewAnimated sharedAnimated].animatedDuration viewLoadStyle:TABViewLoadAnimationShort]
                                 forKey:@"TABScaleAnimation"];
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
                
                if ([TABViewAnimated sharedAnimated].animationType == TABAnimationTypeDefault ||
                    superView.superAnimationType == TABViewSuperAnimationTypeClassic) {
                    
                    layer.frame = CGRectMake(0, (i == 0)?(0):(i*(textHeight + defaultHeight)), width, textHeight);
                    
                    if (i == (lab.numberOfLines - 1)) {
                        
                        [layer addAnimation:[TABAnimationMethod scaleXAnimationDuration:[TABViewAnimated sharedAnimated].animatedDuration viewLoadStyle:TABViewLoadAnimationShort]
                                     forKey:@"TABScaleAnimation"];
                    } else {
                        
                        [layer addAnimation:[TABAnimationMethod scaleXAnimationDuration:[TABViewAnimated sharedAnimated].animatedDuration viewLoadStyle:TABViewLoadAnimationLong]
                                     forKey:@"TABScaleAnimation"];
                    }
                }else {
                    
                    if (i == (lab.numberOfLines - 1)) {
                        layer.frame = CGRectMake(0, (i == 0)?(0):(i*(textHeight + defaultHeight)), width*0.5, textHeight);
                    }else {
                        layer.frame = CGRectMake(0, (i == 0)?(0):(i*(textHeight + defaultHeight)), width, textHeight);
                    }
                }
                
                switch (lab.textAlignment) {
                    case NSTextAlignmentLeft:
                        layer.position = CGPointMake(0, 0);
                        break;
                        
                    case NSTextAlignmentCenter:
                        layer.position = CGPointMake((lab.frame.size.width - layer.frame.size.width)/2.0, 0);
                        break;
                        
                    case NSTextAlignmentRight:
                        layer.position = CGPointMake(lab.frame.size.width - layer.frame.size.width, 0);
                        break;
                    default:
                        break;
                }
                
                [lab.layer addSublayer:layer];
            }
        }else {
            
            if (lab.numberOfLines > 2) {
                
                // If the number of row exceeds four,I will use four.
                for (int i = 0; i < lab.numberOfLines; i++) {
                    
                    CALayer *layer = [[CALayer alloc]init];
                    layer.backgroundColor = color.CGColor;
                    layer.anchorPoint = CGPointMake(0, 0);
                    layer.position = CGPointMake(0, 0);
                    layer.name = @"TABLayer";
                    
                    if ([TABViewAnimated sharedAnimated].animationType == TABAnimationTypeDefault ||
                        superView.superAnimationType == TABViewSuperAnimationTypeClassic) {
                        
                        layer.frame = CGRectMake(0, (i == 0)?(0):(i*(textHeight+defaultSpaceWithLines)), width, textHeight);
                        
                        // If next layer's maxY is over superView, stop add layer.
                        if ((layer.frame.origin.y+textHeight*2+defaultSpaceWithLines*2) >= CGRectGetMaxY(superView.frame)) {
                            
                            [layer addAnimation:[TABAnimationMethod scaleXAnimationDuration:[TABViewAnimated sharedAnimated].animatedDuration viewLoadStyle:TABViewLoadAnimationShort]
                                         forKey:@"TABScaleAnimation"];
                            
                            [lab.layer addSublayer:layer];
                            break;
                        }
                        if (i == (lab.numberOfLines - 1)) {
                            
                            [layer addAnimation:[TABAnimationMethod scaleXAnimationDuration:[TABViewAnimated sharedAnimated].animatedDuration viewLoadStyle:TABViewLoadAnimationShort]
                                         forKey:@"TABScaleAnimation"];
                        }
                    }else {
                        if (i == (lab.numberOfLines - 1)) {
                            layer.frame = CGRectMake(0, (i == 0)?(0):(i*(textHeight+defaultSpaceWithLines)), width*0.5, textHeight);
                        }else {
                            layer.frame = CGRectMake(0, (i == 0)?(0):(i*(textHeight+defaultSpaceWithLines)), width, textHeight);
                        }
                    }
                    
                    switch (lab.textAlignment) {
                        case NSTextAlignmentCenter:
                            layer.position = CGPointMake((lab.frame.size.width - layer.frame.size.width)/2.0, 0);
                            break;
                        default:
                            break;
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
+ (CGRect)changeFrameWithView:(UIView *)view
                withSuperView:(UIView *)superView {
    
    CGRect rect = CGRectZero;
    CGFloat height;
    
    // 如果没有高度
    if (view.frame.size.height == 0.) {
        // 同时没有设置动画时高度
        if (view.tabViewHeight == 0.) {
            height = defaultHeight;
        }else {
            height = view.tabViewHeight;
        }
    }else {
        if (view.tabViewHeight != 0.) {
            height = view.tabViewHeight;
        }else {
            if ([view isKindOfClass:[UIImageView class]]) {
                height = view.frame.size.height;
            }else {
                height = view.frame.size.height*[TABViewAnimated sharedAnimated].animatedHeightCoefficient;
            }
        }
    }
    
    // If the view's width is zero,set up it's width.
    // 如果组件宽度为0，则设置默认宽度
    if (view.frame.size.width == 0) {
        
        CGFloat viewX = view.frame.origin.x;                    // animation view's x
        CGFloat superViewWidth = superView.frame.size.width;    // super view's width
        
        CGFloat longAimatedWidth;                               // storage view's width which to long
        CGFloat shortAimatedWidth;                              // storage view's width which to short
        
        if ([TABViewAnimated sharedAnimated].animationType == TABAnimationTypeShimmer ||
            [TABViewAnimated sharedAnimated].animationType == TABAnimationTypeOnlySkeleton ||
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
            
            if (view.loadStyle == TABViewLoadAnimationLong) {
                rect = CGRectMake(0, 0, view.frame.size.width*0.8, height);
            }else {
                rect = CGRectMake(0, 0, view.frame.size.width, height);
            }
        }
    }
    
    return rect;
}

+ (CGFloat)changeFrameWithLabOfLines:(UILabel *)lab
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
+ (void)initLayerWithView:(UIView *)view
            withSuperView:(UIView *)superView
                withColor:(UIColor *)color {

    // adaptive the label with row is not one
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *lab = (UILabel *)view;
        
        if ([TABViewAnimated sharedAnimated].isRemoveLabelText) {
            lab.text = @"";
        }
        
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
            layer.anchorPoint = CGPointMake(0, 0);
            layer.position = CGPointMake(0, 0);
            layer.frame = [self changeFrameWithView:view withSuperView:superView];

            UILabel *lab = (UILabel *)view;
            switch (lab.textAlignment) {
                case NSTextAlignmentLeft:
                    layer.position = CGPointMake(0, 0);
                    break;
                    
                case NSTextAlignmentCenter:
                    layer.position = CGPointMake((view.frame.size.width - view.tabViewWidth)/2.0, 0);
                    break;
                    
                case NSTextAlignmentRight:
                    layer.position = CGPointMake(view.frame.size.width - view.tabViewWidth, 0);
                    break;
                default:
                    break;
            }
            
            layer.backgroundColor = color.CGColor;
            layer.name = @"TABLayer";
            
            if (view.loadStyle != TABViewLoadAnimationWithOnlySkeleton) {
                
                [layer addAnimation:[TABAnimationMethod scaleXAnimationDuration:[TABViewAnimated sharedAnimated].animatedDuration viewLoadStyle:view.loadStyle]
                             forKey:@"TABScaleAnimation"];
            }
            
            [view.layer addSublayer:layer];
        }
        
    } else {
        
        // add a layer with animation.
        // 添加动画图层
        CALayer *layer = [[CALayer alloc]init];
        layer.anchorPoint = CGPointMake(0, 0);
        layer.position = CGPointMake(0, 0);
        layer.frame = [self changeFrameWithView:view withSuperView:superView];
        layer.backgroundColor = color.CGColor;
        layer.name = @"TABLayer";
        
        if (view.loadStyle != TABViewLoadAnimationWithOnlySkeleton) {
            
            [layer addAnimation:[TABAnimationMethod scaleXAnimationDuration:[TABViewAnimated sharedAnimated].animatedDuration viewLoadStyle:view.loadStyle]
                         forKey:@"TABScaleAnimation"];
        }
        
        [view.layer addSublayer:layer];
        
        if ([TABViewAnimated sharedAnimated].isRemoveButtonTitle) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)view;
                [btn setTitle:@"" forState:UIControlStateNormal];
            }
        }
        
        if ([TABViewAnimated sharedAnimated].isUseTemplate) {
            if ([view isKindOfClass:[UIImageView class]]) {
                view.layer.masksToBounds = YES;
            }
        }
        
        if ([TABViewAnimated sharedAnimated].isRemoveImageViewImage) {
            if ([view isKindOfClass:[UIImageView class]]) {
                UIImageView *img = (UIImageView *)view;
                img.image = nil;
            }
        }
    }
}

@end
