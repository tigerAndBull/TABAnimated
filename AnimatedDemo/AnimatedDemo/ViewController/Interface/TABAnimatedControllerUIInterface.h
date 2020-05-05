//
//  TABAnimatedControllerUIInterface.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/5/3.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#ifndef TABAnimatedControllerUIInterface_h
#define TABAnimatedControllerUIInterface_h

#import <Foundation/Foundation.h>

typedef void(^RightButtonClickBlock)(UIButton *btn);

@protocol TABAnimatedControllerUIInterface <NSObject>

- (void)addRightButtonWithText:(NSString *)text controller:(UIViewController *)controller clickButtonBlock:(RightButtonClickBlock)clickButtonBlock;

@end

#endif /* TABAnimatedControllerUIInterface_h */
