//
//  TableDelegateSelfModel.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/8/10.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TableDeDaSelfModel.h"
#import "TABAnimated.h"
#import "TABComponentManager.h"
#import "TABManagerMethod.h"
#import "TABAnimatedCacheManager.h"

@implementation TableDeDaSelfModel

- (NSInteger)tab_deda_numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tabAnimated.state == TABViewAnimationStart) {
        
        if (tableView.tabAnimated.animatedSectionCount != 0) {
            return tableView.tabAnimated.animatedSectionCount;
        }

        NSInteger count = [self tab_deda_numberOfSectionsInTableView:tableView];
        if (count == 0) {
            count = tableView.tabAnimated.cellClassArray.count;
        }

        if (count == 0) return 1;
        
        return count;
    }
    
    return [self tab_deda_numberOfSectionsInTableView:tableView];
}

- (NSInteger)tab_deda_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView.tabAnimated.runMode == TABAnimatedRunByRow) {
        NSInteger count = [self tab_deda_tableView:tableView numberOfRowsInSection:section];
        if (count == 0) {
            return tableView.tabAnimated.cellClassArray.count;
        }
        return count;
    }
    
    // If the animation running, return animatedCount.
    if ([tableView.tabAnimated currentIndexIsAnimatingWithIndex:section]) {
        
        // 开发者指定section/row
        if (tableView.tabAnimated.animatedIndexArray.count > 0) {
            
            // 没有获取到动画时row数量
            if (tableView.tabAnimated.animatedCountArray.count == 0) {
                return 0;
            }
            
            // 匹配当前section
            for (NSNumber *num in tableView.tabAnimated.animatedIndexArray) {
                if ([num integerValue] == section) {
                    NSInteger index = [tableView.tabAnimated.animatedIndexArray indexOfObject:num];
                    if (index > tableView.tabAnimated.animatedCountArray.count - 1) {
                        return [[tableView.tabAnimated.animatedCountArray lastObject] integerValue];
                    }else {
                        return [tableView.tabAnimated.animatedCountArray[index] integerValue];
                    }
                }
                
                // 没有匹配到指定的数量
                if ([num isEqual:[tableView.tabAnimated.animatedIndexArray lastObject]]) {
                    return 0;
                }
            }
        }
        
        if (tableView.tabAnimated.animatedCountArray.count > 0) {
            if (section > tableView.tabAnimated.animatedCountArray.count - 1) {
                return tableView.tabAnimated.animatedCount;
            }
            return [tableView.tabAnimated.animatedCountArray[section] integerValue];
        }
        return tableView.tabAnimated.animatedCount;
    }
    return [self tab_deda_tableView:tableView numberOfRowsInSection:section];
}

