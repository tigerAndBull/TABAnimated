//
//  TABCollectionAnimated.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/4/27.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABCollectionAnimated.h"

#import "TABManagerMethod.h"
#import "TABAnimated.h"
#import "TABAnimatedCacheManager.h"
#import "TableDeDaSelfModel.h"

#import "objc/runtime.h"

@interface TABCollectionAnimated()

@property (nonatomic, strong, readwrite) NSMutableArray <Class> *headerClassArray;
@property (nonatomic, strong, readwrite) NSMutableArray <NSValue *> *headerSizeArray;
@property (nonatomic, strong, readwrite) NSMutableArray <NSNumber *> *headerSectionArray;

@property (nonatomic, strong, readwrite) NSMutableArray <Class> *footerClassArray;
@property (nonatomic, strong, readwrite) NSMutableArray <NSValue *> *footerSizeArray;
@property (nonatomic, strong, readwrite) NSMutableArray <NSNumber *> *footerSectionArray;

@property (nonatomic, assign, readwrite) TABAnimatedRunMode runMode;

@end

@implementation TABCollectionAnimated

+ (instancetype)animatedWithCellClass:(Class)cellClass
                             cellSize:(CGSize)cellSize {
    TABCollectionAnimated *obj = [[TABCollectionAnimated alloc] init];
    obj.cellClassArray = @[cellClass];
    obj.cellSize = cellSize;
    obj.animatedCount = ceilf([UIScreen mainScreen].bounds.size.height/cellSize.height*1.0);
    return obj;
}

+ (instancetype)animatedWithCellClass:(Class)cellClass
                             cellSize:(CGSize)cellSize
                        animatedCount:(NSInteger)animatedCount {
    TABCollectionAnimated *obj = [self animatedWithCellClass:cellClass cellSize:cellSize];
    obj.animatedCount = animatedCount;
    return obj;
}

+ (instancetype)animatedWithCellClass:(Class)cellClass
                             cellSize:(CGSize)cellSize
                            toSection:(NSInteger)section {
    TABCollectionAnimated *obj = [self animatedWithCellClass:cellClass cellSize:cellSize];
    obj.animatedCountArray = @[@(ceilf([UIScreen mainScreen].bounds.size.height/cellSize.height*1.0))];
    obj.animatedIndexArray = @[@(section)];
    return obj;
}

+ (instancetype)animatedWithCellClass:(Class)cellClass
                             cellSize:(CGSize)cellSize
                        animatedCount:(NSInteger)animatedCount
                            toSection:(NSInteger)section {
    TABCollectionAnimated *obj = [self animatedWithCellClass:cellClass cellSize:cellSize];
    obj.animatedCountArray = @[@(animatedCount)];
    obj.animatedIndexArray = @[@(section)];
    return obj;
}

+ (instancetype)animatedWithCellClassArray:(NSArray <Class> *)cellClassArray
                             cellSizeArray:(NSArray <NSValue *> *)cellSizeArray
                        animatedCountArray:(NSArray <NSNumber *> *)animatedCountArray {
    TABCollectionAnimated *obj = [[TABCollectionAnimated alloc] init];
    obj.animatedCountArray = animatedCountArray;
    obj.cellSizeArray = cellSizeArray;
    obj.cellClassArray = cellClassArray;
    return obj;
}

+ (instancetype)animatedWithCellClassArray:(NSArray <Class> *)cellClassArray
                             cellSizeArray:(NSArray <NSValue *> *)cellSizeArray
                        animatedCountArray:(NSArray <NSNumber *> *)animatedCountArray
                      animatedSectionArray:(NSArray <NSNumber *> *)animatedSectionArray {
    TABCollectionAnimated *obj = [self animatedWithCellClassArray:cellClassArray
                                                    cellSizeArray:cellSizeArray
                                               animatedCountArray:animatedCountArray];
    obj.animatedIndexArray = animatedSectionArray;
    return obj;
}

#pragma mark -

