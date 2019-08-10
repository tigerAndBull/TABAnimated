//
//  UITableView+Animated.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "UITableView+TABAnimated.h"
#import "TABViewAnimated.h"
#import "TABTableAnimated.h"
#import "EstimatedTableViewDelegate.h"
#import <objc/runtime.h>

@implementation UITableView (TABAnimated)

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

- (void)tab_setDelegate:(id<UITableViewDelegate>)delegate {
    
    if ([self isKindOfClass:[delegate class]]) {
        
        //  tabAnimatedLog(@"注意：你采用了`self.delegate = self`,将delegate方法封装在了子类。那么，delegate方法的IMP地址为类对象所有，所以由该类创建的UITableView的代理方法的IMP地址始终唯一，本库不支持这种做法。");
        
        TableDeDaSelfModel *model = [[TABAnimated sharedAnimated] getTableDeDaModelAboutDeDaSelfWithClassName:NSStringFromClass(delegate.class)];
        if (!model.isExhangeDelegate) {
            [self exchangeDelegateMethods:delegate model:model];
            model.isExhangeDelegate = YES;
        }
        
    }else {
        [self exchangeDelegateMethods:delegate model:nil];
    }

    [self tab_setDelegate:delegate];
}

- (void)tab_setDataSource:(id<UITableViewDataSource>)dataSource {
    
    if ([self isKindOfClass:[dataSource class]]) {
        TableDeDaSelfModel *model = [[TABAnimated sharedAnimated] getTableDeDaModelAboutDeDaSelfWithClassName:NSStringFromClass(dataSource.class)];
        if (!model.isExhangeDataSource) {
            [self exchangeDataSourceMethods:dataSource model:model];
#pragma clang diagnostic pop
            model.isExhangeDataSource = YES;
        }
    }else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        [self exchangeDataSourceMethods:dataSource model:nil];
#pragma clang diagnostic pop
    }
    
    [self tab_setDataSource:dataSource];
}

#pragma mark - TABTableViewDataSource

- (NSInteger)tab_numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tabAnimated.state == TABViewAnimationStart &&
        tableView.tabAnimated.animatedSectionCount != 0) {
        for (NSInteger i = 0; i < tableView.tabAnimated.animatedSectionCount; i++) {
            [tableView.tabAnimated.runAnimationSectionArray addObject:[NSNumber numberWithInteger:i]];
        }
        if (tableView.tabAnimated.headerClassArray.count > 0) {
            for (NSInteger i = 0; i < tableView.tabAnimated.animatedSectionCount; i++) {
                [tableView.tabAnimated.headerSectionArray addObject:[NSNumber numberWithInteger:i]];
            }
        }
        if (tableView.tabAnimated.footerClassArray.count > 0) {
            for (NSInteger i = 0; i < tableView.tabAnimated.animatedSectionCount; i++) {
                [tableView.tabAnimated.footerSectionArray addObject:[NSNumber numberWithInteger:i]];
            }
        }
        return tableView.tabAnimated.animatedSectionCount;
    }
    return [self tab_numberOfSectionsInTableView:tableView];
}