- (CGFloat)tab_deda_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index;
    switch (tableView.tabAnimated.runMode) {
        case TABAnimatedRunBySection: {
            index = indexPath.section;
        }
            break;
        case TABAnimatedRunByRow: {
            index = indexPath.row;
        }
            break;
    }
    
    if ([tableView.tabAnimated currentIndexIsAnimatingWithIndex:index]) {
        
        // 开发者指定section
        if (tableView.tabAnimated.animatedIndexArray.count > 0) {
            
            // 匹配当前section
            for (NSNumber *num in tableView.tabAnimated.animatedIndexArray) {
                if ([num integerValue] == index) {
                    NSInteger currentIndex = [tableView.tabAnimated.animatedIndexArray indexOfObject:num];
                    if (currentIndex > tableView.tabAnimated.cellHeightArray.count - 1) {
                        index = [tableView.tabAnimated.cellHeightArray count] - 1;
                    }else {
                        index = currentIndex;
                    }
                    break;
                }
                
                // 没有匹配到注册的cell
                if ([num isEqual:[tableView.tabAnimated.animatedIndexArray lastObject]]) {
                    return 1.;
                }
            }
        }else {
            if (index > (tableView.tabAnimated.cellClassArray.count - 1)) {
                index = tableView.tabAnimated.cellClassArray.count - 1;
                tabAnimatedLog(@"TABAnimated提醒 - section的数量和指定分区的数量不一致，超出的section，将使用最后一个分区cell加载");
            }
        }
        
        return [tableView.tabAnimated.cellHeightArray[index] floatValue];
    }
    return [self tab_deda_tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tab_deda_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index;
    switch (tableView.tabAnimated.runMode) {
        case TABAnimatedRunBySection: {
            index = indexPath.section;
        }
            break;
        case TABAnimatedRunByRow: {
            index = indexPath.row;
        }
            break;
    }
    
    if ([tableView.tabAnimated currentIndexIsAnimatingWithIndex:index]) {
        
        // 开发者指定index
        if (tableView.tabAnimated.animatedIndexArray.count > 0) {
            
            if (tableView.tabAnimated.cellClassArray.count == 0) {
                return UITableViewCell.new;
            }
            
            // 匹配当前section
            for (NSNumber *num in tableView.tabAnimated.animatedIndexArray) {
                if ([num integerValue] == index) {
                    NSInteger currentIndex = [tableView.tabAnimated.animatedIndexArray indexOfObject:num];
                    if (currentIndex > tableView.tabAnimated.cellClassArray.count - 1) {
                        index = [tableView.tabAnimated.cellClassArray count] - 1;
                    }else {
                        index = currentIndex;
                    }
                    break;
                }
                
                if ([num isEqual:[tableView.tabAnimated.animatedIndexArray lastObject]]) {
                    return UITableViewCell.new;
                }
            }
        }else {
            if (index > (tableView.tabAnimated.cellClassArray.count - 1)) {
                index = tableView.tabAnimated.cellClassArray.count - 1;
                tabAnimatedLog(@"TABAnimated - section的数量和指定分区的数量不一致，超出的section，将使用最后一个分区cell加载");
            }
        }
        
        Class currentClass = tableView.tabAnimated.cellClassArray[index];
        NSString *className = NSStringFromClass(currentClass);
        if ([className containsString:@"."]) {
            NSRange range = [className rangeOfString:@"."];
            className = [className substringFromIndex:range.location+1];
        }
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"tab_%@",className] forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *fileName = [className stringByAppendingString:[NSString stringWithFormat:@"_%@",tableView.tabAnimated.targetControllerClassName]];
        
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
                           superView:tableView];
                
                [TABManagerMethod startAnimationToSubViews:cell
                                                  rootView:cell];
                [TABManagerMethod addExtraAnimationWithSuperView:tableView
                                                      targetView:cell
                                                         manager:cell.tabComponentManager];
            }else {
                
                [TABManagerMethod fullData:cell];
                cell.tabComponentManager = [TABComponentManager initWithView:cell
                                                                   superView:tableView tabAnimated:tableView.tabAnimated];
                cell.tabComponentManager.currentSection = indexPath.section;
                cell.tabComponentManager.fileName = fileName;
                cell.tabComponentManager.tabTargetClass = currentClass;
            
                __weak typeof(cell) weakCell = cell;
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    TABTableAnimated *tabAnimated = (TABTableAnimated *)tableView.tabAnimated;
                    
                    if (weakCell && tabAnimated && weakCell.tabComponentManager) {
                        [TABManagerMethod runAnimationWithSuperView:tableView
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
        
        if (tableView.tabAnimated.oldEstimatedRowHeight > 0) {
            [TABManagerMethod fullData:cell];
            __weak typeof(cell) weakCell = cell;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakCell.tabComponentManager.tabLayer.frame = weakCell.bounds;
                [TABManagerMethod resetData:weakCell];
            });
        }
        
        return cell;
    }
    return [self tab_deda_tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tab_deda_tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index;
    switch (tableView.tabAnimated.runMode) {
        case TABAnimatedRunBySection: {
            index = indexPath.section;
        }
            break;
        case TABAnimatedRunByRow: {
            index = indexPath.row;
        }
            break;
    }
    
    if ([tableView.tabAnimated currentIndexIsAnimatingWithIndex:index]) {
        return;
    }
    [self tab_deda_tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

- (void)tab_deda_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index;
    switch (tableView.tabAnimated.runMode) {
        case TABAnimatedRunBySection: {
            index = indexPath.section;
        }
            break;
        case TABAnimatedRunByRow: {
            index = indexPath.row;
        }
            break;
    }
    
    if ([tableView.tabAnimated currentIndexIsAnimatingWithIndex:index]) {
        return;
    }
    [self tab_deda_tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - About HeaderFooterView

- (CGFloat)tab_deda_tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([tableView.tabAnimated currentIndexIsAnimatingWithIndex:section]) {
        NSInteger index = [tableView.tabAnimated headerNeedAnimationOnSection:section];
        if (index != TABViewAnimatedErrorCode) {
            NSNumber *value = nil;
            if (index > tableView.tabAnimated.headerHeightArray.count - 1) {
                value = tableView.tabAnimated.headerHeightArray.lastObject;
            }else {
                value = tableView.tabAnimated.headerHeightArray[index];
            }
            return [value floatValue];
        }
        return [self tab_deda_tableView:tableView heightForHeaderInSection:section];
    }
    return [self tab_deda_tableView:tableView heightForHeaderInSection:section];
}

- (CGFloat)tab_deda_tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([tableView.tabAnimated currentIndexIsAnimatingWithIndex:section]) {
        NSInteger index = [tableView.tabAnimated footerNeedAnimationOnSection:section];
        if (index != TABViewAnimatedErrorCode) {
            NSNumber *value = nil;
            if (index > tableView.tabAnimated.footerHeightArray.count - 1) {
                value = tableView.tabAnimated.footerHeightArray.lastObject;
            }else {
                value = tableView.tabAnimated.footerHeightArray[index];
            }
            return [value floatValue];
        }
        return [self tab_deda_tableView:tableView heightForFooterInSection:section];
    }
    return [self tab_deda_tableView:tableView heightForFooterInSection:section];
}

- (nullable UIView *)tab_deda_tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([tableView.tabAnimated currentIndexIsAnimatingWithIndex:section]) {
        NSInteger index = [tableView.tabAnimated headerNeedAnimationOnSection:section];
        if (index != TABViewAnimatedErrorCode) {
            
            Class class;
            if (index > tableView.tabAnimated.headerClassArray.count - 1) {
                class = tableView.tabAnimated.headerClassArray.lastObject;
            }else {
                class = tableView.tabAnimated.headerClassArray[index];
            }
            
            UIView *headerFooterView = class.new;
            headerFooterView.tabAnimated = TABViewAnimated.new;
            [headerFooterView tab_startAnimation];
            
            NSString *fileName = [NSStringFromClass(class) stringByAppendingString:[NSString stringWithFormat:@"_%@",tableView.tabAnimated.targetControllerClassName]];
            
            if (nil == headerFooterView.tabComponentManager) {
                
                TABComponentManager *manager = [[TABAnimated sharedAnimated].cacheManager getComponentManagerWithFileName:fileName];
                
                if (manager) {
                    manager.fileName = fileName;
                    manager.isLoad = YES;
                    manager.tabTargetClass = class;
                    manager.currentSection = section;
                    [manager reAddToView:headerFooterView
                               superView:tableView];
                    headerFooterView.tabComponentManager = manager;
                    [TABManagerMethod startAnimationToSubViews:headerFooterView
                                                      rootView:headerFooterView];
                    [TABManagerMethod addExtraAnimationWithSuperView:tableView
                                                          targetView:headerFooterView
                                                             manager:headerFooterView.tabComponentManager];
                }else {
                    [TABManagerMethod fullData:headerFooterView];
                    headerFooterView.tabComponentManager = [TABComponentManager initWithView:headerFooterView superView:tableView tabAnimated:tableView.tabAnimated];
                    headerFooterView.tabComponentManager.currentSection = section;
                    headerFooterView.tabComponentManager.fileName = fileName;
                    
                    __weak typeof(headerFooterView) weakView = headerFooterView;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (weakView && weakView.tabComponentManager) {
                            
                            BOOL isCell = NO;
                            if ([weakView isKindOfClass:[UITableViewHeaderFooterView class]]) {
                                isCell = YES;
                            }
                            
                            [TABManagerMethod runAnimationWithSuperView:tableView
                                                             targetView:weakView
                                                                 isCell:isCell
                                                                manager:weakView.tabComponentManager];
                        }
                    });
                }
            }else {
                if (headerFooterView.tabComponentManager.tabLayer.hidden) {
                    headerFooterView.tabComponentManager.tabLayer.hidden = NO;
                }
            }
            headerFooterView.tabComponentManager.tabTargetClass = class;
            if (tableView.tabAnimated.oldEstimatedRowHeight > 0) {
                [TABManagerMethod fullData:headerFooterView];
                __weak typeof(headerFooterView) weakView = headerFooterView;
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakView.tabComponentManager.tabLayer.frame = weakView.bounds;
                    [TABManagerMethod resetData:weakView];
                });
            }

            return headerFooterView;
        }
        return [self tab_deda_tableView:tableView viewForHeaderInSection:section];
    }
    return [self tab_deda_tableView:tableView viewForHeaderInSection:section];
}

