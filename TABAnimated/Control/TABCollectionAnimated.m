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
#import <objc/message.h>

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
    }else if (self.runMode == TABAnimatedRunBySection || self.runMode == TABAnimatedRunByPartSection) {
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

- (void)rebindDelegate:(UIView *)target {
    id <UICollectionViewDelegate> delegate = ((UICollectionView *)target).delegate;
    if (!self.isRebindDelegateIMP) {
        self.oldDelegate = delegate;
        [self updateScrollViewDelegateMethods:delegate target:target];
        [self updateDelegateMethods:delegate target:target];
        self.isRebindDelegateIMP = YES;
    }
}

- (void)rebindDataSource:(UIView *)target {
    id <UICollectionViewDataSource> dataSource = ((UICollectionView *)target).dataSource;
    if (!self.isRebindDataSourceIMP) {
        self.oldDataSource = dataSource;
        [self updateDataSourceMethods:dataSource target:target];
        self.isRebindDataSourceIMP = YES;
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

- (void)updateDelegateMethods:(id<UICollectionViewDelegate>)delegate
                       target:(id)target {
        
    SEL oldHeightSel = @selector(collectionView:layout:sizeForItemAtIndexPath:);
    SEL newHeightSel = @selector(tab_collectionView:layout:sizeForItemAtIndexPath:);
    if ([delegate respondsToSelector:oldHeightSel]) {
        [self addNewMethodWithSel:oldHeightSel newSel:newHeightSel];
    }
    
    SEL oldHeaderCellSel = @selector(collectionView:layout:referenceSizeForHeaderInSection:);
    SEL newHeaderCellSel = @selector(tab_collectionView:layout:referenceSizeForHeaderInSection:);
    if ([delegate respondsToSelector:oldHeaderCellSel]) {
        [self addNewMethodWithSel:oldHeaderCellSel newSel:newHeaderCellSel];
    }
    
    SEL oldFooterCellSel = @selector(collectionView:layout:referenceSizeForFooterInSection:);
    SEL newFooterCellSel = @selector(tab_collectionView:layout:referenceSizeForFooterInSection:);
    if ([delegate respondsToSelector:oldFooterCellSel]) {
        [self addNewMethodWithSel:oldFooterCellSel newSel:newFooterCellSel];
    }
    
    SEL oldInsetForSectionAtIndexSel = @selector(collectionView:layout:insetForSectionAtIndex:);
    SEL newInsetForSectionAtIndexSel = @selector(tab_collectionView:layout:insetForSectionAtIndex:);
    if ([delegate respondsToSelector:oldInsetForSectionAtIndexSel]) {
        [self addNewMethodWithSel:oldInsetForSectionAtIndexSel newSel:newInsetForSectionAtIndexSel];
    }
    
    SEL oldMinimumLineSpacingForSectionAtIndex = @selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:);
    SEL newMinimumLineSpacingForSectionAtIndex = @selector(tab_collectionView:layout:minimumLineSpacingForSectionAtIndex:);
    if ([delegate respondsToSelector:oldMinimumLineSpacingForSectionAtIndex]) {
        [self addNewMethodWithSel:oldMinimumLineSpacingForSectionAtIndex newSel:newMinimumLineSpacingForSectionAtIndex];
    }
    
    SEL oldMinimumInteritemSpacingForSectionAtIndex = @selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:);
    SEL newMinimumInteritemSpacingForSectionAtIndex = @selector(tab_collectionView:layout:minimumInteritemSpacingForSectionAtIndex:);
    if ([delegate respondsToSelector:oldMinimumInteritemSpacingForSectionAtIndex]) {
        [self addNewMethodWithSel:oldMinimumInteritemSpacingForSectionAtIndex newSel:newMinimumInteritemSpacingForSectionAtIndex];
    }
    
    // Extra Delegate
    SEL oldShouldHighlightSel = @selector(collectionView:shouldHighlightItemAtIndexPath:);
    SEL newShouldHighlightSel = @selector(tab_collectionView:shouldHighlightItemAtIndexPath:);
    if ([delegate respondsToSelector:oldShouldHighlightSel]) {
        [self addNewMethodWithSel:oldShouldHighlightSel newSel:newShouldHighlightSel];
    }
    
    SEL oldDidHighlightSel = @selector(collectionView:didHighlightItemAtIndexPath:);
    SEL newDidHighlightSel = @selector(tab_collectionView:didHighlightItemAtIndexPath:);
    if ([delegate respondsToSelector:oldDidHighlightSel]) {
        [self addNewMethodWithSel:oldDidHighlightSel newSel:newDidHighlightSel];
    }
    
    SEL oldDidUnhighlightSel = @selector(collectionView:didUnhighlightItemAtIndexPath:);
    SEL newDidUnhighlightSel = @selector(tab_collectionView:didUnhighlightItemAtIndexPath:);
    if ([delegate respondsToSelector:oldDidUnhighlightSel]) {
        [self addNewMethodWithSel:oldDidUnhighlightSel newSel:newDidUnhighlightSel];
    }
    
    SEL oldShouldSelectSel = @selector(collectionView:shouldSelectItemAtIndexPath:);
    SEL newShouldSelectSel = @selector(tab_collectionView:shouldSelectItemAtIndexPath:);
    if ([delegate respondsToSelector:oldShouldSelectSel]) {
        [self addNewMethodWithSel:oldShouldSelectSel newSel:newShouldSelectSel];
    }
    
    SEL oldShouldDeselectSel = @selector(collectionView:shouldDeselectItemAtIndexPath:);
    SEL newShouldDeselectSel = @selector(tab_collectionView:shouldDeselectItemAtIndexPath:);
    if ([delegate respondsToSelector:oldShouldDeselectSel]) {
        [self addNewMethodWithSel:oldShouldDeselectSel newSel:newShouldDeselectSel];
    }
    
    SEL oldDidSelectSel = @selector(collectionView:didSelectItemAtIndexPath:);
    SEL newDidSelectSel = @selector(tab_collectionView:didSelectItemAtIndexPath:);
    if ([delegate respondsToSelector:oldDidSelectSel]) {
        [self addNewMethodWithSel:oldDidSelectSel newSel:newDidSelectSel];
    }
    
    SEL oldDidDeselectSel = @selector(collectionView:didDeselectItemAtIndexPath:);
    SEL newDidDeselectSel = @selector(tab_collectionView:didDeselectItemAtIndexPath:);
    if ([delegate respondsToSelector:oldDidDeselectSel]) {
        [self addNewMethodWithSel:oldDidDeselectSel newSel:newDidDeselectSel];
    }
    
    SEL oldWillDisplaySel = @selector(collectionView:willDisplayCell:forItemAtIndexPath:);
    SEL newWillDisplaySel = @selector(tab_collectionView:willDisplayCell:forItemAtIndexPath:);
    if ([delegate respondsToSelector:oldWillDisplaySel]) {
        [self addNewMethodWithSel:oldWillDisplaySel newSel:newWillDisplaySel];
    }
    
    SEL oldWillDisplaySupplementarySel = @selector(collectionView:willDisplaySupplementaryView:forElementKind:atIndexPath:);
    SEL newWillDisplaySupplementarySel = @selector(tab_collectionView:willDisplaySupplementaryView:forElementKind:atIndexPath:);
    if ([delegate respondsToSelector:oldWillDisplaySupplementarySel]) {
        [self addNewMethodWithSel:oldWillDisplaySupplementarySel newSel:newWillDisplaySupplementarySel];
    }
    
    SEL oldDidEndDisplayingSel = @selector(collectionView:didEndDisplayingCell:forItemAtIndexPath:);
    SEL newDidEndDisplayingSel = @selector(tab_collectionView:didEndDisplayingCell:forItemAtIndexPath:);
    if ([delegate respondsToSelector:oldDidEndDisplayingSel]) {
        [self addNewMethodWithSel:oldDidEndDisplayingSel newSel:newDidEndDisplayingSel];
    }

    SEL oldDidEndDisplayingSupplementarySel = @selector(collectionView:didEndDisplayingSupplementaryView:forElementKind:atIndexPath:);
    SEL newDidEndDisplayingSupplementarySel = @selector(tab_collectionView:didEndDisplayingSupplementaryView:forElementKind:atIndexPath:);
    if ([delegate respondsToSelector:oldDidEndDisplayingSupplementarySel]) {
        [self addNewMethodWithSel:oldDidEndDisplayingSupplementarySel newSel:newDidEndDisplayingSupplementarySel];
    }
    
    SEL oldShouldMenuSel = @selector(collectionView:shouldShowMenuForItemAtIndexPath:);
    SEL newShouldMenuSel = @selector(tab_collectionView:shouldShowMenuForItemAtIndexPath:);
    if ([delegate respondsToSelector:oldShouldMenuSel]) {
        [self addNewMethodWithSel:oldShouldMenuSel newSel:newShouldMenuSel];
    }
    
    SEL oldCanPerformActionSel = @selector(collectionView:canPerformAction:forItemAtIndexPath:withSender:);
    SEL newCanPerformActionSel = @selector(tab_collectionView:canPerformAction:forItemAtIndexPath:withSender:);
    if ([delegate respondsToSelector:oldCanPerformActionSel]) {
        [self addNewMethodWithSel:oldCanPerformActionSel newSel:newCanPerformActionSel];
    }
    
    SEL oldPerformActionSel = @selector(collectionView:performAction:forItemAtIndexPath:withSender:);
    SEL newPerformActionSel = @selector(tab_collectionView:performAction:forItemAtIndexPath:withSender:);
    if ([delegate respondsToSelector:oldPerformActionSel]) {
        [self addNewMethodWithSel:oldPerformActionSel newSel:newPerformActionSel];
    }
    
    SEL oldTransitionLayoutSel = @selector(collectionView:transitionLayoutForOldLayout:newLayout:);
    SEL newTransitionLayoutSel = @selector(tab_collectionView:transitionLayoutForOldLayout:newLayout:);
    if ([delegate respondsToSelector:oldTransitionLayoutSel]) {
        [self addNewMethodWithSel:oldTransitionLayoutSel newSel:newTransitionLayoutSel];
    }
    
    SEL oldCanFocusItemSel = @selector(collectionView:canFocusItemAtIndexPath:);
    SEL newCanFocusItemSel = @selector(tab_collectionView:canFocusItemAtIndexPath:);
    if ([delegate respondsToSelector:oldCanFocusItemSel]) {
        [self addNewMethodWithSel:oldCanFocusItemSel newSel:newCanFocusItemSel];
    }
    
    SEL oldShouldUpdateFocusSel = @selector(collectionView:shouldUpdateFocusInContext:);
    SEL newShouldUpdateFocusSel = @selector(tab_collectionView:shouldUpdateFocusInContext:);
    if ([delegate respondsToSelector:oldShouldUpdateFocusSel]) {
        [self addNewMethodWithSel:oldShouldUpdateFocusSel newSel:newShouldUpdateFocusSel];
    }
    
    SEL oldDidUpdateFocusSel = @selector(collectionView:didUpdateFocusInContext:context:);
    SEL newDidUpdateFocusSel = @selector(tab_collectionView:didUpdateFocusInContext:context:);
    if ([delegate respondsToSelector:oldDidUpdateFocusSel]) {
        [self addNewMethodWithSel:oldDidUpdateFocusSel newSel:newDidUpdateFocusSel];
    }
    
    SEL oldPreferredFocusedViewSel = @selector(indexPathForPreferredFocusedViewInCollectionView:);
    SEL newPreferredFocusedViewSel = @selector(tab_indexPathForPreferredFocusedViewInCollectionView:);
    if ([delegate respondsToSelector:oldPreferredFocusedViewSel]) {
        [self addNewMethodWithSel:oldPreferredFocusedViewSel newSel:newPreferredFocusedViewSel];
    }
    
    SEL oldMoveFromItemSel = @selector(collectionView:targetIndexPathForMoveFromItemAtIndexPath:toProposedIndexPath:);
    SEL newMoveFromItemSel = @selector(tab_collectionView:targetIndexPathForMoveFromItemAtIndexPath:toProposedIndexPath:);
    if ([delegate respondsToSelector:oldMoveFromItemSel]) {
        [self addNewMethodWithSel:oldMoveFromItemSel newSel:newMoveFromItemSel];
    }
    
    SEL oldTargetContentOffsetSel = @selector(collectionView:targetContentOffsetForProposedContentOffset:);
    SEL newTargetContentOffsetSel = @selector(tab_collectionView:targetContentOffsetForProposedContentOffset:);
    if ([delegate respondsToSelector:oldTargetContentOffsetSel]) {
        [self addNewMethodWithSel:oldTargetContentOffsetSel newSel:newTargetContentOffsetSel];
    }
    
    SEL oldCanEditItemSel = @selector(collectionView:canEditItemAtIndexPath:);
    SEL newCanEditItemSel = @selector(tab_collectionView:canEditItemAtIndexPath:);
    if ([delegate respondsToSelector:oldCanEditItemSel]) {
        [self addNewMethodWithSel:oldCanEditItemSel newSel:newCanEditItemSel];
    }

    SEL oldShouldSpringLoadItemSel = @selector(collectionView:shouldSpringLoadItemAtIndexPath:withContext:);
    SEL newShouldSpringLoadItemSel = @selector(tab_collectionView:shouldSpringLoadItemAtIndexPath:withContext:);
    if ([delegate respondsToSelector:oldShouldSpringLoadItemSel]) {
        [self addNewMethodWithSel:oldShouldSpringLoadItemSel newSel:newShouldSpringLoadItemSel];
    }
    
    SEL oldShouldBeginMultipleSelectionSel = @selector(collectionView:shouldBeginMultipleSelectionInteractionAtIndexPath:);
    SEL newShouldBeginMultipleSelectionSel = @selector(tab_collectionView:shouldBeginMultipleSelectionInteractionAtIndexPath:);
    if ([delegate respondsToSelector:oldShouldBeginMultipleSelectionSel]) {
        [self addNewMethodWithSel:oldShouldBeginMultipleSelectionSel newSel:newShouldBeginMultipleSelectionSel];
    }
    
    SEL oldDidBeginMultipleSelectionSel = @selector(collectionView:didBeginMultipleSelectionInteractionAtIndexPath:);
    SEL newDidBeginMultipleSelectionSel = @selector(tab_collectionView:didBeginMultipleSelectionInteractionAtIndexPath:);
    if ([delegate respondsToSelector:oldDidBeginMultipleSelectionSel]) {
        [self addNewMethodWithSel:oldDidBeginMultipleSelectionSel newSel:newDidBeginMultipleSelectionSel];
    }
    
    SEL oldDidEndMultipleSelectionSel = @selector(collectionViewDidEndMultipleSelectionInteraction:);
    SEL newDidEndMultipleSelectionSel = @selector(tab_collectionViewDidEndMultipleSelectionInteraction:);
    if ([delegate respondsToSelector:oldDidEndMultipleSelectionSel]) {
        [self addNewMethodWithSel:oldDidEndMultipleSelectionSel newSel:newDidEndMultipleSelectionSel];
    }
    
    SEL oldContextMenuConfigurationSel = @selector(collectionView:contextMenuConfigurationForItemAtIndexPath:);
    SEL newContextMenuConfigurationSel = @selector(tab_collectionView:contextMenuConfigurationForItemAtIndexPath:);
    if ([delegate respondsToSelector:oldContextMenuConfigurationSel]) {
        [self addNewMethodWithSel:oldContextMenuConfigurationSel newSel:newContextMenuConfigurationSel];
    }
    
    SEL oldPreviewForHighlightingContextSel = @selector(collectionView:previewForHighlightingContextMenuWithConfiguration:);
    SEL newPreviewForHighlightingContextSel = @selector(tab_collectionView:previewForHighlightingContextMenuWithConfiguration:);
    if ([delegate respondsToSelector:oldPreviewForHighlightingContextSel]) {
        [self addNewMethodWithSel:oldPreviewForHighlightingContextSel newSel:newPreviewForHighlightingContextSel];
    }
    
    SEL oldPreviewForDismissingContextSel = @selector(collectionView:previewForDismissingContextMenuWithConfiguration:);
    SEL newPreviewForDismissingContextSel = @selector(tab_collectionView:previewForDismissingContextMenuWithConfiguration:);
    if ([delegate respondsToSelector:oldPreviewForDismissingContextSel]) {
        [self addNewMethodWithSel:oldPreviewForDismissingContextSel newSel:newPreviewForDismissingContextSel];
    }
    
    SEL oldWillPerformPreviewActionSel = @selector(collectionView:willPerformPreviewActionForMenuWithConfiguration:);
    SEL newWillPerformPreviewActionSel = @selector(tab_collectionView:willPerformPreviewActionForMenuWithConfiguration:);
    if ([delegate respondsToSelector:oldWillPerformPreviewActionSel]) {
        [self addNewMethodWithSel:oldWillPerformPreviewActionSel newSel:newWillPerformPreviewActionSel];
    }
    
    SEL oldWillDisplayContextMenuSel = @selector(collectionView:willDisplayContextMenuWithConfiguration:animator:);
    SEL newWillDisplayContextMenuSel = @selector(tab_collectionView:willDisplayContextMenuWithConfiguration:animator:);
    if ([delegate respondsToSelector:oldWillDisplayContextMenuSel]) {
        [self addNewMethodWithSel:oldWillDisplayContextMenuSel newSel:newWillDisplayContextMenuSel];
    }

    SEL oldWillEndContextMenuInteractionSel = @selector(collectionView:willEndContextMenuInteractionWithConfiguration:animator:);
    SEL newWillEndContextMenuInteractionSel = @selector(tab_collectionView:willEndContextMenuInteractionWithConfiguration:animator:);
    if ([delegate respondsToSelector:oldWillEndContextMenuInteractionSel]) {
        [self addNewMethodWithSel:oldWillEndContextMenuInteractionSel newSel:newWillEndContextMenuInteractionSel];
    }
    
    ((UICollectionView *)target).delegate = self.protocolContainer;
}

- (void)updateDataSourceMethods:(id<UICollectionViewDataSource>)dataSource
                         target:(id)target {

    SEL oldSectionsSel = @selector(numberOfSectionsInCollectionView:);
    SEL newSectionsSel = @selector(tab_numberOfSectionsInCollectionView:);
    if ([dataSource respondsToSelector:oldSectionsSel]) {
        [self addNewMethodWithSel:oldSectionsSel newSel:newSectionsSel];
    }
    
    SEL oldItemsSel = @selector(collectionView:numberOfItemsInSection:);
    SEL newItemsSel = @selector(tab_collectionView:numberOfItemsInSection:);
    if ([dataSource respondsToSelector:oldItemsSel]) {
        [self addNewMethodWithSel:oldItemsSel newSel:newItemsSel];
    }
    
    SEL oldCellSel = @selector(collectionView:cellForItemAtIndexPath:);
    SEL newCellSel = @selector(tab_collectionView:cellForItemAtIndexPath:);
    if ([dataSource respondsToSelector:oldCellSel]) {
        [self addNewMethodWithSel:oldCellSel newSel:newCellSel];
    }
    
    SEL oldReuseableCellSel = @selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:);
    SEL newReuseableCellSel = @selector(tab_collectionView:viewForSupplementaryElementOfKind:atIndexPath:);
    if ([dataSource respondsToSelector:oldReuseableCellSel]) {
        [self addNewMethodWithSel:oldReuseableCellSel newSel:newReuseableCellSel];
    }
    
    if (self.waterFallLayoutHeightSel) {
        SEL oldWaterFallLayoutHeight = self.waterFallLayoutHeightSel;
        SEL newWaterFallLayoutHeight = @selector(tab_waterFallLayout:index:itemWidth:);
        [self exchangeDelegateOldSel:oldWaterFallLayoutHeight
                              newSel:newWaterFallLayoutHeight
                              target:target
                            delegate:dataSource];
    }
    
    // Extra Datasource
    
    SEL oldCanMoveItemSel = @selector(collectionView:canMoveItemAtIndexPath:);
    SEL newCanMoveItemSel = @selector(tab_collectionView:canMoveItemAtIndexPath:);
    if ([dataSource respondsToSelector:oldCanMoveItemSel]) {
        [self addNewMethodWithSel:oldCanMoveItemSel newSel:newCanMoveItemSel];
    }
    
    SEL oldMoveItemSel = @selector(collectionView:moveItemAtIndexPath:toIndexPath:);
    SEL newMoveItemSel = @selector(tab_collectionView:moveItemAtIndexPath:toIndexPath:);
    if ([dataSource respondsToSelector:oldMoveItemSel]) {
        [self addNewMethodWithSel:oldMoveItemSel newSel:newMoveItemSel];
    }

    SEL oldIndexTitlesSel = @selector(indexTitlesForCollectionView:);
    SEL newIndexTitlesSel = @selector(tab_indexTitlesForCollectionView:);
    if ([dataSource respondsToSelector:oldIndexTitlesSel]) {
        [self addNewMethodWithSel:oldIndexTitlesSel newSel:newIndexTitlesSel];
    }
    
    SEL oldIndexPathTitleSel = @selector(collectionView:indexPathForIndexTitle:atIndex:);
    SEL newIndexPathTitleSel = @selector(tab_collectionView:indexPathForIndexTitle:atIndex:);
    if ([dataSource respondsToSelector:oldIndexPathTitleSel]) {
        [self addNewMethodWithSel:oldIndexPathTitleSel newSel:newIndexPathTitleSel];
    }
    
    ((UICollectionView *)target).dataSource = self.protocolContainer;
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
    id oldDelegate = tabAnimated.oldDataSource;
    SEL sel = @selector(numberOfSectionsInCollectionView:);
    
    if (!tabAnimated.isAnimating) {
        return ((NSInteger (*)(id, SEL, UICollectionView *))objc_msgSend)((id)oldDelegate, sel, collectionView);
    }
    
    if (tabAnimated.runMode == TABAnimatedRunBySection) {
        if (tabAnimated.animatedSectionCount > 0) {
            return tabAnimated.animatedSectionCount;
        }
        return tabAnimated.cellClassArray.count;
    }
    
    NSInteger count = ((NSInteger (*)(id, SEL, UICollectionView *))objc_msgSend)((id)oldDelegate, sel, collectionView);
    if (count == 0) count = tabAnimated.cellClassArray.count;
    if (count == 0) return 1;
    return count;
}

