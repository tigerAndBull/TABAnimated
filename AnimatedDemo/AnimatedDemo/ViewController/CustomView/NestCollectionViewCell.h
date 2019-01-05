#import <UIKit/UIKit.h>

#import "BaseCollectionCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface NestCollectionViewCell : BaseCollectionCell

- (void)updateCellWithData:(NSMutableArray *)array;

@end

NS_ASSUME_NONNULL_END
