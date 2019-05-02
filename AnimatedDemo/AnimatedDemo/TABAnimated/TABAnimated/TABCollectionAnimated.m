//
//  TABCollectionAnimated.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/4/27.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABCollectionAnimated.h"

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
    TABCollectionAnimated *obj = [[TABCollectionAnimated alloc] init];
    obj.cellClassArray = @[cellClass];
    obj.cellSize = cellSize;
    obj.animatedCount = animatedCount;
    return obj;
}

+ (instancetype)animatedWithCellClassArray:(NSArray<Class> *)cellClassArray
                             cellSizeArray:(NSArray<NSNumber *> *)cellSizeArray
                        animatedCountArray:(NSArray<NSNumber *> *)animatedCountArray {
    
    TABCollectionAnimated *obj = [[TABCollectionAnimated alloc] init];
    obj.animatedCountArray = animatedCountArray;
    obj.cellSizeArray = cellSizeArray;
    obj.cellClassArray = cellClassArray;
    return obj;
}

- (void)setCellSize:(CGSize)cellSize {
    _cellSize = cellSize;
    _cellSizeArray = @[[NSValue valueWithCGSize:cellSize]];
}

@end
