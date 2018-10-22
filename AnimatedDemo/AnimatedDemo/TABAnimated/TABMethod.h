//
//  TABMethod.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

// judge is iphone
#define tab_kIsIPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
// judge is iphoneX
#define tab_kIsIPhone_X (tab_kIsIPhone && [[UIScreen mainScreen] bounds].size.height == 812.0)
// get screen width
#define tab_kScreenWidth [[UIScreen mainScreen] bounds].size.width
// get screen height
#define tab_kScreenHeight ((tab_kIsIPhone_X)?([[UIScreen mainScreen] bounds].size.height-49):([[UIScreen mainScreen] bounds].size.height))

#define tab_kFont(x) [UIFont systemFontOfSize:x]
#define tab_kColor(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0]
#define tab_kBackColor tab_kColor(0xEEEEEEFF)

@interface TABMethod : NSObject

/**
 get text size

 @param text text content
 @param font font size
 @param size max text area
 @return CGSize new text size
 */
+ (CGSize)tab_getSizeWithText:(NSString *)text sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;


@end
