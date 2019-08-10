//
//  TableDelegateSelfModel.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/8/10.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableDeDaSelfModel : NSObject

@property (nonatomic,copy) NSString *targetClassName;

@property (nonatomic,assign) BOOL isExhangeDelegate;
@property (nonatomic,assign) BOOL isExhangeDataSource;

@end

NS_ASSUME_NONNULL_END
