//
//  UICollectionView+Animated.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/10/12.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "UICollectionView+TABAnimated.h"
#import "UIView+TABAnimated.h"
#import "TABViewAnimated.h"
#import "TABCollectionAnimated.h"
#import <objc/runtime.h>

@implementation UICollectionView (TABAnimated)

+ (void)load {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        Method originMethod = class_getInstanceMethod([self class], @selector(setDelegate:));
        Method newMethod = class_getInstanceMethod([self class], @selector(tab_setDelegate:));
        method_exchangeImplementations(originMethod, newMethod);
        
        Method originSourceMethod = class_getInstanceMethod([self class], @selector(setDataSource:));
        Method newSourceMethod = class_getInstanceMethod([self class], @selector(tab_setDataSource:));
        method_exchangeImplementations(originSourceMethod, newSourceMethod);
    });
}

- (void)tab_setDelegate:(id<UICollectionViewDelegate>)delegate {
    
    SEL oldHeightSel = @selector(collectionView:layout:sizeForItemAtIndexPath:);
    SEL newHeightSel = @selector(tab_collectionView:layout:sizeForItemAtIndexPath:);
    [self exchangeDelegateOldSel:oldHeightSel withNewSel:newHeightSel withDelegate:delegate];
    
    SEL oldDisplaySel = @selector(collectionView:willDisplayCell:forItemAtIndexPath:);
    SEL newDisplaySel = @selector(tab_collectionView:willDisplayCell:forItemAtIndexPath:);
    [self exchangeDelegateOldSel:oldDisplaySel withNewSel:newDisplaySel withDelegate:delegate];
    
    SEL oldClickSel = @selector(collectionView:didSelectItemAtIndexPath:);
    SEL newClickSel = @selector(tab_collectionView:didSelectItemAtIndexPath:);
    [self exchangeDelegateOldSel:oldClickSel withNewSel:newClickSel withDelegate:delegate];
    
    [self tab_setDelegate:delegate];
}

- (void)tab_setDataSource:(id<UICollectionViewDataSource>)dataSource {
    
    SEL oldSectionsSel = @selector(numberOfSectionsInCollectionView:);
    SEL newSectionsSel = @selector(tab_numberOfSectionsInCollectionView:);
    [self exchangeDelegateOldSel:oldSectionsSel withNewSel:newSectionsSel withDelegate:dataSource];
    
    SEL oldItemsSel = @selector(collectionView:numberOfItemsInSection:);
    SEL newItemsSel = @selector(tab_collectionView:numberOfItemsInSection:);
    [self exchangeDelegateOldSel:oldItemsSel withNewSel:newItemsSel withDelegate:dataSource];
    
    SEL oldCellSel = @selector(collectionView:cellForItemAtIndexPath:);
    SEL newCellSel = @selector(tab_collectionView:cellForItemAtIndexPath:);
    [self exchangeDelegateOldSel:oldCellSel withNewSel:newCellSel withDelegate:dataSource];
    
    SEL oldReuseableCellSel = @selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:);
    SEL newReuseableCellSel = @selector(tab_collectionView:viewForSupplementaryElementOfKind:atIndexPath:);
    [self exchangeDelegateOldSel:oldReuseableCellSel withNewSel:newReuseableCellSel withDelegate:dataSource];
    
    SEL oldHeaderCellSel = @selector(collectionView:layout:referenceSizeForHeaderInSection:);
    SEL newHeaderCellSel = @selector(tab_collectionView:layout:referenceSizeForHeaderInSection:);
    [self exchangeDelegateOldSel:oldHeaderCellSel withNewSel:newHeaderCellSel withDelegate:dataSource];
    
    SEL oldFooterCellSel = @selector(collectionView:layout:referenceSizeForFooterInSection:);
    SEL newFooterCellSel = @selector(tab_collectionView:layout:referenceSizeForFooterInSection:);
    [self exchangeDelegateOldSel:oldFooterCellSel withNewSel:newFooterCellSel withDelegate:dataSource];
    
    [self tab_setDataSource:dataSource];
}

#pragma mark - TABCollectionViewDelegate

- (NSInteger)tab_numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (collectionView.tabAnimated.state == TABViewAnimationStart &&
        collectionView.tabAnimated.animatedSectionCount != 0) {
        for (NSInteger i = 0; i < collectionView.tabAnimated.animatedSectionCount; i++) {
            [collectionView.tabAnimated.runAnimationSectionArray addObject:[NSNumber numberWithInteger:i]];
        }
        if (collectionView.tabAnimated.headerClassArray.count > 0) {
            for (NSInteger i = 0; i < collectionView.tabAnimated.animatedSectionCount; i++) {
                [collectionView.tabAnimated.headerSectionArray addObject:[NSNumber numberWithInteger:i]];
            }
        }
        if (collectionView.tabAnimated.footerClassArray.count > 0) {
            for (NSInteger i = 0; i < collectionView.tabAnimated.animatedSectionCount; i++) {
                [collectionView.tabAnimated.footerSectionArray addObject:[NSNumber numberWithInteger:i]];
            }
        }
        return collectionView.tabAnimated.animatedSectionCount;
    }
    return [self tab_numberOfSectionsInCollectionView:collectionView];
}