- (nullable UIView *)tab_deda_tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([tableView.tabAnimated currentIndexIsAnimatingWithIndex:section]) {
        NSInteger index = [tableView.tabAnimated footerNeedAnimationOnSection:section];
        if (index != TABViewAnimatedErrorCode) {
            
            Class class;
            if (index > tableView.tabAnimated.footerClassArray.count - 1) {
                class = tableView.tabAnimated.footerClassArray.lastObject;
            }else {
                class = tableView.tabAnimated.footerClassArray[index];
            }
            
            UIView *headerFooterView = class.new;
            headerFooterView.tabAnimated = TABViewAnimated.new;
            [headerFooterView tab_startAnimation];
            
            NSString *fileName = [NSStringFromClass(class) stringByAppendingString:[NSString stringWithFormat:@"_%@",tableView.tabAnimated.targetControllerClassName]];
            
            if (nil == headerFooterView.tabComponentManager) {
                
                TABComponentManager *manager = [[TABAnimated sharedAnimated].cacheManager getComponentManagerWithFileName:fileName];
                
                if (manager) {
                    manager.fileName = fileName;
                    manager.isLoad = YES;
                    manager.tabTargetClass = class;
                    manager.currentSection = section;
                    [manager reAddToView:headerFooterView
                               superView:tableView];
                    headerFooterView.tabComponentManager = manager;
                    
                    [TABManagerMethod startAnimationToSubViews:headerFooterView
                                                      rootView:headerFooterView];
                    [TABManagerMethod addExtraAnimationWithSuperView:tableView
                                                          targetView:headerFooterView
                                                             manager:headerFooterView.tabComponentManager];
                    
                }else {
                    [TABManagerMethod fullData:headerFooterView];
                    headerFooterView.tabComponentManager = [TABComponentManager initWithView:headerFooterView superView:tableView tabAnimated:tableView.tabAnimated];
                    headerFooterView.tabComponentManager.currentSection = section;
                    headerFooterView.tabComponentManager.fileName = fileName;
                    
                    __weak typeof(headerFooterView) weakView = headerFooterView;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (weakView && weakView.tabComponentManager) {
                            
                            BOOL isCell = NO;
                            if ([weakView isKindOfClass:[UITableViewHeaderFooterView class]]) {
                                isCell = YES;
                            }
                            
                            [TABManagerMethod runAnimationWithSuperView:tableView
                                                             targetView:weakView
                                                                 isCell:isCell
                                                                manager:weakView.tabComponentManager];
                        }
                    });
                }
            }else {
                if (headerFooterView.tabComponentManager.tabLayer.hidden) {
                    headerFooterView.tabComponentManager.tabLayer.hidden = NO;
                }
            }
            
            headerFooterView.tabComponentManager.tabTargetClass = class;
            
            if (tableView.tabAnimated.oldEstimatedRowHeight > 0) {
                [TABManagerMethod fullData:headerFooterView];
                __weak typeof(headerFooterView) weakView = headerFooterView;
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakView.tabComponentManager.tabLayer.frame = weakView.bounds;
                    [TABManagerMethod resetData:weakView];
                });
            }
            
            return headerFooterView;
        }
        return [self tab_deda_tableView:tableView viewForFooterInSection:section];
    }
    return [self tab_deda_tableView:tableView viewForFooterInSection:section];
}


