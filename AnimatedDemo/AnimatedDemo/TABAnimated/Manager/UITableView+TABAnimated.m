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
    
    SEL oldHeightDelegate = @selector(tableView:heightForRowAtIndexPath:);
    SEL newHeightDelegate = @selector(tab_tableView:heightForRowAtIndexPath:);
    
    SEL oldClickDelegate = @selector(tableView:didSelectRowAtIndexPath:);
    SEL newClickDelegate = @selector(tab_tableView:didSelectRowAtIndexPath:);
    
    SEL estimatedHeightDelegateSel = @selector(tableView:estimatedHeightForRowAtIndexPath:);
    
    if ([delegate respondsToSelector:estimatedHeightDelegateSel] &&
        ![delegate respondsToSelector:oldHeightDelegate]) {
        
        EstimatedTableViewDelegate *edelegate = EstimatedTableViewDelegate.new;
        
        Method method = class_getClassMethod(edelegate.class, oldHeightDelegate);
        BOOL isSuccess = class_addMethod([delegate class], oldHeightDelegate, class_getMethodImplementation(edelegate.class, oldHeightDelegate), method_getTypeEncoding(method));
        if (isSuccess) {
            [self exchangeDelegateOldSel:oldHeightDelegate withNewSel:newHeightDelegate withDelegate:delegate];
        }
        
    }else {
        [self exchangeDelegateOldSel:oldHeightDelegate withNewSel:newHeightDelegate withDelegate:delegate];
    }
    
    [self exchangeDelegateOldSel:oldClickDelegate withNewSel:newClickDelegate withDelegate:delegate];

    [self tab_setDelegate:delegate];
}

- (void)tab_setDataSource:(id<UITableViewDataSource>)dataSource {
    
    SEL oldSectionSelector = @selector(numberOfSectionsInTableView:);
    SEL newSectionSelector = @selector(tab_numberOfSectionsInTableView:);
    
    SEL oldSelector = @selector(tableView:numberOfRowsInSection:);
    SEL newSelector = @selector(tab_tableView:numberOfRowsInSection:);
    
    SEL oldCell = @selector(tableView:cellForRowAtIndexPath:);
    SEL newCell = @selector(tab_tableView:cellForRowAtIndexPath:);
    
    SEL old = @selector(tableView:willDisplayCell:forRowAtIndexPath:);
    SEL new = @selector(tab_tableView:willDisplayCell:forRowAtIndexPath:);
    
    [self exchangeDelegateOldSel:oldSectionSelector
                      withNewSel:newSectionSelector
                    withDelegate:dataSource];
    
    [self exchangeDelegateOldSel:oldSelector
                      withNewSel:newSelector
                    withDelegate:dataSource];
    
    [self exchangeDelegateOldSel:old
                      withNewSel:new
                    withDelegate:dataSource];
    
    [self exchangeDelegateOldSel:oldCell
                      withNewSel:newCell
                    withDelegate:dataSource];
    
    [self tab_setDataSource:dataSource];
}

#pragma mark - TABTableViewDataSource

- (NSInteger)tab_numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tabAnimated.state == TABViewAnimationStart &&
        tableView.tabAnimated.animatedSectionCount != 0) {
        for (NSInteger i = 0; i < tableView.tabAnimated.animatedSectionCount; i++) {
            [tableView.tabAnimated.runAnimationSectionArray addObject:[NSNumber numberWithInteger:i]];
        }
        return tableView.tabAnimated.animatedSectionCount;
    }
    return [self tab_numberOfSectionsInTableView:tableView];
}

- (NSInteger)tab_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // If the animation running, return animatedCount.
    if ([tableView.tabAnimated currentSectionIsAnimating:tableView
                                                 section:section]) {
        
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
    
    if ([tableView.tabAnimated currentSectionIsAnimating:tableView
                                                 section:indexPath.section]) {
        
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
    
    if ([tableView.tabAnimated currentSectionIsAnimating:tableView
                                                 section:indexPath.section]) {
        
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
        
        NSString *className = NSStringFromClass(tableView.tabAnimated.cellClassArray[index]);
        if ([className containsString:@"."]) {
            NSRange range = [className rangeOfString:@"."];
            className = [className substringFromIndex:range.location+1];
        }
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"tab_%@",className] forIndexPath:indexPath];
        
        NSString *nibPath = [[NSBundle mainBundle] pathForResource:className ofType:@"nib"];
        if (nibPath != nil && nibPath.length > 0) {
            NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:className owner:self options:nil];
            if (cellArray.count <= 0) {
                NSAssert(NO, @"No xib file of the cell name.");
            }
            cell = [cellArray objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (nil == cell.tabComponentManager) {
            [TABManagerMethod fullData:cell];
            cell.tabComponentManager = [TABComponentManager initWithView:cell];
            
            CGFloat height = 0.;
            if (index > tableView.tabAnimated.cellHeightArray.count - 1) {
                height = [[tableView.tabAnimated.cellHeightArray lastObject] floatValue];
            }else {
                height = [tableView.tabAnimated.cellHeightArray[index] floatValue];
            }
            
            cell.tabComponentManager.currentSection = indexPath.section;
            cell.tabComponentManager.tabLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height);
            cell.tabComponentManager.animatedHeight = tableView.tabAnimated.animatedHeight;
            cell.tabComponentManager.animatedCornerRadius = tableView.tabAnimated.animatedCornerRadius;
            cell.tabComponentManager.cancelGlobalCornerRadius = tableView.tabAnimated.cancelGlobalCornerRadius;
            if (tableView.tabAnimated.animatedBackViewCornerRadius > 0) {
                cell.tabComponentManager.tabLayer.cornerRadius = tableView.tabAnimated.animatedBackViewCornerRadius;
            }
            cell.tabComponentManager.animatedBackgroundColor = tableView.tabAnimated.animatedBackgroundColor;
            cell.tabComponentManager.animatedColor = tableView.tabAnimated.animatedColor;
        }
        
        return cell;
    }
    return [self tab_tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (nullable UIView *)tab_tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([tableView.tabAnimated currentSectionIsAnimating:tableView
                                                 section:section]) {
//        UIView *view = 
    }
    return [self tab_tableView:tableView viewForHeaderInSection:section];
}

- (nullable UIView *)tab_tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([tableView.tabAnimated currentSectionIsAnimating:tableView
                                                 section:section]) {
        
    }
    return [self tab_tableView:tableView viewForFooterInSection:section];
}

- (void)tab_tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView.tabAnimated currentSectionIsAnimating:tableView
                                                 section:indexPath.section]) {
        return;
    }
    [self tab_tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

- (void)tab_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView.tabAnimated currentSectionIsAnimating:tableView
                                                 section:indexPath.section] ||
        tableView.tabAnimated.state == TABViewAnimationRunning) {
        return;
    }
    [self tab_tableView:tableView didSelectRowAtIndexPath:indexPath];
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