+ (instancetype)animatedInRowModeWithCellClassArray:(NSArray <Class> *)cellClassArray
                                      cellSizeArray:(NSArray <NSValue *> *)cellSizeArray {
    TABCollectionAnimated *obj = [[TABCollectionAnimated alloc] init];
    obj.cellSizeArray = cellSizeArray;
    obj.cellClassArray = cellClassArray;
    obj.runMode = TABAnimatedRunByRow;
    return obj;
}

+ (instancetype)animatedInRowModeWithCellClassArray:(NSArray <Class> *)cellClassArray
                                      cellSizeArray:(NSArray <NSValue *> *)cellSizeArray
                                           rowArray:(NSArray <NSNumber *> *)rowArray {
    TABCollectionAnimated *obj = [TABCollectionAnimated animatedInRowModeWithCellClassArray:cellSizeArray cellSizeArray:cellSizeArray];
    obj.animatedIndexArray = rowArray;
    return obj;
}

+ (instancetype)animatedInRowModeWithCellClass:(Class)cellClass
                                      cellSize:(CGSize)cellSize
                                         toRow:(NSInteger)row {
    TABCollectionAnimated *obj = [self animatedWithCellClass:cellClass cellSize:cellSize];
    obj.runMode = TABAnimatedRunByRow;
    obj.animatedCountArray = @[@(1)];
    obj.animatedIndexArray = @[@(row)];
    return obj;
}

- (instancetype)init {
    if (self = [super init]) {
        _runAnimationIndexArray = @[].mutableCopy;
        _animatedSectionCount = 0;
        _animatedCount = 1;
        
        _headerSizeArray = @[].mutableCopy;
        _headerClassArray = @[].mutableCopy;
        _headerSectionArray = @[].mutableCopy;
        
        _footerSizeArray = @[].mutableCopy;
        _footerClassArray = @[].mutableCopy;
        _footerSectionArray = @[].mutableCopy;
    }
    return self;
}

- (void)setCellSize:(CGSize)cellSize {
    _cellSize = cellSize;
    _cellSizeArray = @[[NSValue valueWithCGSize:cellSize]];
}

- (BOOL)currentIndexIsAnimatingWithIndex:(NSInteger)index {
    for (NSNumber *num in self.runAnimationIndexArray) {
        if ([num integerValue] == index) {
            return YES;
        }
    }
    return NO;
}

- (NSInteger)headerFooterNeedAnimationOnSection:(NSInteger)section
                                           kind:(NSString *)kind {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        if (self.headerSectionArray.count == 0) {
            return TABViewAnimatedErrorCode;
        }
        
        for (NSInteger i = 0; i < self.headerSectionArray.count; i++) {
            NSNumber *num = self.headerSectionArray[i];
            if ([num integerValue] == section) {
                return i;
            }
        }
        
        return TABViewAnimatedErrorCode;
    }
    
    if (self.footerSectionArray.count == 0) {
        return TABViewAnimatedErrorCode;
    }
    
    for (NSInteger i = 0; i < self.footerSectionArray.count; i++) {
        NSNumber *num = self.footerSectionArray[i];
        if ([num integerValue] == section) {
            return i;
        }
    }
    
    return TABViewAnimatedErrorCode;
}

- (void)addHeaderViewClass:(_Nonnull Class)headerViewClass
                  viewSize:(CGSize)viewSize {
    [_headerClassArray addObject:headerViewClass];
    [_headerSizeArray addObject:@(viewSize)];
}

- (void)addHeaderViewClass:(_Nonnull Class)headerViewClass
                  viewSize:(CGSize)viewSize
                 toSection:(NSInteger)section {
    BOOL isAdd = false;
    for (int i = 0; i < _headerSectionArray.count; i++) {
        NSInteger oldSection = [_headerSectionArray[i] integerValue];
        if (oldSection == section) {
            isAdd = YES;
            [_headerClassArray replaceObjectAtIndex:i withObject:headerViewClass];
            [_headerSizeArray replaceObjectAtIndex:i withObject:@(viewSize)];
            [_headerSectionArray replaceObjectAtIndex:i withObject:@(section)];
        }
    }
    
    if (!isAdd) {
        [_headerClassArray addObject:headerViewClass];
        [_headerSizeArray addObject:@(viewSize)];
        [_headerSectionArray addObject:@(section)];
    }
}

