//
//  TABSentryView.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/9/29.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TABSentryViewCallBack)(void);

@interface TABSentryView : UIView

@property (nonatomic, copy) TABSentryViewCallBack traitCollectionDidChangeBack;

@end

NS_ASSUME_NONNULL_END