- (NSInteger)tab_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // If the animation running, return animatedCount.
    if ([tableView.tabAnimated currentSectionIsAnimatingWithSection:section]) {
        
        // 开发者指定section
        if (tableView.tabAnimated.animatedSectionArray.count > 0) {
            
            // 没有获取到动画时row数量
            if (tableView.tabAnimated.animatedCountArray.count == 0) {
                return 0;
            }
            
            // 匹配当前section
            for (NSNumber *num in tableView.tabAnimated.animatedSectionArray) {
                if ([num integerValue] == section) {
                    NSInteger index = [tableView.tabAnimated.animatedSectionArray indexOfObject:num];
                    if (index > tableView.tabAnimated.animatedCountArray.count - 1) {
                        return [[tableView.tabAnimated.animatedCountArray lastObject] integerValue];
                    }else {
                        return [tableView.tabAnimated.animatedCountArray[index] integerValue];
                    }
                }
                
                // 没有匹配到指定的数量
                if ([num isEqual:[tableView.tabAnimated.animatedSectionArray lastObject]]) {
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
    return [self tab_tableView:tableView numberOfRowsInSection:section];
}

- (CGFloat)tab_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView.tabAnimated currentSectionIsAnimatingWithSection:indexPath.section]) {
        
        NSInteger index = indexPath.section;
        
        // 开发者指定section
        if (tableView.tabAnimated.animatedSectionArray.count > 0) {
            
            // 匹配当前section
            for (NSNumber *num in tableView.tabAnimated.animatedSectionArray) {
                if ([num integerValue] == indexPath.section) {
                    NSInteger currentIndex = [tableView.tabAnimated.animatedSectionArray indexOfObject:num];
                    if (currentIndex > tableView.tabAnimated.cellHeightArray.count - 1) {
                        index = [tableView.tabAnimated.cellHeightArray count] - 1;
                    }else {
                        index = currentIndex;
                    }
                    break;
                }
                
                // 没有匹配到注册的cell
                if ([num isEqual:[tableView.tabAnimated.animatedSectionArray lastObject]]) {
                    return 1.;
                }
            }
        }else {
            if (indexPath.section > (tableView.tabAnimated.cellClassArray.count - 1)) {
                index = tableView.tabAnimated.cellClassArray.count - 1;
                tabAnimatedLog(@"TABAnimated提醒 - section的数量和指定分区的数量不一致，超出的section，将使用最后一个分区cell加载");
            }
        }
        
        return [tableView.tabAnimated.cellHeightArray[index] floatValue];
    }
    return [self tab_tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tab_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView.tabAnimated currentSectionIsAnimatingWithSection:indexPath.section]) {
        
        NSInteger index = indexPath.section;
        
        // 开发者指定section
        if (tableView.tabAnimated.animatedSectionArray.count > 0) {
            
            if (tableView.tabAnimated.cellClassArray.count == 0) {
                return UITableViewCell.new;
            }
            
            // 匹配当前section
            for (NSNumber *num in tableView.tabAnimated.animatedSectionArray) {
                if ([num integerValue] == indexPath.section) {
                    NSInteger currentIndex = [tableView.tabAnimated.animatedSectionArray indexOfObject:num];
                    if (currentIndex > tableView.tabAnimated.cellClassArray.count - 1) {
                        index = [tableView.tabAnimated.cellClassArray count] - 1;
                    }else {
                        index = currentIndex;
                    }
                    break;
                }
                
                if ([num isEqual:[tableView.tabAnimated.animatedSectionArray lastObject]]) {
                    return UITableViewCell.new;
                }
            }
        }else {
            if (indexPath.section > (tableView.tabAnimated.cellClassArray.count - 1)) {
                index = tableView.tabAnimated.cellClassArray.count - 1;
                tabAnimatedLog(@"TABAnimated提醒 - section的数量和指定分区的数量不一致，超出的section，将使用最后一个分区cell加载");
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
        
        if (nil == cell.tabComponentManager) {
            [TABManagerMethod fullData:cell];
            cell.tabComponentManager = [TABComponentManager initWithView:cell
                                                             tabAnimated:tableView.tabAnimated];
            cell.tabComponentManager.currentSection = indexPath.section;
            cell.tabComponentManager.currentRow = indexPath.row;
            cell.tabComponentManager.tabTargetClass = currentClass;
        }
        
        return cell;
    }
    return [self tab_tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tab_tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView.tabAnimated currentSectionIsAnimatingWithSection:indexPath.section]) {
        return;
    }
    [self tab_tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

- (void)tab_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView.tabAnimated currentSectionIsAnimatingWithSection:indexPath.section]) {
        return;
    }
    [self tab_tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - About HeaderFooterView

- (CGFloat)tab_tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([tableView.tabAnimated currentSectionIsAnimatingWithSection:section]) {
        NSInteger index = [tableView.tabAnimated headerNeedAnimationOnSection:section];
        if (index != tab_animated_error_code) {
            NSNumber *value = nil;
            if (index > tableView.tabAnimated.headerHeightArray.count - 1) {
                value = tableView.tabAnimated.headerHeightArray.lastObject;
            }else {
                value = tableView.tabAnimated.headerHeightArray[index];
            }
            return [value floatValue];
        }
        return [self tab_tableView:tableView heightForHeaderInSection:section];
    }
    return [self tab_tableView:tableView heightForHeaderInSection:section];
}

