//
//  TABCollectionAnimated.m
//  TABAnimatedDemo
//
//  Created by tigerAndBull on 2019/4/27.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABCollectionAnimated.h"

#import "TABViewAnimated.h"
#import "UIView+TABControlModel.h"
#import "UIView+TABControlAnimation.h"
#import <objc/runtime.h>

@interface TABCollectionAnimated()

@property (nonatomic, strong, readwrite) NSMutableArray <NSValue *> *headerSizeArray;
@property (nonatomic, strong, readwrite) NSMutableArray <NSValue *> *footerSizeArray;

@end

@implementation TABCollectionAnimated

+ (instancetype)animatedWithCellClass:(Class)cellClass
                             cellSize:(CGSize)cellSize {
    NSInteger animatedCount = ceilf([UIScreen mainScreen].bounds.size.height/cellSize.height*1.0);
    TABCollectionAnimated *obj = [TABCollectionAnimated _animatedWithCellClass:cellClass cellSize:cellSize animatedCount:animatedCount toIndex:0 runMode:TABAnimatedRunBySection];
    return obj;
}

+ (instancetype)animatedWithCellClass:(Class)cellClass
                             cellSize:(CGSize)cellSize
                        animatedCount:(NSInteger)animatedCount {
     TABCollectionAnimated *obj = [TABCollectionAnimated _animatedWithCellClass:cellClass cellSize:cellSize animatedCount:animatedCount toIndex:0 runMode:TABAnimatedRunBySection];
    return obj;
}

+ (instancetype)animatedWithCellClass:(Class)cellClass
                             cellSize:(CGSize)cellSize
                            toSection:(NSInteger)section {
    NSInteger animatedCount = ceilf([UIScreen mainScreen].bounds.size.height/cellSize.height*1.0);
    TABCollectionAnimated *obj = [TABCollectionAnimated _animatedWithCellClass:cellClass cellSize:cellSize animatedCount:animatedCount toIndex:section runMode:TABAnimatedRunBySection];
    return obj;
}

+ (instancetype)animatedWithCellClass:(Class)cellClass
                             cellSize:(CGSize)cellSize
                        animatedCount:(NSInteger)animatedCount
                            toSection:(NSInteger)section {
    TABCollectionAnimated *obj = [TABCollectionAnimated _animatedWithCellClass:cellClass cellSize:cellSize animatedCount:animatedCount toIndex:section runMode:TABAnimatedRunBySection];
    return obj;
}

+ (instancetype)animatedWithCellClassArray:(NSArray <Class> *)cellClassArray
                             cellSizeArray:(NSArray <NSValue *> *)cellSizeArray
                        animatedCountArray:(NSArray <NSNumber *> *)animatedCountArray {
    TABCollectionAnimated *obj = [TABCollectionAnimated _animatedWithCellClassArray:cellClassArray cellSizeArray:cellSizeArray animatedCountArray:animatedCountArray indexArray:nil runMode:TABAnimatedRunBySection];
    return obj;
}

+ (instancetype)animatedWithCellClassArray:(NSArray <Class> *)cellClassArray
                             cellSizeArray:(NSArray <NSValue *> *)cellSizeArray
                        animatedCountArray:(NSArray <NSNumber *> *)animatedCountArray
                      animatedSectionArray:(NSArray <NSNumber *> *)animatedSectionArray {
    TABCollectionAnimated *obj = [TABCollectionAnimated _animatedWithCellClassArray:cellClassArray cellSizeArray:cellSizeArray animatedCountArray:animatedCountArray indexArray:animatedSectionArray runMode:TABAnimatedRunBySection];
    return obj;
}

#pragma mark -

+ (instancetype)animatedInRowModeWithCellClassArray:(NSArray <Class> *)cellClassArray
                                      cellSizeArray:(NSArray <NSValue *> *)cellSizeArray {
    TABCollectionAnimated *obj = [TABCollectionAnimated _animatedWithCellClassArray:cellClassArray cellSizeArray:cellSizeArray animatedCountArray:nil indexArray:nil runMode:TABAnimatedRunByRow];
    return obj;
}

