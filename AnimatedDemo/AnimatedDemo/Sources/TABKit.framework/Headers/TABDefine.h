//
//  TABDefine.h
//  TABBaseProject
//
//  Created by tigerAndBull on 2018/10/26.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#ifndef TABDefine_h
#define TABDefine_h

#import "TABSafe.h"

#define kAPPDELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define tabbarSize (self.hidesBottomBarWhenPushed ? CGSizeZero : self.navigationController.tabBarController.tabBar.frame.size)
#define navigationBarSize (self.navigationController.navigationBar.frame.size)
#define statusFrameSize ([UIApplication sharedApplication].statusBarFrame.size)

// use to iPad
#define isIPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
// use to iphone 5,5s,6,7,8
#define isIPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
// use to iphone 6P,7P,8P
#define isIPhonePlus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)
// use to iphoneX,XR,XS,XS Max
#define isIPhoneFill (([UIScreen mainScreen].bounds.size.height == 812) || ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isIPad : NO) || ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isIPad : NO) || ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isIPad : NO))

#define kNavigationHeight (isIPhoneFill?88:64)
#define kTabbarHeight (isIPhoneFill?83:49)
#define kSafeAreaHeight (isIPhoneFill?34:0)
#define kStatusHeight (isIPhoneFill?44:20)

#define kFont(x) [UIFont systemFontOfSize:((isIPhonePlus)?(x + 1):((isIPhoneFill)?(x + 2):x))]
#define kBlodFont(x) [UIFont boldSystemFontOfSize:((isIPhonePlus)?(x + 1):((isIPhoneFill)?(x + 2):x))]

#define kColor(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0]
#define kBackColor kColor(0xEEEEEEFF)
#define kNavigationColor ([UIColor colorWithRed:139/255.0 green:221/255.0 blue:94/255.0 alpha:1])
#define kHeight(x) ((kScreenHeight/812.0)*x)
#define kWidth(x) ((kScreenWidth/375.0)*x)

#define kImageMaxWidth 720
#define kImageMaxHeight 1280

#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#pragma mark - AD

#define bannerHeight (isIPad?90:50)
#define bannerWidth (isIPad?728:320)

#endif /* TABDefine_h */
