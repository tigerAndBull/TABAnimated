

#import "UIScrollView+TABExtension.h"
#import <objc/runtime.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability-new"

@implementation UIScrollView (TABExtension)

static BOOL respondsToAdjustedContentInset_;

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        respondsToAdjustedContentInset_ = [self instancesRespondToSelector:@selector(adjustedContentInset)];
    });
}

- (UIEdgeInsets)tab_inset {
#ifdef __IPHONE_11_0
    if (respondsToAdjustedContentInset_) {
        return self.adjustedContentInset;
    }
#endif
    return self.contentInset;
}

- (void)setTab_insetT:(CGFloat)tab_insetT {
    UIEdgeInsets inset = self.contentInset;
    inset.top = tab_insetT;
#ifdef __IPHONE_11_0
    if (respondsToAdjustedContentInset_) {
        inset.top -= (self.adjustedContentInset.top - self.contentInset.top);
    }
#endif
    self.contentInset = inset;
}

- (CGFloat)tab_insetT {
    return self.tab_inset.top;
}

- (void)setTab_insetB:(CGFloat)tab_insetB {
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = tab_insetB;
#ifdef __IPHONE_11_0
    if (respondsToAdjustedContentInset_) {
        inset.bottom -= (self.adjustedContentInset.bottom - self.contentInset.bottom);
    }
#endif
    self.contentInset = inset;
}

- (CGFloat)tab_insetB {
    return self.tab_inset.bottom;
}

- (void)setTab_insetL:(CGFloat)tab_insetL {
    UIEdgeInsets inset = self.contentInset;
    inset.left = tab_insetL;
#ifdef __IPHONE_11_0
    if (respondsToAdjustedContentInset_) {
        inset.left -= (self.adjustedContentInset.left - self.contentInset.left);
    }
#endif
    self.contentInset = inset;
}

- (CGFloat)tab_insetL {
    return self.tab_inset.left;
}

- (void)setTab_insetR:(CGFloat)tab_insetR {
    UIEdgeInsets inset = self.contentInset;
    inset.right = tab_insetR;
#ifdef __IPHONE_11_0
    if (respondsToAdjustedContentInset_) {
        inset.right -= (self.adjustedContentInset.right - self.contentInset.right);
    }
#endif
    self.contentInset = inset;
}

- (CGFloat)tab_insetR {
    return self.tab_inset.right;
}

- (void)setTab_offsetX:(CGFloat)tab_offsetX {
    CGPoint offset = self.contentOffset;
    offset.x = tab_offsetX;
    self.contentOffset = offset;
}

- (CGFloat)tab_offsetX {
    return self.contentOffset.x;
}

- (void)setTab_offsetY:(CGFloat)tab_offsetY {
    CGPoint offset = self.contentOffset;
    offset.y = tab_offsetY;
    self.contentOffset = offset;
}

- (CGFloat)tab_offsetY {
    return self.contentOffset.y;
}

- (void)setTab_contentW:(CGFloat)tab_contentW {
    CGSize size = self.contentSize;
    size.width = tab_contentW;
    self.contentSize = size;
}

- (CGFloat)tab_contentW {
    return self.contentSize.width;
}

- (void)setTab_contentH:(CGFloat)tab_contentH {
    CGSize size = self.contentSize;
    size.height = tab_contentH;
    self.contentSize = size;
}

- (CGFloat)tab_contentH {
    return self.contentSize.height;
}

#pragma mark -

- (void)tab_scrollToTop {
    [self tab_scrollToTopAnimated:NO];
}

- (void)tab_scrollToTopAnimated:(BOOL)animated {
    CGPoint off = self.contentOffset;
    UIEdgeInsets contentInset = self.tab_inset;
    off.y = 0 - contentInset.top;
    [self setContentOffset:off animated:animated];
}

@end

#pragma clang diagnostic pop