+ (instancetype)animatedInRowModeWithCellClassArray:(NSArray <Class> *)cellClassArray
                                      cellSizeArray:(NSArray <NSValue *> *)cellSizeArray
                                           rowArray:(NSArray <NSNumber *> *)rowArray {
    TABCollectionAnimated *obj = [TABCollectionAnimated _animatedWithCellClassArray:cellClassArray cellSizeArray:cellSizeArray animatedCountArray:nil indexArray:rowArray runMode:TABAnimatedRunByRow];
    return obj;
}

+ (instancetype)animatedInRowModeWithCellClass:(Class)cellClass
                                      cellSize:(CGSize)cellSize
                                         toRow:(NSInteger)row {
    TABCollectionAnimated *obj = [TABCollectionAnimated _animatedWithCellClass:cellClass cellSize:cellSize animatedCount:1 toIndex:row runMode:TABAnimatedRunByRow];
    return obj;
}

+ (instancetype)animatedWaterFallLayoutWithCellClass:(Class)cellClass
                                         heightArray:(NSArray <NSNumber *> *)heightArray
                                           heightSel:(SEL)heightSel {
    TABCollectionAnimated *obj = [TABCollectionAnimated _animatedWithCellClass:cellClass cellSize:CGSizeZero animatedCount:0 toIndex:0 runMode:TABAnimatedRunBySection];
    obj.waterFallLayoutHeightArray = heightArray;
    obj.waterFallLayoutHeightSel = heightSel;
   return obj;
}

#pragma mark -

+ (instancetype)_animatedWithCellClass:(Class)cellClass
                              cellSize:(CGSize)cellSize
                         animatedCount:(NSInteger)animatedCount
                               toIndex:(NSInteger)toIndex
                               runMode:(TABAnimatedRunMode)runMode {
    TABCollectionAnimated *obj = [[TABCollectionAnimated alloc] init];
    obj.runMode = runMode;
    obj.cellClassArray = @[cellClass];
    obj.cellSizeArray = @[@(cellSize)];
    obj.cellCountArray = @[@(animatedCount)];
    obj.cellIndexArray = @[@(0)];
    [obj.runIndexDict setValue:@(0) forKey:[NSString stringWithFormat:@"%ld",(long)toIndex]];
    return obj;
}

+ (instancetype)_animatedWithCellClassArray:(NSArray <Class> *)cellClassArray
                              cellSizeArray:(NSArray <NSValue *> *)cellSizeArray
                         animatedCountArray:(NSArray <NSNumber *> *)animatedCountArray
                                 indexArray:(NSArray <NSNumber *> *)indexArray
                                    runMode:(TABAnimatedRunMode)runMode {
    TABCollectionAnimated *obj = [[TABCollectionAnimated alloc] init];
    obj.runMode = runMode;
    obj.cellClassArray = cellClassArray;
    obj.cellSizeArray = cellSizeArray;
    obj.cellCountArray = animatedCountArray ? animatedCountArray : @[].copy;
    if (cellClassArray.count > 0 && indexArray.count == 0) {
        NSMutableArray *newIndexArray = @[].mutableCopy;
        for (NSInteger i = 0; i < cellClassArray.count; i++) {
            NSInteger index = i;
            NSInteger value = i;
            [obj.runIndexDict setValue:@(value) forKey:[NSString stringWithFormat:@"%ld",(long)index]];
            [newIndexArray addObject:@(index)];
        }
        obj.cellIndexArray = newIndexArray.copy;
    }else {
        obj.cellIndexArray = indexArray;
        for (NSInteger i = 0; i < indexArray.count; i++) {
            NSInteger index = [indexArray[i] integerValue];
            NSInteger value = i;
            [obj.runIndexDict setValue:@(value) forKey:[NSString stringWithFormat:@"%ld",(long)index]];
        }
    }
    return obj;
}

