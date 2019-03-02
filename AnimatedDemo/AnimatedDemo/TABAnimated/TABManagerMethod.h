//
//  TABManagerMethod.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/2/21.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TABManagerMethod : NSObject

@property (nonatomic,strong,readonly) NSMutableArray <NSMutableArray *> *cacheArray;
@property (nonatomic,strong,readonly) NSMutableArray <NSMutableArray *> *cacheAlignArray;

/**
 SingleTon

 @return self
 */
+ (instancetype)sharedManager;

/**
 缓存boderWidth不为0的view

 @param view superView
 */
- (void)cacheView:(UIView *)view;

/**
 移除缓存的view
 
 @param view superView
 */
- (void)recoverView:(UIView *)view;

+ (BOOL)judgeViewIsNeedAddAnimation:(UIView *)view;

+ (void)managerAnimationSubViewsOfView:(UIView *)superView;

+ (void)endAnimationToSubViews:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
