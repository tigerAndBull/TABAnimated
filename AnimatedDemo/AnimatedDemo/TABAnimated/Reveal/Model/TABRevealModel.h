//
//  TABRevealModel.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/9/6.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TABRevealChainManager;

@interface TABRevealModel : NSObject<NSCoding>

@property (nonatomic, strong) NSMutableArray <TABRevealChainManager *> *chainManagerArray;
@property (nonatomic, strong) NSNumber *chainManagerCount;

@property (nonatomic, copy) NSString *targetClassString;
@property (nonatomic) CGFloat targetHeight;
@property (nonatomic) CGFloat targetWidth;

- (void)managerAddObject:(TABRevealChainManager *)manager;
- (void)managerRemoveObject:(NSInteger)index;

- (void)updateArrayToCache;

@end

NS_ASSUME_NONNULL_END
