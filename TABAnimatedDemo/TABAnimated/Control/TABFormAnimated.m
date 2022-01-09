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
#import "UIScrollView+TABExtension.h"
#import <objc/runtime.h>
#import <objc/message.h>

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
        _scrollToTopEnabled = YES;
    }
    return self;
}

- (void)rebindDelegate:(UIView *)target {}
- (void)rebindDataSource:(UIView *)target {}
- (void)registerViewToReuse:(UIView *)view {}
- (void)refreshWithIndex:(NSInteger)index controlView:(UIView *)controlView {}

- (BOOL)prepareDataWithIndex:(NSInteger)index isFirstLoad:(BOOL)isFirstLoad controlView:(UIView *)controlView {
    
    if (!isFirstLoad && index == TABAnimatedIndexTag && self.runningCount > 0) {
        return NO;
    }
    
    if (isFirstLoad) {
        if (self.runIndexDict.count == 0) return NO;
        [self registerViewToReuse:controlView];
        NSString *className = [NSString stringWithFormat:@"%@_tabProtocolContainer", self.targetControllerClassName];
        Class newClass = NSClassFromString(className);
        if (!newClass) {
            newClass = objc_allocateClassPair([NSObject class], [className UTF8String], 0);
            objc_registerClassPair(newClass);
        }
        self.protocolContainer = newClass.new;
        self.protocolContainerClass = newClass;
        [self rebindDelegate:controlView];
        [self rebindDataSource:controlView];
    }else {
        
        UIScrollView *scrollView = (UIScrollView *)controlView;
        
        if (self.scrollToTopEnabled) {
            [scrollView tab_scrollToTop];
        }
        
        if (index == TABAnimatedIndexTag) {
            [self reloadAnimation];
        }else if (![self reloadAnimationWithIndex:index]) {
            return NO;
        }
    }
    
    if (self.runIndexDict.count == 0) return NO;
    
    if (self.animatedSectionCount > 0 && self.runIndexDict.count == 1) {
        for (NSInteger i = 1; i < self.animatedSectionCount; i++) {
            [self.runIndexDict setValue:@(0) forKey:[self getStringWIthIndex:i]];
        }
    }
    
    return YES;
}

- (void)startAnimationWithIndex:(NSInteger)index isFirstLoad:(BOOL)isFirstLoad controlView:(UIView *)controlView {
    if ([self prepareDataWithIndex:index isFirstLoad:isFirstLoad controlView:controlView]) {
        [self refreshWithIndex:index controlView:controlView];
        [self updateLoadCountWithFrame:controlView.frame];
    }
}

- (void)updateLoadCountWithFrame:(CGRect)frame {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[TABAnimatedCacheManager shareManager] updateCacheModelLoadCountWithFormAnimated:self frame:frame];
    });
}

- (void)addNewMethodWithSel:(SEL)oldSel newSel:(SEL)newSel {
    Method newMethod = class_getInstanceMethod(self.class, newSel);
    IMP imp = method_getImplementation(newMethod);
    class_addMethod(self.protocolContainerClass, oldSel, imp, method_getTypeEncoding(newMethod));
}

- (void)exchangeDelegateOldSel:(SEL)oldSel newSel:(SEL)newSel target:(id)target delegate:(id)delegate {
    
    if (![delegate respondsToSelector:oldSel]) return;
    
    Class targetClass  = [self class];
    Method newMethod = class_getInstanceMethod(targetClass, newSel);
    if (newMethod == nil) return;
    
    Method oldMethod = class_getInstanceMethod([delegate class], oldSel);
    
    #ifdef DEBUG
        class_addMethod([delegate class], newSel, class_getMethodImplementation([delegate class], oldSel), method_getTypeEncoding(oldMethod));
        class_replaceMethod([delegate class], oldSel, class_getMethodImplementation(targetClass, newSel), method_getTypeEncoding(newMethod));
    #else
        BOOL isVictory = class_addMethod([delegate class], newSel, class_getMethodImplementation([delegate class], oldSel), method_getTypeEncoding(oldMethod));
        if (isVictory) {
            class_replaceMethod([delegate class], oldSel, class_getMethodImplementation(targetClass, newSel), method_getTypeEncoding(newMethod));
        }
    #endif
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
    if (self.runMode == TABAnimatedRunBySection || self.runMode == TABAnimatedRunByPartSection) {
        currentIndex = indexPath.section;
    }else {
        currentIndex = indexPath.row;
    }
    return [self getIndexWithIndex:currentIndex];
}

