//
//  MainViewController.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/10/7.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    // 一级
    MainViewControllerMain = 0,
    
    // 二级
    MainViewControllerCode,
    MainViewControllerXib,
    MainViewControllerDouban,
    MainViewControllerAutoLayout,
    MainViewControllerDelegateSelf,
    
    // 三级
    MainViewControllerCodeUseTableView,
    MainViewControllerCodeUseCollectionView,
    MainViewControllerCodeUseCustomView,
    
    MainViewControllerXibUseTableView,
    MainViewControllerXibUseCollectionView,
    MainViewControllerXibUseCustomView,
    
    MainViewControllerDoubanUseTableView,
    MainViewControllerDoubanUseCollectionView,
    MainViewControllerDoubanUseCustomView,
    
    MainViewControllerAutoLayoutUseTableView,
    MainViewControllerAutoLayoutUseCollectionView,
    MainViewControllerAutoLayoutUseCustomView,
    
} MainViewControllerType;

@interface MainViewController : UIViewController

@property (nonatomic) MainViewControllerType type;

@end

NS_ASSUME_NONNULL_END
