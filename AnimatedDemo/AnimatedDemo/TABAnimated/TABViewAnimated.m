//
//  TABViewAnimated.m
//  lifeAndSport
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "TABViewAnimated.h"
#import "TABMethod.h"
#import "UITableView+Animated.h"

@implementation TABViewAnimated

+ (void)startOrEndAnimated:(UITableViewCell *)cell {
    
    UITableView *superView = (UITableView *)cell.superview;
    
    switch (superView.animatedStyle) {
            
        case TABTableViewAnimationStart:
            
            //添加并开启动画
            for (int i = 0; i < cell.contentView.subviews.count; i++) {
                UIView *v = cell.contentView.subviews[i];
                if ( v.loadStyle != TABViewLoadAnimationDefault ) {
                    [TABViewAnimated initLayerWithView:v withColor:kBackColor];
                }
            }
            break;
            
        case TABTableViewAnimationEnd:
            
            if ( cell.contentView.subviews.count > 0 ) {
                
                //移除动画图层
                for (int i = 0; i < cell.contentView.subviews.count; i++) {
                    
                    UIView *v = cell.contentView.subviews[i];
                    
                    if ( v.layer.sublayers.count > 0 ) {
                        
                        NSArray<CALayer *> *subLayers = v.layer.sublayers;
                        NSArray<CALayer *> *removedLayers = [subLayers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                            
                            if ([evaluatedObject isKindOfClass:[CALayer class]]) {
                                
                                //找出CALayer是你需要移除的，这里根据背景色来判断的
                                CALayer *layer = (CALayer *)evaluatedObject;
                                if (CGColorEqualToColor(layer.backgroundColor,kBackColor.CGColor)) {
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
                }
            }
            break;
            
        default:
            break;
    }
}

+ (void)initLayerWithView:(UIView *)view withColor:(UIColor *)color {
    
    CALayer *layer = [[CALayer alloc]init];
    layer.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    layer.backgroundColor = kBackColor.CGColor;
    layer.anchorPoint = CGPointMake(0, 0);
    layer.position = CGPointMake(0, 0);
    // 添加一个基本动画
    [layer addAnimation:[self scaleXAnimation:view.loadStyle] forKey:@"scaleAnimation"];
    
    [view.layer addSublayer:layer];
}

+ (CABasicAnimation *)scaleXAnimation:(TABViewLoadAnimationStyle)style {
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    anim.removedOnCompletion = NO;
    anim.duration = 0.4;
    anim.autoreverses = YES;  //往返都有动画
    anim.repeatCount = MAXFLOAT;  //执行次数
    
    switch (style) {
            
        case TABViewLoadAnimationShort:{
            anim.toValue = @0.6;
        }
        break;
            
        case TABViewLoadAnimationLong:{
            anim.toValue = @1.6;
        }
        break;
            
        default:{
            anim.toValue = @0.6;
        }
    }
    
    return anim;
}

@end
