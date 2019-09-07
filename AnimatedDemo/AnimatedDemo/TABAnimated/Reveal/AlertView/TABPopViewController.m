//
//  TABPopViewController.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/9/7.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABPopViewController.h"
#import "TABPopBgView.h"

static const NSTimeInterval kPopViewDuration = 0.22;

@interface TABPopViewController ()

@property (nonatomic,strong) UIView *superView;
@property (nonatomic,strong) UIViewController *superController;

@property (nonatomic,strong) TABPopBgView *bgView;
@property (nonatomic,strong) UIView *popView;

@property (nonatomic,assign) TABPopViewIn popViewIn;
@property (nonatomic,assign) TABPopViewStop popViewStop;
@property (nonatomic,assign) TABPopViewOut popViewOut;

@property (nonatomic,assign) CGRect popViewStopFrame;

@property (nonatomic) BOOL bgViewCancel;

@end

@implementation TABPopViewController

+ (TABPopViewController *)sharePopView {
    static TABPopViewController *popView;
    if (popView == nil) {
        popView = [[TABPopViewController alloc] init];
    }
    return popView;
}

- (void)pushPopViewWithSuperController:(UIViewController *)superController
                               popView:(UIView *)popView
                           TABPopViewIn:(TABPopViewIn)popViewIn
                         TABPopViewStop:(TABPopViewStop)popViewStop
                          TABPopViewOut:(TABPopViewOut)popViewOut
                    TABPopViewStopFrame:(CGRect)popViewStopFrame
                            BgViewCancel:(BOOL)bgViewCancel {
    
    self.bgViewCancel = bgViewCancel;
    self.superController = superController;
    self.popViewIn = popViewIn;
    self.popViewStop = popViewStop;
    self.popViewOut = popViewOut;
    self.popViewStopFrame = popViewStopFrame;
    
    if (self.beingPresented) {
        return;
    }
    
    self.popView = popView;
    
    self.bgView = [[TABPopBgView alloc] init];
    self.bgView.frame = self.view.bounds;
    self.bgView.userInteractionEnabled = YES;
    self.bgView.backgroundColor = [UIColor clearColor];
    [self.bgView addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.popView];
    
    CGRect startRect;
    switch (self.popViewIn) {
        case TABPopViewInCenter:
        {
            startRect = CGRectMake((self.bgView.bounds.size.width - self.popView.bounds.size.width)/2, (self.bgView.bounds.size.height - self.popView.bounds.size.height)/2, self.popView.bounds.size.width, self.popView.bounds.size.height);
        }
            break;
        case TABPopViewInTop:
        {
            startRect = CGRectMake((self.bgView.bounds.size.width - self.popView.bounds.size.width)/2, - self.popView.bounds.size.height, self.popView.bounds.size.width, self.popView.bounds.size.height);
        }
            break;
        case TABPopViewInLeft:
        {
            startRect = CGRectMake(- self.popView.bounds.size.width, (self.bgView.bounds.size.height - self.popView.bounds.size.height)/2, self.popView.bounds.size.width, self.popView.bounds.size.height);
        }
            break;
        case TABPopViewInBottom:
        {
            startRect = CGRectMake((self.bgView.bounds.size.width - self.popView.bounds.size.width)/2, self.bgView.bounds.size.height, self.popView.bounds.size.width, self.popView.bounds.size.height);
        }
            break;
        case TABPopViewInRight:
        {
            startRect = CGRectMake(self.bgView.bounds.size.width, (self.bgView.bounds.size.height - self.popView.bounds.size.height)/2, self.popView.bounds.size.width, self.popView.bounds.size.height);
        }
            break;
        default:
            break;
    }
    
    CGRect endRect;
    switch (self.popViewStop) {
        case TABPopViewStopCenter:
        {
            endRect = CGRectMake((self.bgView.bounds.size.width - self.popView.bounds.size.width)/2, (self.bgView.bounds.size.height - self.popView.bounds.size.height)/2, self.popView.bounds.size.width, self.popView.bounds.size.height);
        }
            break;
        case TABPopViewStopTop:
        {
            endRect = CGRectMake((self.bgView.bounds.size.width - self.popView.bounds.size.width)/2, 0, self.popView.bounds.size.width, self.popView.bounds.size.height);
        }
            break;
        case TABPopViewStopLeft:
        {
            endRect = CGRectMake(0, (self.bgView.bounds.size.height - self.popView.bounds.size.height)/2, self.popView.bounds.size.width, self.popView.bounds.size.height);
        }
            break;
        case TABPopViewStopBottom:
        {
            endRect = CGRectMake((self.bgView.bounds.size.width - self.popView.bounds.size.width)/2, self.bgView.bounds.size.height - self.popView.bounds.size.height, self.popView.bounds.size.width, self.popView.bounds.size.height);
        }
            break;
        case TABPopViewStopRight:
        {
            endRect = CGRectMake(self.bgView.bounds.size.width - self.popView.bounds.size.width, (self.bgView.bounds.size.height - self.popView.bounds.size.height)/2, self.popView.bounds.size.width, self.popView.bounds.size.height);
        }
            break;
        case TABPopViewStopCustom:
        {
            endRect = self.popViewStopFrame;
        }
            break;
        default:
            break;
    }
    [self.bgView setAlpha:0.0f];
    [self.popView setFrame:startRect];
    
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    superController.modalPresentationStyle = UIModalPresentationCurrentContext;
    superController.providesPresentationContextTransitionStyle = YES;
    superController.definesPresentationContext = YES;
    
    [superController presentViewController:self animated:NO completion:^{
        [UIView animateWithDuration:kPopViewDuration delay:0.0f options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
            [self.bgView setAlpha:1.0f];
            [self.popView setFrame:endRect];
        } completion:nil];
    }];
}

