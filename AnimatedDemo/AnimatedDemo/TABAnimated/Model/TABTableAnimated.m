//
//  TABTableAnimated.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/4/27.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABTableAnimated.h"

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

+ (instancetype)animatedWithCellClassArray:(NSArray<Class> *)cellClassArray
                           cellHeightArray:(NSArray<NSNumber *> *)cellHeightArray
                        animatedCountArray:(NSArray<NSNumber *> *)animatedCountArray {
    
    TABTableAnimated *obj = [[TABTableAnimated alloc] init];
    obj.animatedCountArray = animatedCountArray;
    NSInteger result = 0;
    for (NSNumber *num in animatedCountArray) {
        NSInteger count = [num integerValue];
        result += count;
    }
    obj.animatedCount = result;
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

- (void)setCellHeight:(CGFloat)cellHeight {
    _cellHeight = cellHeight;
    _cellHeightArray = @[[NSNumber numberWithFloat:cellHeight]];
}

@end
