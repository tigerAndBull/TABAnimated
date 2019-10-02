//
//  TABViewAnimated.m
//  lifeAndSport
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "TABAnimated.h"

#import "TABAnimationMethod.h"
#import "TABManagerMethod.h"

#import "UIView+TABAnimated.h"
#import "TableDeDaSelfModel.h"
#import "TABAnimatedDocumentMethod.h"
#import "TABAnimatedCacheManager.h"

#import <objc/runtime.h>

#define tab_kBackColor tab_kColor(0xEEEEEE)
#define tab_kDarkBackColor tab_kColor(0x282828)
#define tab_kShimmerBackColor tab_kColor(0xDFDFDF)

NSString * const TABAnimatedAlphaAnimation = @"TABAlphaAnimation";
NSString * const TABAnimatedLocationAnimation = @"TABLocationAnimation";
NSString * const TABAnimatedShimmerAnimation = @"TABShimmerAnimation";
NSString * const TABAnimatedDropAnimation = @"TABDropAnimation";

@interface TABAnimated()

@property (nonatomic, strong, readwrite) NSMutableArray <TableDeDaSelfModel *> *tableDeDaSelfModelArray;
@property (nonatomic, strong, readwrite) NSMutableArray <CollectionDeDaSelfModel *> *collectionDeDaSelfModelArray;

@property (nonatomic, strong, readwrite) TABAnimatedCacheManager *cacheManager;

@end

@implementation TABAnimated

#pragma mark - Initize Method

+ (TABAnimated *)sharedAnimated {
    static dispatch_once_t token;
    static TABAnimated *tabAnimated;
    dispatch_once(&token, ^{
        tabAnimated = [[TABAnimated alloc] init];
    });
    return tabAnimated;
}

- (instancetype)init {
    if (self = [super init]) {
        
        _tableDeDaSelfModelArray = @[].mutableCopy;
        _collectionDeDaSelfModelArray = @[].mutableCopy;
        
        _animationType = TABAnimationTypeOnlySkeleton;
        [TABAnimatedDocumentMethod createFile:TABCacheManagerFolderName
                                        isDir:YES];
#ifdef DEBUG
        _closeCache = YES;
#endif
        
        _cacheManager = TABAnimatedCacheManager.new;
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.cacheManager install];
        });
    }
    return self;
}

- (void)initWithOnlySkeleton {
    if (self) {
        _animationType = TABAnimationTypeOnlySkeleton;
    }
}

- (void)initWithBinAnimation {
    if (self) {
        _animationType = TABAnimationTypeBinAnimation;
    }
}

- (void)initWithShimmerAnimated {
    if (self) {
        _animationType = TABAnimationTypeShimmer;
        _animatedDurationShimmer = 1.;
        _shimmerDirection = TABShimmerDirectionToRight;
        _shimmerBackColor = tab_kShimmerBackColor;
        _shimmerBrightness = 0.92;
    }
}

- (void)initWithShimmerAnimatedDuration:(CGFloat)duration
                              withColor:(UIColor *)color {
    if (self) {
        _animatedDurationShimmer = duration;
        _animatedColor = color;
        _animationType = TABAnimationTypeShimmer;
        _shimmerDirection = TABShimmerDirectionToRight;
        _shimmerBackColor = tab_kShimmerBackColor;
        _shimmerBrightness = 0.92;
    }
}

- (void)initWithDropAnimated {
    if (self) {
        _animationType = TABAnimationTypeDrop;
    }
}

#pragma mark - Other Method

- (TableDeDaSelfModel *)getTableDeDaModelAboutDeDaSelfWithClassName:(NSString *)className {
    for (TableDeDaSelfModel *model in self.tableDeDaSelfModelArray) {
        if ([model.targetClassName isEqualToString:className]) {
            return model;
        }
    }
    
    TableDeDaSelfModel *newModel = TableDeDaSelfModel.new;
    newModel.targetClassName = className;
    [self.tableDeDaSelfModelArray addObject:newModel];
    return newModel;
}