- (instancetype)init {
    if (self = [super init]) {
        _headerSizeArray = @[].mutableCopy;
        _footerSizeArray = @[].mutableCopy;
    }
    return self;
}

- (void)refreshWithIndex:(NSInteger)index controlView:(UIView *)controlView {
    UICollectionView *collectionView = (UICollectionView *)controlView;
    if (index == TABAnimatedIndexTag) {
        [collectionView reloadData];
    }else if (self.runMode == TABAnimatedRunBySection) {
        [collectionView reloadSections:[NSIndexSet indexSetWithIndex:index]];
    }else if (self.runMode == TABAnimatedRunByRow) {
        [collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
    }
}

- (void)setCellSize:(CGSize)cellSize {
    _cellSize = cellSize;
    _cellSizeArray = @[[NSValue valueWithCGSize:cellSize]];
}

- (void)addHeaderViewClass:(_Nonnull Class)headerViewClass
                  viewSize:(CGSize)viewSize {
    if (self.animatedSectionCount > 0) {
        for (NSInteger i = 0; i < self.animatedSectionCount; i++) {
            [self addHeaderViewClass:headerViewClass viewSize:viewSize toSection:i];
        }
    }
}

- (void)addHeaderViewClass:(_Nonnull Class)headerViewClass
                  viewSize:(CGSize)viewSize
                 toSection:(NSInteger)section {
    [self.headerClassArray addObject:headerViewClass];
    [self.headerSizeArray addObject:@(viewSize)];
    [self.runHeaderIndexDict setValue:@(self.headerClassArray.count-1) forKey:[self getStringWIthIndex:section]];
}

- (void)addFooterViewClass:(_Nonnull Class)footerViewClass
                  viewSize:(CGSize)viewSize {
    if (self.animatedSectionCount > 0) {
        for (NSInteger i = 0; i < self.animatedSectionCount; i++) {
            [self addFooterViewClass:footerViewClass viewSize:viewSize toSection:i];
        }
    }
}

- (void)addFooterViewClass:(_Nonnull Class)footerViewClass
                  viewSize:(CGSize)viewSize
                 toSection:(NSInteger)section {
    [self.footerClassArray addObject:footerViewClass];
    [self.footerSizeArray addObject:@(viewSize)];
    [self.runFooterIndexDict setValue:@(self.footerClassArray.count-1) forKey:[self getStringWIthIndex:section]];
}

- (void)exchangeDelegate:(UIView *)target {
    id <UICollectionViewDelegate> delegate = ((UICollectionView *)target).delegate;
    if (!self.isExhangeDelegateIMP) {
        [self exchangeDelegateMethods:delegate target:target];
        self.isExhangeDelegateIMP = YES;
    }
}

- (void)exchangeDataSource:(UIView *)target {
    id <UICollectionViewDataSource> dataSource = ((UICollectionView *)target).dataSource;
    if (!self.isExhangeDataSourceIMP) {
        [self exchangeDataSourceMethods:dataSource target:target];
        self.isExhangeDataSourceIMP = YES;
    }
}

- (void)registerViewToReuse:(UIView *)view {
    UICollectionView *collectionView = (UICollectionView *)view;
    
    for (Class class in self.cellClassArray) {
        
        if (class == [NSNull class]) continue;
        
        NSString *classString = tab_NSStringFromClass(class);
        NSString *nibPath = [TABXibBundleWithClass(class) pathForResource:classString ofType:@"nib"];
        
        if (nil != nibPath && nibPath.length > 0) {
            [collectionView registerNib:[UINib nibWithNibName:classString bundle:TABXibBundleWithClass(class)] forCellWithReuseIdentifier:[NSString stringWithFormat:@"tab_%@",classString]];
            [collectionView registerNib:[UINib nibWithNibName:classString bundle:TABXibBundleWithClass(class)] forCellWithReuseIdentifier:classString];
        }else {
            [collectionView registerClass:class forCellWithReuseIdentifier:[NSString stringWithFormat:@"tab_%@",classString]];
            [collectionView registerClass:class forCellWithReuseIdentifier:classString];
        }
        [collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:[NSString stringWithFormat:@"tab_contain_%@",classString]];
    }
    
    if (self.headerClassArray.count > 0) {
        [self _registerCollectionHeaderOrFooter:YES collectionView:collectionView];
    }
    if (self.footerClassArray.count > 0) {
        [self _registerCollectionHeaderOrFooter:NO collectionView:collectionView];
    }
}

#pragma mark - Private Methods

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

- (void)exchangeDelegateMethods:(id<UICollectionViewDelegate>)delegate
                         target:(id)target {
        
    SEL oldHeightSel = @selector(collectionView:layout:sizeForItemAtIndexPath:);
    SEL newHeightSel = @selector(tab_collectionView:layout:sizeForItemAtIndexPath:);
    [self exchangeDelegateOldSel:oldHeightSel
                          newSel:newHeightSel
                          target:target
                        delegate:delegate];
    
    SEL oldDisplaySel = @selector(collectionView:willDisplayCell:forItemAtIndexPath:);
    SEL newDisplaySel = @selector(tab_collectionView:willDisplayCell:forItemAtIndexPath:);
    [self exchangeDelegateOldSel:oldDisplaySel
                          newSel:newDisplaySel
                          target:target
                        delegate:delegate];
    
    SEL oldClickSel = @selector(collectionView:didSelectItemAtIndexPath:);
    SEL newClickSel = @selector(tab_collectionView:didSelectItemAtIndexPath:);
    [self exchangeDelegateOldSel:oldClickSel
                          newSel:newClickSel
                          target:target
                        delegate:delegate];
}

- (void)exchangeDataSourceMethods:(id<UICollectionViewDataSource>)dataSource
                           target:(id)target {

    SEL oldSectionsSel = @selector(numberOfSectionsInCollectionView:);
    SEL newSectionsSel = @selector(tab_numberOfSectionsInCollectionView:);
    [self exchangeDelegateOldSel:oldSectionsSel
                          newSel:newSectionsSel
                          target:target
                        delegate:dataSource];
    
    SEL oldItemsSel = @selector(collectionView:numberOfItemsInSection:);
    SEL newItemsSel = @selector(tab_collectionView:numberOfItemsInSection:);
    [self exchangeDelegateOldSel:oldItemsSel
                          newSel:newItemsSel
                          target:target
                        delegate:dataSource];
    
    SEL oldCellSel = @selector(collectionView:cellForItemAtIndexPath:);
    SEL newCellSel = @selector(tab_collectionView:cellForItemAtIndexPath:);
    [self exchangeDelegateOldSel:oldCellSel
                          newSel:newCellSel
                          target:target
                        delegate:dataSource];
    
    SEL oldReuseableCellSel = @selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:);
    SEL newReuseableCellSel = @selector(tab_collectionView:viewForSupplementaryElementOfKind:atIndexPath:);
    [self exchangeDelegateOldSel:oldReuseableCellSel
                          newSel:newReuseableCellSel
                          target:target
                        delegate:dataSource];
    
    SEL oldHeaderCellSel = @selector(collectionView:layout:referenceSizeForHeaderInSection:);
    SEL newHeaderCellSel = @selector(tab_collectionView:layout:referenceSizeForHeaderInSection:);
    [self exchangeDelegateOldSel:oldHeaderCellSel
                          newSel:newHeaderCellSel
                          target:target
                        delegate:dataSource];
    
    SEL oldFooterCellSel = @selector(collectionView:layout:referenceSizeForFooterInSection:);
    SEL newFooterCellSel = @selector(tab_collectionView:layout:referenceSizeForFooterInSection:);
    [self exchangeDelegateOldSel:oldFooterCellSel
                          newSel:newFooterCellSel
                          target:target
                        delegate:dataSource];
    
    if (self.waterFallLayoutHeightSel) {
        SEL oldWaterFallLayoutHeight = self.waterFallLayoutHeightSel;
        SEL newWaterFallLayoutHeight = @selector(tab_waterFallLayout:index:itemWidth:);
        
        [self exchangeDelegateOldSel:oldWaterFallLayoutHeight
                              newSel:newWaterFallLayoutHeight
                              target:target
                            delegate:dataSource];
    }
}

