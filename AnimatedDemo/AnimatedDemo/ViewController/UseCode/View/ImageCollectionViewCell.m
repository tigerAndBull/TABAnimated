#import "ImageCollectionViewCell.h"

#import "TABAnimated.h"
#import "Masonry.h"
#import <TABKit/TABKit.h>

@interface ImageCollectionViewCell()

@end

@implementation ImageCollectionViewCell

+ (CGSize)cellSize {
    return CGSizeMake((kScreenWidth-(15)*3-(45))/2+(15), ((kScreenWidth-(15)*3-(45))/2)*(3/2.0));
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.imgV];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self);
        make.left.mas_equalTo(self).mas_offset(15);
        make.right.mas_equalTo(self);
    }];
    
    self.imgV.layer.cornerRadius = 4;
}

- (void)updateWithModel:(id)model {
    
}

- (UIImageView *)imgV {
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.contentMode = UIViewContentModeScaleAspectFill;
        _imgV.layer.masksToBounds = YES;
        _imgV.clipsToBounds = YES;
        _imgV.tag = 1000;
    }
    return _imgV;
}

@end
