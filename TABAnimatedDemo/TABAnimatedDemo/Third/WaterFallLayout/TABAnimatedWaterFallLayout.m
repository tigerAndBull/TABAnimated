
#import "TABAnimatedWaterFallLayout.h"

@interface TABAnimatedWaterFallLayout ()

// 保存每一列最大y值的数组
@property (nonatomic, strong) NSMutableArray *columnHeightArray;

// 保存每一个item的attributes的数组
@property (nonatomic, strong) NSMutableArray *attributesArray;

@end

@implementation TABAnimatedWaterFallLayout

- (NSInteger)columnCount {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberColumnsInWaterFallLayout:)]) {
        
        return [self.delegate numberColumnsInWaterFallLayout:self];
    }
    if (_columnCount > 0) {
        
        return _columnCount;
    }
    return 2;
}

- (NSInteger)columnSpacing {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(columnSpacingInWaterFallLayout:)]) {
        
        return [self.delegate columnSpacingInWaterFallLayout:self];
    }
    if (_columnSpacing > 0) {
        
        return _columnSpacing;
    }
    return 10.0;
}

- (NSInteger)lineSpacing {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(lineSpacingInWaterFallLayout:)]) {
        
        return [self.delegate lineSpacingInWaterFallLayout:self];
    }
    if (_lineSpacing > 0) {
        
        return _lineSpacing;
    }
    return 10.0;
}

- (UIEdgeInsets)sectionInset {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sectionInsetInWaterFallLayout:)]) {
        
        return [self.delegate sectionInsetInWaterFallLayout:self];
    }
    if (_sectionInset.top != 0 || _sectionInset.left != 0 || _sectionInset.bottom != 0 || _sectionInset.right != 0) {
        
        return _sectionInset;
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

/**
 *懒加载
 */
- (NSMutableArray *)columnHeightArray
{
    if (_columnHeightArray == nil)
    {
        _columnHeightArray = [NSMutableArray array];
    }
    return _columnHeightArray;
}
- (NSMutableArray *)attributesArray
{
    if (_attributesArray == nil)
    {
        _attributesArray = [NSMutableArray array];
    }
    return _attributesArray;
}

// 布局前的准备会调用这个方法
- (void)prepareLayout {
    
    [super prepareLayout];
    [self.columnHeightArray removeAllObjects];
    for (int i = 0; i < self.columnCount; i++) {
        
        [self.columnHeightArray addObject:@(self.sectionInset.top)];
    }
    // 根据collectionView获取总共有多少个item
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    // 为每一个item创建一个attributes并存入数组
    [self.attributesArray removeAllObjects];
    for (int i = 0; i < itemCount; i++) {
        
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attributesArray addObject:attributes];
    }
}

/**
 *决定cell的排布
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    return self.attributesArray;
}

/**
 *返回indexPath位置cell对应的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [[self.columnHeightArray objectAtIndex:0] doubleValue];
    for (int i = 1; i < self.columnCount; i++) {
        
        CGFloat columnHeight = [self.columnHeightArray[i] doubleValue];
        if (minColumnHeight > columnHeight) {
            
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    
    CGFloat w = (self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right - (self.columnCount - 1) * self.columnSpacing) / self.columnCount;
    CGFloat h = [self.delegate waterFallLayout:self heightForItemAtIndex:indexPath.item itemWidth:w];
    CGFloat x = self.sectionInset.left + destColumn * (w + self.columnSpacing);
    CGFloat y = minColumnHeight;
    if (y != self.sectionInset.top) {
        
        y += self.lineSpacing;
    }
    
    attributes.frame = CGRectMake(x, y, w, h);
    
    self.columnHeightArray[destColumn] = @(y + h);
    return attributes;
}


- (CGSize)collectionViewContentSize {
    
    CGFloat maxHeight = [[self.columnHeightArray objectAtIndex:0] doubleValue];
    for (int i = 1; i < self.columnCount; i++) {
        //取得第i列的高度
        float height = [self.columnHeightArray[i] doubleValue];
        if (height > maxHeight) {
            
            maxHeight = height;
        }
    }
    return CGSizeMake(0, maxHeight + self.sectionInset.bottom);
}


@end
