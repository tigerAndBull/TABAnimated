//
//  TABMethod.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBulll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//判断是否是iphone
#define kIsIPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//判断是否是iphoneX
#define kIsIPhone_X (kIsIPhone && [[UIScreen mainScreen] bounds].size.height == 812.0)
//获取屏幕宽
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
//获取屏幕高
#define kScreenHeight ((kIsIPhone_X)?([[UIScreen mainScreen] bounds].size.height-49):([[UIScreen mainScreen] bounds].size.height))

#define kFont(x) [UIFont systemFontOfSize:x]
#define kColor(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0 alpha:((c)&0xFF)/255.0]
#define kBackColor kColor(0xEEEEEEFF)

@interface TABMethod : NSObject

/**
 获取文本大小

 @param text 文本内容
 @param font 字体大小
 @param size 文本区域
 @return CGSize 文本区域大小
 */
+ (CGSize)tab_getSizeWithText:(NSString *)text sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

@end
