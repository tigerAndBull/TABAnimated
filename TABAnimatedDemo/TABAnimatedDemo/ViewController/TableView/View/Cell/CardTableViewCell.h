//
//  CardTableViewCell.h
//  TABAnimatedDemo
//
//  Created by tigerAndBull on 2019/10/2.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardTableViewCell : BaseTableViewCell

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *leftImg;
@property (nonatomic, strong) UILabel *infoLab;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *priceLab;

@end

NS_ASSUME_NONNULL_END