- (CGFloat)tab_tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([tableView.tabAnimated currentSectionIsAnimatingWithSection:section]) {
        NSInteger index = [tableView.tabAnimated footerNeedAnimationOnSection:section];
        if (index != tab_animated_error_code) {
            NSNumber *value = nil;
            if (index > tableView.tabAnimated.footerHeightArray.count - 1) {
                value = tableView.tabAnimated.footerHeightArray.lastObject;
            }else {
                value = tableView.tabAnimated.footerHeightArray[index];
            }
            return [value floatValue];
        }
        return [self tab_tableView:tableView heightForFooterInSection:section];
    }
    return [self tab_tableView:tableView heightForFooterInSection:section];
}

- (nullable UIView *)tab_tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([tableView.tabAnimated currentSectionIsAnimatingWithSection:section]) {
        NSInteger index = [tableView.tabAnimated headerNeedAnimationOnSection:section];
        if (index != tab_animated_error_code) {
            
            Class class;
            if (index > tableView.tabAnimated.headerClassArray.count - 1) {
                class = tableView.tabAnimated.headerClassArray.lastObject;
            }else {
                class = tableView.tabAnimated.headerClassArray[index];
            }

            UIView *headerFooterView = class.new;
            headerFooterView.tabAnimated = TABViewAnimated.new;
            [headerFooterView tab_startAnimation];
            
            if (nil == headerFooterView.tabComponentManager) {
                [TABManagerMethod fullData:headerFooterView];
                headerFooterView.tabComponentManager = [TABComponentManager initWithView:headerFooterView tabAnimated:tableView.tabAnimated];
                headerFooterView.tabComponentManager.currentSection = section;
            }
            return headerFooterView;
        }
        return [self tab_tableView:tableView viewForHeaderInSection:section];
    }
    return [self tab_tableView:tableView viewForHeaderInSection:section];
}