#pragma clang diagnostic pop

- (void)_registerCollectionHeaderOrFooter:(BOOL)isHeader collectionView:(UICollectionView *)collectionView {
    
    NSString *defaultPrefix = nil;
    NSMutableArray *classArray;
    NSString *kind = nil;
    
    if (isHeader) {
        classArray = self.headerClassArray;
        kind = UICollectionElementKindSectionHeader;
    }else {
        classArray = self.footerClassArray;
        kind = UICollectionElementKindSectionFooter;
    }
    
    defaultPrefix = @"tab_";
    
    for (Class class in classArray) {
        
        NSString *classString = tab_NSStringFromClass(class);
        NSString *nibPath = [TABXibBundleWithClass(class) pathForResource:classString ofType:@"nib"];
        
        if (nil != nibPath && nibPath.length > 0) {
            [collectionView registerNib:[UINib nibWithNibName:classString
                                                       bundle:TABXibBundleWithClass(class)]
             forSupplementaryViewOfKind:kind
                    withReuseIdentifier:[NSString stringWithFormat:@"%@%@",defaultPrefix,classString]];
        }else {
            if (isHeader) {
                [collectionView registerClass:class
                forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                       withReuseIdentifier:[NSString stringWithFormat:@"%@%@",defaultPrefix,classString]];
            }else {
                [collectionView registerClass:class
                forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                       withReuseIdentifier:[NSString stringWithFormat:@"%@%@",defaultPrefix,classString]];
            }
        }
        
        [collectionView registerClass:class
           forSupplementaryViewOfKind:kind
                  withReuseIdentifier:[NSString stringWithFormat:@"tab_contain_%@",classString]];
    }
}

