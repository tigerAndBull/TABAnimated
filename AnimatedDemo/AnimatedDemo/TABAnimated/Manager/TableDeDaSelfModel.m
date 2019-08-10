//
//  TableDelegateSelfModel.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/8/10.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TableDeDaSelfModel.h"
#import "TABAnimated.h"

@implementation TableDeDaSelfModel

- (NSInteger)tab_deda_numberOfSectionsInTableView:(UITableView *)tableView {
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
    return [self tab_deda_numberOfSectionsInTableView:tableView];
}

- (NSInteger)tab_deda_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
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
    return [self tab_deda_tableView:tableView numberOfRowsInSection:section];
}

- (CGFloat)tab_deda_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    return [self tab_deda_tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tab_deda_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    return [self tab_deda_tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tab_deda_tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView.tabAnimated currentSectionIsAnimatingWithSection:indexPath.section]) {
        return;
    }
    [self tab_deda_tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

- (void)tab_deda_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView.tabAnimated currentSectionIsAnimatingWithSection:indexPath.section]) {
        return;
    }
    [self tab_deda_tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - About HeaderFooterView

- (CGFloat)tab_deda_tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
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
        return [self tab_deda_tableView:tableView heightForHeaderInSection:section];
    }
    return [self tab_deda_tableView:tableView heightForHeaderInSection:section];
}

- (CGFloat)tab_deda_tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
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
        return [self tab_deda_tableView:tableView heightForFooterInSection:section];
    }
    return [self tab_deda_tableView:tableView heightForFooterInSection:section];
}

- (nullable UIView *)tab_deda_tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
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
        return [self tab_deda_tableView:tableView viewForHeaderInSection:section];
    }
    return [self tab_deda_tableView:tableView viewForHeaderInSection:section];
}

- (nullable UIView *)tab_deda_tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
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
        return [self tab_deda_tableView:tableView viewForFooterInSection:section];
    }
    return [self tab_deda_tableView:tableView viewForFooterInSection:section];
}

@end
