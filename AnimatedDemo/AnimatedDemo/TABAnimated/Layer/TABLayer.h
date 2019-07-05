//
//  TABLayer.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/3/24.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 * 集成时，该文件开发者不需要关心。
 * 用于管理TABComponentLayer集合
 */

@class TABComponentLayer;

@interface TABLayer : CALayer

@property (nonatomic,strong) UIColor *animatedColor;
@property (nonatomic,strong) UIColor *animatedBackgroundColor;

@property (nonatomic,assign) CGFloat animatedHeight;
@property (nonatomic,assign) CGFloat animatedCornerRadius;
@property (nonatomic,assign) BOOL cancelGlobalCornerRadius;

@property (nonatomic,assign) CGPoint cardOffset;

@property (nonatomic,strong) NSMutableArray <TABComponentLayer *> *resultLayerArray;

@property (nonatomic,strong) NSMutableArray <TABComponentLayer *> *componentLayerArray;

@property (nonatomic,strong) NSMutableArray <NSArray *> *entireIndexArray;

@property (nonatomic,assign,readonly) NSInteger dropAnimationCount;

@property (nonatomic,weak) UIView *nestView;

@property (nonatomic,assign) BOOL isLoad;

- (void)updateSublayers:(NSArray <TABComponentLayer *> *)componentLayerArray;

@end

NS_ASSUME_NONNULL_END
