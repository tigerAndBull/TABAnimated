//
//  TABRevealChainModel.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/9/1.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    TABRevealChainCGFloat = 0,
    TABRevealChainNSInteger,
    TABRevealChainString,
    TABRevealChainVoid,
    TABRevealChainColor,
} TABRevealChainType;

@interface TABRevealChainModel : NSObject<NSCoding>

+ (TABRevealChainType)getChainModelTypeByString:(NSString *)string;

@property (nonatomic) TABRevealChainType chainType;
@property (nonatomic, copy) NSString *chainName;
@property (nonatomic) id chainValue;

@end

NS_ASSUME_NONNULL_END