- (void)updateScrollViewDelegateMethods:(id)delegate target:(id)target {
    
    SEL oldDidScroll = @selector(scrollViewDidScroll:);
    SEL newDidScroll = @selector(tab_scrollViewDidScroll:);
    if ([delegate respondsToSelector:oldDidScroll]) {
        [self addNewMethodWithSel:oldDidScroll newSel:newDidScroll];
    }
    
    SEL oldDidZoom = @selector(scrollViewDidZoom:);
    SEL newDidZoom = @selector(tab_scrollViewDidZoom:);
    if ([delegate respondsToSelector:oldDidZoom]) {
        [self addNewMethodWithSel:oldDidZoom newSel:newDidZoom];
    }
    
    SEL oldWillDeginDragging = @selector(scrollViewWillBeginDragging:);
    SEL newWillDeginDragging = @selector(tab_scrollViewWillBeginDragging:);
    if ([delegate respondsToSelector:oldWillDeginDragging]) {
        [self addNewMethodWithSel:oldWillDeginDragging newSel:newWillDeginDragging];
    }
    
    SEL oldWillEndDragging = @selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:);
    SEL newWillEndDragging = @selector(tab_scrollViewWillEndDragging:withVelocity:targetContentOffset:);
    if ([delegate respondsToSelector:oldWillEndDragging]) {
        [self addNewMethodWithSel:oldWillEndDragging newSel:newWillEndDragging];
    }
    
    SEL oldDidEndDragging = @selector(scrollViewDidEndDragging:willDecelerate:);
    SEL newDidEndDragging = @selector(tab_scrollViewDidEndDragging:willDecelerate:);
    if ([delegate respondsToSelector:oldDidEndDragging]) {
        [self addNewMethodWithSel:oldDidEndDragging newSel:newDidEndDragging];
    }
    
    SEL oldWillBeginDece = @selector(scrollViewWillBeginDecelerating:);
    SEL newWillBeginDece = @selector(tab_scrollViewWillBeginDecelerating:);
    if ([delegate respondsToSelector:oldWillBeginDece]) {
        [self addNewMethodWithSel:oldWillBeginDece newSel:newWillBeginDece];
    }

    SEL oldEndBeginDece = @selector(scrollViewDidEndDecelerating:);
    SEL newEndBeginDece = @selector(tab_scrollViewDidEndDecelerating:);
    if ([delegate respondsToSelector:oldEndBeginDece]) {
        [self addNewMethodWithSel:oldEndBeginDece newSel:newEndBeginDece];
    }
    
    SEL oldEndScrolling = @selector(scrollViewDidEndScrollingAnimation:);
    SEL newEndScrolling = @selector(tab_scrollViewDidEndScrollingAnimation:);
    if ([delegate respondsToSelector:oldEndScrolling]) {
        [self addNewMethodWithSel:oldEndScrolling newSel:newEndScrolling];
    }
    
    SEL oldViewZooming = @selector(viewForZoomingInScrollView:);
    SEL newViewZooming = @selector(tab_viewForZoomingInScrollView:);
    if ([delegate respondsToSelector:oldViewZooming]) {
        [self addNewMethodWithSel:oldViewZooming newSel:newViewZooming];
    }
    
    SEL oldWillBeginZooming = @selector(scrollViewWillBeginZooming:withView:);
    SEL newWillBeginZooming = @selector(tab_scrollViewWillBeginZooming:withView:);
    if ([delegate respondsToSelector:oldWillBeginZooming]) {
        [self addNewMethodWithSel:oldWillBeginZooming newSel:newWillBeginZooming];
    }
    
    SEL oldDidEndZooming = @selector(scrollViewDidEndZooming:withView:atScale:);
    SEL newDidEndZooming = @selector(tab_scrollViewDidEndZooming:withView:atScale:);
    if ([delegate respondsToSelector:oldDidEndZooming]) {
        [self addNewMethodWithSel:oldDidEndZooming newSel:newDidEndZooming];
    }
    
    SEL oldScrollToTop = @selector(scrollViewShouldScrollToTop:);
    SEL newScrollToTop = @selector(tab_scrollViewShouldScrollToTop:);
    if ([delegate respondsToSelector:oldScrollToTop]) {
        [self addNewMethodWithSel:oldScrollToTop newSel:newScrollToTop];
    }
    
    SEL oldDidScrollToTop = @selector(scrollViewDidScrollToTop:);
    SEL newDidScrollToTop = @selector(tab_scrollViewDidScrollToTop:);
    if ([delegate respondsToSelector:oldDidScrollToTop]) {
        [self addNewMethodWithSel:oldDidScrollToTop newSel:newDidScrollToTop];
    }
    
    SEL oldDidChangeAdjusted = @selector(scrollViewDidChangeAdjustedContentInset:);
    SEL newDidChangeAdjusted = @selector(tab_scrollViewDidChangeAdjustedContentInset:);
    if ([delegate respondsToSelector:oldDidChangeAdjusted]) {
        [self addNewMethodWithSel:oldDidChangeAdjusted newSel:newDidChangeAdjusted];
    }
}