- (NSInteger)tab_collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    id oldDelegate = tabAnimated.oldDataSource;
    SEL sel = @selector(collectionView:numberOfItemsInSection:);
    
    if (!tabAnimated.isAnimating) {
        return ((NSInteger (*)(id, SEL, UICollectionView *, NSInteger))objc_msgSend)((id)oldDelegate, sel, collectionView, section);
    }
    
    NSInteger originCount = 0;
    
    if (tabAnimated.animatedSectionCount <= 0) {
        originCount = ((NSInteger (*)(id, SEL, UICollectionView *, NSInteger))objc_msgSend)((id)oldDelegate, sel, collectionView, section);
        if (tabAnimated.runMode == TABAnimatedRunByRow) {
            if (tabAnimated.animatedCount > 0) return tabAnimated.animatedCount;
            return originCount > 0 ? originCount : tabAnimated.cellClassArray.count;
        }
    }
    
    if (tabAnimated.animatedCount > 0) return tabAnimated.animatedCount;
    NSInteger index = [tabAnimated getIndexWithIndex:section];
    if (index < 0) return originCount > 0 ? originCount : 1;
    return [tabAnimated.cellCountArray[index] integerValue];
}

- (CGSize)tab_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:layout:sizeForItemAtIndexPath:);
    
    if (!tabAnimated.isAnimating) {
        return ((CGSize (*)(id, SEL, UICollectionView *, UICollectionViewLayout *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, collectionView, collectionViewLayout, indexPath);
    }
    
    NSInteger index = [tabAnimated getIndexWithIndex:indexPath.section];
    if (index < 0) {
        return ((CGSize (*)(id, SEL, UICollectionView *, UICollectionViewLayout *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, collectionView, collectionViewLayout, indexPath);
    }
    return [tabAnimated.cellSizeArray[index] CGSizeValue];
}

- (UICollectionViewCell *)tab_collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    id oldDelegate = tabAnimated.oldDataSource;
    SEL sel = @selector(collectionView:cellForItemAtIndexPath:);
    
    if (!tabAnimated.isAnimating) {
        return ((UICollectionViewCell * (*)(id, SEL, UICollectionView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, collectionView, indexPath);
    }
    
    NSInteger index = [tabAnimated getIndexWithIndex:indexPath.section];
    if (index < 0) {
        return ((UICollectionViewCell * (*)(id, SEL, UICollectionView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, collectionView, indexPath);
    }

    Class currentClass = tabAnimated.cellClassArray[index];
    UICollectionViewCell *cell = [tabAnimated.producter productWithControlView:collectionView currentClass:currentClass indexPath:indexPath origin:TABAnimatedProductOriginCollectionViewCell];
    return cell;
}

#pragma mark - About HeaderFooterView

- (CGSize)tab_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    id oldDelegate = tabAnimated.oldDataSource;
    SEL sel = @selector(collectionView:layout:referenceSizeForHeaderInSection:);
    NSInteger index = [tabAnimated getHeaderIndexWithIndex:section];
    if (index < 0) {
        return ((CGSize (*)(id, SEL, UICollectionView *, UICollectionViewLayout *, NSInteger))objc_msgSend)((id)oldDelegate, sel, collectionView, collectionViewLayout, section);
    }
    NSValue *value = collectionView.tabAnimated.headerSizeArray[index];
    return [value CGSizeValue];
}

- (CGSize)tab_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    id oldDelegate = tabAnimated.oldDataSource;
    SEL sel = @selector(collectionView:layout:referenceSizeForFooterInSection:);
    NSInteger index = [tabAnimated getFooterIndexWithIndex:section];
    if (index < 0) {
        return ((CGSize (*)(id, SEL, UICollectionView *, UICollectionViewLayout *, NSInteger))objc_msgSend)((id)oldDelegate, sel, collectionView, collectionViewLayout, section);
    }
    NSValue *value = collectionView.tabAnimated.footerSizeArray[index];
    return [value CGSizeValue];
}

- (UICollectionReusableView *)tab_collectionView:(UICollectionView *)collectionView
               viewForSupplementaryElementOfKind:(NSString *)kind
                                     atIndexPath:(NSIndexPath *)indexPath {
    
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    id oldDelegate = tabAnimated.oldDataSource;
    SEL sel = @selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:);
    
    NSInteger index = -1;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        index = [tabAnimated getHeaderIndexWithIndex:indexPath.section];
    }else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        index = [tabAnimated getFooterIndexWithIndex:indexPath.section];
    }
    
    if (index < 0) {
        return ((UICollectionReusableView * (*)(id, SEL, UICollectionView *, NSString *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, collectionView, kind, indexPath);
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
    if (!tabAnimated.isAnimating) {
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

#pragma mark - Extra DataSource

- (BOOL)tab_collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return NO;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:canMoveItemAtIndexPath:);
    return ((BOOL (*)(id, SEL, UICollectionView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, collectionView, indexPath);
}

- (void)tab_collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:moveItemAtIndexPath:toIndexPath:);
    ((void (*)(id, SEL, UICollectionView *, NSIndexPath *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, collectionView, sourceIndexPath, destinationIndexPath);
}

- (nullable NSArray<NSString *> *)tab_indexTitlesForCollectionView:(UICollectionView *)collectionView {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return nil;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(indexTitlesForCollectionView:);
    return ((NSArray<NSString *> * (*)(id, SEL, UICollectionView *))objc_msgSend)((id)oldDelegate, sel, collectionView);
}

- (NSIndexPath *)tab_collectionView:(UICollectionView *)collectionView indexPathForIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return nil;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:indexPathForIndexTitle:atIndex:);
    return ((NSIndexPath * (*)(id, SEL, UICollectionView *, NSString *, NSInteger))objc_msgSend)((id)oldDelegate, sel, collectionView, title, index);
}

#pragma mark - Extra Delegate

- (BOOL)tab_collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return NO;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:shouldHighlightItemAtIndexPath:);
    return ((BOOL (*)(id, SEL, UICollectionView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, collectionView, indexPath);
}

- (void)tab_collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:didHighlightItemAtIndexPath:);
    ((void (*)(id, SEL, UICollectionView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, collectionView, indexPath);
}

- (void)tab_collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:didUnhighlightItemAtIndexPath:);
    ((void (*)(id, SEL, UICollectionView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, collectionView, indexPath);
}

- (BOOL)tab_collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return NO;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:shouldSelectItemAtIndexPath:);
    return ((BOOL (*)(id, SEL, UICollectionView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, collectionView, indexPath);
}

- (BOOL)tab_collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return NO;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:shouldDeselectItemAtIndexPath:);
    return ((BOOL (*)(id, SEL, UICollectionView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, collectionView, indexPath);
}

- (void)tab_collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:didSelectItemAtIndexPath:);
    ((void (*)(id, SEL, UICollectionView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, collectionView, indexPath);
}

- (void)tab_collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:didDeselectItemAtIndexPath:);
    ((void (*)(id, SEL, UICollectionView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, collectionView, indexPath);
}

- (void)tab_collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:willDisplayCell:forItemAtIndexPath:);
    ((void (*)(id, SEL, UICollectionView *, UICollectionViewCell *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, collectionView, cell, indexPath);
}

- (void)tab_collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:willDisplaySupplementaryView:forElementKind:atIndexPath:);
    ((void (*)(id, SEL, UICollectionView *, UICollectionReusableView *, NSString *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, collectionView, view, elementKind, indexPath);
}

- (void)tab_collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:didEndDisplayingCell:forItemAtIndexPath:);
    ((void (*)(id, SEL, UICollectionView *, UICollectionViewCell *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, collectionView, cell, indexPath);
}

- (void)tab_collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:didEndDisplayingSupplementaryView:forElementOfKind:atIndexPath:);
    ((void (*)(id, SEL, UICollectionView *, UICollectionReusableView *, NSString *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, collectionView, view, elementKind, indexPath);
}

- (BOOL)tab_collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return NO;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:shouldShowMenuForItemAtIndexPath:);
    return ((BOOL (*)(id, SEL, UICollectionView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, collectionView, indexPath);
}

- (BOOL)tab_collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return NO;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:canPerformAction:forItemAtIndexPath:withSender:);
    return ((BOOL (*)(id, SEL, UICollectionView *, SEL, NSIndexPath *, id))objc_msgSend)((id)oldDelegate, sel, collectionView, action, indexPath, sender);
}

- (void)tab_collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:performAction:forItemAtIndexPath:withSender:);
    ((void (*)(id, SEL, UICollectionView *, SEL, NSIndexPath *, id))objc_msgSend)((id)oldDelegate, sel, collectionView, action, indexPath, sender);
}

