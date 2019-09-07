//
//  TABPopViewController.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/9/7.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, TABPopViewIn) {
    TABPopViewInCenter   = 0,
    TABPopViewInTop      = 1,
    TABPopViewInLeft     = 2,
    TABPopViewInBottom   = 3,
    TABPopViewInRight    = 4
};

typedef NS_ENUM (NSInteger, TABPopViewStop) {
    TABPopViewStopCenter = 0,
    TABPopViewStopTop    = 1,
    TABPopViewStopLeft   = 2,
    TABPopViewStopBottom = 3,
    TABPopViewStopRight  = 4,
    TABPopViewStopCustom = 5
};

typedef NS_ENUM (NSInteger, TABPopViewOut) {
    TABPopViewOutCenter  = 0,
    TABPopViewOutTop     = 1,
    TABPopViewOutLeft    = 2,
    TABPopViewOutBottom  = 3,
    TABPopViewOutRight   = 4
};

@protocol TABPopViewControllerDelegate <NSObject>

- (void)didClickButtonWithSelString:(NSString *)selString withParam:(NSString *)str;

@end

@interface TABPopViewController : UIViewController

@property (nonatomic) id<TABPopViewControllerDelegate> delegate;

+ (TABPopViewController *)sharePopView;

- (void)pushPopViewWithSuperController:(UIViewController *)superController
                                  popView:(UIView *)popView
                           TABPopViewIn:(TABPopViewIn)popViewIn
                         TABPopViewStop:(TABPopViewStop)popViewStop
                          TABPopViewOut:(TABPopViewOut)popViewOut
                    TABPopViewStopFrame:(CGRect)popViewStopFrame
                          BgViewCancel:(BOOL)bgViewCancel;


- (void)dissPopView;

@end
