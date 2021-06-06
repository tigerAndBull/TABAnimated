//
//  TABAnimatedConfig.h
//  TABAnimatedDemo
//
//  Created by tigerAndBull on 2020/1/15.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#ifndef TABAnimatedConfig_h
#define TABAnimatedConfig_h

#import "UIView+TABAnimatedProduction.h"
#import "UIView+TABControlAnimation.h"
#import "NSArray+TABAnimatedChain.h"
#import "UIView+TABControlModel.h"

#import "TABViewAnimated.h"
#import "TABTableAnimated.h"
#import "TABCollectionAnimated.h"

#import "TABAnimatedProduction.h"

typedef void (^TABConfigBlock)(TABViewAnimated * _Nonnull tabAnimated);

#define tabAnimatedLog(x) {if([TABAnimated sharedAnimated].openLog) NSLog(x);}
#define tab_kColor(s) [UIColor colorWithRed:(((s&0xFF0000)>>16))/255.0 green:(((s&0xFF00)>>8))/255.0 blue:((s&0xFF))/255.0 alpha:1.]
#define tab_RGB(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.]

#define tab_kBackColor tab_kColor(0xEEEEEE)
#define tab_kDarkBackColor tab_kColor(0x282828)
#define tab_kShimmerBackColor tab_kColor(0xDFDFDF)

#endif /* TABAnimatedConfig_h */
