//
//  GradientButtonViewController.m
//  TABAnimatedDemo
//
//  Created by tigerAndBull on 2020/11/14.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "GradientButtonViewController.h"
#import "UIButton+Gradient.h"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define buttonWidth 240
#define buttonHeight 50

@interface GradientButtonViewController ()

@property (nonatomic, strong) UIButton *gradientLayerButton;
@property (nonatomic, strong) UIButton *gradientImageButton;

@end

@implementation GradientButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.gradientLayerButton];
    [self.view addSubview:self.gradientImageButton];
    self.view.tabAnimated = TABViewAnimated.new;
    [self.view tab_startAnimationWithCompletion:^{
        [self afterGetData];
    }];
}

- (void)reloadViewAnimated {
    self.view.tabAnimated.canLoadAgain = YES;
    [self.view tab_startAnimationWithCompletion:^{
        [self afterGetData];
    }];
}

- (void)afterGetData {
    [self.view tab_endAnimation];
}

- (UIButton *)gradientLayerButton {
    if (!_gradientLayerButton) {
        _gradientLayerButton = [[UIButton alloc] init];
        _gradientLayerButton.frame = CGRectMake((kScreenWidth - buttonWidth)/2, kNavigationHeight+20, buttonWidth, buttonHeight);
        CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 0);
        gradientLayer.locations = @[@(0.3),@(1)];
        [gradientLayer setColors:@[
            (id)[[UIColor colorWithRed:253/255.0 green:176/255.0 blue:56/255.0 alpha:1] CGColor]
        ,
        (id)
            [[UIColor colorWithRed:91/255.0 green:10/255.0 blue:10/255.0 alpha:1] CGColor]]];
        [_gradientLayerButton.layer addSublayer:gradientLayer];
        [_gradientLayerButton setTitle:@"映射CAGradientLayer渐变色" forState:UIControlStateNormal];
        [_gradientLayerButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_gradientLayerButton.titleLabel setFont:kFont(16)];
        _gradientLayerButton.layer.cornerRadius = 5.0f;
        _gradientLayerButton.layer.masksToBounds = YES;
    }
    return _gradientLayerButton;
}

- (UIButton *)gradientImageButton {
    if (!_gradientImageButton) {
        _gradientImageButton = [[UIButton alloc] init];
        _gradientImageButton.frame = CGRectMake((kScreenWidth - buttonWidth)/2, kNavigationHeight+20+66, buttonWidth, buttonHeight);
        [_gradientImageButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_gradientImageButton.titleLabel setFont:kFont(16)];
        [_gradientImageButton gradientButtonWithSize:CGSizeMake(buttonWidth, buttonHeight) colorArray:@[(id)[UIColor yellowColor],(id)[UIColor brownColor]] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromLeftBottomToRightTop];
        [_gradientImageButton setTitle:@"映射backgroundImage渐变色" forState:UIControlStateNormal];
        _gradientImageButton.layer.cornerRadius = 5.0f;
        _gradientImageButton.layer.masksToBounds = YES;
    }
    return _gradientImageButton;
}

@end