- (CollectionDeDaSelfModel *)getCollectionDeDaModelAboutDeDaSelfWithClassName:(NSString *)className {
    for (CollectionDeDaSelfModel *model in self.collectionDeDaSelfModelArray) {
        if ([model.targetClassName isEqualToString:className]) {
            return model;
        }
    }
    
    CollectionDeDaSelfModel *newModel = CollectionDeDaSelfModel.new;
    newModel.targetClassName = className;
    [self.collectionDeDaSelfModelArray addObject:newModel];
    return newModel;
}

#pragma mark - Getter / Setter

- (CGFloat)animatedHeightCoefficient {
    if (_animatedHeightCoefficient == 0.) {
        return 0.75f;
    }
    return _animatedHeightCoefficient;
}

- (CGFloat)animatedHeight {
    if (_animatedHeight == 0.) {
        return 12.f;
    }
    return _animatedHeight;
}

- (UIColor *)animatedColor {
    if (_animatedColor) {
        return _animatedColor;
    }
    return tab_kBackColor;
}

- (UIColor *)darkAnimatedColor {
    if (_darkAnimatedColor) {
        return _darkAnimatedColor;
    }
    return tab_kDarkBackColor;
}

- (UIColor *)animatedBackgroundColor {
    if (_animatedBackgroundColor) {
        return _animatedBackgroundColor;
    }
    return UIColor.whiteColor;
}

- (UIColor *)darkAnimatedBackgroundColor {
    if (_darkAnimatedBackgroundColor) {
        return _darkAnimatedBackgroundColor;
    }
    
    if (@available(iOS 13.0, *)) {
        return UIColor.secondarySystemBackgroundColor;
    }
    return UIColor.whiteColor;
}

- (UIColor *)dropAnimationDeepColor {
    if (_dropAnimationDeepColor) {
        return _dropAnimationDeepColor;
    }
    return tab_kColor(0xE1E1E1);
}

- (UIColor *)dropAnimationDeepColorInDarkMode {
    if (_dropAnimationDeepColorInDarkMode) {
        return _dropAnimationDeepColorInDarkMode;
    }
    return tab_kColor(0x323232);
}

- (CGFloat)dropAnimationDuration {
    if (_dropAnimationDuration) {
        return _dropAnimationDuration;
    }
    return 0.4;
}

- (CGFloat)animatedDuration {
    if (_animatedDuration == 0.) {
        return 0.7;
    }
    return _animatedDuration;
}

- (CGFloat)animatedDurationBin {
    if (_animatedDurationBin == 0.) {
        return 1.0;
    }
    return _animatedDurationBin;
}

- (CGFloat)longToValue {
    if (_longToValue == 0.) {
        return 1.9;
    }
    return _longToValue;
}

- (CGFloat)shortToValue {
    if (_shortToValue == 0.) {
        return 0.6;
    }
    return _shortToValue;
}

- (UIColor *)shimmerBackColor {
    if (_shimmerBackColor == nil) {
        return tab_kShimmerBackColor;
    }
    return _shimmerBackColor;
}

- (CGFloat)shimmerBrightness {
    if (_shimmerBrightness == 0.) {
        return 0.92;
    }
    return _shimmerBrightness;
}

- (UIColor *)shimmerBackColorInDarkMode {
    if (_shimmerBackColorInDarkMode == nil) {
        return tab_kDarkBackColor;
    }
    return _shimmerBackColorInDarkMode;
}

- (CGFloat)shimmerBrightnessInDarkMode {
    if (_shimmerBrightnessInDarkMode == 0.) {
        return 0.5;
    }
    return _shimmerBrightnessInDarkMode;
}

- (CGFloat)animatedDurationShimmer {
    if (_animatedDurationShimmer == 0.) {
        return 1.;
    }
    return _animatedDurationShimmer;
}

@end
