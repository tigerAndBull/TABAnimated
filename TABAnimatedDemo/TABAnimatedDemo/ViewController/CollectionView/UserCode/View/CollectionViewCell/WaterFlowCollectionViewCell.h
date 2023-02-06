//
//  WaterFlowCollectionViewCell.h
//  TABAnimatedDemo
//
//  Created by anwenhu on 2023/2/6.
//  Copyright © 2023 tigerAndBull. All rights reserved.
//

#import "BaseCollectionCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface WaterFlowCollectionViewCell : BaseCollectionCell

@property (nonatomic,strong) UIImageView *leftImg;
@property (nonatomic,strong) UILabel *infoLab;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *priceLab;

- (void)updateWithModel:(id)model;

@end

NS_ASSUME_NONNULL_END