@end

@implementation CollectionDeDaSelfModel

- (NSInteger)tab_deda_numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    if (collectionView.tabAnimated.state == TABViewAnimationStart) {
        
        if (collectionView.tabAnimated.animatedSectionCount != 0) {
            return collectionView.tabAnimated.animatedSectionCount;
        }

        NSInteger count = [self tab_deda_numberOfSectionsInCollectionView:collectionView];
        if (count == 0) {
            count = collectionView.tabAnimated.cellClassArray.count;
        }

        if (count == 0) return 1;
        
        return count;
    }
    
    return [self tab_deda_numberOfSectionsInCollectionView:collectionView];
}

- (NSInteger)tab_deda_collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView.tabAnimated.runMode == TABAnimatedRunByRow) {
        NSInteger count = [self tab_deda_collectionView:collectionView numberOfItemsInSection:section];
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
                    return [self tab_deda_collectionView:collectionView numberOfItemsInSection:section];
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
    return [self tab_deda_collectionView:collectionView numberOfItemsInSection:section];
}

- (CGSize)tab_deda_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
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
                    return [self tab_deda_collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
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
    return [self tab_deda_collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
}

- (UICollectionViewCell *)tab_deda_collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
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
                    return [self tab_deda_collectionView:collectionView cellForItemAtIndexPath:indexPath];
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
                                        superView:collectionView  tabAnimated:collectionView.tabAnimated];
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
    return [self tab_deda_collectionView:collectionView cellForItemAtIndexPath:indexPath];
}