#pragma mark - TABCollectionViewDelegate

- (NSInteger)tab_numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.state != TABViewAnimationStart) {
        return [self tab_numberOfSectionsInCollectionView:collectionView];
    }
    
    if (tabAnimated.runMode == TABAnimatedRunBySection && tabAnimated.animatedSectionCount > 0) {
        return tabAnimated.animatedSectionCount;
    }
    
    NSInteger count = [self tab_numberOfSectionsInCollectionView:collectionView];
    if (count == 0) count = tabAnimated.cellClassArray.count;
    if (count == 0) return 1;
    return count;
}

- (NSInteger)tab_collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.state != TABViewAnimationStart) {
        return [self tab_collectionView:collectionView numberOfItemsInSection:section];
    }
    
    NSInteger originCount = [self tab_collectionView:collectionView numberOfItemsInSection:section];
    if (tabAnimated.runMode == TABAnimatedRunByRow) {
        if (tabAnimated.animatedCount > 0) return tabAnimated.animatedCount;
        return originCount > 0 ? originCount : tabAnimated.cellClassArray.count;
    }
    
    if (tabAnimated.animatedCount > 0) return tabAnimated.animatedCount;
    NSInteger index = [tabAnimated getIndexWithIndex:section];
    if (index < 0) return originCount > 0 ? originCount : 1;
    return [tabAnimated.cellCountArray[index] integerValue];
}

