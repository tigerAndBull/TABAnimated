//
//  News.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/5/1.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface News : NSObject

@property (nonatomic,copy) NSString *imageUrl;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *coverImageUrls;

@end

NS_ASSUME_NONNULL_END
