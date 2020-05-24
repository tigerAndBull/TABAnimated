//
//  TABFormAnimated.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/3/5.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "TABFormAnimated.h"
#import "TABAnimatedCacheManager.h"
#import "TABAnimated.h"
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
        
        _scrollEnabled = YES;
    }
    return self;
}

- (void)exchangeDelegate:(UIView *)target {}
- (void)exchangeDataSource:(UIView *)target {}
- (void)registerViewToReuse:(UIView *)view {}
- (void)refreshWithIndex:(NSInteger)index controlView:(UIView *)controlView {}

- (BOOL)prepareDataWithIndex:(NSInteger)index isFirstLoad:(BOOL)isFirstLoad controlView:(UIView *)controlView {
    
    if (!isFirstLoad && index == TABAnimatedIndexTag && self.runningCount > 0) {
        return NO;
    }
    
    if (isFirstLoad) {
        if (self.runIndexDict.count == 0) return NO;
        [self registerViewToReuse:controlView];
        [self exchangeDelegate:controlView];
        [self exchangeDataSource:controlView];
    }else if (index == TABAnimatedIndexTag) {
        [self reloadAnimation];
    }else if (![self reloadAnimationWithIndex:index]) {
        return NO;
    }
    
    if (self.runIndexDict.count == 0) return NO;
    
    if (self.animatedSectionCount > 0 && self.runIndexDict.count == 1) {
        for (NSInteger i = 1; i < self.animatedSectionCount; i++) {
            [self.runIndexDict setValue:@(0) forKey:[self getStringWIthIndex:i]];
        }
    }
    
    self.isAnimating = YES;
    self.state = TABViewAnimationStart;
    
    return YES;
}

- (void)startAnimationWithIndex:(NSInteger)index isFirstLoad:(BOOL)isFirstLoad controlView:(UIView *)controlView {
    if ([self prepareDataWithIndex:index isFirstLoad:isFirstLoad controlView:controlView]) {
        [self refreshWithIndex:index controlView:controlView];
        [self updateLoadCount];
    }
}

- (void)updateLoadCount {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[TABAnimatedCacheManager shareManager] updateCacheModelLoadCountWithFormAnimated:self];
    });
}

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

#pragma mark -

- (BOOL)getIndexIsRuning:(NSInteger)index {
    if ([self getIndexWithIndex:index dict:self.runIndexDict] >= 0) {
        return YES;
    }
    return NO;
}

- (NSInteger)getIndexWithIndex:(NSInteger)index {
    return [self getIndexWithIndex:index dict:self.runIndexDict];
}

- (NSInteger)getHeaderIndexWithIndex:(NSInteger)index {
    return [self getIndexWithIndex:index dict:self.runHeaderIndexDict];
}

- (NSInteger)getFooterIndexWithIndex:(NSInteger)index {
    return [self getIndexWithIndex:index dict:self.runFooterIndexDict];
}

- (NSInteger)getIndexWithIndex:(NSInteger)index dict:(NSMutableDictionary *)dict {
    NSString *key = [self _getStringWIthIndex:index];
    if (![[dict allKeys] containsObject:key]) return -1;
    return [[dict objectForKey:key] integerValue];
}

#pragma mark -

- (void)reloadAnimation {
    for (NSString *key in self.runIndexDict.allKeys) {
        [self reloadAnimationWithKey:key];
    }
}

- (BOOL)reloadAnimationWithIndex:(NSInteger)index {
    return [self reloadAnimationWithKey:[self _getStringWIthIndex:index]];
}

- (BOOL)reloadAnimationWithKey:(NSString *)key {
    if ([self _reloadWithKey:key resultDict:self.runIndexDict]) {
        [self _reloadWithKey:key resultDict:self.runHeaderIndexDict];
        [self _reloadWithKey:key resultDict:self.runFooterIndexDict];
        self.runningCount++;
        return YES;
    }
    return NO;
}

#pragma mark -

- (void)endAnimation {
    for (NSString *key in self.runIndexDict.allKeys) {
        [self endAnimationWithKey:key];
    }
}

- (BOOL)endAnimationWithIndex:(NSInteger)index {
    return [self endAnimationWithKey:[self _getStringWIthIndex:index]];
}

- (BOOL)endAnimationWithKey:(NSString *)key {
    if ([self _endWithKey:key resultDict:self.runIndexDict]) {
        [self _endWithKey:key resultDict:self.runHeaderIndexDict];
        [self _endWithKey:key resultDict:self.runFooterIndexDict];
        self.runningCount--;
        return YES;
    }
    return NO;
}

#pragma mark -

- (NSString *)getStringWIthIndex:(NSInteger)index {
    return [self _getStringWIthIndex:index];
}

- (NSString *)_getStringWIthIndex:(NSInteger)index {
    return [NSString stringWithFormat:@"%ld",index];
}

#pragma mark -

- (BOOL)_reloadWithIndex:(NSInteger)index resultDict:(NSMutableDictionary *)resultDict {
    return [self _reloadWithKey:[self _getStringWIthIndex:index] resultDict:resultDict];
}

- (BOOL)_reloadWithKey:(NSString *)key resultDict:(NSMutableDictionary *)resultDict {
    if (![[resultDict allKeys] containsObject:key]) return NO;
    NSInteger value = [[resultDict objectForKey:key] integerValue];
    if (value >= 0) {
        return NO;
    }
    value -= TABAnimatedIndexTag;
    [resultDict setValue:@(value) forKey:key];
    return YES;
}

- (BOOL)_endWithIndex:(NSInteger)index resultDict:(NSMutableDictionary *)resultDict {
    return [self _endWithKey:[self getStringWIthIndex:index] resultDict:resultDict];
}

- (BOOL)_endWithKey:(NSString *)key resultDict:(NSMutableDictionary *)resultDict {
    if (![[resultDict allKeys] containsObject:key]) return NO;
    NSInteger value = [[resultDict objectForKey:key] integerValue];
    if (value < 0) {
        return NO;
    }
    value += TABAnimatedIndexTag;
    [resultDict setValue:@(value) forKey:key];
    return YES;
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

- (BOOL)scrollEnabled {
    if (!_scrollEnabled) {
        return NO;
    }
    if (_scrollEnabled && ![TABAnimated sharedAnimated].scrollEnabled) {
        return NO;
    }
    return YES;
}

@end
