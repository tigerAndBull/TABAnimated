//
//  TABRevealChainModel.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/9/1.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABRevealChainModel.h"

@implementation TABRevealChainModel

+ (TABRevealChainType)getChainModelTypeByString:(NSString *)string {
    NSInteger index = [self partitionWithArray:self.functionNameArray targetStr:string];
    if (index != -1) {
        return [self.functionTypeArray[index] integerValue];
    }
    return TABRevealChainCGFloat;
}

+ (NSInteger)partitionWithArray:(NSArray <NSString *> *)array
                      targetStr:(NSString *)targetStr {
    if (array == nil || array.count <= 0) {
        return -1;
    }
    
    for (int i = 0; i < array.count; i++) {
        if ([targetStr isEqualToString:array[i]]) {
            return i;
        }
    }
    return -1;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_chainName forKey:@"chainName"];
    [aCoder encodeObject:_chainValue forKey:@"chainValue"];
    [aCoder encodeInteger:_chainType forKey:@"chainType"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.chainName = [aDecoder decodeObjectForKey:@"chainName"];
        self.chainValue = [aDecoder decodeObjectForKey:@"chainValue"];
        self.chainType = [aDecoder decodeIntegerForKey:@"chainType"];
    }
    return self;
}

+ (NSArray <NSString *> *)functionNameArray {
    return @[
             @"left",@"reducedWidth",
             @"right",@"reducedHeight",
             @"up",@"reducedRadius",
             @"down",@"line",
             @"width",@"placeholder",
             @"height",@"color",
             @"radius",@"dropIndex",
             @"x",@"dropFromIndex",
             @"y",@"dropStayTime",
             ];
}

+ (NSArray <NSNumber *> *)functionTypeArray {
    return @[
             @(TABRevealChainCGFloat),@(TABRevealChainCGFloat),
             @(TABRevealChainCGFloat),@(TABRevealChainCGFloat),
             @(TABRevealChainCGFloat),@(TABRevealChainCGFloat),
             @(TABRevealChainCGFloat),@(TABRevealChainNSInteger),
             @(TABRevealChainCGFloat),@(TABRevealChainString),
             @(TABRevealChainCGFloat),@(TABRevealChainColor),
             @(TABRevealChainCGFloat),@(TABRevealChainNSInteger),
             @(TABRevealChainCGFloat),@(TABRevealChainNSInteger),
             @(TABRevealChainCGFloat),@(TABRevealChainCGFloat),
             ];
}
@end
