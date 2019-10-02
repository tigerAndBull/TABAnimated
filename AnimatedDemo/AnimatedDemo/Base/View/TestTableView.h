//
//  TestTableView.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/8/10.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestTableView : UITableView

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *cellName;

@end

NS_ASSUME_NONNULL_END
