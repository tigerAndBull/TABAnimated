//
//  TABRevealAddChainView.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/9/1.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TABRevealChainManager;

typedef void(^TABRevealAddDoneBlock)(TABRevealChainManager *chainManager);

@interface TABRevealAddChainView : UIView

@property (nonatomic, copy) TABRevealAddDoneBlock addDoneBlock;
@property (nonatomic, weak) UIViewController *currentController;

- (void)paddingDataWithManager:(TABRevealChainManager *)manager;

@end

NS_ASSUME_NONNULL_END
