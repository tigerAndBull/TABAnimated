//
//  CourseTemplateCollectionViewCell.h
//  yifu
//
//  Created by tigerAndBull on 2019/4/15.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TABBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface CardTemplateCollectionViewCell : TABBaseCollectionViewCell

@property (nonatomic,strong) UIImageView *leftImg;
@property (nonatomic,strong) UILabel *infoLab;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *priceLab;

@property (nonatomic,strong) UIView *shadowView;

@end

NS_ASSUME_NONNULL_END
