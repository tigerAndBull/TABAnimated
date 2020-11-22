//
//  TABAnimatedPullLoadingComponent.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/6/3.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "TABAnimatedPullLoadingComponent.h"
#import "UIScrollView+TABExtension.h"
#import "UIView+TABExtension.h"
#import "TABAnimationMethod.h"
#import <objc/message.h>
#import "UIView+TABControlModel.h"
#import "TABViewAnimated.h"

NSString *const TABAnimatedPullLoadingKeyPathContentOffset = @"contentOffset";
NSString *const TABAnimatedPullLoadingKeyPathContentInset = @"contentInset";
NSString *const TABAnimatedPullLoadingKeyPathContentSize = @"contentSize";
NSString *const TABAnimatedPullLoadingKeyPathPanState = @"state";

// 运行时objc_msgSend
#define TABPullLoadingMsgSend(...) ((void (*)(void *, SEL, UIView *))objc_msgSend)(__VA_ARGS__)
#define TABPullLoadingMsgTarget(target) (__bridge void *)(target)

@interface TABAnimatedPullLoadingComponent()

@property (assign, nonatomic) NSInteger lastRefreshCount;
@property (assign, nonatomic) CGFloat lastBottomDelta;

@end

@implementation TABAnimatedPullLoadingComponent

- (instancetype)initWithScrollView:(UIScrollView *)scrollView targetClass:(Class)targetClass viewHeight:(CGFloat)viewHeight actionHandler:(TABAnimatedFooterActionHandler)actionHandler {
    if (self = [self initWithScrollView:scrollView targetClass:targetClass viewHeight:viewHeight]) {
        self.actionHandler = actionHandler;
    }
    return self;
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView targetClass:(Class)targetClass viewHeight:(CGFloat)viewHeight target:(id)target action:(SEL)action {
    if (self = [self initWithScrollView:scrollView targetClass:targetClass viewHeight:viewHeight]) {
        self.action = action;
        self.target = target;
    }
    return self;
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView targetClass:(Class)targetClass viewHeight:(CGFloat)viewHeight {
    if (self = [super init]) {
        self.scrollView = scrollView;
        self.targetClass = targetClass;
        self.viewHeight = viewHeight;
        self.tab_h = viewHeight;
        self.state = TABAnimatedPullLoadingStateNormal;
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}

- (void)dealloc {
    [self removeObservers];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview) {

        _scrollView = (UIScrollView *)newSuperview;
        
        // 设置位置
        self.tab_w = _scrollView.tab_w;
        self.tab_x = -_scrollView.tab_insetL;
    
        // 支持垂直弹簧效果
        _scrollView.alwaysBounceVertical = YES;
        _scrollViewOriginalInset = _scrollView.tab_inset;
        
        [self addObservers];
        
        if (self.hidden == NO) {
            self.scrollView.tab_insetB += self.tab_h;
        }
        
        // 更新纵坐标
        self.tab_y = _scrollView.tab_contentH;
        
    } else {
        // 被移除了
        if (self.hidden == NO) {
            self.scrollView.tab_insetB -= self.tab_h;
        }
    }
}

#pragma mark -

- (void)addObservers {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:TABAnimatedPullLoadingKeyPathContentOffset options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:TABAnimatedPullLoadingKeyPathContentSize options:options context:nil];
}

- (void)removeObservers {
    [self.scrollView removeObserver:self forKeyPath:TABAnimatedPullLoadingKeyPathContentOffset];
    [self.scrollView removeObserver:self forKeyPath:TABAnimatedPullLoadingKeyPathContentSize];
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if (!self.userInteractionEnabled) return;
    
    if ([keyPath isEqualToString:TABAnimatedPullLoadingKeyPathContentSize]) {
        [self scrollViewContentSizeDidChange:change];
    }
    
    if (self.hidden) return;
    
    if ([keyPath isEqualToString:TABAnimatedPullLoadingKeyPathContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {

    if (self.state == TABAnimatedPullLoadingStateRefreshing) {
        return;
    }
    
    _scrollViewOriginalInset = self.scrollView.tab_inset;
    
    // 当前的contentOffset
    CGFloat currentOffsetY = self.scrollView.tab_offsetY;
    // 尾部控件刚好出现的offsetY
    CGFloat happenOffsetY = [self happenOffsetY];
    // 如果是向下滚动到看不见尾部控件，直接返回
    if (currentOffsetY <= happenOffsetY) return;
    
    if (self.scrollView.isDragging) {
        if (self.state == TABAnimatedPullLoadingStateNormal && currentOffsetY > happenOffsetY) {
            self.state = TABAnimatedPullLoadingStateRefreshing;
        }
    }
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    // 内容的高度
    CGFloat contentHeight = self.scrollView.tab_contentH;
    // 表格的高度
    CGFloat scrollHeight = self.scrollView.tab_h - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom;
    // 设置位置和尺寸
    self.tab_y = MAX(contentHeight, scrollHeight);
    if (self.state == TABAnimatedPullLoadingStateStopped) {
        self.state = TABAnimatedPullLoadingStateNormal;
    }
}

#pragma mark - 刚好看到上拉刷新控件时的contentOffset.y

- (CGFloat)happenOffsetY {
    CGFloat deltaH = [self heightForContentBreakView];
    if (deltaH > 0) {
        return deltaH - self.scrollViewOriginalInset.top;
    } else {
        return - self.scrollViewOriginalInset.top;
    }
}

- (CGFloat)heightForContentBreakView {
    CGFloat h = self.scrollView.frame.size.height - self.scrollViewOriginalInset.bottom - self.scrollViewOriginalInset.top;
    return self.scrollView.contentSize.height - h;
}

- (void)setState:(TABAnimatedPullLoadingState)state {

    TABAnimatedPullLoadingState oldState = _state;
    if (state == oldState) return;
    _state = state;

    switch (state) {
        case TABAnimatedPullLoadingStateNormal: {
            if (oldState == TABAnimatedPullLoadingStateStopped) {
                self.hidden = NO;
            }else if (oldState == TABAnimatedPullLoadingStateNoMoreData) {
                self.hidden = NO;
                [self addObservers];
                self.scrollView.tab_insetB += self.tab_h;
            }
        }
            break;
            
        case TABAnimatedPullLoadingStateRefreshing: {
            if (self.hidden) {
                self.hidden = NO;
            }else {
                [self.scrollView.tabAnimated.producter pullLoadingProductWithView:self
                                                                      controlView:self.scrollView
                                                                     currentClass:self.targetClass
                                                                        indexPath:nil
                                                                           origin:TABAnimatedProductOriginView];
            }

            if (self.actionHandler) {
                self.actionHandler();
            }
            
            if ([self.target respondsToSelector:self.action]) {
                TABPullLoadingMsgSend(TABPullLoadingMsgTarget(self.target), self.action, self);
            }
        }
            break;
        
        case TABAnimatedPullLoadingStateStopped: {
            self.hidden = YES;
        }
            break;
        
        case TABAnimatedPullLoadingStateNoMoreData: {
            self.hidden = YES;
            [self removeObservers];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.scrollView.tab_insetB -= self.tab_h;
            });
        }
            break;
            
        default:
            break;
    }
}

@end
