//
//  TABRevealChainManager.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/9/2.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABRevealChainManager.h"

#import "TABRevealChainModel.h"

@implementation TABRevealChainManager

- (instancetype)init {
    if (self = [super init]) {
        _chainModelArray = @[].mutableCopy;
    }
    return self;
}

- (void)installChainStatementByModelArray:(NSArray <TABRevealChainModel *> *)modelArray {
    
    NSString *resultString = @"manager";
    for (TABRevealChainModel *model in modelArray) {
        switch (model.chainType) {
                
            case TABRevealChainCGFloat:
                [resultString stringByAppendingString:[NSString stringWithFormat:@".%@(%lf)",model.chainName,[(NSNumber *)model.chainValue floatValue]]];
                break;
                
            case TABRevealChainNSInteger:
                [resultString stringByAppendingString:[NSString stringWithFormat:@".%@(%d)",model.chainName,[(NSNumber *)model.chainValue intValue]]];
                break;
                
            case TABRevealChainString:
                [resultString stringByAppendingString:[NSString stringWithFormat:@".%@(%@)",model.chainName, (NSString *)model.chainValue]];
                break;
                
            case TABRevealChainVoid:
                [resultString stringByAppendingString:[NSString stringWithFormat:@".%@()",model.chainName]];
                break;
            case TABRevealChainColor:
                [resultString stringByAppendingString:[NSString stringWithFormat:@".%@(%@)",model.chainName, (NSString *)model.chainValue]];
                break;
        }
    }
    [resultString stringByAppendingString:@";\n"];
    [self.cacheCodeString stringByAppendingString:resultString];
    [self.chainModelArray addObjectsFromArray:modelArray];
}

- (NSString *)cacheCodeString {
    NSString *nodeString = [NSString stringWithFormat:@"manager.%@",self.prefixString];
    for (TABRevealChainModel *model in self.chainModelArray) {
        nodeString = [nodeString stringByAppendingString:
         [NSString stringWithFormat:@".%@(%@)",model.chainName,
          [self appendChainFunctionNameWithValue:model.chainValue
                                            type:model.chainType]]];
    }
    nodeString = [nodeString stringByAppendingString:@";\n"];
    return nodeString;
}

- (NSString *)appendChainFunctionNameWithValue:(id)value
                                          type:(TABRevealChainType)type {
    NSString *resultString;
    switch (type) {
        case TABRevealChainCGFloat:
            resultString = [NSString stringWithFormat:@"%.lf",[(NSNumber *)value floatValue]];
            break;
        case TABRevealChainNSInteger:
            resultString = [NSString stringWithFormat:@"%ld",(long)[(NSNumber *)value integerValue]];
            break;
        case TABRevealChainString:
            resultString = (NSString *)value;
            break;
        case TABRevealChainVoid:
            resultString = @"";
            break;
        case TABRevealChainColor:
            resultString = [NSString stringWithFormat:@"tab_RGB(%@)",(NSString *)value];
            break;
    }
    return resultString;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:_managerType forKey:@"managerType"];
    [aCoder encodeObject:_prefixString forKey:@"prefixString"];
    [aCoder encodeObject:_targetString forKey:@"targetString"];
    [aCoder encodeObject:_cacheCodeString forKey:@"cacheCodeString"];
    [aCoder encodeObject:_chainModelArray forKey:@"chainModelArray"];
    
    [aCoder encodeBool:_reEdit forKey:@"reEdit"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.managerType = [aDecoder decodeIntegerForKey:@"managerType"];
        self.prefixString = [aDecoder decodeObjectForKey:@"prefixString"];
        self.targetString = [aDecoder decodeObjectForKey:@"targetString"];
        self.cacheCodeString = [aDecoder decodeObjectForKey:@"cacheCodeString"];
        self.chainModelArray = [aDecoder decodeObjectForKey:@"chainModelArray"];
        
        self.reEdit = [aDecoder decodeBoolForKey:@"reEdit"];;
    }
    return self;
}

@end
