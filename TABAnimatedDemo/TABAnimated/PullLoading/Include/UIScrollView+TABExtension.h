

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (TABExtension)

@property (readonly, nonatomic) UIEdgeInsets tab_inset;

@property (assign, nonatomic) CGFloat tab_insetT;
@property (assign, nonatomic) CGFloat tab_insetB;
@property (assign, nonatomic) CGFloat tab_insetL;
@property (assign, nonatomic) CGFloat tab_insetR;

@property (assign, nonatomic) CGFloat tab_offsetX;
@property (assign, nonatomic) CGFloat tab_offsetY;

@property (assign, nonatomic) CGFloat tab_contentW;
@property (assign, nonatomic) CGFloat tab_contentH;

@end

NS_ASSUME_NONNULL_END
