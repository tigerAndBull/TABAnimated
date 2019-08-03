//
//  TABCollectionAnimated.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/4/27.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABCollectionAnimated.h"

@interface TABCollectionAnimated()

@property (nonatomic,strong,readwrite) NSMutableArray <Class> *headerClassArray;
@property (nonatomic,strong,readwrite) NSMutableArray <NSValue *> *headerSizeArray;
@property (nonatomic,strong,readwrite) NSMutableArray <NSNumber *> *headerSectionArray;

@property (nonatomic,strong,readwrite) NSMutableArray <Class> *footerClassArray;
@property (nonatomic,strong,readwrite) NSMutableArray <NSValue *> *footerSizeArray;
@property (nonatomic,strong,readwrite) NSMutableArray <NSNumber *> *footerSectionArray;

@end

@implementation TABCollectionAnimated

+ (instancetype)animatedWithCellClass:(Class)cellClass
                             cellSize:(CGSize)cellSize {
    TABCollectionAnimated *obj = [[TABCollectionAnimated alloc] init];
    obj.cellClassArray = @[cellClass];
    obj.cellSize = cellSize;
    obj.animatedCount = ceilf([UIScreen mainScreen].bounds.size.height/cellSize.height*1.0);
    return obj;
}

+ (instancetype)animatedWithCellClass:(Class)cellClass
                             cellSize:(CGSize)cellSize
                        animatedCount:(NSInteger)animatedCount {
    TABCollectionAnimated *obj = [self animatedWithCellClass:cellClass cellSize:cellSize];
    obj.animatedCount = animatedCount;
    return obj;
}

+ (instancetype)animatedWithCellClass:(Class)cellClass
                             cellSize:(CGSize)cellSize
                            toSection:(NSInteger)section {
    TABCollectionAnimated *obj = [self animatedWithCellClass:cellClass cellSize:cellSize];
    obj.animatedCountArray = @[@(ceilf([UIScreen mainScreen].bounds.size.height/cellSize.height*1.0))];
    obj.animatedSectionArray = @[@(section)];
    return obj;
}

+ (instancetype)animatedWithCellClass:(Class)cellClass
                             cellSize:(CGSize)cellSize
                        animatedCount:(NSInteger)animatedCount
                            toSection:(NSInteger)section {
    TABCollectionAnimated *obj = [self animatedWithCellClass:cellClass cellSize:cellSize];
    obj.animatedCountArray = @[@(animatedCount)];
    obj.animatedSectionArray = @[@(section)];
    return obj;
}

+ (instancetype)animatedWithCellClassArray:(NSArray <Class> *)cellClassArray
                             cellSizeArray:(NSArray <NSValue *> *)cellSizeArray
                        animatedCountArray:(NSArray <NSNumber *> *)animatedCountArray {
    TABCollectionAnimated *obj = [[TABCollectionAnimated alloc] init];
    obj.animatedCountArray = animatedCountArray;
    obj.cellSizeArray = cellSizeArray;
    obj.cellClassArray = cellClassArray;
    return obj;
}

+ (instancetype)animatedWithCellClassArray:(NSArray <Class> *)cellClassArray
                             cellSizeArray:(NSArray <NSValue *> *)cellSizeArray
                        animatedCountArray:(NSArray <NSNumber *> *)animatedCountArray
                      animatedSectionArray:(NSArray <NSNumber *> *)animatedSectionArray {
    TABCollectionAnimated *obj = [self animatedWithCellClassArray:cellClassArray
                                                    cellSizeArray:cellSizeArray
                                               animatedCountArray:animatedCountArray];
    obj.animatedSectionArray = animatedSectionArray;
    return obj;
}

- (instancetype)init {
    if (self = [super init]) {
        _runAnimationSectionArray = @[].mutableCopy;
        _animatedSectionCount = 0;
        _animatedCount = 1;
        
        _headerSizeArray = @[].mutableCopy;
        _headerClassArray = @[].mutableCopy;
        _headerSectionArray = @[].mutableCopy;
        
        _footerSizeArray = @[].mutableCopy;
        _footerClassArray = @[].mutableCopy;
        _footerSectionArray = @[].mutableCopy;
    }
    return self;
}

- (void)setCellSize:(CGSize)cellSize {
    _cellSize = cellSize;
    _cellSizeArray = @[[NSValue valueWithCGSize:cellSize]];
}

- (BOOL)currentSectionIsAnimatingWithSection:(NSInteger)section {
    for (NSNumber *num in self.runAnimationSectionArray) {
        if ([num integerValue] == section) {
            return YES;
        }
    }
    return NO;
}

- (NSInteger)headerFooterNeedAnimationOnSection:(NSInteger)section
                                           kind:(NSString *)kind {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
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

- (void)addHeaderViewClass:(_Nonnull Class)headerViewClass
                  viewSize:(CGSize)viewSize {
    [_headerClassArray addObject:headerViewClass];
    [_headerSizeArray addObject:@(viewSize)];
}

- (void)addHeaderViewClass:(_Nonnull Class)headerViewClass
                  viewSize:(CGSize)viewSize
                 toSection:(NSInteger)section {
    [_headerClassArray addObject:headerViewClass];
    [_headerSizeArray addObject:@(viewSize)];
    [_headerSectionArray addObject:@(section)];
}

- (void)addFooterViewClass:(_Nonnull Class)footerViewClass
                  viewSize:(CGSize)viewSize {
    [_footerClassArray addObject:footerViewClass];
    [_footerSizeArray addObject:@(viewSize)];
}

- (void)addFooterViewClass:(_Nonnull Class)footerViewClass
                  viewSize:(CGSize)viewSize
                 toSection:(NSInteger)section {
    [_footerClassArray addObject:footerViewClass];
    [_footerSizeArray addObject:@(viewSize)];
    [_footerSectionArray addObject:@(section)];
}

@end