- (void)addFooterViewClass:(_Nonnull Class)footerViewClass
                  viewSize:(CGSize)viewSize {
    [_footerClassArray addObject:footerViewClass];
    [_footerSizeArray addObject:@(viewSize)];
}

- (void)addFooterViewClass:(_Nonnull Class)footerViewClass
                  viewSize:(CGSize)viewSize
                 toSection:(NSInteger)section {
    BOOL isAdd = false;
    for (int i = 0; i < _footerSectionArray.count; i++) {
        NSInteger oldSection = [_footerSectionArray[i] integerValue];
        if (oldSection == section) {
            isAdd = YES;
            [_footerClassArray replaceObjectAtIndex:i withObject:footerViewClass];
            [_footerSizeArray replaceObjectAtIndex:i withObject:@(viewSize)];
            [_footerSectionArray replaceObjectAtIndex:i withObject:@(section)];
        }
    }
    
    if (!isAdd) {
        [_footerClassArray addObject:footerViewClass];
        [_footerSizeArray addObject:@(viewSize)];
        [_footerSectionArray addObject:@(section)];
    }
}

- (void)exchangeCollectionViewDelegate:(UICollectionView *)target {
    
    id <UICollectionViewDelegate> delegate = target.delegate;
    
    if (!_isExhangeDelegateIMP) {
        _isExhangeDelegateIMP = YES;
        
        if ([target isEqual:delegate]) {
            CollectionDeDaSelfModel *model = [[TABAnimated sharedAnimated] getCollectionDeDaModelAboutDeDaSelfWithClassName:NSStringFromClass(delegate.class)];
            if (!model.isExhangeDelegate) {
                [self exchangeDelegateMethods:delegate
                                       target:target
                                        model:model];
                model.isExhangeDelegate = YES;
            }
        }else {
            [self exchangeDelegateMethods:delegate
                                   target:target
                                    model:nil];
        }
    }
}

- (void)exchangeCollectionViewDataSource:(UICollectionView *)target {
    
    id <UICollectionViewDataSource> dataSource = target.dataSource;
    
    if (!_isExhangeDataSourceIMP) {
        _isExhangeDataSourceIMP = YES;
        if ([target isEqual:dataSource]) {
            CollectionDeDaSelfModel *model = [[TABAnimated sharedAnimated] getCollectionDeDaModelAboutDeDaSelfWithClassName:NSStringFromClass(dataSource.class)];
            if (!model.isExhangeDataSource) {
                [self exchangeDataSourceMethods:dataSource
                                         target:target
                                          model:model];
                model.isExhangeDataSource = YES;
            }
        }else {
            [self exchangeDataSourceMethods:dataSource
                                     target:target
                                      model:nil];
        }
    }
}

#pragma mark - Private Methods

- (void)exchangeDelegateMethods:(id<UICollectionViewDelegate>)delegate
                         target:(id)target
                          model:(CollectionDeDaSelfModel *)model {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    SEL oldHeightSel = @selector(collectionView:layout:sizeForItemAtIndexPath:);
    SEL newHeightSel;
    if (model) {
        newHeightSel = @selector(tab_deda_collectionView:layout:sizeForItemAtIndexPath:);
    }else {
        newHeightSel = @selector(tab_collectionView:layout:sizeForItemAtIndexPath:);
    }
    [self exchangeDelegateOldSel:oldHeightSel
                      withNewSel:newHeightSel
                      withTarget:target
                    withDelegate:delegate
                           model:model];
    
    SEL oldDisplaySel = @selector(collectionView:willDisplayCell:forItemAtIndexPath:);
    SEL newDisplaySel;
    if (model) {
        newDisplaySel = @selector(tab_deda_collectionView:willDisplayCell:forItemAtIndexPath:);
    }else {
        newDisplaySel = @selector(tab_collectionView:willDisplayCell:forItemAtIndexPath:);
    }
    [self exchangeDelegateOldSel:oldDisplaySel
                      withNewSel:newDisplaySel
                      withTarget:target
                    withDelegate:delegate
                           model:model];
    
    SEL oldClickSel = @selector(collectionView:didSelectItemAtIndexPath:);
    SEL newClickSel;
    if (model) {
        newClickSel = @selector(tab_deda_collectionView:didSelectItemAtIndexPath:);
    }else {
        newClickSel = @selector(tab_collectionView:didSelectItemAtIndexPath:);
    }
    [self exchangeDelegateOldSel:oldClickSel
                      withNewSel:newClickSel
                      withTarget:target
                    withDelegate:delegate
                           model:model];
    
#pragma clang diagnostic pop
    
}

