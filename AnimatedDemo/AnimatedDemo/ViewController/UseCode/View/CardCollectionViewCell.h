//
//  CourseListCollectionViewCell.h
//  yifu
//
//  Created by tigerAndBull on 2019/3/6.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCollectionCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardCollectionViewCell : BaseCollectionCell

@property (nonatomic,strong) UIImageView *leftImg;
@property (nonatomic,strong) UILabel *infoLab;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *priceLab;

@property (nonatomic,strong) UIView *shadowView;

- (void)updateWithModel:(id)model;

@end

NS_ASSUME_NONNULL_END
