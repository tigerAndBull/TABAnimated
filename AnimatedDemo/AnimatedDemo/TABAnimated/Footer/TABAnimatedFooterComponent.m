//
//  TABAnimatedFooterComponent.m
//  AnimatedDemo
//
//  Created by 安文虎 on 2020/6/3.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "TABAnimatedFooterComponent.h"
#import "UIScrollView+MJExtension.h"
#import "UIView+MJExtension.h"
#import "TABAnimationMethod.h"

NSString *const MJRefreshKeyPathContentOffset = @"contentOffset";
NSString *const MJRefreshKeyPathContentInset = @"contentInset";
NSString *const MJRefreshKeyPathContentSize = @"contentSize";
NSString *const MJRefreshKeyPathPanState = @"state";

@interface TABAnimatedFooterComponent()

@property (assign, nonatomic) NSInteger lastRefreshCount;
@property (assign, nonatomic) CGFloat lastBottomDelta;

@end

@implementation TABAnimatedFooterComponent

- (instancetype)init {
    if (self = [super init]) {
        self.mj_h = 100;
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview) {

        _scrollView = (UIScrollView *)newSuperview;
        
        // 设置宽度
        self.mj_w = _scrollView.mj_w;
        // 设置位置
        self.mj_x = -_scrollView.mj_insetL;
    
        // 设置永远支持垂直弹簧效果
        _scrollView.alwaysBounceVertical = YES;
        // 记录UIScrollView最开始的contentInset
        _scrollViewOriginalInset = _scrollView.mj_inset;
        
        // 添加监听
        [self addObservers];
        
        if (self.hidden == NO) {
            self.scrollView.mj_insetB += self.mj_h;
        }
        
        // 设置位置
        self.mj_y = _scrollView.mj_contentH;
        
    } else {
        // 被移除了
        if (self.hidden == NO) {
            self.scrollView.mj_insetB -= self.mj_h;
        }
    }
}

#pragma mark -

- (void)addObservers {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:MJRefreshKeyPathContentOffset options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:MJRefreshKeyPathContentSize options:options context:nil];
}

- (void)removeObservers {
    [self.scrollView removeObserver:self forKeyPath:MJRefreshKeyPathContentOffset];
    [self.scrollView removeObserver:self forKeyPath:MJRefreshKeyPathContentSize];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if (!self.userInteractionEnabled) return;
    
    if ([keyPath isEqualToString:MJRefreshKeyPathContentSize]) {
        [self scrollViewContentSizeDidChange:change];
    }
    
    if (self.hidden) return;
    
    if ([keyPath isEqualToString:MJRefreshKeyPathContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    // 如果正在刷新，直接返回
    if (self.state == TABAnimatedFooterRefreshStateRefreshing) return;
    
    _scrollViewOriginalInset = self.scrollView.mj_inset;
    
    // 当前的contentOffset
    CGFloat currentOffsetY = self.scrollView.mj_offsetY;
    // 尾部控件刚好出现的offsetY
    CGFloat happenOffsetY = [self happenOffsetY];
    // 如果是向下滚动到看不见尾部控件，直接返回
    if (currentOffsetY <= happenOffsetY) return;
    
    if (self.scrollView.isDragging) {
        if (self.state == TABAnimatedFooterRefreshStateNormal && currentOffsetY > happenOffsetY) {
            self.state = TABAnimatedFooterRefreshStateRefreshing;
        }
    }
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    // 内容的高度
    CGFloat contentHeight = self.scrollView.mj_contentH;
    // 表格的高度
    CGFloat scrollHeight = self.scrollView.mj_h - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom;
    // 设置位置和尺寸
    self.mj_y = MAX(contentHeight, scrollHeight);
}

#pragma mark 刚好看到上拉刷新控件时的contentOffset.y

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

- (void)setHidden:(BOOL)hidden {
    BOOL lastHidden = self.isHidden;
    [super setHidden:hidden];
    
    if (!lastHidden && hidden) {
        self.state = TABAnimatedFooterRefreshStateNormal;
        self.scrollView.mj_insetB -= self.mj_h;
    } else if (lastHidden && !hidden) {
        self.scrollView.mj_insetB += self.mj_h;
        self.mj_y = _scrollView.mj_contentH;
    }
}

- (void)setState:(TABAnimatedFooterRefreshState)state {

    TABAnimatedFooterRefreshState oldState = _state;
    if (state == oldState) return;
    _state = state;

    switch (state) {
        case TABAnimatedFooterRefreshStateNormal: {
            
        }
            break;
            
        case TABAnimatedFooterRefreshStateRefreshing: {
            if (self.hidden) {
                self.hidden = NO;
            }else {
                [self.scrollView.tabAnimated.producter productWithView:self controlView:self.scrollView currentClass:((TABFormAnimated *)(self.scrollView.tabAnimated)).cellClassArray[0] indexPath:nil origin:TABAnimatedProductOriginView productByClass:YES];
            }
            // 执行回调
            if (self.actionHandler) {
                self.actionHandler();
            }
        }
            break;
        
        case TABAnimatedFooterRefreshStateStopped: {
            self.hidden = YES;
        }
            break;
        
        case TABAnimatedFooterRefreshStateNoMoreData: {
            
        }
            break;
            
        default:
            break;
    }
}

@end