- (nonnull UICollectionViewTransitionLayout *)tab_collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return nil;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:transitionLayoutForOldLayout:newLayout:);
    return ((UICollectionViewTransitionLayout * (*)(id, SEL, UICollectionView *, UICollectionViewLayout *, UICollectionViewLayout *))objc_msgSend)((id)oldDelegate, sel, collectionView, fromLayout, toLayout);
}

- (BOOL)tab_collectionView:(UICollectionView *)collectionView canFocusItemAtIndexPath:(NSIndexPath *)indexPath {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return NO;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:canFocusItemAtIndexPath:);
    return ((BOOL (*)(id, SEL, UICollectionView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, collectionView, indexPath);
}

- (BOOL)tab_collectionView:(UICollectionView *)collectionView shouldUpdateFocusInContext:(UICollectionViewFocusUpdateContext *)context {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return NO;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:shouldUpdateFocusInContext:);
    return ((BOOL (*)(id, SEL, UICollectionView *, UICollectionViewFocusUpdateContext *))objc_msgSend)((id)oldDelegate, sel, collectionView, context);
}

- (void)tab_collectionView:(UICollectionView *)collectionView didUpdateFocusInContext:(UICollectionViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:didUpdateFocusInContext:withAnimationCoordinator:);
    ((void (*)(id, SEL, UICollectionView *, UICollectionViewFocusUpdateContext *, UIFocusAnimationCoordinator *))objc_msgSend)((id)oldDelegate, sel, collectionView, context, coordinator);
}

