//
//  UIImage+TABAnimatedDemo.m
//  TABAnimatedDemo
//
//  Created by tigerAndBull on 2021/3/24.
//  Copyright © 2021 tigerAndBull. All rights reserved.
//

#import "UIImage+TABAnimatedDemo.h"
#import <objc/runtime.h>

@implementation UIImage (TABAnimatedDemo)

+ (void)load {
    Method imageNamed = class_getClassMethod(self,@selector(imageNamed:));
    Method looha_ImageNamed =class_getClassMethod(self, @selector(tab_none_imageNamed:));
    method_exchangeImplementations(imageNamed, looha_ImageNamed);
}

+ (instancetype)tab_none_imageNamed:(NSString *)name {
    if (name && name.length > 0) {
        return [self tab_none_imageNamed:name];
    }else{
        return nil;
    }
}

@end
