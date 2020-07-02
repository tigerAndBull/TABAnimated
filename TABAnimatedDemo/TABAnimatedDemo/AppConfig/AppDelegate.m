//
//  AppDelegate.m
//  TABAnimatedDemo
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBulll. All rights reserved.
//

#import "AppDelegate.h"

#import "MainViewController.h"
#import "TABAnimated.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // 初始化TABAnimated，并设置TABAnimated相关属性
    // 初始化方法仅仅设置的是全局的动画效果
    // 你可以设置`TABViewAnimated`中局部动画属性`superAnimationType`覆盖全局属性，在工程中兼容多种动画
    [[TABAnimated sharedAnimated] initWithOnlySkeleton];
    // 开启日志
    [TABAnimated sharedAnimated].openLog = NO;
    // 是否开启动画坐标标记，如果开启，也仅在debug环境下有效。
    // 开启后，会在每一个动画元素上增加一个红色的数字，该数字表示该动画元素所在下标，方便快速定位某个动画元素。
    [TABAnimated sharedAnimated].openAnimationTag = NO;
    // 如果你想在 debug 环境下测试缓存功能，可以手动置为NO，但是预处理回调只生效一次！！！！
    // 如果你始终都不想使用缓存功能，可以手动置为YES
    // debug 环境下，默认关闭缓存功能（为了方便调试预处理回调)
    // release 环境下，默认开启缓存功能
    [TABAnimated sharedAnimated].closeCache = YES;

    MainViewController *vc = [[MainViewController alloc] init];
    vc.title = kText(@"主页面");
    _nav = [[UINavigationController alloc]initWithRootViewController:vc];
    
    [self.window setRootViewController:_nav];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
