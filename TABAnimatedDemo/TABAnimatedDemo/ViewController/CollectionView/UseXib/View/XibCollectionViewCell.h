//
//  XibCollectionViewCell.h
//  TABAnimatedDemo
//
//  Created by tigerAndBull on 2019/5/22.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XibCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftLab;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *bottomLab;


@end

NS_ASSUME_NONNULL_END
