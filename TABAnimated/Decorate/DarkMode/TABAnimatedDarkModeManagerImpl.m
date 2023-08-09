//
//  TABAnimatedDarkModelImpl.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/4/7.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "TABAnimatedDarkModeManagerImpl.h"

#import "TABAnimatedProduction.h"
#import "TABComponentLayer.h"
#import "TABViewAnimated.h"
#import "TABSentryView.h"
#import "UIView+TABControlModel.h"
#import "UIView+TABAnimatedProduction.h"

#import "TABAnimated.h"

#import "TABAnimatedDarkModeInterface.h"
#import "TABWeakDelegateManager.h"
#import "TABAnimatedDarkModeImpl.h"

@interface TABAnimatedDarkModeManagerImpl()

@property (nonatomic, weak) UIView *controlView;
@property (nonatomic, assign) BOOL isAddSentryView;
@property (nonatomic, strong) TABSentryView *sentryView;

@property (nonatomic, strong) TABWeakDelegateManager *weakDelegateManager;

@end

@implementation TABAnimatedDarkModeManagerImpl

- (void)setControlView:(UIView *)controlView {
    _controlView = controlView;
}

- (void)addDarkModelSentryView {
    if (_isAddSentryView || !_controlView) return;
    [_controlView addSubview:self.sentryView];
    __weak typeof(self) weakSelf = self;
    self.sentryView.traitCollectionDidChangeBack = ^ {
        [weakSelf _traitCollectionDidChange];
    };
    _isAddSentryView = YES;
}

- (void)addNeedChangeView:(UIView *)view {
    [self.weakDelegateManager addDelegate:view];
}

- (void)destroy {
    _isAddSentryView = NO;
    [_weakDelegateManager removeAllDelegates];
    _weakDelegateManager = nil;
    [_sentryView removeFromSuperview];
    _sentryView = nil;
}

#pragma mark -

- (void)_traitCollectionDidChangeWithView:(UIView *)view {
    [self _traitCollectionDidChangeWithTargetView:view];
}

- (void)_traitCollectionDidChange {
    NSArray <UIView *> *targetViewArray = [self.weakDelegateManager getDelegates];
    for (UIView *view in targetViewArray) {
        [self _traitCollectionDidChangeWithTargetView:view];
    }
}

- (void)_traitCollectionDidChangeWithTargetView:(UIView *)targetView {
    
    TABViewAnimated *_tabAnimated = _controlView.tabAnimated;
    
    if (!_controlView || !_tabAnimated) {
        return;
    }
    
    if (_tabAnimated.switcher) {
        if (_tabAnimated.switcher  && [_tabAnimated.switcher  respondsToSelector:@selector(traitCollectionDidChange:tabAnimated:backgroundLayer:layers:)]) {
            TABAnimatedProduction *production = targetView.tabAnimatedProduction;
            [_tabAnimated.switcher  traitCollectionDidChange:_controlView.traitCollection
                                                           tabAnimated:_tabAnimated
                                                       backgroundLayer:production.backgroundLayer
                                                                layers:production.layers];
        }
        return;
    }
    
    if (_tabAnimated.superAnimationType == TABViewSuperAnimationTypeDefault) {
        if ([TABAnimated sharedAnimated].animationType == TABAnimationTypeOnlySkeleton) {
            _tabAnimated.switcher  = TABAnimatedDarkModeImpl.new;
        }else if ([TABAnimated sharedAnimated].animationType == TABAnimationTypeShimmer) {
            _tabAnimated.switcher  = (id <TABAnimatedDarkModeInterface>)_tabAnimated.decorator;
        }else if ([TABAnimated sharedAnimated].animationType == TABAnimationTypeDrop) {
            _tabAnimated.switcher  = (id <TABAnimatedDarkModeInterface>)_tabAnimated.decorator;
        }
    }else if(_tabAnimated.superAnimationType == TABViewSuperAnimationTypeOnlySkeleton) {
        _tabAnimated.switcher  = TABAnimatedDarkModeImpl.new;
    }else if (_tabAnimated.superAnimationType == TABViewSuperAnimationTypeShimmer) {
        _tabAnimated.switcher  = (id <TABAnimatedDarkModeInterface>)_tabAnimated.decorator;
    }else if (_tabAnimated.superAnimationType == TABViewSuperAnimationTypeDrop) {
        _tabAnimated.switcher  = (id <TABAnimatedDarkModeInterface>)_tabAnimated.decorator;
    }
    
    if (_tabAnimated.switcher) {
        if (_tabAnimated.switcher  && [_tabAnimated.switcher  respondsToSelector:@selector(traitCollectionDidChange:tabAnimated:backgroundLayer:layers:)]) {
            TABAnimatedProduction *production = targetView.tabAnimatedProduction;
            [_tabAnimated.switcher  traitCollectionDidChange:_controlView.traitCollection
                                                           tabAnimated:_tabAnimated
                                                       backgroundLayer:production.backgroundLayer
                                                                layers:production.layers];
        }
    }
}

#pragma mark -

- (TABSentryView *)sentryView {
    if (!_sentryView) {
        _sentryView = TABSentryView.new;
    }
    return _sentryView;
}

- (TABWeakDelegateManager *)weakDelegateManager {
    if (!_weakDelegateManager) {
        _weakDelegateManager = TABWeakDelegateManager.new;
    }
    return _weakDelegateManager;
}

@end
