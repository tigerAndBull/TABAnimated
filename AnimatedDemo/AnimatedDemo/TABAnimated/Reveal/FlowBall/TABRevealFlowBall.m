//
//  TABRevealFlowBall.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/9/7.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABRevealFlowBall.h"
#import "TABRevealHomeWindow.h"

static const CGFloat kFlowBallSize = 55.;
static const NSInteger kFlowBallMargin = 10;
static const NSTimeInterval kFlowBallAnimationDuration = 0.2;

@interface TABRevealFlowBall()

@property (nonatomic, strong) UIButton *flowBallBtn;

@end

@implementation TABRevealFlowBall

- (instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake(tab_revealScreenWidth - kFlowBallSize - kFlowBallMargin, tab_revealScreenHeight/2, kFlowBallSize, kFlowBallSize);
        self.backgroundColor = [UIColor clearColor];
        self.windowLevel = UIWindowLevelStatusBar + 100;
        self.layer.masksToBounds = YES;
        
        NSString *version = [UIDevice currentDevice].systemVersion;
        if(version.doubleValue >= 10.0) {
            if (!self.rootViewController) {
                self.rootViewController = [[UIViewController alloc] init];
            }
        }
        [self.rootViewController.view addSubview:self.flowBallBtn];
        
        [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
    }
    return self;
}

- (void)becomeKeyWindow {
    UIWindow *appWindow = [[UIApplication sharedApplication].delegate window];
    [appWindow makeKeyWindow];
}

#pragma mark - Target Method

- (void)pan:(UIPanGestureRecognizer *)ges {
    
    if (ges.state == UIGestureRecognizerStateChanged) {
        
        CGPoint transitionP = [ges translationInView:ges.view];
        CGFloat transitionX = MAX(kFlowBallSize / 2.0, MIN(self.center.x + transitionP.x, tab_revealScreenWidth - kFlowBallSize / 2.0));
        CGFloat transitionY = MAX(tab_revealScreenWidth / 2.0, MIN(self.center.y + transitionP.y, tab_revealScreenHeight - tab_revealScreenWidth / 2.0));
        self.center = CGPointMake(transitionX, transitionY);
        [ges setTranslation:CGPointZero inView:ges.view];
        
    }else if (ges.state == UIGestureRecognizerStateEnded ||
              ges.state ==  UIGestureRecognizerStateCancelled) {
        
        [UIView animateWithDuration:kFlowBallAnimationDuration animations:^{
            
            CGFloat minX = kFlowBallMargin;
            CGFloat maxX = tab_revealScreenWidth - self.frame.size.width - kFlowBallMargin;
            CGFloat minY = kFlowBallMargin;
            CGFloat maxY = tab_revealScreenHeight - self.frame.size.width - kFlowBallMargin;
            CGPoint point = CGPointZero;
            
            if (self.center.x < tab_revealScreenWidth / 2.0) {
                point.x = minX;
                point.y = MIN(MAX(minY, self.frame.origin.y), maxY);
            }else {
                point.x = maxX;
                point.y = MIN(MAX(minY, self.frame.origin.y), maxY);
            }
            
            CGRect frame = self.frame;
            frame.origin = point;
            self.frame = frame;
        }];
    }
}

- (void)clickAction:(UIButton *)button {
    if ([TABRevealHomeWindow shared].hidden) {
        [[TABRevealHomeWindow shared] show];
    }else{
        [[TABRevealHomeWindow shared] hide];
    }
}

- (UIButton *)flowBallBtn {
    if (!_flowBallBtn) {
        _flowBallBtn = UIButton.new;
        _flowBallBtn.frame = self.bounds;
        _flowBallBtn.backgroundColor = [UIColor clearColor];
        _flowBallBtn.layer.masksToBounds = YES;
        [_flowBallBtn setImage:[UIImage imageNamed:@"TabAnimatedLogo"] forState:UIControlStateNormal];
        _flowBallBtn.layer.cornerRadius = kFlowBallSize/2.;
        [_flowBallBtn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flowBallBtn;
}

@end
