//
//  TABButtonProtocol.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/9/1.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TABButtonProtocol <NSObject>

@optional
- (void)clickButton:(UIButton *)button targetClass:(Class)targetClass;

- (void)clickButton:(UIButton *)button targetClass:(Class)targetClass indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
