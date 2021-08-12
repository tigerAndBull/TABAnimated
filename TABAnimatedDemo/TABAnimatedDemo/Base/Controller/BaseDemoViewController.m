//
//  BaseDemoViewController.m
//  TABAnimatedDemo
//
//  Created by tigerAndBull on 2019/10/1.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "BaseDemoViewController.h"
#import "TABAnimatedControllerUIInterface.h"
#import "TABAnimatedControllerUIImpl.h"

@interface BaseDemoViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) id <TABAnimatedControllerUIInterface> rightButtonImpl;

@end

@implementation BaseDemoViewController

- (instancetype)init {
    if (self = [super init]) {
        _rightButtonImpl = TABAnimatedControllerUIImpl.new;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@", [NSString stringWithFormat:@"【控制器：%@】---> enter", NSStringFromClass(self.class)]);
    [self setupUI];
}

- (void)dealloc {
    NSLog(@"%@", [NSString stringWithFormat:@"【控制器：%@】---> dealloc", NSStringFromClass(self.class)]);
}

- (void)setupUI {
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return UIColor.systemBackgroundColor;
            }else {
                return UIColor.whiteColor;
            }
        }];
    } else {
        self.view.backgroundColor = UIColor.whiteColor;
    }
    
    __weak typeof(self) weakSelf = self;
    [_rightButtonImpl addReloadButtonWithController:self clickButtonBlock:^(UIButton *btn) {
        [weakSelf reloadViewAnimated];
    }];
}

- (void)reloadViewAnimated {
    
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//}
//
//- (void)scrollViewDidZoom:(UIScrollView *)scrollView API_AVAILABLE(ios(3.2)) {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//}
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//}
//
//// called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//}
//
//// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//}
//
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//}
//
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//}
//
//- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//    return nil;
//}
//
//- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view API_AVAILABLE(ios(3.2)) {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//}
//
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//}
//
//- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//    return NO;
//}
//
//- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//}
//
//- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView API_AVAILABLE(ios(11.0), tvos(11.0)) {
//    NSLog(@"%@", NSStringFromSelector(_cmd));
//}

@end