- (void)tab_deda_collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
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
    [self tab_deda_collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
}

- (void)tab_deda_collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
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
    [self tab_deda_collectionView:collectionView didSelectItemAtIndexPath:indexPath];
}

#pragma mark - About HeaderFooterView

- (CGSize)tab_deda_collectionView:(UICollectionView *)collectionView
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
        return [self tab_deda_collectionView:collectionView
                                 layout:collectionViewLayout
        referenceSizeForHeaderInSection:section];
    }
    
    return [self tab_deda_collectionView:collectionView
                             layout:collectionViewLayout
    referenceSizeForHeaderInSection:section];
}

- (CGSize)tab_deda_collectionView:(UICollectionView *)collectionView
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
        return [self tab_deda_collectionView:collectionView
                                 layout:collectionViewLayout
        referenceSizeForFooterInSection:section];
    }
    
    return [self tab_deda_collectionView:collectionView
                             layout:collectionViewLayout
    referenceSizeForFooterInSection:section];
}

- (UICollectionReusableView *)tab_deda_collectionView:(UICollectionView *)collectionView
               viewForSupplementaryElementOfKind:(NSString *)kind
                                     atIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView.tabAnimated currentIndexIsAnimatingWithIndex:indexPath.section]) {
        
        NSInteger index = [collectionView.tabAnimated headerFooterNeedAnimationOnSection:indexPath.section
                                                                                    kind:kind];
        
        if (index == TABViewAnimatedErrorCode) {
            return [self tab_deda_collectionView:collectionView
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
            return [self tab_deda_collectionView:collectionView
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
    return [self tab_deda_collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
}

@end