- (void)dissPopView
{
    CGRect endRect;
    switch (self.popViewOut)
    {
        case TABPopViewOutCenter:
        {
            endRect = CGRectMake((self.bgView.bounds.size.width - self.popView.bounds.size.width)/2, (self.bgView.bounds.size.height - self.popView.bounds.size.height)/2, self.popView.bounds.size.width, self.popView.bounds.size.height);
        }
            break;
        case TABPopViewOutTop:
        {
            endRect = CGRectMake((self.bgView.bounds.size.width - self.popView.bounds.size.width)/2, - self.popView.bounds.size.height, self.popView.bounds.size.width, self.popView.bounds.size.height);
        }
            break;
        case TABPopViewOutLeft:
        {
            endRect = CGRectMake(- self.popView.bounds.size.width, (self.bgView.bounds.size.height - self.popView.bounds.size.height)/2, self.popView.bounds.size.width, self.popView.bounds.size.height);
        }
            break;
        case TABPopViewOutBottom:
        {
            endRect = CGRectMake((self.bgView.bounds.size.width - self.popView.bounds.size.width)/2, self.bgView.bounds.size.height, self.popView.bounds.size.width, self.popView.bounds.size.height);
        }
            break;
        case TABPopViewOutRight:
        {
            endRect = CGRectMake(self.bgView.bounds.size.width, (self.bgView.bounds.size.height - self.popView.bounds.size.height)/2, self.popView.bounds.size.width, self.popView.bounds.size.height);
        }
            break;
        default:
            break;
    }
    
    __weak typeof(self) weakSelf = self;
    if (_superController) {
        [UIView animateWithDuration:kPopViewDuration delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            [weakSelf.bgView setAlpha:0.0f];
            [weakSelf.popView setFrame:endRect];
        } completion:^(BOOL finished) {
            [weakSelf.bgView removeFromSuperview];
            [weakSelf.superController dismissViewControllerAnimated:NO completion:nil];
        }];
    }
}

- (void)clickCancel {
    if (_bgViewCancel) {
        [self dissPopView];
    }
}

- (void)setPopViewTop:(CGFloat)top Left:(CGFloat)left; {
    CGRect rect = self.popView.frame;
    rect.origin.x += left;
    rect.origin.y += top;
    [self.popView setFrame:rect];
}

@end
