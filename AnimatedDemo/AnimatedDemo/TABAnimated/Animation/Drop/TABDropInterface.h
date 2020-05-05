//
//  TABDropInterface.h
//  AnimatedDemo
//
//  Created by wenhuan on 2020/4/23.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#ifndef TABDropInterface_h
#define TABDropInterface_h

@protocol TABDropInterface <NSObject>

- (void)setDropIndex:(NSInteger)index;
- (NSInteger)getDropIndex;

- (void)setFromIndex:(NSInteger)fromIndex;
- (NSInteger)getFromIndex;

- (void)setStayTime:(CGFloat)stayTime;
- (NSInteger)getStayTime;

@end

#endif /* TABDropInterface_h */
