//
//  TABTableAnimated.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/4/27.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABTableAnimated.h"

@interface TABTableAnimated()

@property (nonatomic,strong,readwrite) NSMutableArray <Class> *headerClassArray;
@property (nonatomic,strong,readwrite) NSMutableArray <NSNumber *> *headerHeightArray;
@property (nonatomic,strong,readwrite) NSMutableArray <NSNumber *> *headerSectionArray;

@property (nonatomic,strong,readwrite) NSMutableArray <Class> *footerClassArray;
@property (nonatomic,strong,readwrite) NSMutableArray <NSNumber *> *footerHeightArray;
@property (nonatomic,strong,readwrite) NSMutableArray <NSNumber *> *footerSectionArray;

@end

@implementation TABTableAnimated

+ (instancetype)animatedWithCellClass:(Class)cellClass
                           cellHeight:(CGFloat)cellHeight {
    
    TABTableAnimated *obj = [[TABTableAnimated alloc] init];
    obj.cellClassArray = @[cellClass];
    obj.cellHeight = cellHeight;
    obj.animatedCount = ceilf([UIScreen mainScreen].bounds.size.height/cellHeight*1.0);
    return obj;
}

+ (instancetype)animatedWithCellClass:(Class)cellClass
                           cellHeight:(CGFloat)cellHeight
                        animatedCount:(NSInteger)animatedCount {
    TABTableAnimated *obj = [self animatedWithCellClass:cellClass cellHeight:cellHeight];
    obj.animatedCount = animatedCount;
    return obj;
}

+ (instancetype)animatedWithCellClass:(Class)cellClass
                           cellHeight:(CGFloat)cellHeight
                            toSection:(NSInteger)section {
    TABTableAnimated *obj = [self animatedWithCellClass:cellClass cellHeight:cellHeight];
    obj.animatedCountArray = @[@(ceilf([UIScreen mainScreen].bounds.size.height/cellHeight*1.0))];
    obj.animatedSectionArray = @[@(section)];
    return obj;
}

+ (instancetype)animatedWithCellClass:(Class)cellClass
                           cellHeight:(CGFloat)cellHeight
                        animatedCount:(NSInteger)animatedCount
                            toSection:(NSInteger)section {
    TABTableAnimated *obj = [self animatedWithCellClass:cellClass cellHeight:cellHeight];
    obj.animatedCountArray = @[@(animatedCount)];
    obj.animatedSectionArray = @[@(section)];
    return obj;
}

+ (instancetype)animatedWithCellClassArray:(NSArray<Class> *)cellClassArray
                           cellHeightArray:(NSArray<NSNumber *> *)cellHeightArray
                        animatedCountArray:(NSArray<NSNumber *> *)animatedCountArray {
    TABTableAnimated *obj = [[TABTableAnimated alloc] init];
    obj.animatedCountArray = animatedCountArray;
    obj.cellHeightArray = cellHeightArray;
    obj.cellClassArray = cellClassArray;
    return obj;
}

+ (instancetype)animatedWithCellClassArray:(NSArray <Class> *)cellClassArray
                           cellHeightArray:(NSArray <NSNumber *> *)cellHeightArray
                        animatedCountArray:(NSArray <NSNumber *> *)animatedCountArray
                      animatedSectionArray:(NSArray <NSNumber *> *)animatedSectionArray {
    TABTableAnimated *obj = [self animatedWithCellClassArray:cellClassArray
                                             cellHeightArray:cellHeightArray
                                          animatedCountArray:animatedCountArray];
    obj.animatedSectionArray = animatedSectionArray;
    return obj;
}

+ (instancetype)animatedWithCellClass:(Class)cellClass {
    TABTableAnimated *obj = [[TABTableAnimated alloc] init];
    obj.cellClassArray = @[cellClass];
    return obj;
}

- (instancetype)init {
    if (self = [super init]) {
        _runAnimationSectionArray = @[].mutableCopy;
        _animatedSectionCount = 0;
        _animatedCount = 1;
        
        _headerClassArray = @[].mutableCopy;
        _headerHeightArray = @[].mutableCopy;
        _headerSectionArray = @[].mutableCopy;
        
        _footerClassArray = @[].mutableCopy;
        _footerHeightArray = @[].mutableCopy;
        _footerSectionArray = @[].mutableCopy;
    }
    return self;
}

- (void)addHeaderViewClass:(__nonnull Class)headerViewClass
                viewHeight:(CGFloat)viewHeight
                 toSection:(NSInteger)section {
    [_headerClassArray addObject:headerViewClass];
    [_headerHeightArray addObject:@(viewHeight)];
    [_headerSectionArray addObject:@(section)];
}

- (void)addHeaderViewClass:(__nonnull Class)headerViewClass
                viewHeight:(CGFloat)viewHeight {
    [_headerClassArray addObject:headerViewClass];
    [_headerHeightArray addObject:@(viewHeight)];
}

- (void)addFooterViewClass:(__nonnull Class)footerViewClass
                viewHeight:(CGFloat)viewHeight
                 toSection:(NSInteger)section {
    [_footerClassArray addObject:footerViewClass];
    [_footerHeightArray addObject:@(viewHeight)];
    [_footerSectionArray addObject:@(section)];
}

- (void)addFooterViewClass:(__nonnull Class)footerViewClass
                viewHeight:(CGFloat)viewHeight {
    [_footerClassArray addObject:footerViewClass];
    [_footerHeightArray addObject:@(viewHeight)];
}

- (void)setCellHeight:(CGFloat)cellHeight {
    _cellHeight = cellHeight;
    _cellHeightArray = @[[NSNumber numberWithFloat:cellHeight]];
}

- (BOOL)currentSectionIsAnimatingWithSection:(NSInteger)section {
    for (NSNumber *num in self.runAnimationSectionArray) {
        if ([num integerValue] == section) {
            return YES;
        }
    }
    return NO;
}

- (NSInteger)headerNeedAnimationOnSection:(NSInteger)section {
    
    if (self.headerSectionArray.count == 0) {
        return tab_animated_error_code;
    }
    
    for (NSInteger i = 0; i < self.headerSectionArray.count; i++) {
        NSNumber *num = self.headerSectionArray[i];
        if ([num integerValue] == section) {
            return i;
        }
    }
    
    return tab_animated_error_code;
}

- (NSInteger)footerNeedAnimationOnSection:(NSInteger)section {
    
    if (self.footerSectionArray.count == 0) {
        return tab_animated_error_code;
    }
    
    for (NSInteger i = 0; i < self.footerSectionArray.count; i++) {
        NSNumber *num = self.footerSectionArray[i];
        if ([num integerValue] == section) {
            return i;
        }
    }
    
    return tab_animated_error_code;
}

@end
