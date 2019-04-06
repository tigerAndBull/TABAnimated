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

@interface TABLayer : CALayer

@property (nonatomic,strong) NSMutableArray <NSValue *> *valueArray;
@property (nonatomic,strong) NSMutableArray <NSNumber *> *labelLinesArray;
@property (nonatomic,strong) NSMutableArray <NSNumber *> *cornerRadiusArray;
@property (nonatomic,strong) NSMutableArray <NSNumber *> *judgeImageViewArray;

@property (nonatomic,strong) NSMutableArray <NSNumber *> *tabWidthArray;
@property (nonatomic,strong) NSMutableArray <NSNumber *> *tabHeightArray;

@property (nonatomic,strong) NSMutableArray <NSNumber *> *judgeCenterLabelArray;

@property (nonatomic,assign) CGPoint tempPoint;

@end

NS_ASSUME_NONNULL_END