- (NSInteger)tab_collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if ([collectionView.tabAnimated currentSectionIsAnimatingWithSection:section]) {
        
        // 开发者指定section
        if (collectionView.tabAnimated.animatedSectionArray.count > 0) {
            
            // 匹配当前section
            for (NSNumber *num in collectionView.tabAnimated.animatedSectionArray) {
                if ([num integerValue] == section) {
                    NSInteger index = [collectionView.tabAnimated.animatedSectionArray indexOfObject:num];
                    if (index > collectionView.tabAnimated.animatedCountArray.count - 1) {
                        return [[collectionView.tabAnimated.animatedCountArray lastObject] integerValue];
                    }else {
                        return [collectionView.tabAnimated.animatedCountArray[index] integerValue];
                    }
                }
                
                if ([num isEqual:[collectionView.tabAnimated.animatedSectionArray lastObject]]) {
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
    
    if ([collectionView.tabAnimated currentSectionIsAnimatingWithSection:indexPath.section]) {
        
        NSInteger index = indexPath.section;
        
        // 开发者指定section
        if (collectionView.tabAnimated.animatedSectionArray.count > 0) {
            
            // 匹配当前section
            for (NSNumber *num in collectionView.tabAnimated.animatedSectionArray) {
                if ([num integerValue] == indexPath.section) {
                    NSInteger currentIndex = [collectionView.tabAnimated.animatedSectionArray indexOfObject:num];
                    if (currentIndex > collectionView.tabAnimated.cellSizeArray.count - 1) {
                        index = [collectionView.tabAnimated.cellSizeArray count] - 1;
                    }else {
                        index = currentIndex;
                    }
                    break;
                }
                
                if ([num isEqual:[collectionView.tabAnimated.animatedSectionArray lastObject]]) {
                    return [self tab_collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
                }
            }
        }else {
            if (indexPath.section > (collectionView.tabAnimated.cellSizeArray.count - 1)) {
                index = collectionView.tabAnimated.cellSizeArray.count - 1;
                tabAnimatedLog(@"TABAnimated提醒 - section的数量和指定分区的数量不一致，超出的section，将使用最后一个分区cell加载");
            }
        }
        
        CGSize size = [collectionView.tabAnimated.cellSizeArray[index] CGSizeValue];
        return size;
    }
    return [self tab_collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
}

- (UICollectionViewCell *)tab_collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([collectionView.tabAnimated currentSectionIsAnimatingWithSection:indexPath.section]) {
        
        NSInteger index = indexPath.section;
        
        // 开发者指定section
        if (collectionView.tabAnimated.animatedSectionArray.count > 0) {
            
            // 匹配当前section
            for (NSNumber *num in collectionView.tabAnimated.animatedSectionArray) {
                if ([num integerValue] == indexPath.section) {
                    NSInteger currentIndex = [collectionView.tabAnimated.animatedSectionArray indexOfObject:num];
                    if (currentIndex > collectionView.tabAnimated.cellClassArray.count - 1) {
                        index = [collectionView.tabAnimated.cellClassArray count] - 1;
                    }else {
                        index = currentIndex;
                    }
                    break;
                }
                
                if ([num isEqual:[collectionView.tabAnimated.animatedSectionArray lastObject]]) {
                    return [self tab_collectionView:collectionView cellForItemAtIndexPath:indexPath];
                }
            }
        }else {
            if (indexPath.section > (collectionView.tabAnimated.cellClassArray.count - 1)) {
                index = collectionView.tabAnimated.cellClassArray.count - 1;
                tabAnimatedLog(@"TABAnimated提醒 - section的数量和指定分区的数量不一致，超出的section，将使用最后一个分区cell加载");
            }
        }
        
        Class currentClass = collectionView.tabAnimated.cellClassArray[index];
        NSString *className = NSStringFromClass(currentClass);
        if ([className containsString:@"."]) {
            NSRange range = [className rangeOfString:@"."];
            className = [className substringFromIndex:range.location+1];
        }
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"tab_%@",className] forIndexPath:indexPath];
        
        if (nil == cell.tabComponentManager) {
            [TABManagerMethod fullData:cell];
            cell.tabComponentManager = [TABComponentManager initWithView:cell
                                                             tabAnimated:collectionView.tabAnimated];
            cell.tabComponentManager.currentSection = indexPath.section;
            cell.tabComponentManager.currentRow = indexPath.row;
            cell.tabComponentManager.tabTargetClass = currentClass;
        }
        
        return cell;
    }
    return [self tab_collectionView:collectionView cellForItemAtIndexPath:indexPath];
}

- (void)tab_collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([collectionView.tabAnimated currentSectionIsAnimatingWithSection:indexPath.section]) {
        return;
    }
    [self tab_collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
}

- (void)tab_collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView.tabAnimated currentSectionIsAnimatingWithSection:indexPath.section] ||
        collectionView.tabAnimated.state == TABViewAnimationRunning) {
        return;
    }
    [self tab_collectionView:collectionView didSelectItemAtIndexPath:indexPath];
}

