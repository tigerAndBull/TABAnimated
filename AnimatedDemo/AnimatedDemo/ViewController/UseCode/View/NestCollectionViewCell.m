#import "NestCollectionViewCell.h"
#import "ImageCollectionViewCell.h"
#import "AppDelegate.h"
#import "TABAnimated.h"
#import "Masonry.h"
#import "UIView+TABAnimated.h"
#import <TABKit/TABKit.h>

@interface NestCollectionViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSMutableArray * dataArray;
}

@property (nonatomic, strong) UICollectionView * collectionView;

@end

@implementation NestCollectionViewCell

+ (CGSize)cellSize {
    return CGSizeMake(kScreenWidth, ((kScreenWidth-15*3-45)/2)*(3/2.0)+10);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.bottom.mas_equalTo(self).mas_offset(10);
        make.top.mas_equalTo(self).mas_offset(0);
    }];
}

- (void)updateCellWithData:(NSMutableArray *)array {
    self->dataArray = array;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self->dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [ImageCollectionViewCell cellSize];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.1f;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ImageCollectionViewCell *cell = [ImageCollectionViewCell cellWithIndexPath:indexPath atCollectionView:collectionView];
    [cell.imgV setImage:[UIImage imageNamed:dataArray[indexPath.row]]];
    
    return cell;
}

#pragma mark - Init Method

- (void)initUI {
    [self.contentView addSubview:self.collectionView];
    [ImageCollectionViewCell registerCellInCollectionView:self.collectionView];
}

#pragma mark - Lazy Method

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width, self.frame.size.height-40) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        _collectionView.tabAnimated =
        [TABCollectionAnimated animatedWithCellClass:[ImageCollectionViewCell class]
                                            cellSize:[ImageCollectionViewCell cellSize]];
        _collectionView.tabAnimated.isNest = YES;
        _collectionView.tabAnimated.animatedCount = 3;
    }
    return _collectionView;
}
@end