- (void)exchangeDataSourceMethods:(id<UICollectionViewDataSource>)dataSource
                           target:(id)target
                            model:(CollectionDeDaSelfModel *)model {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    SEL oldSectionsSel = @selector(numberOfSectionsInCollectionView:);
    SEL newSectionsSel;
    if (model) {
        newSectionsSel = @selector(tab_deda_numberOfSectionsInCollectionView:);
    }else {
        newSectionsSel = @selector(tab_numberOfSectionsInCollectionView:);
    }
    [self exchangeDelegateOldSel:oldSectionsSel
                      withNewSel:newSectionsSel
                      withTarget:target
                    withDelegate:dataSource
                           model:model];
    
    SEL oldItemsSel = @selector(collectionView:numberOfItemsInSection:);
    SEL newItemsSel;
    if (model) {
        newItemsSel = @selector(tab_deda_collectionView:numberOfItemsInSection:);
    }else {
        newItemsSel = @selector(tab_collectionView:numberOfItemsInSection:);
    }
    [self exchangeDelegateOldSel:oldItemsSel
                      withNewSel:newItemsSel
                      withTarget:target
                    withDelegate:dataSource
                           model:model];
    
    SEL oldCellSel = @selector(collectionView:cellForItemAtIndexPath:);
    SEL newCellSel;
    if (model) {
        newCellSel = @selector(tab_deda_collectionView:cellForItemAtIndexPath:);
    }else {
        newCellSel = @selector(tab_collectionView:cellForItemAtIndexPath:);
    }
    [self exchangeDelegateOldSel:oldCellSel
                      withNewSel:newCellSel
                      withTarget:target
                    withDelegate:dataSource
                           model:model];
    
    SEL oldReuseableCellSel = @selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:);
    SEL newReuseableCellSel;
    if (model) {
        newReuseableCellSel = @selector(tab_deda_collectionView:viewForSupplementaryElementOfKind:atIndexPath:);
    }else {
        newReuseableCellSel = @selector(tab_collectionView:viewForSupplementaryElementOfKind:atIndexPath:);
    }
    [self exchangeDelegateOldSel:oldReuseableCellSel
                      withNewSel:newReuseableCellSel
                      withTarget:target
                    withDelegate:dataSource
                           model:model];
    
    SEL oldHeaderCellSel = @selector(collectionView:layout:referenceSizeForHeaderInSection:);
    SEL newHeaderCellSel;
    if (model) {
        newHeaderCellSel = @selector(tab_deda_collectionView:layout:referenceSizeForHeaderInSection:);
    }else {
        newHeaderCellSel = @selector(tab_collectionView:layout:referenceSizeForHeaderInSection:);
    }
    [self exchangeDelegateOldSel:oldHeaderCellSel
                      withNewSel:newHeaderCellSel
                      withTarget:target
                    withDelegate:dataSource
                           model:model];
    
    SEL oldFooterCellSel = @selector(collectionView:layout:referenceSizeForFooterInSection:);
    SEL newFooterCellSel;
    if (model) {
        newFooterCellSel = @selector(tab_deda_collectionView:layout:referenceSizeForFooterInSection:);
    }else {
        newFooterCellSel = @selector(tab_collectionView:layout:referenceSizeForFooterInSection:);
    }
    [self exchangeDelegateOldSel:oldFooterCellSel
                      withNewSel:newFooterCellSel
                      withTarget:target
                    withDelegate:dataSource
                           model:model];
    
#pragma clang diagnostic pop
    
}

/**
 exchange method
 
 @param oldSelector old method's sel
 @param newSelector new method's sel
 @param delegate return nil
 */
