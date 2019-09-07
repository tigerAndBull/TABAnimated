//
//  TABPreviewViewController.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/9/1.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    TABPreviewViewControllerCustomView,
    TABPreviewViewControllerTableView,
    TABPreviewViewControllerCollectionView,
} TABPreviewViewControllerType;

@class TABRevealChainManager;

@interface TABPreviewViewController : UIViewController

@property (nonatomic) Class targetClass;
@property (nonatomic) CGFloat targetWidth;
@property (nonatomic) CGFloat targetHeight;
@property (nonatomic, strong) NSMutableArray <TABRevealChainManager *> *chainManagerArray;

@end

NS_ASSUME_NONNULL_END
