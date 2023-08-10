

#import "UIView+TABExtension.h"

@implementation UIView (TABExtension)

- (void)setTab_x:(CGFloat)tab_x {
    CGRect frame = self.frame;
    frame.origin.x = tab_x;
    self.frame = frame;
}

- (CGFloat)tab_x {
    return self.frame.origin.x;
}

- (void)setTab_y:(CGFloat)tab_y {
    CGRect frame = self.frame;
    frame.origin.y = tab_y;
    self.frame = frame;
}

- (CGFloat)tab_y {
    return self.frame.origin.y;
}

- (void)setTab_w:(CGFloat)tab_w {
    CGRect frame = self.frame;
    frame.size.width = tab_w;
    self.frame = frame;
}

- (CGFloat)tab_w {
    return self.frame.size.width;
}

- (void)setTab_h:(CGFloat)tab_h {
    CGRect frame = self.frame;
    frame.size.height = tab_h;
    self.frame = frame;
}

- (CGFloat)tab_h {
    return self.frame.size.height;
}

- (void)setTab_size:(CGSize)tab_size {
    CGRect frame = self.frame;
    frame.size = tab_size;
    self.frame = frame;
}

- (CGSize)tab_size {
    return self.frame.size;
}

- (void)setTab_origin:(CGPoint)tab_origin {
    CGRect frame = self.frame;
    frame.origin = tab_origin;
    self.frame = frame;
}

- (CGPoint)tab_origin {
    return self.frame.origin;
}

@end