- (CGSize)tab_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tabAnimated.state != TABViewAnimationStart) {
        return [self tab_collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
    
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    NSInteger index = [tabAnimated getIndexWithIndex:indexPath.section];
    if (index < 0) {
        return [self tab_collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
    return [tabAnimated.cellSizeArray[index] CGSizeValue];
}

- (UICollectionViewCell *)tab_collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tabAnimated.state != TABViewAnimationStart) {
        return [self tab_collectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
    
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    NSInteger index = [tabAnimated getIndexWithIndex:indexPath.section];
    if (index < 0) {
        return [self tab_collectionView:collectionView cellForItemAtIndexPath:indexPath];
    }

    Class currentClass = tabAnimated.cellClassArray[index];
    UICollectionViewCell *cell = [tabAnimated.producter productWithControlView:collectionView currentClass:currentClass indexPath:indexPath origin:TABAnimatedProductOriginCollectionViewCell];
    return cell;
}

- (void)tab_collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tabAnimated.state != TABViewAnimationStart) {
        [self tab_collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
    }
}

- (void)tab_collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tabAnimated.state != TABViewAnimationStart) {
        [self tab_collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark - About HeaderFooterView

- (CGSize)tab_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    NSInteger index = [tabAnimated getHeaderIndexWithIndex:section];
    if (index < 0) {
        return [self tab_collectionView:collectionView layout:collectionViewLayout referenceSizeForHeaderInSection:section];
    }
    NSValue *value = collectionView.tabAnimated.headerSizeArray[index];
    return [value CGSizeValue];
}

- (CGSize)tab_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    NSInteger index = [tabAnimated getFooterIndexWithIndex:section];
    if (index < 0) {
        return [self tab_collectionView:collectionView layout:collectionViewLayout referenceSizeForFooterInSection:section];
    }
    NSValue *value = collectionView.tabAnimated.footerSizeArray[index];
    return [value CGSizeValue];
}

- (UICollectionReusableView *)tab_collectionView:(UICollectionView *)collectionView
               viewForSupplementaryElementOfKind:(NSString *)kind
                                     atIndexPath:(NSIndexPath *)indexPath {
    
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    NSInteger index = -1;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        index = [tabAnimated getHeaderIndexWithIndex:indexPath.section];
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        index = [tabAnimated getFooterIndexWithIndex:indexPath.section];
    }
    
    if (index < 0) {
        return [self tab_collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
    }
    
    Class currentClass = nil;
    TABAnimatedProductOrigin origin;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        origin = TABAnimatedProductOriginCollectionReuseableHeaderView;
        currentClass = collectionView.tabAnimated.headerClassArray[index];
    }else {
        origin = TABAnimatedProductOriginCollectionReuseableFooterView;
        currentClass = collectionView.tabAnimated.footerClassArray[index];
    }
    
    UICollectionReusableView *view = [collectionView.tabAnimated.producter productWithControlView:collectionView currentClass:currentClass indexPath:indexPath origin:origin];
    return view;
}

#pragma mark - 瀑布流

- (CGFloat)tab_waterFallLayout:(UICollectionViewLayout *)waterFallLayout index:(NSInteger)index itemWidth:(CGFloat)itemWidth {
    TABCollectionAnimated *tabAnimated = waterFallLayout.tabAnimated;
    if (tabAnimated.state != TABViewAnimationStart) {
        return [self tab_waterFallLayout:waterFallLayout index:index itemWidth:itemWidth];
    }
    return [tabAnimated.waterFallLayoutHeightArray[index] floatValue];
}

#pragma mark -

- (void)setWaterFallLayoutHeightArray:(NSArray<NSNumber *> *)waterFallLayoutHeightArray {
    _waterFallLayoutHeightArray = waterFallLayoutHeightArray;
    _animatedCount = waterFallLayoutHeightArray.count;
}

- (void)setAnimatedCount:(NSInteger)animatedCount {
    if (_waterFallLayoutHeightArray.count > 0) return;
    _animatedCount = animatedCount;
}

@end
