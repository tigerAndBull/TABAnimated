//
//  TABAnimatedInjectionIIIHelper.m
//  TABAnimatedDemo
//
//  Created by tigerAndBull on 2020/7/19.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "TABAnimatedInjectionIIIHelper.h"
#import <objc/runtime.h>
#import "UIView+TABControlModel.h"

@implementation TABAnimatedInjectionIIIHelper

#if DEBUG

/**
 InjectionIII 热部署会调用的一个方法，
 runtime给VC绑定上之后，每次部署完就重新viewDidLoad
*/
void injected(id self, SEL _cmd) {
    [self viewDidLoad];
}

+ (void)load {
    __block id observer =
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [[NSBundle bundleWithPath:@"/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle"] load];
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }];
    class_addMethod([UIViewController class], NSSelectorFromString(@"injected"), (IMP)injected, "v@:");
}

#endif

@end