- (void)exchangeDelegateOldSel:(SEL)oldSelector
                    withNewSel:(SEL)newSelector
                    withTarget:(id)target
                  withDelegate:(id)delegate
                         model:(CollectionDeDaSelfModel *)model {
    
    if (![delegate respondsToSelector:oldSelector]) {
        return;
    }
    
    Class targetClass;
    if (model) {
        targetClass = [model class];
    }else {
        targetClass = [self class];
    }
    
    Method newMethod = class_getInstanceMethod(targetClass, newSelector);
    if (newMethod == nil) {
        return;
    }
    
    Method oldMethod = class_getInstanceMethod([delegate class], oldSelector);
    
    BOOL isVictory = class_addMethod([delegate class], newSelector, class_getMethodImplementation([delegate class], oldSelector), method_getTypeEncoding(oldMethod));
    if (isVictory) {
        class_replaceMethod([delegate class], oldSelector, class_getMethodImplementation(targetClass, newSelector), method_getTypeEncoding(newMethod));
    }
}

#pragma mark - TABCollectionViewDelegate

- (NSInteger)tab_numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (collectionView.tabAnimated.state == TABViewAnimationStart) {
        
        if (collectionView.tabAnimated.animatedSectionCount != 0) {
            return collectionView.tabAnimated.animatedSectionCount;
        }

        NSInteger count = [self tab_numberOfSectionsInCollectionView:collectionView];
        if (count == 0) {
            count = collectionView.tabAnimated.cellClassArray.count;
        }

        if (count == 0) return 1;
        
        return count;
    }
    
    return [self tab_numberOfSectionsInCollectionView:collectionView];
}

- (NSInteger)tab_collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView.tabAnimated.runMode == TABAnimatedRunByRow) {
        NSInteger count = [self tab_collectionView:collectionView numberOfItemsInSection:section];
        if (count == 0) {
            return collectionView.tabAnimated.cellClassArray.count;
        }
        return count;
    }
    
    if ([collectionView.tabAnimated currentIndexIsAnimatingWithIndex:section]) {
        
        // 开发者指定section
        if (collectionView.tabAnimated.animatedIndexArray.count > 0) {
            
            // 匹配当前section
            for (NSNumber *num in collectionView.tabAnimated.animatedIndexArray) {
                if ([num integerValue] == section) {
                    NSInteger index = [collectionView.tabAnimated.animatedIndexArray indexOfObject:num];
                    if (index > collectionView.tabAnimated.animatedCountArray.count - 1) {
                        return [[collectionView.tabAnimated.animatedCountArray lastObject] integerValue];
                    }else {
                        return [collectionView.tabAnimated.animatedCountArray[index] integerValue];
                    }
                }
                
                if ([num isEqual:[collectionView.tabAnimated.animatedIndexArray lastObject]]) {
                    return [self tab_collectionView:collectionView numberOfItemsInSection:section];
                }
            }
        }
        
        if (collectionView.tabAnimated.animatedCountArray.count > 0) {
            if (section > collectionView.tabAnimated.animatedCountArray.count - 1) {
                return collectionView.tabAnimated.animatedCount;
            }
            return [collectionView.tabAnimated.animatedCountArray[section] integerValue];
        }
        return collectionView.tabAnimated.animatedCount;
    }
    return [self tab_collectionView:collectionView numberOfItemsInSection:section];
}