- (nullable UIView *)tab_tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([tableView.tabAnimated currentSectionIsAnimatingWithSection:section]) {
        NSInteger index = [tableView.tabAnimated footerNeedAnimationOnSection:section];
        if (index != tab_animated_error_code) {
            
            Class class;
            if (index > tableView.tabAnimated.footerClassArray.count - 1) {
                class = tableView.tabAnimated.footerClassArray.lastObject;
            }else {
                class = tableView.tabAnimated.footerClassArray[index];
            }
            
            UIView *headerFooterView = class.new;
            headerFooterView.tabAnimated = TABViewAnimated.new;
            [headerFooterView tab_startAnimation];
            
            if (nil == headerFooterView.tabComponentManager) {
                [TABManagerMethod fullData:headerFooterView];
                headerFooterView.tabComponentManager = [TABComponentManager initWithView:headerFooterView tabAnimated:tableView.tabAnimated];
                headerFooterView.tabComponentManager.currentSection = section;
            }
            return headerFooterView;
        }
        return [self tab_tableView:tableView viewForFooterInSection:section];
    }
    return [self tab_tableView:tableView viewForFooterInSection:section];
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
                  withDelegate:(id)delegate
                         model:(TableDeDaSelfModel *)model {
    
    if (![delegate respondsToSelector:oldSelector]) {
        return;
    }
    
    Method oldMethod = class_getInstanceMethod([delegate class], oldSelector);
    Method newMethod;
    
    if (model) {
        
        newMethod = class_getInstanceMethod(model.class, newSelector);

        if (newMethod == nil) {
            return;
        }

        BOOL isVictory = class_addMethod([delegate class], newSelector, class_getMethodImplementation([delegate class], oldSelector), method_getTypeEncoding(oldMethod));
        if (isVictory) {
            class_replaceMethod([delegate class], oldSelector, class_getMethodImplementation(model.class, newSelector), method_getTypeEncoding(newMethod));
        }
        
    }else {
        newMethod = class_getInstanceMethod([self class], newSelector);
        
        if (newMethod == nil) {
            return;
        }

        BOOL isVictory = class_addMethod([delegate class], newSelector, class_getMethodImplementation([delegate class], oldSelector), method_getTypeEncoding(oldMethod));
        if (isVictory) {
            class_replaceMethod([delegate class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
        }
    }
}

- (void)exchangeDelegateMethods:(id<UITableViewDelegate>)delegate
                          model:(TableDeDaSelfModel *)model {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    SEL oldClickDelegate = @selector(tableView:didSelectRowAtIndexPath:);
    SEL newClickDelegate;
    if (model) {
        newClickDelegate = @selector(tab_deda_tableView:didSelectRowAtIndexPath:);
    }else {
        newClickDelegate = @selector(tab_tableView:didSelectRowAtIndexPath:);
    }
    [self exchangeDelegateOldSel:oldClickDelegate withNewSel:newClickDelegate withDelegate:delegate model:model];
    
    SEL oldHeightDelegate = @selector(tableView:heightForRowAtIndexPath:);
    SEL newHeightDelegate;
    if (model) {
        newHeightDelegate = @selector(tab_deda_tableView:heightForRowAtIndexPath:);
    }else {
        newHeightDelegate = @selector(tab_tableView:heightForRowAtIndexPath:);
    }

    SEL estimatedHeightDelegateSel = @selector(tableView:estimatedHeightForRowAtIndexPath:);
    
    if ([delegate respondsToSelector:estimatedHeightDelegateSel] &&
        ![delegate respondsToSelector:oldHeightDelegate]) {
        
        EstimatedTableViewDelegate *edelegate = EstimatedTableViewDelegate.new;
        Method method = class_getClassMethod(edelegate.class, oldHeightDelegate);

        BOOL isSuccess = class_addMethod([delegate class], oldHeightDelegate, class_getMethodImplementation(edelegate.class, oldHeightDelegate), method_getTypeEncoding(method));
        if (isSuccess) {
            [self exchangeDelegateOldSel:oldHeightDelegate withNewSel:newHeightDelegate withDelegate:delegate model:model];
        }
        
    }else {
        [self exchangeDelegateOldSel:oldHeightDelegate withNewSel:newHeightDelegate withDelegate:delegate model:model];
    }
    
    SEL oldHeadViewDelegate = @selector(tableView:viewForHeaderInSection:);
    SEL newHeadViewDelegate;
    if (model) {
        newHeadViewDelegate= @selector(tab_deda_tableView:viewForHeaderInSection:);
    }else {
        newHeadViewDelegate= @selector(tab_tableView:viewForHeaderInSection:);
    }
    [self exchangeDelegateOldSel:oldHeadViewDelegate withNewSel:newHeadViewDelegate withDelegate:delegate model:model];
    
    SEL oldFooterViewDelegate = @selector(tableView:viewForFooterInSection:);
    SEL newFooterViewDelegate;
    if (model) {
        newFooterViewDelegate = @selector(tab_deda_tableView:viewForFooterInSection:);
    }else {
        newFooterViewDelegate = @selector(tab_tableView:viewForFooterInSection:);
    }
    [self exchangeDelegateOldSel:oldFooterViewDelegate withNewSel:newFooterViewDelegate withDelegate:delegate model:model];
    
    SEL oldHeadHeightDelegate = @selector(tableView:heightForHeaderInSection:);
    SEL newHeadHeightDelegate;
    if (model) {
        newHeadHeightDelegate = @selector(tab_deda_tableView:heightForHeaderInSection:);
    }else {
        newHeadHeightDelegate = @selector(tab_tableView:heightForHeaderInSection:);
    }
    [self exchangeDelegateOldSel:oldHeadHeightDelegate withNewSel:newHeadHeightDelegate withDelegate:delegate model:model];
    
    SEL oldFooterHeightDelegate = @selector(tableView:heightForFooterInSection:);
    SEL newFooterHeightDelegate;
    if (model) {
        newFooterHeightDelegate = @selector(tab_deda_tableView:heightForFooterInSection:);
    }else {
        newFooterHeightDelegate = @selector(tab_tableView:heightForFooterInSection:);
    }
    [self exchangeDelegateOldSel:oldFooterHeightDelegate withNewSel:newFooterHeightDelegate withDelegate:delegate model:model];
#pragma clang diagnostic pop
}

- (void)exchangeDataSourceMethods:(id<UITableViewDataSource>)dataSource
                            model:(TableDeDaSelfModel *)model {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    SEL oldSectionSelector = @selector(numberOfSectionsInTableView:);
    SEL newSectionSelector;
    if (model) {
        newSectionSelector = @selector(tab_deda_numberOfSectionsInTableView:);
    }else {
        newSectionSelector = @selector(tab_numberOfSectionsInTableView:);
    }
    
    SEL oldSelector = @selector(tableView:numberOfRowsInSection:);
    SEL newSelector;
    if (model) {
        newSelector = @selector(tab_deda_tableView:numberOfRowsInSection:);
    }else {
        newSelector = @selector(tab_tableView:numberOfRowsInSection:);
    }
    
    SEL oldCell = @selector(tableView:cellForRowAtIndexPath:);
    SEL newCell;
    if (model) {
        newCell = @selector(tab_deda_tableView:cellForRowAtIndexPath:);
    }else {
        newCell = @selector(tab_tableView:cellForRowAtIndexPath:);
    }
    
    SEL old = @selector(tableView:willDisplayCell:forRowAtIndexPath:);
    SEL new;
    if (model) {
        new = @selector(tab_deda_tableView:willDisplayCell:forRowAtIndexPath:);
    }else {
        new = @selector(tab_tableView:willDisplayCell:forRowAtIndexPath:);
    }
    
#pragma clang diagnostic pop
    
    [self exchangeDelegateOldSel:oldSectionSelector
                      withNewSel:newSectionSelector
                    withDelegate:dataSource
                           model:model];
    
    [self exchangeDelegateOldSel:oldSelector
                      withNewSel:newSelector
                    withDelegate:dataSource
                           model:model];
    
    [self exchangeDelegateOldSel:old
                      withNewSel:new
                    withDelegate:dataSource
                           model:model];
    
    [self exchangeDelegateOldSel:oldCell
                      withNewSel:newCell
                    withDelegate:dataSource
                           model:model];
}

- (TABTableAnimated *)tabAnimated {
    return objc_getAssociatedObject(self, @selector(tabAnimated));
}

- (void)setTabAnimated:(TABTableAnimated *)tabAnimated {
    objc_setAssociatedObject(self, @selector(tabAnimated),tabAnimated, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (self.tableHeaderView != nil && self.tableHeaderView.tabAnimated == nil) {
        self.tableHeaderView.tabAnimated = TABViewAnimated.new;
        self.tabAnimated.tabHeadViewAnimated = self.tableHeaderView.tabAnimated;
    }
    
    if (self.tableFooterView != nil && self.tableFooterView.tabAnimated == nil) {
        self.tableFooterView.tabAnimated = TABViewAnimated.new;
        self.tabAnimated.tabFooterViewAnimated = self.tableFooterView.tabAnimated;
    }
}

@end
