
#import <UIKit/UIKit.h>

@class TABAnimatedWaterFallLayout;

NS_ASSUME_NONNULL_BEGIN

@protocol TABAnimatedWaterFallLayoutDelegate <NSObject>

// item 高度
- (CGFloat)waterFallLayout:(TABAnimatedWaterFallLayout *)waterFallLayout heightForItemAtIndex:(NSInteger)index itemWidth:(CGFloat)itemWidth;

@optional
// 多少列
- (NSUInteger)numberColumnsInWaterFallLayout:(TABAnimatedWaterFallLayout *)waterFallLayout;
// 列间距
- (CGFloat)columnSpacingInWaterFallLayout:(TABAnimatedWaterFallLayout *)waterFallLayout;
// 行间距
- (CGFloat)lineSpacingInWaterFallLayout:(TABAnimatedWaterFallLayout *)waterFallLayout;
// 边距
- (UIEdgeInsets)sectionInsetInWaterFallLayout:(TABAnimatedWaterFallLayout *)waterFallLayout;

@end

@interface TABAnimatedWaterFallLayout : UICollectionViewLayout

@property (nonatomic, weak) id<TABAnimatedWaterFallLayoutDelegate> delegate;

// 总列数
@property (nonatomic, assign) NSInteger columnCount;
// 列间距
@property (nonatomic, assign) NSInteger columnSpacing;
// 行间距
@property (nonatomic, assign) NSInteger lineSpacing;
// 边距
@property (nonatomic, assign) UIEdgeInsets sectionInset;

@end

NS_ASSUME_NONNULL_END