- (nullable NSIndexPath *)tab_indexPathForPreferredFocusedViewInCollectionView:(UICollectionView *)collectionView {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return nil;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(indexPathForPreferredFocusedViewInCollectionView:);
    return ((NSIndexPath * (*)(id, SEL, UICollectionView *))objc_msgSend)((id)oldDelegate, sel, collectionView);
}

- (NSIndexPath *)tab_collectionView:(UICollectionView *)collectionView targetIndexPathForMoveFromItemAtIndexPath:(NSIndexPath *)originalIndexPath toProposedIndexPath:(NSIndexPath *)proposedIndexPath {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return nil;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:targetIndexPathForMoveFromItemAtIndexPath:toProposedIndexPath:);
    return ((NSIndexPath * (*)(id, SEL, UICollectionView *, NSIndexPath *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, collectionView, originalIndexPath, proposedIndexPath);
}

- (CGPoint)tab_collectionView:(UICollectionView *)collectionView targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return CGPointZero;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:targetContentOffsetForProposedContentOffset:);
    // On some architectures, use objc_msgSend_stret for some struct return types.
#ifdef __arm64__
    return ((CGPoint (*)(id, SEL, UICollectionView *, CGPoint))objc_msgSend)((id)oldDelegate, sel, collectionView, proposedContentOffset);
