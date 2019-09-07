//
//  TABRevealChainManager.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/9/2.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TABRevealChainModel;

typedef enum : NSUInteger {
    TABRevealChainManagerOne,
    TABRevealChainManagerMoreAndContinuous,
    TABRevealChainManagerMoreNotContinuous,
} TABRevealChainManagerType;

@interface TABRevealChainManager : NSObject<NSCoding>

@property (nonatomic) TABRevealChainManagerType managerType;
@property (nonatomic, copy) NSString *prefixString;
@property (nonatomic, copy) NSString *targetString;
@property (nonatomic, copy) NSString *cacheCodeString;
@property (nonatomic, strong) NSMutableArray <TABRevealChainModel *> *chainModelArray;

@property (nonatomic) BOOL reEdit;

- (void)installChainStatementByModelArray:(NSArray <TABRevealChainModel *> *)modelArray;

@end

NS_ASSUME_NONNULL_END
