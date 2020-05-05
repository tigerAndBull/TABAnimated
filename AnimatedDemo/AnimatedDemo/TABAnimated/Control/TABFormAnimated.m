//
//  TABFormAnimated.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/3/5.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "TABFormAnimated.h"
#import <objc/runtime.h>

@interface TABFormAnimated()

@property (nonatomic, assign, readwrite) NSInteger runningCount;

@end

@implementation TABFormAnimated

- (instancetype)init {
    if (self = [super init]) {
        _cellIndexArray = @[].mutableCopy;
        _cellCountArray = @[].mutableCopy;
        _cellClassArray = @[].mutableCopy;
        
        _headerClassArray = @[].mutableCopy;
        _headerSectionArray = @[].mutableCopy;
        _footerClassArray = @[].mutableCopy;
        _footerSectionArray = @[].mutableCopy;
        
        _runIndexDict = @{}.mutableCopy;
    }
    return self;
}

- (void)exchangeDelegate:(UIView *)target {}
- (void)exchangeDataSource:(UIView *)target {}
- (void)registerViewToReuse:(UIView *)view {}
- (void)startAnimationWithIndex:(NSInteger)index isFirstLoad:(BOOL)isFirstLoad controlView:(UIView *)controlView {}

- (void)exchangeDelegateOldSel:(SEL)oldSel newSel:(SEL)newSel target:(id)target delegate:(id)delegate {
    
    if (![delegate respondsToSelector:oldSel]) return;
    
    Class targetClass  = [self class];
    Method newMethod = class_getInstanceMethod(targetClass, newSel);
    if (newMethod == nil) return;
    
    Method oldMethod = class_getInstanceMethod([delegate class], oldSel);
    
    BOOL isVictory = class_addMethod([delegate class], newSel, class_getMethodImplementation([delegate class], oldSel), method_getTypeEncoding(oldMethod));
    if (isVictory) {
        class_replaceMethod([delegate class], oldSel, class_getMethodImplementation(targetClass, newSel), method_getTypeEncoding(newMethod));
    }
}

- (void)setRunningCount:(NSInteger)runningCount {
    _runningCount = runningCount;
    if (runningCount <= 0) {
        self.state = TABViewAnimationEnd;
    }
}

- (void)setCellIndexArray:(NSArray<NSNumber *> *)cellIndexArray {
    _cellIndexArray = cellIndexArray;
    _runningCount = cellIndexArray.count;
}

- (NSInteger)getIndexWithIndexPath:(NSIndexPath *)indexPath {
    NSInteger currentIndex;
    if (self.runMode == TABAnimatedRunBySection) {
        currentIndex = indexPath.section;
    }else {
        currentIndex = indexPath.row;
    }
    return [self getIndexWithIndex:currentIndex];
}

- (NSInteger)getIndexWithIndex:(NSInteger)index {
    return [[self.runIndexDict objectForKey:[self _getStringWIthIndex:index]] integerValue]-1;
}

- (NSInteger)getHeaderIndexWithIndex:(NSInteger)index {
    return [[self.runHeaderIndexDict objectForKey:[self _getStringWIthIndex:index]] integerValue]-1;
}

- (NSInteger)getFooterIndexWithIndex:(NSInteger)index {
    return [[self.runFooterIndexDict objectForKey:[self _getStringWIthIndex:index]] integerValue]-1;
}

- (void)startAnimation {
    NSInteger count = self.cellIndexArray.count;
    for (NSInteger i = 0; i < count; i++) {
        NSInteger index = [self.cellIndexArray[i] integerValue];
        NSInteger value = i+1;
        [self.runIndexDict setValue:@(value) forKey:[self _getStringWIthIndex:index]];
    }
    _runningCount = count;
}

- (void)startAnimationWithIndex:(NSInteger)index {
    NSInteger value = [self getIndexWithIndex:index];
    if (value < -1) {
        _runningCount ++;
        value -= TABAnimatedIndexTag;
        [self.runIndexDict setValue:@(value) forKey:[self _getStringWIthIndex:index]];
    }
}

- (void)endAnimation {
    self.runningCount = 0;
    [self.runIndexDict removeAllObjects];
    [self.runHeaderIndexDict removeAllObjects];
    [self.runFooterIndexDict removeAllObjects];
}

- (void)endAnimationWithIndex:(NSInteger)index {
    if ([self _endWithIndex:index]) {
        self.runningCount--;
        [self _endHeaderWithIndex:index];
        [self _endFooterWithIndex:index];
    }
}

- (NSString *)getStringWIthIndex:(NSInteger)index {
    return [self _getStringWIthIndex:index];
}

- (NSString *)_getStringWIthIndex:(NSInteger)index {
    return [NSString stringWithFormat:@"%ld",index];
}

- (BOOL)_endWithIndex:(NSInteger)index {
    NSInteger value = [self getIndexWithIndex:index];
    if (value < -1) {
        return NO;
    }
    value += TABAnimatedIndexTag;
    [self.runIndexDict setValue:@(value) forKey:[self _getStringWIthIndex:index]];
    return YES;
}

- (void)_endHeaderWithIndex:(NSInteger)index {
    NSInteger value = [self getHeaderIndexWithIndex:index];
    if (value < -1) {
        return;
    }
    value += TABAnimatedIndexTag;
    [self.runHeaderIndexDict setValue:@(value) forKey:[self _getStringWIthIndex:index]];
}

- (void)_endFooterWithIndex:(NSInteger)index {
    NSInteger value = [self getFooterIndexWithIndex:index];
    if (value < -1) {
        return;
    }
    value += TABAnimatedIndexTag;
    [self.runFooterIndexDict setValue:@(value) forKey:[self _getStringWIthIndex:index]];
}

#pragma mark -

- (NSMutableDictionary *)runHeaderIndexDict {
    if (!_runHeaderIndexDict) {
        _runHeaderIndexDict = @{}.mutableCopy;
    }
    return _runHeaderIndexDict;
}

- (NSMutableDictionary *)runFooterIndexDict {
    if (!_runFooterIndexDict) {
        _runFooterIndexDict = @{}.mutableCopy;
    }
    return _runFooterIndexDict;
}

@end