- (CGSize)tab_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index;
    switch (collectionView.tabAnimated.runMode) {
        case TABAnimatedRunBySection: {
            index = indexPath.section;
        }
            break;
        case TABAnimatedRunByRow: {
            index = indexPath.row;
        }
            break;
    }
    
    if ([collectionView.tabAnimated currentIndexIsAnimatingWithIndex:index]) {
        
        // 开发者指定section
        if (collectionView.tabAnimated.animatedIndexArray.count > 0) {
            
            // 匹配当前section
            for (NSNumber *num in collectionView.tabAnimated.animatedIndexArray) {
                if ([num integerValue] == index) {
                    NSInteger currentIndex = [collectionView.tabAnimated.animatedIndexArray indexOfObject:num];
                    if (currentIndex > collectionView.tabAnimated.cellSizeArray.count - 1) {
                        index = [collectionView.tabAnimated.cellSizeArray count] - 1;
                    }else {
                        index = currentIndex;
                    }
                    break;
                }
                
                if ([num isEqual:[collectionView.tabAnimated.animatedIndexArray lastObject]]) {
                    return [self tab_collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
                }
            }
        }else {
            if (index > (collectionView.tabAnimated.cellSizeArray.count - 1)) {
                index = collectionView.tabAnimated.cellSizeArray.count - 1;
                tabAnimatedLog(@"TABAnimated提醒 - 获取到的分区的数量和设置的分区数量不一致，超出的分区值部分，将使用最后一个分区cell加载");
            }
        }
        
        CGSize size = [collectionView.tabAnimated.cellSizeArray[index] CGSizeValue];
        return size;
    }
    return [self tab_collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
}

- (UICollectionViewCell *)tab_collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index;
    switch (collectionView.tabAnimated.runMode) {
        case TABAnimatedRunBySection: {
            index = indexPath.section;
        }
            break;
        case TABAnimatedRunByRow: {
            index = indexPath.row;
        }
            break;
    }
    
    if ([collectionView.tabAnimated currentIndexIsAnimatingWithIndex:index]) {
        
        // 开发者指定section
        if (collectionView.tabAnimated.animatedIndexArray.count > 0) {
            
            // 匹配当前section
            for (NSNumber *num in collectionView.tabAnimated.animatedIndexArray) {
                if ([num integerValue] == index) {
                    NSInteger currentIndex = [collectionView.tabAnimated.animatedIndexArray indexOfObject:num];
                    if (currentIndex > collectionView.tabAnimated.cellClassArray.count - 1) {
                        index = [collectionView.tabAnimated.cellClassArray count] - 1;
                    }else {
                        index = currentIndex;
                    }
                    break;
                }
                
                if ([num isEqual:[collectionView.tabAnimated.animatedIndexArray lastObject]]) {
                    return [self tab_collectionView:collectionView cellForItemAtIndexPath:indexPath];
                }
            }
        }else {
            if (index > (collectionView.tabAnimated.cellClassArray.count - 1)) {
                index = collectionView.tabAnimated.cellClassArray.count - 1;
                tabAnimatedLog(@"TABAnimated提醒 - 获取到的分区的数量和设置的分区数量不一致，超出的分区值部分，将使用最后一个分区cell加载");
            }
        }
        
        Class currentClass = collectionView.tabAnimated.cellClassArray[index];
        NSString *className = NSStringFromClass(currentClass);
        if ([className containsString:@"."]) {
            NSRange range = [className rangeOfString:@"."];
            className = [className substringFromIndex:range.location+1];
        }
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"tab_%@",className] forIndexPath:indexPath];
        
        NSString *fileName = [className stringByAppendingString:[NSString stringWithFormat:@"_%@",collectionView.tabAnimated.targetControllerClassName]];
        
        if (nil == cell.tabComponentManager) {
            
            TABComponentManager *manager = [[TABAnimated sharedAnimated].cacheManager getComponentManagerWithFileName:fileName];

            if (manager &&
                !manager.needChangeRowStatus) {
                manager.fileName = fileName;
                manager.isLoad = YES;
                manager.tabTargetClass = currentClass;
                manager.currentSection = indexPath.section;
                cell.tabComponentManager = manager;
                [manager reAddToView:cell
                           superView:collectionView];
                [TABManagerMethod startAnimationToSubViews:cell
                                                  rootView:cell];
                [TABManagerMethod addExtraAnimationWithSuperView:collectionView
                                                      targetView:cell
                                                         manager:cell.tabComponentManager];

            }else {
                [TABManagerMethod fullData:cell];
                cell.tabComponentManager =
                [TABComponentManager initWithView:cell
                                        superView:collectionView
                                      tabAnimated:collectionView.tabAnimated];
                cell.tabComponentManager.currentSection = indexPath.section;
                cell.tabComponentManager.fileName = fileName;
                
                __weak typeof(cell) weakCell = cell;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weakCell && weakCell.tabComponentManager) {
                        weakCell.tabComponentManager.tabTargetClass = weakCell.class;
                        // 加载动画
                        [TABManagerMethod runAnimationWithSuperView:collectionView
                                                         targetView:weakCell
                                                             isCell:YES
                                                            manager:weakCell.tabComponentManager];
                    }
                });
            }
        
        }else {
            if (cell.tabComponentManager.tabLayer.hidden) {
                cell.tabComponentManager.tabLayer.hidden = NO;
            }
        }
        cell.tabComponentManager.currentRow = indexPath.row;
        
        return cell;
    }
    return [self tab_collectionView:collectionView cellForItemAtIndexPath:indexPath];
}