#else
    return ((CGPoint (*)(id, SEL, UICollectionView *, CGPoint))objc_msgSend_stret)((id)oldDelegate, sel, collectionView, proposedContentOffset);
#endif
}

- (BOOL)tab_collectionView:(UICollectionView *)collectionView canEditItemAtIndexPath:(NSIndexPath *)indexPath {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return NO;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:canEditItemAtIndexPath:);
    return ((BOOL (*)(id, SEL, UICollectionView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, collectionView, indexPath);
}

- (BOOL)tab_collectionView:(UICollectionView *)collectionView shouldSpringLoadItemAtIndexPath:(NSIndexPath *)indexPath withContext:(id<UISpringLoadedInteractionContext>)context API_AVAILABLE(ios(11.0)) {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return NO;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:shouldSpringLoadItemAtIndexPath:withContext:);
    return ((BOOL (*)(id, SEL, UICollectionView *, NSIndexPath *, id<UISpringLoadedInteractionContext>))objc_msgSend)((id)oldDelegate, sel, collectionView, indexPath, context);
}

- (BOOL)tab_collectionView:(UICollectionView *)collectionView shouldBeginMultipleSelectionInteractionAtIndexPath:(NSIndexPath *)indexPath {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return NO;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:shouldBeginMultipleSelectionInteractionAtIndexPath:);
    return ((BOOL (*)(id, SEL, UICollectionView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, collectionView, indexPath);
}

- (void)tab_collectionView:(UICollectionView *)collectionView didBeginMultipleSelectionInteractionAtIndexPath:(NSIndexPath *)indexPath {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:didBeginMultipleSelectionInteractionAtIndexPath:);
    ((void (*)(id, SEL, UICollectionView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, collectionView, indexPath);
}

- (void)tab_collectionViewDidEndMultipleSelectionInteraction:(UICollectionView *)collectionView {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionViewDidEndMultipleSelectionInteraction:);
    ((void (*)(id, SEL, UICollectionView *))objc_msgSend)((id)oldDelegate, sel, collectionView);
}

- (nullable UIContextMenuConfiguration *)tab_collectionView:(UICollectionView *)collectionView contextMenuConfigurationForItemAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point  API_AVAILABLE(ios(13.0)) {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return nil;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:contextMenuConfigurationForItemAtIndexPath:point:);
    return ((UIContextMenuConfiguration * (*)(id, SEL, UICollectionView *, NSIndexPath *, CGPoint))objc_msgSend)((id)oldDelegate, sel, collectionView, indexPath, point);
}

