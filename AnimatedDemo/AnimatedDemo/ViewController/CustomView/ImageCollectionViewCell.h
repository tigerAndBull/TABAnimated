#import <UIKit/UIKit.h>
#import "BaseCollectionCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageCollectionViewCell : BaseCollectionCell

@property (nonatomic, strong) UIImageView *imgV;

+ (CGSize)cellSizeWithWidth:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
