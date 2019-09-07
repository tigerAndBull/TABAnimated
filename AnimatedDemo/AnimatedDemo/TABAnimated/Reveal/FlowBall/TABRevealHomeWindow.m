//
//  TABRevealHomeWindow.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/9/7.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABRevealHomeWindow.h"
#import "TABRevealViewController.h"

@implementation TABRevealHomeWindow

+ (TABRevealHomeWindow *)shared {
    static dispatch_once_t once;
    static TABRevealHomeWindow *homeWindow;
    dispatch_once(&once, ^{
        homeWindow = [[TABRevealHomeWindow alloc] initWithFrame:CGRectMake(0, 0, tab_revealScreenWidth, tab_revealScreenHeight)];
    });
    return homeWindow;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar + 1;
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
    }
    return self;
}

- (void)show {
    TABRevealViewController *vc = [[TABRevealViewController alloc] init];
    [self resetRootViewController:vc];
    self.hidden = NO;
}

- (void)hide{
    [self resetRootViewController:nil];
    self.hidden = YES;
}

- (void)resetRootViewController:(UIViewController *)controller {
    if (controller) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
        NSDictionary *attributesDic = @{
                                        NSForegroundColorAttributeName:[UIColor blackColor],
                                        NSFontAttributeName:[UIFont boldSystemFontOfSize:17]
                                        };
        [nav.navigationBar setTitleTextAttributes:attributesDic];
        _nav = nav;
        
        self.rootViewController = nav;
    }else{
        self.rootViewController = nil;
        _nav = nil;
    }
}

@end