#pragma mark -

- (BOOL)getIndexIsRuning:(NSInteger)index {
    if ([self getIndexWithIndex:index dict:self.runIndexDict] >= 0) return YES;
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
    return [NSString stringWithFormat:@"%ld",(long)index];
}

#pragma mark -

- (BOOL)_reloadWithIndex:(NSInteger)index resultDict:(NSMutableDictionary *)resultDict {
    return [self _reloadWithKey:[self _getStringWIthIndex:index] resultDict:resultDict];
}

- (BOOL)_reloadWithKey:(NSString *)key resultDict:(NSMutableDictionary *)resultDict {
    if (![[resultDict allKeys] containsObject:key]) return NO;
    NSInteger value = [[resultDict objectForKey:key] integerValue];
    if (value >= 0) return NO;
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
    if (value < 0) return NO;
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
    if (!_scrollEnabled) return NO;
    if (_scrollEnabled && ![TABAnimated sharedAnimated].scrollEnabled) return NO;
    return YES;
}

#pragma mark -

#pragma mark - UIScrollViewDelegate

- (void)tab_scrollViewDidScroll:(UIScrollView *)scrollView {
    TABFormAnimated *tabAnimated = (TABFormAnimated *)(scrollView.tabAnimated);
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(scrollViewDidScroll:);
    ((void (*)(id, SEL, UIScrollView *))objc_msgSend)((id)oldDelegate, sel, scrollView);
}

- (void)tab_scrollViewDidZoom:(UIScrollView *)scrollView {
    TABFormAnimated *tabAnimated = (TABFormAnimated *)(scrollView.tabAnimated);
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(scrollViewDidZoom:);
    ((void (*)(id, SEL, UIScrollView *))objc_msgSend)((id)oldDelegate, sel, scrollView);
}

// called on start of dragging (may require some time and or distance to move)
- (void)tab_scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    TABFormAnimated *tabAnimated = (TABFormAnimated *)(scrollView.tabAnimated);
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(scrollViewWillBeginDragging:);
    ((void (*)(id, SEL, UIScrollView *))objc_msgSend)((id)oldDelegate, sel, scrollView);
}

