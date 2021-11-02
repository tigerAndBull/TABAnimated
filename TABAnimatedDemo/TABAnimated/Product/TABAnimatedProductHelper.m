//
//  TABAnimatedProductHelper.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/4/5.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "TABAnimatedProductHelper.h"
#import "TABComponentLayer.h"
#import "TABAnimatedProduction.h"
#import "TABViewAnimated.h"

#import "UIView+TABAnimatedProduction.h"
#import "UIView+TABControlModel.h"
#import "UIView+TABControlAnimation.h"
#import <objc/runtime.h>
#import "UIView+TABAnimated.h"

static NSString * const kShortFillString = @"                "; // 16
static NSString * const kLongFillString = @"                                                "; // 48

static const CGFloat kTagDefaultFontSize = 10.f;
static const CGFloat kTagLabelHeight = 20.f;
static const CGFloat kTagLabelMinWidth = 15.f;

@implementation TABAnimatedProductHelper

+ (void)nameWithInstance:(UIView *)instance
             superObject:(UIView *)superObject {
    unsigned int numIvars = 0;
    NSString *key = nil;
    Ivar *ivars = class_copyIvarList(superObject.class, &numIvars);
    for (int i = 0; i < numIvars; i++) {
        Ivar thisIvar = ivars[i];
        const char *type = ivar_getTypeEncoding(thisIvar);
        NSString *stringType =  [NSString stringWithCString:type encoding:NSUTF8StringEncoding];
        if (![stringType hasPrefix:@"@"]) {
            continue;
        }
        
        UIView *thisObject = object_getIvar(superObject, thisIvar);
        if (thisObject == instance) {
            key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
            if (key && key.length > 0) {
                if ([[key substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"_"]) {
                    thisObject.tab_name = [key substringFromIndex:1];
                }else {
                    thisObject.tab_name = key;
                }
            }
        }
    }
    free(ivars);
}

+ (void)fullDataAndStartNestAnimation:(UIView *)view isHidden:(BOOL)isHidden superView:(UIView *)superView rootView:(UIView *)rootView {
    
    if ([view isKindOfClass:[UITableView class]] ||
        [view isKindOfClass:[UICollectionView class]]) {
        return;
    }
    
    NSArray *subViews = [view subviews];
    if ([subViews count] == 0) {
        return;
    }
    
    for (int i = 0; i < subViews.count; i++) {
        
        UIView *subV = subViews[i];
        
        UIView *targetView;
        if (![NSStringFromClass(subV.class) hasPrefix:@"UI"]) {
            targetView = subV;
        }else {
            targetView = view;
        }
        [self fullDataAndStartNestAnimation:subV isHidden:isHidden superView:targetView rootView:rootView];

        [TABAnimatedProductHelper nameWithInstance:subV superObject:superView];
        
        if ([subV isKindOfClass:[UITableView class]] || [subV isKindOfClass:[UICollectionView class]]) {
            if (subV.tabAnimated) {
                [self cutView:subV rootView:rootView];
                [subV tab_startAnimation];
            }
            continue;
        }
        
        if (isHidden) {
            subV.hidden = YES;
        }
        
        if ([subV isKindOfClass:[UILabel class]] && ![subV isKindOfClass:NSClassFromString(@"UITableViewLabel")]) {
            UILabel *lab = (UILabel *)subV;
            if (lab.text == nil || [lab.text isEqualToString:@""]) {
                if (lab.numberOfLines == 1) {
                    lab.text = kShortFillString;
                }else {
                    lab.text = kLongFillString;
                }
            }
        }else if ([subV isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)subV;
            if (btn.titleLabel.text == nil && btn.imageView.image == nil) {
                [btn setTitle:kShortFillString forState:UIControlStateNormal];
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
    for (int i = 0; i < subViews.count;i++) {
        
        UIView *subV = subViews[i];
        [self resetData:subV];
        
        if ([subV isKindOfClass:[UILabel class]]) {
            UILabel *lab = (UILabel *)subV;
            if ([lab.text isEqualToString:kLongFillString] || [lab.text isEqualToString:kShortFillString]) {
                lab.text = @"";
            }
        }else if ([subV isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)subV;
            if ([btn.titleLabel.text isEqualToString:kLongFillString] || [btn.titleLabel.text isEqualToString:kShortFillString]) {
                [btn setTitle:@"" forState:UIControlStateNormal];
            }
        }
    }
}

+ (BOOL)canProduct:(UIView *)view tabAnimated:(TABViewAnimated *)tabAnimated {
    
    if ([view isKindOfClass:[UICollectionView class]] || [view isKindOfClass:[UITableView class]]) {
        // 判断view为tableview/collectionview时，若有设置骨架动画，则返回NO；否则返回YES，允许设置绘制骨架图
        if (view.tabAnimated) {
            return NO;
        }else {
            return YES;
        }
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
    }else if (view.layer.sublayers.count == 0) {
        return YES;
    }else if ([view isKindOfClass:[UILabel class]] || [view isKindOfClass:[UIImageView class]]) {
        return YES;
    }
    return NO;
}

/**
  填充后行为：
  1. frame兜底
  2. 卡片视图frame处理
  3. 标记过滤，穿透组件
  4. 绑定layer
 */
+ (void)bindView:(UIView *)view production:(TABAnimatedProduction *)production animatedHeight:(CGFloat)animatedHeight {
    
    // 防止不能覆盖底部视图
    if (production.backgroundLayer.
        frame.size.height == 0. && view.layer.bounds.size.height > 0.) {
        production.backgroundLayer.frame = view.layer.bounds;
    }

    if (!production.backgroundLayer.isCard &&
        view.frame.size.width != 0 && production.backgroundLayer.frame.size.width != view.frame.size.width &&
        view.frame.size.height != 0 && production.backgroundLayer.frame.size.height != view.frame.size.height) {
        production.backgroundLayer.frame = CGRectMake(production.backgroundLayer.frame.origin.x, production.backgroundLayer.frame.origin.y, view.frame.size.width, view.frame.size.height);
    }
    
    view.hidden = NO;
    view.layer.cornerRadius = production.backgroundLayer.cornerRadius;
    [view.layer addSublayer:production.backgroundLayer];
    
    UIBezierPath *penetratePath = [UIBezierPath bezierPathWithRect:production.backgroundLayer.bounds];
    BOOL isNeedPenetrate = NO;
    for (NSInteger i = 0; i < production.layers.count; i++) {
        TABComponentLayer *layer = production.layers[i];
        if (layer.loadStyle == TABViewLoadAnimationRemove) continue;
        // 穿透
        if (layer.loadStyle == TABViewLoadAnimationPenetrate) {
            if (!isNeedPenetrate) isNeedPenetrate = YES;
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:layer.originFrame cornerRadius:layer.cornerRadius];
            [penetratePath appendPath:path];
        }
        [production.backgroundLayer addLayer:layer viewWidth:view.frame.size.width animatedHeight:animatedHeight superLayer:production.backgroundLayer];
    }
    
    if (isNeedPenetrate) {
        [self penetrateTargetLayer:production.backgroundLayer path:penetratePath];
    }
    
    production.state = TABAnimatedProductionBind;
    view.tabAnimatedProduction = production;
}

// 填充前
+ (TABComponentLayer *)getBackgroundLayerWithView:(UIView *)view controlView:(UIView *)controlView {
    TABViewAnimated *tabAnimated = controlView.tabAnimated;
    
    UIColor *animatedBackgroundColor = [tabAnimated getCurrentAnimatedBackgroundColorWithCollection:controlView.traitCollection];
    TABComponentLayer *backgroundLayer = TABComponentLayer.new;
    
    if (tabAnimated.animatedBackViewCornerRadius > 0) {
        backgroundLayer.cornerRadius = tabAnimated.animatedBackViewCornerRadius;
    }else if (view.layer.cornerRadius > 0.) {
        backgroundLayer.cornerRadius = view.layer.cornerRadius;
    }else if ([view isKindOfClass:[UITableViewCell class]]) {
        UITableViewCell *cell = (UITableViewCell *)view;
        if (cell.contentView.layer.cornerRadius > 0.) {
            backgroundLayer.cornerRadius = cell.contentView.layer.cornerRadius;
        }
    }else if ([view isKindOfClass:[UICollectionViewCell class]]) {
        UICollectionViewCell *cell = (UICollectionViewCell *)view;
        if (cell.contentView.layer.cornerRadius > 0.) {
            backgroundLayer.cornerRadius = cell.contentView.layer.cornerRadius;
        }
    }
    
    if (view.layer.shadowOpacity > 0.) {
        backgroundLayer.shadowColor = view.layer.shadowColor;
        backgroundLayer.shadowOffset = view.layer.shadowOffset;
        backgroundLayer.shadowRadius = view.layer.shadowRadius;
        backgroundLayer.shadowPath = view.layer.shadowPath;
        backgroundLayer.shadowOpacity = view.layer.shadowOpacity;
        backgroundLayer.frame = view.frame;
    }else if (view.frame.size.width == 0.) {
        backgroundLayer.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, TABAnimatedProductHelperScreenWidth, view.frame.size.height);
    }else {
        backgroundLayer.frame = view.bounds;
    }
    
    backgroundLayer.backgroundColor = animatedBackgroundColor.CGColor;
    return backgroundLayer;
}

+ (void)addTagWithComponentLayer:(TABComponentLayer *)layer isLines:(BOOL)isLines needFrame:(BOOL)needFrame superLayer:(TABComponentLayer *)superLayer {
    
    CATextLayer *textLayer = [CATextLayer layer];
    CGFloat width = layer.frame.size.width > kTagLabelMinWidth ? layer.frame.size.width : kTagLabelMinWidth;
    if (layer.tagName.length > 0) {
        textLayer.string = [NSString stringWithFormat:@"%ld %@", (long)layer.tagIndex, layer.tagName];
    } else {
        textLayer.string = [NSString stringWithFormat:@"%ld", (long)layer.tagIndex];
    }
    
    if (needFrame) {
        textLayer.frame = CGRectMake(layer.frame.origin.x, layer.frame.origin.y, width, kTagLabelHeight);
    }else if (isLines || layer.origin != TABComponentLayerOriginImageView) {
        textLayer.frame = CGRectMake(layer.bounds.origin.x, layer.bounds.origin.y, width, kTagLabelHeight);
    } else {
        textLayer.frame = CGRectMake(0, layer.frame.size.height / 2.0, width, kTagLabelHeight);
    }
    
    if (!needFrame) {
        CGRect resultFrame = [layer convertRect:textLayer.frame toLayer:superLayer];
        textLayer.frame = resultFrame;
    }
    
    textLayer.contentsScale = ([[UIScreen mainScreen] scale] > 3.0) ? [[UIScreen mainScreen] scale] : 3.0;
    textLayer.fontSize = kTagDefaultFontSize;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.foregroundColor = UIColor.redColor.CGColor;
    dispatch_async(dispatch_get_main_queue(), ^{
        [superLayer addSublayer:textLayer];
    });
}

+ (nullable NSString *)getKeyWithControllerName:(NSString *)controllerName targetClass:(Class)targetClass frame:(CGRect)frame {
    if (!controllerName) return nil;
    NSString *classString = tab_NSStringFromClass(targetClass);
    return [NSString stringWithFormat:@"%@_%@_%.2f_%.2f_%.2f_%.2f", controllerName, classString, frame.origin.x, frame.origin.y, frame.size.width, frame.size.height];
}

+ (void)cutView:(UIView *)view rootView:(UIView *)rootView {
    dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), ^{
        CGRect cutRect = [rootView convertRect:view.frame fromView:view.superview];
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:rootView.bounds];
        [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:cutRect cornerRadius:0.] bezierPathByReversingPath]];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        [rootView.tabAnimatedProduction.backgroundLayer setMask:shapeLayer];
    });
}

+ (void)penerateIndexArray:(NSArray <NSNumber *> *)penerateIndexArray production:(TABAnimatedProduction *)production {
    UIBezierPath *penetratePath = [UIBezierPath bezierPathWithRect:production.backgroundLayer.bounds];
    for (NSInteger i = 0; i < penerateIndexArray.count; i++) {
        NSInteger index = [penerateIndexArray[i] integerValue];
        TABComponentLayer *layer = production.layers[index];
        layer.hidden = YES;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:layer.originFrame cornerRadius:layer.cornerRadius];
        [penetratePath appendPath:path];
    }
    [self penetrateTargetLayer:production.backgroundLayer path:penetratePath];
}

+ (void)penetrateTargetLayer:(TABComponentLayer *)targetLayer path:(UIBezierPath *)path {
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    targetLayer.mask = fillLayer;
}

@end