- (void)tab_collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index;
    switch (collectionView.tabAnimated.runMode) {
        case TABAnimatedRunBySection: {
            index = indexPath.section;
        }
            break;
        case TABAnimatedRunByRow: {
            index = indexPath.row;
        }
            break;
    }
    
    if ([collectionView.tabAnimated currentIndexIsAnimatingWithIndex:index]) {
        return;
    }
    [self tab_collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
}

- (void)tab_collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index;
    switch (collectionView.tabAnimated.runMode) {
        case TABAnimatedRunBySection: {
            index = indexPath.section;
        }
            break;
        case TABAnimatedRunByRow: {
            index = indexPath.row;
        }
            break;
    }
    
    if ([collectionView.tabAnimated currentIndexIsAnimatingWithIndex:index] ||
        collectionView.tabAnimated.state == TABViewAnimationRunning) {
        return;
    }
    [self tab_collectionView:collectionView didSelectItemAtIndexPath:indexPath];
}

#pragma mark - About HeaderFooterView

- (CGSize)tab_collectionView:(UICollectionView *)collectionView
                      layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    
    if ([collectionView.tabAnimated currentIndexIsAnimatingWithIndex:section]) {
        NSInteger index = [collectionView.tabAnimated headerFooterNeedAnimationOnSection:section
                                                                                    kind:UICollectionElementKindSectionHeader];
        if (index != TABViewAnimatedErrorCode) {
            NSValue *value = nil;
            if (index > collectionView.tabAnimated.headerSizeArray.count - 1) {
                value = collectionView.tabAnimated.headerSizeArray.lastObject;
            }else {
                value = collectionView.tabAnimated.headerSizeArray[index];
            }
            return [value CGSizeValue];
        }
        return [self tab_collectionView:collectionView
                                 layout:collectionViewLayout
        referenceSizeForHeaderInSection:section];
    }
    
    return [self tab_collectionView:collectionView
                             layout:collectionViewLayout
    referenceSizeForHeaderInSection:section];
}

- (CGSize)tab_collectionView:(UICollectionView *)collectionView
                      layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section {
    
    if ([collectionView.tabAnimated currentIndexIsAnimatingWithIndex:section]) {
        NSInteger index = [collectionView.tabAnimated headerFooterNeedAnimationOnSection:section
                                                                                    kind:UICollectionElementKindSectionFooter];
        if (index != TABViewAnimatedErrorCode) {
            NSValue *value = nil;
            if (index > collectionView.tabAnimated.footerSizeArray.count - 1) {
                value = collectionView.tabAnimated.footerSizeArray.lastObject;
            }else {
                value = collectionView.tabAnimated.footerSizeArray[index];
            }
            return [value CGSizeValue];
        }
        return [self tab_collectionView:collectionView
                                 layout:collectionViewLayout
        referenceSizeForFooterInSection:section];
    }
    
    return [self tab_collectionView:collectionView
                             layout:collectionViewLayout
    referenceSizeForFooterInSection:section];
}