#pragma mark - About HeaderFooterView

- (CGSize)tab_collectionView:(UICollectionView *)collectionView
                      layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    
    if ([collectionView.tabAnimated currentSectionIsAnimatingWithSection:section]) {
        NSInteger index = [collectionView.tabAnimated headerFooterNeedAnimationOnSection:section
                                                                                    kind:UICollectionElementKindSectionHeader];
        if (index != tab_animated_error_code) {
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
    
    if ([collectionView.tabAnimated currentSectionIsAnimatingWithSection:section]) {
        NSInteger index = [collectionView.tabAnimated headerFooterNeedAnimationOnSection:section
                                                                                    kind:UICollectionElementKindSectionFooter];
        if (index != tab_animated_error_code) {
            NSValue *value = nil;
            if (index > collectionView.tabAnimated.footerSizeArray.count - 1) {
                value = collectionView.tabAnimated.footerSizeArray.lastObject;
            }else {
                value = collectionView.tabAnimated.footerSizeArray[index];
            }
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
    if ([collectionView.tabAnimated currentSectionIsAnimatingWithSection:indexPath.section]) {
        
        NSInteger index = [collectionView.tabAnimated headerFooterNeedAnimationOnSection:indexPath.section
                                                                                    kind:kind];
        
        if (index == tab_animated_error_code) {
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
            defaultPredix = tab_header_prefix;
            identifier = [NSString stringWithFormat:@"%@%@",tab_header_prefix,NSStringFromClass(resuableClass)];
        }else {
            if (index > collectionView.tabAnimated.footerClassArray.count - 1) {
                resuableClass = collectionView.tabAnimated.footerClassArray.lastObject;
            }else {
                resuableClass = collectionView.tabAnimated.footerClassArray[index];
            }
            defaultPredix = tab_footer_prefix;
            identifier = [NSString stringWithFormat:@"%@%@",tab_footer_prefix,NSStringFromClass(resuableClass)];
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
                                                              withReuseIdentifier:[NSString stringWithFormat:@"%@%@",defaultPredix,tab_default_suffix]
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
        
        if (nil == reusableView.tabComponentManager) {
            [TABManagerMethod fullData:reusableView];
            reusableView.tabComponentManager = [TABComponentManager initWithView:reusableView tabAnimated:collectionView.tabAnimated];
            reusableView.tabComponentManager.currentSection = indexPath.section;
            reusableView.tabComponentManager.tabTargetClass = resuableClass;
        }
        
        return reusableView;
        
    }
    return [self tab_collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
}

#pragma mark - Private Methods

/**
 exchange method
 
 @param oldSelector old method's sel
 @param newSelector new method's sel
 @param delegate return nil
 */
- (void)exchangeDelegateOldSel:(SEL)oldSelector
                    withNewSel:(SEL)newSelector
                  withDelegate:(id)delegate {
    
    if (![delegate respondsToSelector:oldSelector]) {
        return;
    }
    
    Method oldMethod = class_getInstanceMethod([delegate class], oldSelector);
    Method newMethod = class_getInstanceMethod([self class], newSelector);
    
    if ([self isKindOfClass:[delegate class]]) {
        tabAnimatedLog(@"注意：你采用了`self.delegate = self`,将delegate方法封装在了子类。那么，delegate方法的IMP地址为类对象所有，所以由该类创建的UITableView的代理方法的IMP地址始终唯一，本库不支持这种做法。");
    }else {
        
        // 代理对象添加newMethod，指向oldImp
        BOOL isVictory = class_addMethod([delegate class], newSelector, class_getMethodImplementation([delegate class], oldSelector), method_getTypeEncoding(oldMethod));
        if (isVictory) {
            // 添加成功后，将oldMethod指向当前类的新的
            class_replaceMethod([delegate class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
        }
    }
}

- (TABCollectionAnimated *)tabAnimated {
    return objc_getAssociatedObject(self, @selector(tabAnimated));
}

- (void)setTabAnimated:(TABCollectionAnimated *)tabAnimated {
    objc_setAssociatedObject(self, @selector(tabAnimated),tabAnimated, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
