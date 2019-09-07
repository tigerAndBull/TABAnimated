//
//  TABRevealTableViewCell.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/9/1.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TABButtonProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface TABRevealTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, weak) id <TABButtonProtocol> delegate;

@end

NS_ASSUME_NONNULL_END