- (UICollectionReusableView *)tab_collectionView:(UICollectionView *)collectionView
               viewForSupplementaryElementOfKind:(NSString *)kind
                                     atIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView.tabAnimated currentIndexIsAnimatingWithIndex:indexPath.section]) {
        
        NSInteger index = [collectionView.tabAnimated headerFooterNeedAnimationOnSection:indexPath.section
                                                                                    kind:kind];
        
        if (index == TABViewAnimatedErrorCode) {
            return [self tab_collectionView:collectionView
          viewForSupplementaryElementOfKind:kind
                                atIndexPath:indexPath];
        }
        
        Class resuableClass = nil;
        NSString *identifier = nil;
        NSString *defaultPredix = nil;
        
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            if (index > collectionView.tabAnimated.headerClassArray.count - 1) {
                resuableClass = collectionView.tabAnimated.headerClassArray.lastObject;
            }else {
                resuableClass = collectionView.tabAnimated.headerClassArray[index];
            }
            defaultPredix = TABViewAnimatedHeaderPrefixString;
            identifier = [NSString stringWithFormat:@"%@%@",TABViewAnimatedHeaderPrefixString,NSStringFromClass(resuableClass)];
        }else {
            if (index > collectionView.tabAnimated.footerClassArray.count - 1) {
                resuableClass = collectionView.tabAnimated.footerClassArray.lastObject;
            }else {
                resuableClass = collectionView.tabAnimated.footerClassArray[index];
            }
            defaultPredix = TABViewAnimatedFooterPrefixString;
            identifier = [NSString stringWithFormat:@"%@%@",TABViewAnimatedFooterPrefixString,NSStringFromClass(resuableClass)];
        }
        
        if (resuableClass == nil) {
            return [self tab_collectionView:collectionView
          viewForSupplementaryElementOfKind:kind
                                atIndexPath:indexPath];
        }
        
        UIView *view = resuableClass.new;
        UICollectionReusableView *reusableView;
        
        if (![view isKindOfClass:[UICollectionReusableView class]]) {
            reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                              withReuseIdentifier:[NSString stringWithFormat:@"%@%@",defaultPredix,TABViewAnimatedDefaultSuffixString]
                                                                     forIndexPath:indexPath];
            for (UIView *view in reusableView.subviews) {
                [view removeFromSuperview];
            }
            view.frame = reusableView.bounds;
            [reusableView addSubview:view];
        }else {
            reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                              withReuseIdentifier:identifier
                                                                     forIndexPath:indexPath];
        }
        
        NSString *fileName = [NSStringFromClass(resuableClass) stringByAppendingString:[NSString stringWithFormat:@"_%@",collectionView.tabAnimated.targetControllerClassName]];
        
        if (nil == reusableView.tabComponentManager) {
            
            TABComponentManager *manager = [[TABAnimated sharedAnimated].cacheManager getComponentManagerWithFileName:fileName];
            
            if (manager &&
                !manager.needChangeRowStatus) {
                manager.fileName = fileName;
                manager.isLoad = YES;
                manager.tabTargetClass = resuableClass;
                manager.currentSection = indexPath.section;
                [manager reAddToView:reusableView
                           superView:collectionView];
                reusableView.tabComponentManager = manager;
                [TABManagerMethod startAnimationToSubViews:reusableView
                                                  rootView:reusableView];
                [TABManagerMethod addExtraAnimationWithSuperView:collectionView
                                                      targetView:reusableView
                                                         manager:reusableView.tabComponentManager];
            }else {
                [TABManagerMethod fullData:reusableView];
                reusableView.tabComponentManager =
                [TABComponentManager initWithView:reusableView
                                        superView:collectionView
                                      tabAnimated:collectionView.tabAnimated];
                reusableView.tabComponentManager.currentSection = indexPath.section;
                reusableView.tabComponentManager.tabTargetClass = resuableClass;
                reusableView.tabComponentManager.fileName = fileName;
                
                __weak typeof(reusableView) weakView = reusableView;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (weakView && weakView.tabComponentManager) {
                        
                        BOOL isCell = NO;
                        if ([weakView isKindOfClass:[UICollectionReusableView class]]) {
                            isCell = YES;
                        }
                        
                        [TABManagerMethod runAnimationWithSuperView:collectionView
                                                         targetView:weakView
                                                             isCell:isCell
                                                            manager:weakView.tabComponentManager];
                    }
                });
            }
        }else {
            if (reusableView.tabComponentManager.tabLayer.hidden) {
                reusableView.tabComponentManager.tabLayer.hidden = NO;
            }
        }
        reusableView.tabComponentManager.currentRow = indexPath.row;
        
        return reusableView;
        
    }
    return [self tab_collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
}

@end
