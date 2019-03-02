//
//  UIImage+TABCategory.h
//  TABKit
//
//  Created by tigerAndBull on 2019/2/15.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (TABCategory)

/**
 Modify the size of image.
 the origin object is changed.

 @param toSize  target size
 @return        return the new image
 */
- (UIImage *)changeImageSize:(CGSize)toSize;

@end

NS_ASSUME_NONNULL_END
