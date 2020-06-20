//
//  LineTableViewHeaderFooterView.h
//  TABAnimatedDemo
//
//  Created by tigerAndBull on 2020/5/4.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LineTableViewHeaderFooterView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *lineView;

@end

NS_ASSUME_NONNULL_END
