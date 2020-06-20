//
//  TABAnimatedCacheModel.h
//  TABAnimatedDemo
//
//  Created by tigerAndBull on 2019/9/21.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TABAnimatedCacheModel : NSObject <NSSecureCoding>

@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, assign) NSInteger loadCount;

@end

NS_ASSUME_NONNULL_END