- (nullable UITargetedPreview *)tab_collectionView:(UICollectionView *)collectionView previewForHighlightingContextMenuWithConfiguration:(UIContextMenuConfiguration *)configuration API_AVAILABLE(ios(13.0)) {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return nil;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:previewForHighlightingContextMenuWithConfiguration:);
    return ((UITargetedPreview * (*)(id, SEL, UICollectionView *, UIContextMenuConfiguration *))objc_msgSend)((id)oldDelegate, sel, collectionView, configuration);
}

- (nullable UITargetedPreview *)tab_collectionView:(UICollectionView *)collectionView previewForDismissingContextMenuWithConfiguration:(UIContextMenuConfiguration *)configuration API_AVAILABLE(ios(13.0)) {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return nil;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:previewForDismissingContextMenuWithConfiguration:);
    return ((UITargetedPreview * (*)(id, SEL, UICollectionView *, UIContextMenuConfiguration *))objc_msgSend)((id)oldDelegate, sel, collectionView, configuration);
}

- (void)tab_collectionView:(UICollectionView *)collectionView willPerformPreviewActionForMenuWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionCommitAnimating>)animator API_AVAILABLE(ios(13.0)) {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:willPerformPreviewActionForMenuWithConfiguration:animator:);
    ((void (*)(id, SEL, UICollectionView *, UIContextMenuConfiguration *, id))objc_msgSend)((id)oldDelegate, sel, collectionView, configuration, animator);
}