// called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
- (void)tab_scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset API_AVAILABLE(ios(5.0)) {
    TABFormAnimated *tabAnimated = (TABFormAnimated *)(scrollView.tabAnimated);
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:);
    ((void (*)(id, SEL, UIScrollView *, CGPoint, CGPoint *))objc_msgSend)((id)oldDelegate, sel, scrollView, velocity, targetContentOffset);
}

// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)tab_scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    TABFormAnimated *tabAnimated = (TABFormAnimated *)(scrollView.tabAnimated);
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(scrollViewDidEndDragging:willDecelerate:);
    ((void (*)(id, SEL, UIScrollView *, BOOL))objc_msgSend)((id)oldDelegate, sel, scrollView, decelerate);
}

- (void)tab_scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    TABFormAnimated *tabAnimated = (TABFormAnimated *)(scrollView.tabAnimated);
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(scrollViewWillBeginDecelerating:);
    ((void (*)(id, SEL, UIScrollView *))objc_msgSend)((id)oldDelegate, sel, scrollView);
}

- (void)tab_scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    TABFormAnimated *tabAnimated = (TABFormAnimated *)(scrollView.tabAnimated);
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(scrollViewDidEndDecelerating:);
    ((void (*)(id, SEL, UIScrollView *))objc_msgSend)((id)oldDelegate, sel, scrollView);
}

- (void)tab_scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    TABFormAnimated *tabAnimated = (TABFormAnimated *)(scrollView.tabAnimated);
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(scrollViewDidEndScrollingAnimation:);
    ((void (*)(id, SEL, UIScrollView *))objc_msgSend)((id)oldDelegate, sel, scrollView);
}

- (nullable UIView *)tab_viewForZoomingInScrollView:(UIScrollView *)scrollView {
    TABFormAnimated *tabAnimated = (TABFormAnimated *)(scrollView.tabAnimated);
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(viewForZoomingInScrollView:);
    return ((UIView * (*)(id, SEL, UIScrollView *))objc_msgSend)((id)oldDelegate, sel, scrollView);
}

- (void)tab_scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view API_AVAILABLE(ios(3.2)) {
    TABFormAnimated *tabAnimated = (TABFormAnimated *)(scrollView.tabAnimated);
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(scrollViewWillBeginZooming:withView:);
    ((void (*)(id, SEL, UIScrollView *, UIView *))objc_msgSend)((id)oldDelegate, sel, scrollView, view);
}

- (void)tab_scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    TABFormAnimated *tabAnimated = (TABFormAnimated *)(scrollView.tabAnimated);
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(scrollViewDidEndZooming:withView:atScale:);
    ((void (*)(id, SEL, UIScrollView *, UIView *, CGFloat))objc_msgSend)((id)oldDelegate, sel, scrollView, view, scale);
}

- (BOOL)tab_scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    TABFormAnimated *tabAnimated = (TABFormAnimated *)(scrollView.tabAnimated);
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(scrollViewShouldScrollToTop:);
    return ((BOOL (*)(id, SEL, UIScrollView *))objc_msgSend)((id)oldDelegate, sel, scrollView);
}

- (void)tab_scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    TABFormAnimated *tabAnimated = (TABFormAnimated *)(scrollView.tabAnimated);
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(scrollViewDidScrollToTop:);
    ((void (*)(id, SEL, UIScrollView *))objc_msgSend)((id)oldDelegate, sel, scrollView);
}

/* Also see -[UIScrollView adjustedContentInsetDidChange]
 */
- (void)tab_scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView API_AVAILABLE(ios(11.0), tvos(11.0)) {
    TABFormAnimated *tabAnimated = (TABFormAnimated *)(scrollView.tabAnimated);
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(scrollViewDidChangeAdjustedContentInset:);
    ((void (*)(id, SEL, UIScrollView *))objc_msgSend)((id)oldDelegate, sel, scrollView);
}

@end