- (void)tab_collectionView:(UICollectionView *)collectionView willDisplayContextMenuWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(nullable id<UIContextMenuInteractionAnimating>)animator API_AVAILABLE(ios(13.0)) {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:willDisplayContextMenuWithConfiguration:animator:);
    ((void (*)(id, SEL, UICollectionView *, UIContextMenuConfiguration *, id))objc_msgSend)((id)oldDelegate, sel, collectionView, configuration, animator);
}

- (void)tab_collectionView:(UICollectionView *)collectionView willEndContextMenuInteractionWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(nullable id<UIContextMenuInteractionAnimating>)animator API_AVAILABLE(ios(13.0)) {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:willEndContextMenuInteractionWithConfiguration:animator:);
    ((void (*)(id, SEL, UICollectionView *, UIContextMenuConfiguration *, id))objc_msgSend)((id)oldDelegate, sel, collectionView, configuration, animator);
}

#pragma mark - UICollectionViewLayout

- (UIEdgeInsets)tab_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:layout:insetForSectionAtIndex:);
    
    // On some architectures, use objc_msgSend_stret for some struct return types.
#ifdef __arm64__
    return ((UIEdgeInsets (*)(id, SEL, UICollectionView *, UICollectionViewLayout *, NSInteger))objc_msgSend)((id)oldDelegate, sel, collectionView, collectionViewLayout, section);
#else
    return ((UIEdgeInsets (*)(id, SEL, UICollectionView *, UICollectionViewLayout *, NSInteger))objc_msgSend_stret)((id)oldDelegate, sel, collectionView, collectionViewLayout, section);
#endif
}

- (CGFloat)tab_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:);
    return ((CGFloat (*)(id, SEL, UICollectionView *, UICollectionViewLayout *, NSInteger))objc_msgSend)((id)oldDelegate, sel, collectionView, collectionViewLayout, section);
}

- (CGFloat)tab_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    TABCollectionAnimated *tabAnimated = collectionView.tabAnimated;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:);
    return ((CGFloat (*)(id, SEL, UICollectionView *, UICollectionViewLayout *, NSInteger))objc_msgSend)((id)oldDelegate, sel, collectionView, collectionViewLayout, section);
}

@end
