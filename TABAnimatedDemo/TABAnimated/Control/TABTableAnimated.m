//
//  TABTableAnimated.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/4/27.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABTableAnimated.h"

#import "TABViewAnimated.h"
#import "UIView+TABControlModel.h"
#import "UIView+TABControlAnimation.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface EstimatedTableViewDelegate : NSObject
@end
@implementation EstimatedTableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return UITableViewAutomaticDimension;
}
    
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return UITableViewAutomaticDimension;
}

@end

@interface TABTableAnimated()

@property (nonatomic, strong, readwrite) NSMutableArray <NSNumber *> *headerHeightArray;
@property (nonatomic, strong, readwrite) NSMutableArray <NSNumber *> *footerHeightArray;

@end

@implementation TABTableAnimated

#pragma mark - Section Mode

+ (instancetype)animatedWithCellClass:(Class)cellClass
                           cellHeight:(CGFloat)cellHeight {
    TABTableAnimated *obj = [self _animatedWithCellClass:cellClass cellHeight:cellHeight animatedCount:ceilf([UIScreen mainScreen].bounds.size.height/cellHeight*1.0) toIndex:0 runMode:TABAnimatedRunBySection];
    return obj;
}

+ (instancetype)animatedWithCellClass:(Class)cellClass
                           cellHeight:(CGFloat)cellHeight
                        animatedCount:(NSInteger)animatedCount {
    TABTableAnimated *obj = [self _animatedWithCellClass:cellClass cellHeight:cellHeight animatedCount:animatedCount toIndex:0 runMode:TABAnimatedRunBySection];
    return obj;
}

+ (instancetype)animatedWithCellClass:(Class)cellClass
                           cellHeight:(CGFloat)cellHeight
                            toSection:(NSInteger)section {
    TABTableAnimated *obj = [self _animatedWithCellClass:cellClass cellHeight:cellHeight animatedCount:ceilf([UIScreen mainScreen].bounds.size.height/cellHeight*1.0) toIndex:section runMode:TABAnimatedRunByPartSection];
    return obj;
}

+ (instancetype)animatedWithCellClass:(Class)cellClass
                           cellHeight:(CGFloat)cellHeight
                        animatedCount:(NSInteger)animatedCount
                            toSection:(NSInteger)section {
    TABTableAnimated *obj = [self _animatedWithCellClass:cellClass cellHeight:cellHeight animatedCount:animatedCount toIndex:section runMode:TABAnimatedRunByPartSection];
    return obj;
}

+ (instancetype)animatedWithCellClassArray:(NSArray <Class> *)cellClassArray
                           cellHeightArray:(NSArray <NSNumber *> *)cellHeightArray
                        animatedCountArray:(NSArray <NSNumber *> *)animatedCountArray {
    TABTableAnimated *obj = [TABTableAnimated _animatedWithCellClassArray:cellClassArray
                                                          cellHeightArray:cellHeightArray
                                                       animatedCountArray:animatedCountArray
                                                               indexArray:nil
                                                                  runMode:TABAnimatedRunBySection];
    return obj;
}

+ (instancetype)animatedWithCellClassArray:(NSArray <Class> *)cellClassArray
                           cellHeightArray:(NSArray <NSNumber *> *)cellHeightArray
                        animatedCountArray:(NSArray <NSNumber *> *)animatedCountArray
                      animatedSectionArray:(NSArray <NSNumber *> *)animatedSectionArray {
    TABTableAnimated *obj = [TABTableAnimated _animatedWithCellClassArray:cellClassArray
                                                          cellHeightArray:cellHeightArray
                                                       animatedCountArray:animatedCountArray
                                                               indexArray:animatedSectionArray
                                                                  runMode:TABAnimatedRunByPartSection];
    return obj;
}

#pragma mark - Row Mode

+ (instancetype)animatedInRowModeWithCellClassArray:(NSArray <Class> *)cellClassArray
                                    cellHeightArray:(NSArray <NSNumber *> *)cellHeightArray {
    TABTableAnimated *obj = [TABTableAnimated _animatedWithCellClassArray:cellClassArray
                                                          cellHeightArray:cellHeightArray
                                                       animatedCountArray:nil
                                                               indexArray:nil
                                                                  runMode:TABAnimatedRunByRow];
    return obj;
}

+ (instancetype)animatedInRowModeWithCellClassArray:(NSArray <Class> *)cellClassArray
                                    cellHeightArray:(NSArray <NSNumber *> *)cellHeightArray
                                           rowArray:(NSArray <NSNumber *> *)rowArray {
    TABTableAnimated *obj = [TABTableAnimated _animatedWithCellClassArray:cellClassArray
                                                          cellHeightArray:cellHeightArray
                                                       animatedCountArray:nil
                                                               indexArray:rowArray
                                                                  runMode:TABAnimatedRunByRow];
    return obj;
}

+ (instancetype)animatedInRowModeWithCellClass:(Class)cellClass
                                    cellHeight:(CGFloat)cellHeight
                                         toRow:(NSInteger)row {
    TABTableAnimated *obj = [self _animatedWithCellClass:cellClass cellHeight:cellHeight animatedCount:1 toIndex:row runMode:TABAnimatedRunByRow];
    return obj;
}

#pragma mark - 自适应高度

+ (instancetype)animatedWithCellClass:(Class)cellClass {
    TABTableAnimated *obj = [[TABTableAnimated alloc] init];
    obj.cellClassArray = @[cellClass];
    obj.cellIndexArray = @[@(0)].mutableCopy;
    obj.cellCountArray = @[@(10)];
    return obj;
}

#pragma mark -

+ (instancetype)_animatedWithCellClass:(Class)cellClass
                            cellHeight:(CGFloat)cellHeight
                         animatedCount:(NSInteger)animatedCount
                               toIndex:(NSInteger)toIndex
                               runMode:(TABAnimatedRunMode)runMode {
    TABTableAnimated *obj = [[TABTableAnimated alloc] init];
    obj.runMode = runMode;
    obj.cellClassArray = @[cellClass];
    obj.cellHeightArray = @[@(cellHeight)];
    obj.cellCountArray = @[@(animatedCount)];
    obj.cellIndexArray = @[@(0)];
    [obj.runIndexDict setValue:@(0) forKey:[NSString stringWithFormat:@"%ld",(long)toIndex]];
    return obj;
}

+ (instancetype)_animatedWithCellClassArray:(NSArray <Class> *)cellClassArray
                            cellHeightArray:(NSArray <NSNumber *> *)cellHeightArray
                         animatedCountArray:(NSArray <NSNumber *> *)animatedCountArray
                                 indexArray:(NSArray <NSNumber *> *)indexArray
                                    runMode:(TABAnimatedRunMode)runMode {
    TABTableAnimated *obj = [[TABTableAnimated alloc] init];
    obj.runMode = runMode;
    obj.cellClassArray = cellClassArray;
    obj.cellHeightArray = cellHeightArray;
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
        _headerHeightArray = @[].mutableCopy;
        _footerHeightArray = @[].mutableCopy;
        _showTableHeaderView = YES;
        _showTableFooterView = YES;
    }
    return self;
}

- (CGFloat)cellHeight {
    return (self.cellHeightArray.count == 1) ? [self.cellHeightArray[0] floatValue] : 44;
}

#pragma mark - Public Method

- (void)addHeaderViewClass:(__nonnull Class)headerViewClass
                viewHeight:(CGFloat)viewHeight {
    for (NSInteger i = 0; i < self.animatedSectionCount; i++) {
        [self addHeaderViewClass:headerViewClass viewHeight:viewHeight toSection:i];
    }
}

- (void)addHeaderViewClass:(__nonnull Class)headerViewClass
                viewHeight:(CGFloat)viewHeight
                 toSection:(NSInteger)section {
    [self.headerClassArray addObject:headerViewClass];
    [self.headerHeightArray addObject:@(viewHeight)];
    [self.runHeaderIndexDict setValue:@(self.headerClassArray.count-1) forKey:[self getStringWIthIndex:section]];
}

- (void)addFooterViewClass:(__nonnull Class)footerViewClass
                viewHeight:(CGFloat)viewHeight {
    for (NSInteger i = 0; i < self.animatedSectionCount; i++) {
        [self addFooterViewClass:footerViewClass viewHeight:viewHeight toSection:i];
    }
}

- (void)addFooterViewClass:(__nonnull Class)footerViewClass
                viewHeight:(CGFloat)viewHeight
                 toSection:(NSInteger)section {
    [self.footerClassArray addObject:footerViewClass];
    [self.footerHeightArray addObject:@(viewHeight)];
    [self.runFooterIndexDict setValue:@(self.footerClassArray.count-1) forKey:[self getStringWIthIndex:section]];
}

#pragma mark -

- (void)refreshWithIndex:(NSInteger)index controlView:(UIView *)controlView {
    
    UITableView *tableView = (UITableView *)controlView;
    
    if (tableView.estimatedRowHeight > 0) {
        self.oldEstimatedRowHeight = tableView.estimatedRowHeight;
        tableView.estimatedRowHeight = UITableViewAutomaticDimension;
        if (self.animatedCount == 0) {
            self.animatedCount = ceilf([UIScreen mainScreen].bounds.size.height/self.cellHeight*1.0);
        }
        tableView.rowHeight = self.cellHeight;
    }
    
    if (self.showTableHeaderView) {
        if (tableView.tableHeaderView.tabAnimated == nil) {
            if (tableView.tabAnimated.tabHeadViewAnimated) {
                tableView.tableHeaderView.tabAnimated = tableView.tabAnimated.tabHeadViewAnimated;
            }else {
                tableView.tableHeaderView.tabAnimated = TABViewAnimated.new;
            }
        }
        TABViewSuperAnimationType superAnimationType = tableView.tableHeaderView.tabAnimated.superAnimationType;
        if (superAnimationType == TABViewSuperAnimationTypeDefault) {
            tableView.tableHeaderView.tabAnimated.superAnimationType = superAnimationType;
        }
        tableView.tableHeaderView.tabAnimated.canLoadAgain = tableView.tabAnimated.canLoadAgain;
        [tableView.tableHeaderView tab_startAnimation];
    }
    
    if (self.showTableFooterView) {
        if (tableView.tableFooterView.tabAnimated == nil) {
            if (tableView.tabAnimated.tabFooterViewAnimated) {
                tableView.tableFooterView.tabAnimated = tableView.tabAnimated.tabFooterViewAnimated;
            }else {
                tableView.tableFooterView.tabAnimated = TABViewAnimated.new;
            }
        }
        TABViewSuperAnimationType superAnimationType = tableView.tableFooterView.tabAnimated.superAnimationType;
        if (superAnimationType == TABViewSuperAnimationTypeDefault) {
            tableView.tableFooterView.tabAnimated.superAnimationType = superAnimationType;
        }
        tableView.tableFooterView.tabAnimated.canLoadAgain = tableView.tabAnimated.canLoadAgain;
        [tableView.tableFooterView tab_startAnimation];
    }

    if (index == TABAnimatedIndexTag) {
        [tableView reloadData];
    }else if (self.runMode == TABAnimatedRunBySection || self.runMode == TABAnimatedRunByPartSection) {
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
    }else if (self.runMode == TABAnimatedRunByRow) {
        [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)rebindDelegate:(UIView *)target {
    if (self.isRebindDelegateIMP) return;
    id <UITableViewDelegate> delegate = ((UITableView *)target).delegate;
    self.oldDelegate = delegate;
    [self updateScrollViewDelegateMethods:delegate target:target];
    [self updateDelegateMethods:delegate target:target];
    self.isRebindDelegateIMP = YES;
}

- (void)rebindDataSource:(UIView *)target {
    if(self.isRebindDataSourceIMP) return;
    id <UITableViewDataSource> dataSource = ((UITableView *)target).dataSource;
    self.oldDataSource = dataSource;
    [self updateDataSourceMethods:dataSource target:target];
    self.isRebindDataSourceIMP = YES;
}

- (void)registerViewToReuse:(UIView *)view {
    UITableView *tableView = (UITableView *)view;
    [self _registerViewToReuse:tableView classArray:tableView.tabAnimated.cellClassArray containClass:UITableViewCell.class isHeaderFooter:NO];
    [self _registerViewToReuse:tableView classArray:tableView.tabAnimated.headerClassArray containClass:UITableViewHeaderFooterView.class isHeaderFooter:YES];
    [self _registerViewToReuse:tableView classArray:tableView.tabAnimated.footerClassArray containClass:UITableViewHeaderFooterView.class isHeaderFooter:YES];
}

- (void)_registerViewToReuse:(UITableView *)tableView classArray:(NSArray *)classArray containClass:(Class)containClass isHeaderFooter:(BOOL)isHeaderFooter {
    for (Class class in classArray) {
        
        if (class == [NSNull class]) continue;
        
        NSString *classString = tab_NSStringFromClass(class);
        NSString *nibPath = [TABXibBundleWithClass(class) pathForResource:classString ofType:@"nib"];
        
        if (isHeaderFooter) {
            if (nil != nibPath && nibPath.length > 0) {
                [tableView registerNib:[UINib nibWithNibName:classString bundle:TABXibBundleWithClass(class)] forHeaderFooterViewReuseIdentifier:[NSString stringWithFormat:@"tab_%@",classString]];
            }else {
                [tableView registerClass:class forHeaderFooterViewReuseIdentifier:[NSString stringWithFormat:@"tab_%@",classString]];
            }
            [tableView registerClass:containClass forHeaderFooterViewReuseIdentifier:[NSString stringWithFormat:@"tab_contain_%@",classString]];
        }else {
            NSString *nibPath = [TABXibBundleWithClass(class) pathForResource:classString ofType:@"nib"];
            if (nil != nibPath && nibPath.length > 0) {
                [tableView registerNib:[UINib nibWithNibName:classString bundle:TABXibBundleWithClass(class)] forCellReuseIdentifier:[NSString stringWithFormat:@"tab_%@",classString]];
            }else {
                [tableView registerClass:class forCellReuseIdentifier:[NSString stringWithFormat:@"tab_%@",classString]];
            }
             [tableView registerClass:containClass forCellReuseIdentifier:[NSString stringWithFormat:@"tab_contain_%@",classString]];
        }
    }
}

#pragma mark - Private

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

- (void)updateDelegateMethods:(id<UITableViewDelegate>)delegate target:(id)target {
    
    SEL oldClickDelegate = @selector(tableView:didSelectRowAtIndexPath:);
    SEL newClickDelegate = @selector(tab_tableView:didSelectRowAtIndexPath:);
    if ([delegate respondsToSelector:oldClickDelegate]) {
        [self addNewMethodWithSel:oldClickDelegate newSel:newClickDelegate];
    }
    
    SEL oldHeightDelegate = @selector(tableView:heightForRowAtIndexPath:);
    SEL newHeightDelegate = @selector(tab_tableView:heightForRowAtIndexPath:);
    SEL estimatedHeightDelegateSel = @selector(tableView:estimatedHeightForRowAtIndexPath:);
    if ([delegate respondsToSelector:estimatedHeightDelegateSel] &&
        ![delegate respondsToSelector:oldHeightDelegate]) {
        EstimatedTableViewDelegate *edelegate = EstimatedTableViewDelegate.new;
        Method method = class_getInstanceMethod([edelegate class], oldHeightDelegate);
        BOOL isVictory = class_addMethod([delegate class], oldHeightDelegate, class_getMethodImplementation([edelegate class], oldHeightDelegate), method_getTypeEncoding(method));
        if (isVictory) {
            if ([delegate respondsToSelector:oldHeightDelegate]) {
                [self addNewMethodWithSel:oldHeightDelegate newSel:newHeightDelegate];
            }
        }
    }else {
        if ([delegate respondsToSelector:oldHeightDelegate]) {
            [self addNewMethodWithSel:oldHeightDelegate newSel:newHeightDelegate];
        }
    }
    
    SEL oldHeaderHeightDelegate = @selector(tableView:heightForHeaderInSection:);
    SEL newHeaderHeightDelegate = @selector(tab_tableView:heightForHeaderInSection:);
    SEL estimatedHeaderHeightDelegateSel = @selector(tableView:estimatedHeightForHeaderInSection:);
    if ([delegate respondsToSelector:estimatedHeaderHeightDelegateSel] &&
        ![delegate respondsToSelector:oldHeaderHeightDelegate]) {
        EstimatedTableViewDelegate *edelegate = EstimatedTableViewDelegate.new;
        Method method = class_getInstanceMethod([edelegate class], oldHeaderHeightDelegate);
        BOOL isVictory = class_addMethod([delegate class], oldHeaderHeightDelegate, class_getMethodImplementation([edelegate class], oldHeaderHeightDelegate), method_getTypeEncoding(method));
        if (isVictory) {
            if ([delegate respondsToSelector:oldHeaderHeightDelegate]) {
                [self addNewMethodWithSel:oldHeaderHeightDelegate newSel:newHeaderHeightDelegate];
            }
        }
    }else {
        if ([delegate respondsToSelector:oldHeaderHeightDelegate]) {
            [self addNewMethodWithSel:oldHeaderHeightDelegate newSel:newHeaderHeightDelegate];
        }
    }
    
    SEL oldFooterHeightDelegate = @selector(tableView:heightForFooterInSection:);
    SEL newFooterHeightDelegate = @selector(tab_tableView:heightForFooterInSection:);
    SEL estimatedFooterHeightDelegateSel = @selector(tableView:estimatedHeightForFooterInSection:);
    if ([delegate respondsToSelector:estimatedFooterHeightDelegateSel] &&
        ![delegate respondsToSelector:oldFooterHeightDelegate]) {
        EstimatedTableViewDelegate *edelegate = EstimatedTableViewDelegate.new;
        Method method = class_getInstanceMethod([edelegate class], oldFooterHeightDelegate);
        BOOL isVictory = class_addMethod([delegate class], oldFooterHeightDelegate, class_getMethodImplementation([edelegate class], oldFooterHeightDelegate), method_getTypeEncoding(method));
        if (isVictory) {
            if ([delegate respondsToSelector:oldFooterHeightDelegate]) {
                [self addNewMethodWithSel:oldFooterHeightDelegate newSel:newFooterHeightDelegate];
            }
        }
    }else {
        if ([delegate respondsToSelector:oldFooterHeightDelegate]) {
            [self addNewMethodWithSel:oldFooterHeightDelegate newSel:newFooterHeightDelegate];
        }
    }
    
    
    SEL oldHeadViewDelegate = @selector(tableView:viewForHeaderInSection:);
    SEL newHeadViewDelegate = @selector(tab_tableView:viewForHeaderInSection:);
    if ([delegate respondsToSelector:oldHeadViewDelegate]) {
        [self addNewMethodWithSel:oldHeadViewDelegate newSel:newHeadViewDelegate];
    }
    
    SEL oldFooterViewDelegate = @selector(tableView:viewForFooterInSection:);
    SEL newFooterViewDelegate = @selector(tab_tableView:viewForFooterInSection:);
    if ([delegate respondsToSelector:oldFooterViewDelegate]) {
        [self addNewMethodWithSel:oldFooterViewDelegate newSel:newFooterViewDelegate];
    }

    // Extra Delegate
    
    SEL oldWillDisplayCell = @selector(tableView:willDisplayCell:forRowAtIndexPath:);
    SEL newWillDisplayCell = @selector(tab_tableView:willDisplayCell:forRowAtIndexPath:);
    if ([delegate respondsToSelector:oldWillDisplayCell]) {
        [self addNewMethodWithSel:oldWillDisplayCell newSel:newWillDisplayCell];
    }
    
    SEL oldWillDisplayHeader = @selector(tableView:willDisplayHeaderView:forSection:);
    SEL newWillDisplayHeader = @selector(tab_tableView:willDisplayHeaderView:forSection:);
    if ([delegate respondsToSelector:oldWillDisplayHeader]) {
        [self addNewMethodWithSel:oldWillDisplayHeader newSel:newWillDisplayHeader];
    }
    
    SEL oldWillDisplayFooter = @selector(tableView:willDisplayFooterView:forSection:);
    SEL newWillDisplayFooter = @selector(tab_tableView:willDisplayFooterView:forSection:);
    if ([delegate respondsToSelector:oldWillDisplayFooter]) {
        [self addNewMethodWithSel:oldWillDisplayFooter newSel:newWillDisplayFooter];
    }
    
    SEL oldDidEndDisplayingCell = @selector(tableView:didEndDisplayingCell:forRowAtIndexPath:);
    SEL newDidEndDisplayingCell = @selector(tab_tableView:didEndDisplayingCell:forRowAtIndexPath:);
    if ([delegate respondsToSelector:oldDidEndDisplayingCell]) {
        [self addNewMethodWithSel:oldDidEndDisplayingCell newSel:newDidEndDisplayingCell];
    }
    
    SEL oldDidEndDisplayingHeader = @selector(tableView:didEndDisplayingHeaderView:forSection:);
    SEL newDidEndDisplayingHeader = @selector(tab_tableView:didEndDisplayingHeaderView:forSection:);
    if ([delegate respondsToSelector:oldDidEndDisplayingHeader]) {
        [self addNewMethodWithSel:oldDidEndDisplayingHeader newSel:newDidEndDisplayingHeader];
    }
    
    SEL oldDidEndDisplayingFooter = @selector(tableView:didEndDisplayingFooterView:forSection:);
    SEL newDidEndDisplayingFooter = @selector(tab_tableView:didEndDisplayingFooterView:forSection:);
    if ([delegate respondsToSelector:oldDidEndDisplayingFooter]) {
        [self addNewMethodWithSel:oldDidEndDisplayingFooter newSel:newDidEndDisplayingFooter];
    }
    
    SEL oldAccessoryTypeForRow = @selector(tableView:accessoryTypeForRowWithIndexPath:);
    SEL newAccessoryTypeForRow = @selector(tab_tableView:accessoryTypeForRowWithIndexPath:);
    if ([delegate respondsToSelector:oldAccessoryTypeForRow]) {
        [self addNewMethodWithSel:oldAccessoryTypeForRow newSel:newAccessoryTypeForRow];
    }
    
    SEL oldAccessoryButtonTapped = @selector(tableView:accessoryButtonTappedForRowWithIndexPath:);
    SEL newAccessoryButtonTapped = @selector(tab_tableView:accessoryButtonTappedForRowWithIndexPath:);
    if ([delegate respondsToSelector:oldAccessoryButtonTapped]) {
        [self addNewMethodWithSel:oldAccessoryButtonTapped newSel:newAccessoryButtonTapped];
    }
    
    SEL oldShouldHighlightRow = @selector(tableView:shouldHighlightRowAtIndexPath:);
    SEL newShouldHighlightRow = @selector(tab_tableView:shouldHighlightRowAtIndexPath:);
    if ([delegate respondsToSelector:oldShouldHighlightRow]) {
        [self addNewMethodWithSel:oldShouldHighlightRow newSel:newShouldHighlightRow];
    }
    
    SEL oldDidHighlightRow = @selector(tableView:didHighlightRowAtIndexPath:);
    SEL newDidHighlightRow = @selector(tab_tableView:didHighlightRowAtIndexPath:);
    if ([delegate respondsToSelector:oldDidHighlightRow]) {
        [self addNewMethodWithSel:oldDidHighlightRow newSel:newDidHighlightRow];
    }
    
    SEL oldDidUnhighlightRow = @selector(tableView:didUnhighlightRowAtIndexPath:);
    SEL newDidUnhighlightRow = @selector(tab_tableView:didUnhighlightRowAtIndexPath:);
    if ([delegate respondsToSelector:oldDidUnhighlightRow]) {
        [self addNewMethodWithSel:oldDidUnhighlightRow newSel:newDidUnhighlightRow];
    }
    
    SEL oldWillSelectRow = @selector(tableView:willSelectRowAtIndexPath:);
    SEL newWillSelectRow = @selector(tab_tableView:willSelectRowAtIndexPath:);
    if ([delegate respondsToSelector:oldWillSelectRow]) {
        [self addNewMethodWithSel:oldWillSelectRow newSel:newWillSelectRow];
    }
    
    SEL oldWillDeselectRow = @selector(tableView:willDeselectRowAtIndexPath:);
    SEL newWillDeselectRow = @selector(tab_tableView:willDeselectRowAtIndexPath:);
    if ([delegate respondsToSelector:oldWillDeselectRow]) {
        [self addNewMethodWithSel:oldWillDeselectRow newSel:newWillDeselectRow];
    }
    
    SEL oldDidDeselectRow = @selector(tableView:didDeselectRowAtIndexPath:);
    SEL newDidDeselectRow = @selector(tab_tableView:didDeselectRowAtIndexPath:);
    if ([delegate respondsToSelector:oldDidDeselectRow]) {
        [self addNewMethodWithSel:oldDidDeselectRow newSel:newDidDeselectRow];
    }
    
    SEL oldEditingStyleForRow = @selector(tableView:editingStyleForRowAtIndexPath:);
    SEL newEditingStyleForRow = @selector(tab_tableView:editingStyleForRowAtIndexPath:);
    if ([delegate respondsToSelector:oldEditingStyleForRow]) {
        [self addNewMethodWithSel:oldEditingStyleForRow newSel:newEditingStyleForRow];
    }
    
    SEL oldTitleForDelete = @selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:);
    SEL newTitleForDelete = @selector(tab_tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:);
    if ([delegate respondsToSelector:oldTitleForDelete]) {
        [self addNewMethodWithSel:oldTitleForDelete newSel:newTitleForDelete];
    }
    
    SEL oldEditActionsForRow = @selector(tableView:editActionsForRowAtIndexPath:);
    SEL newEditActionsForRow = @selector(tab_tableView:editActionsForRowAtIndexPath:);
    if ([delegate respondsToSelector:oldEditActionsForRow]) {
        [self addNewMethodWithSel:oldEditActionsForRow newSel:newEditActionsForRow];
    }
    
    SEL oldLeadingSwipeActions = @selector(tableView:leadingSwipeActionsConfigurationForRowAtIndexPath:);
    SEL newLeadingSwipeActions = @selector(tab_tableView:leadingSwipeActionsConfigurationForRowAtIndexPath:);
    if ([delegate respondsToSelector:oldLeadingSwipeActions]) {
        [self addNewMethodWithSel:oldLeadingSwipeActions newSel:newLeadingSwipeActions];
    }
    
    SEL oldTrailingSwipeActions = @selector(tableView:trailingSwipeActionsConfigurationForRowAtIndexPath:);
    SEL newTrailingSwipeActions = @selector(tab_tableView:trailingSwipeActionsConfigurationForRowAtIndexPath:);
    if ([delegate respondsToSelector:oldTrailingSwipeActions]) {
        [self addNewMethodWithSel:oldTrailingSwipeActions newSel:newTrailingSwipeActions];
    }
    
    SEL oldShouldIndentWhileEditing = @selector(tableView:shouldIndentWhileEditingRowAtIndexPath:);
    SEL newShouldIndentWhileEditing = @selector(tab_tableView:shouldIndentWhileEditingRowAtIndexPath:);
    if ([delegate respondsToSelector:oldShouldIndentWhileEditing]) {
        [self addNewMethodWithSel:oldShouldIndentWhileEditing newSel:newShouldIndentWhileEditing];
    }
    
    SEL oldWillBeginEditingRow = @selector(tableView:willBeginEditingRowAtIndexPath:);
    SEL newWillBeginEditingRow = @selector(tab_tableView:willBeginEditingRowAtIndexPath:);
    if ([delegate respondsToSelector:oldWillBeginEditingRow]) {
        [self addNewMethodWithSel:oldWillBeginEditingRow newSel:newWillBeginEditingRow];
    }
    
    SEL oldDidEndEditingRow = @selector(tableView:didEndEditingRowAtIndexPath:);
    SEL newDidEndEditingRow = @selector(tab_tableView:didEndEditingRowAtIndexPath:);
    if ([delegate respondsToSelector:oldDidEndEditingRow]) {
        [self addNewMethodWithSel:oldDidEndEditingRow newSel:newDidEndEditingRow];
    }
    
    SEL oldTargetIndexPathForMove = @selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:);
    SEL newTargetIndexPathForMove = @selector(tab_tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:);
    if ([delegate respondsToSelector:oldTargetIndexPathForMove]) {
        [self addNewMethodWithSel:oldTargetIndexPathForMove newSel:newTargetIndexPathForMove];
    }
    
    SEL oldIndentationLevelForRow = @selector(tableView:indentationLevelForRowAtIndexPath:);
    SEL newIndentationLevelForRow = @selector(tab_tableView:indentationLevelForRowAtIndexPath:);
    if ([delegate respondsToSelector:oldIndentationLevelForRow]) {
        [self addNewMethodWithSel:oldIndentationLevelForRow newSel:newIndentationLevelForRow];
    }
    
    SEL oldShouldShowMenuForRow = @selector(tableView:shouldShowMenuForRowAtIndexPath:);
    SEL newShouldShowMenuForRow = @selector(tab_tableView:shouldShowMenuForRowAtIndexPath:);
    if ([delegate respondsToSelector:oldShouldShowMenuForRow]) {
        [self addNewMethodWithSel:oldShouldShowMenuForRow newSel:newShouldShowMenuForRow];
    }
    
    SEL oldCanPerformAction = @selector(tableView:canPerformAction:forRowAtIndexPath:withSender:);
    SEL newCanPerformAction = @selector(tab_tableView:canPerformAction:forRowAtIndexPath:withSender:);
    if ([delegate respondsToSelector:oldCanPerformAction]) {
        [self addNewMethodWithSel:oldCanPerformAction newSel:newCanPerformAction];
    }
    
    SEL oldPerformAction = @selector(tableView:performAction:forRowAtIndexPath:withSender:);
    SEL newPerformAction = @selector(tab_tableView:performAction:forRowAtIndexPath:withSender:);
    if ([delegate respondsToSelector:oldPerformAction]) {
        [self addNewMethodWithSel:oldPerformAction newSel:newPerformAction];
    }
    
    SEL oldCanFocusRow = @selector(tableView:canFocusRowAtIndexPath:);
    SEL newCanFocusRow = @selector(tab_tableView:canFocusRowAtIndexPath:);
    if ([delegate respondsToSelector:oldCanFocusRow]) {
        [self addNewMethodWithSel:oldCanFocusRow newSel:newCanFocusRow];
    }
    
    SEL oldShouldUpdateFocus = @selector(tableView:shouldUpdateFocusInContext:);
    SEL newShouldUpdateFocus = @selector(tab_tableView:shouldUpdateFocusInContext:);
    if ([delegate respondsToSelector:oldShouldUpdateFocus]) {
        [self addNewMethodWithSel:oldShouldUpdateFocus newSel:newShouldUpdateFocus];
    }
    
    SEL oldDidUpdateFocus = @selector(tableView:didUpdateFocusInContext:withAnimationCoordinator:);
    SEL newDidUpdateFocus = @selector(tab_tableView:didUpdateFocusInContext:withAnimationCoordinator:);
    if ([delegate respondsToSelector:oldDidUpdateFocus]) {
        [self addNewMethodWithSel:oldDidUpdateFocus newSel:newDidUpdateFocus];
    }
    
    SEL oldPreferredFocusedView = @selector(indexPathForPreferredFocusedViewInTableView:);
    SEL newPreferredFocusedView = @selector(tab_indexPathForPreferredFocusedViewInTableView:);
    if ([delegate respondsToSelector:oldPreferredFocusedView]) {
        [self addNewMethodWithSel:oldPreferredFocusedView newSel:newPreferredFocusedView];
    }
    
    SEL oldShouldSpringLoadRow = @selector(tableView:shouldSpringLoadRowAtIndexPath:withContext:);
    SEL newShouldSpringLoadRow = @selector(tab_tableView:shouldSpringLoadRowAtIndexPath:withContext:);
    if ([delegate respondsToSelector:oldShouldSpringLoadRow]) {
        [self addNewMethodWithSel:oldShouldSpringLoadRow newSel:newShouldSpringLoadRow];
    }
    
    SEL oldShouldBeginMultipleSelection = @selector(tableView:shouldBeginMultipleSelectionInteractionAtIndexPath:);
    SEL newShouldBeginMultipleSelection = @selector(tab_tableView:shouldBeginMultipleSelectionInteractionAtIndexPath:);
    if ([delegate respondsToSelector:oldShouldBeginMultipleSelection]) {
        [self addNewMethodWithSel:oldShouldBeginMultipleSelection newSel:newShouldBeginMultipleSelection];
    }
    
    SEL oldDidBeginMultipleSelection = @selector(tableView:didBeginMultipleSelectionInteractionAtIndexPath:);
    SEL newDidBeginMultipleSelection = @selector(tab_tableView:didBeginMultipleSelectionInteractionAtIndexPath:);
    if ([delegate respondsToSelector:oldDidBeginMultipleSelection]) {
        [self addNewMethodWithSel:oldDidBeginMultipleSelection newSel:newDidBeginMultipleSelection];
    }
    
    SEL oldDidEndMultipleSelection = @selector(tableView:tableViewDidEndMultipleSelectionInteraction:);
    SEL newDidEndMultipleSelection = @selector(tab_tableView:tableViewDidEndMultipleSelectionInteraction:);
    if ([delegate respondsToSelector:oldDidEndMultipleSelection]) {
        [self addNewMethodWithSel:oldDidEndMultipleSelection newSel:newDidEndMultipleSelection];
    }
    
    SEL oldContextMenuConfiguration = @selector(tableView:contextMenuConfigurationForRowAtIndexPath:point:);
    SEL newContextMenuConfiguration = @selector(tab_tableView:contextMenuConfigurationForRowAtIndexPath:point:);
    if ([delegate respondsToSelector:oldContextMenuConfiguration]) {
        [self addNewMethodWithSel:oldContextMenuConfiguration newSel:newContextMenuConfiguration];
    }
    
    SEL oldPreviewForHighlightingContextMenu = @selector(tableView:previewForHighlightingContextMenuWithConfiguration:);
    SEL newPreviewForHighlightingContextMenu = @selector(tab_tableView:previewForHighlightingContextMenuWithConfiguration:);
    if ([delegate respondsToSelector:oldPreviewForHighlightingContextMenu]) {
        [self addNewMethodWithSel:oldPreviewForHighlightingContextMenu newSel:newPreviewForHighlightingContextMenu];
    }
    
    SEL oldPreviewForDismissingContextMenu = @selector(tableView:previewForDismissingContextMenuWithConfiguration:);
    SEL newPreviewForDismissingContextMenu = @selector(tab_tableView:previewForDismissingContextMenuWithConfiguration:);
    if ([delegate respondsToSelector:oldPreviewForDismissingContextMenu]) {
        [self addNewMethodWithSel:oldPreviewForDismissingContextMenu newSel:newPreviewForDismissingContextMenu];
    }
    
    SEL oldWillPerformPreviewAction = @selector(tableView:willPerformPreviewActionForMenuWithConfiguration:animator:);
    SEL newWillPerformPreviewAction = @selector(tab_tableView:willPerformPreviewActionForMenuWithConfiguration:animator:);
    if ([delegate respondsToSelector:oldWillPerformPreviewAction]) {
        [self addNewMethodWithSel:oldWillPerformPreviewAction newSel:newWillPerformPreviewAction];
    }
    
    SEL oldWillEndContextMenuInteraction = @selector(tableView:willEndContextMenuInteractionWithConfiguration:animator:);
    SEL newWillEndContextMenuInteraction = @selector(tab_tableView:willEndContextMenuInteractionWithConfiguration:animator:);
    if ([delegate respondsToSelector:oldWillEndContextMenuInteraction]) {
        [self addNewMethodWithSel:oldWillEndContextMenuInteraction newSel:newWillEndContextMenuInteraction];
    }
    
    ((UITableView *)target).delegate = self.protocolContainer;
}

- (void)updateDataSourceMethods:(id<UITableViewDataSource>)dataSource
                         target:(id)target {
    
    SEL oldSectionSelector = @selector(numberOfSectionsInTableView:);
    SEL newSectionSelector = @selector(tab_numberOfSectionsInTableView:);
    if ([dataSource respondsToSelector:oldSectionSelector]) {
        [self addNewMethodWithSel:oldSectionSelector newSel:newSectionSelector];
    }
    
    SEL oldSelector = @selector(tableView:numberOfRowsInSection:);
    SEL newSelector = @selector(tab_tableView:numberOfRowsInSection:);
    if ([dataSource respondsToSelector:oldSelector]) {
        [self addNewMethodWithSel:oldSelector newSel:newSelector];
    }
    
    SEL oldCell = @selector(tableView:cellForRowAtIndexPath:);
    SEL newCell = @selector(tab_tableView:cellForRowAtIndexPath:);
    if ([dataSource respondsToSelector:oldCell]) {
        [self addNewMethodWithSel:oldCell newSel:newCell];
    }
    
    SEL old = @selector(tableView:willDisplayCell:forRowAtIndexPath:);
    SEL new = @selector(tab_tableView:willDisplayCell:forRowAtIndexPath:);
    if ([dataSource respondsToSelector:old]) {
        [self addNewMethodWithSel:old newSel:new];
    }
    
    // Extra Datasource
    
    SEL oldTitleForHeader = @selector(tableView:titleForHeaderInSection:);
    SEL newTitleForHeader = @selector(tab_tableView:titleForHeaderInSection:);
    if ([dataSource respondsToSelector:oldTitleForHeader]) {
        [self addNewMethodWithSel:oldTitleForHeader newSel:newTitleForHeader];
    }
    
    SEL oldTitleForFooter = @selector(tableView:titleForFooterInSection:);
    SEL newTitleForFooter = @selector(tab_tableView:titleForFooterInSection:);
    if ([dataSource respondsToSelector:oldTitleForFooter]) {
        [self addNewMethodWithSel:oldTitleForFooter newSel:newTitleForFooter];
    }
    
    SEL oldCanEditRow = @selector(tableView:canEditRowAtIndexPath:);
    SEL newCanEditRow = @selector(tab_tableView:canEditRowAtIndexPath:);
    if ([dataSource respondsToSelector:oldCanEditRow]) {
        [self addNewMethodWithSel:oldCanEditRow newSel:newCanEditRow];
    }
    
    SEL oldCanMoveRow = @selector(tableView:canMoveRowAtIndexPath:);
    SEL newCanMoveRow = @selector(tab_tableView:canMoveRowAtIndexPath:);
    if ([dataSource respondsToSelector:oldCanMoveRow]) {
        [self addNewMethodWithSel:oldCanMoveRow newSel:newCanMoveRow];
    }
    
    SEL oldSectionIndexTitles = @selector(sectionIndexTitlesForTableView:);
    SEL newSectionIndexTitles = @selector(tab_sectionIndexTitlesForTableView:);
    if ([dataSource respondsToSelector:oldSectionIndexTitles]) {
        [self addNewMethodWithSel:oldSectionIndexTitles newSel:newSectionIndexTitles];
    }
    
    SEL oldSectionIndexTitle = @selector(tableView:sectionForSectionIndexTitle:atIndex:);
    SEL newSectionIndexTitle = @selector(tab_tableView:sectionForSectionIndexTitle:atIndex:);
    if ([dataSource respondsToSelector:oldSectionIndexTitle]) {
        [self addNewMethodWithSel:oldSectionIndexTitle newSel:newSectionIndexTitle];
    }
    
    SEL oldCommitEditingStyle = @selector(tableView:commitEditingStyle:forRowAtIndexPath:);
    SEL newCommitEditingStyle = @selector(tab_tableView:commitEditingStyle:forRowAtIndexPath:);
    if ([dataSource respondsToSelector:oldCommitEditingStyle]) {
        [self addNewMethodWithSel:oldCommitEditingStyle newSel:newCommitEditingStyle];
    }
    
    SEL oldMoveRow = @selector(tableView:moveRowAtIndexPath:toIndexPath:);
    SEL newMoveRow = @selector(tab_tableView:moveRowAtIndexPath:toIndexPath:);
    if ([dataSource respondsToSelector:oldMoveRow]) {
        [self addNewMethodWithSel:oldMoveRow newSel:newMoveRow];
    }
    
    ((UITableView *)target).dataSource = self.protocolContainer;
}

#pragma clang diagnostic pop

#pragma mark - TABTableViewDataSource / Delegate

- (NSInteger)tab_numberOfSectionsInTableView:(UITableView *)tableView {
    
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    id oldDelegate = tabAnimated.oldDataSource;
    SEL sel = @selector(numberOfSectionsInTableView:);
    
    if (!tabAnimated.isAnimating) {
        return ((NSInteger (*)(id, SEL, UITableView *))objc_msgSend)((id)oldDelegate, sel, tableView);
    }
    
    if (tabAnimated.runMode == TABAnimatedRunBySection) {
        if (tabAnimated.animatedSectionCount > 0) {
            return tabAnimated.animatedSectionCount;
        }
        return tabAnimated.cellClassArray.count;
    }
    
    NSInteger count = ((NSInteger (*)(id, SEL, UITableView *))objc_msgSend)((id)oldDelegate, sel, tableView);
    if (count == 0) count = tabAnimated.cellClassArray.count;
    if (count == 0) return 1;
    return count;
}

- (NSInteger)tab_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    id oldDelegate = tabAnimated.oldDataSource;
    SEL sel = @selector(tableView:numberOfRowsInSection:);
    
    if (!tabAnimated.isAnimating) {
        return ((NSInteger (*)(id, SEL, UITableView *, NSInteger))objc_msgSend)((id)oldDelegate, sel, tableView, section);
    }
    
    NSInteger originCount = 0;
    
    if (tabAnimated.animatedSectionCount <= 0) {
        originCount = ((NSInteger (*)(id, SEL, UITableView *, NSInteger))objc_msgSend)((id)oldDelegate, sel, tableView, section);
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

- (CGFloat)tab_tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:heightForRowAtIndexPath:);
    
    if (!tabAnimated.isAnimating) {
        return ((CGFloat (*)(id, SEL, UITableView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, tableView, indexPath);
    }
    
    NSInteger index = [tabAnimated getIndexWithIndexPath:indexPath];
    if (index < 0) {
        return ((CGFloat (*)(id, SEL, UITableView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, tableView, indexPath);
    }
    return [tabAnimated.cellHeightArray[index] floatValue];
}

- (UITableViewCell *)tab_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    id oldDelegate = tabAnimated.oldDataSource;
    SEL sel = @selector(tableView:cellForRowAtIndexPath:);
    
    if (!tabAnimated.isAnimating) {
        return ((UITableViewCell * (*)(id, SEL, UITableView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, tableView, indexPath);
    }
    
    NSInteger index = [tabAnimated getIndexWithIndexPath:indexPath];
    if (index < 0) {
        return ((UITableViewCell * (*)(id, SEL, UITableView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, tableView, indexPath);
    }
    
    Class currentClass = tabAnimated.cellClassArray[index];
    UITableViewCell *cell = [tabAnimated.producter productWithControlView:tableView currentClass:currentClass indexPath:indexPath origin:TABAnimatedProductOriginTableViewCell];
    return cell;
}

- (void)tab_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (!tabAnimated.isAnimating) {
        id oldDelegate = tabAnimated.oldDelegate;
        SEL sel = @selector(tableView:didSelectRowAtIndexPath:);
        ((void (*)(id, SEL, UITableView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, tableView, indexPath);
    }
}

#pragma mark - HeaderFooterView

- (CGFloat)tab_tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:heightForHeaderInSection:);
    
    if (!tabAnimated.isAnimating) {
        return ((CGFloat (*)(id, SEL, UITableView *, NSInteger))objc_msgSend)((id)oldDelegate, sel, tableView, section);
    }
    
    NSInteger index = [tabAnimated getHeaderIndexWithIndex:section];
    if (index < 0) {
        return ((CGFloat (*)(id, SEL, UITableView *, NSInteger))objc_msgSend)((id)oldDelegate, sel, tableView, section);
    }
    return [tabAnimated.headerHeightArray[index] floatValue];
}

- (CGFloat)tab_tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:heightForFooterInSection:);
    
    if (!tabAnimated.isAnimating) {
        return ((CGFloat (*)(id, SEL, UITableView *, NSInteger))objc_msgSend)((id)oldDelegate, sel, tableView, section);
    }
    
    NSInteger index = [tabAnimated getFooterIndexWithIndex:section];
    if (index < 0) {
        return ((CGFloat (*)(id, SEL, UITableView *, NSInteger))objc_msgSend)((id)oldDelegate, sel, tableView, section);
    }
    return [tabAnimated.footerHeightArray[index] floatValue];
}

- (nullable UIView *)tab_tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:viewForHeaderInSection:);
    
    if (!tabAnimated.isAnimating) {
        return ((UIView * (*)(id, SEL, UITableView *, NSInteger))objc_msgSend)((id)oldDelegate, sel, tableView, section);
    }
    
    NSInteger index = [tabAnimated getHeaderIndexWithIndex:section];
    if (index < 0) {
        return ((UIView * (*)(id, SEL, UITableView *, NSInteger))objc_msgSend)((id)oldDelegate, sel, tableView, section);
    }
    
    Class class = tabAnimated.headerClassArray[index];
    
    UIView *hfView;
    TABAnimatedProductOrigin origin = [class isSubclassOfClass:[UITableViewHeaderFooterView class]] ? TABAnimatedProductOriginTableHeaderFooterViewCell : TABAnimatedProductOriginTableHeaderFooterView;
    hfView = [tabAnimated.producter productWithControlView:tableView currentClass:class indexPath:nil origin:origin];
    
    return hfView;
}

- (nullable UIView *)tab_tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:viewForFooterInSection:);
    
    if (!tabAnimated.isAnimating) {
        return ((UIView * (*)(id, SEL, UITableView *, NSInteger))objc_msgSend)((id)oldDelegate, sel, tableView, section);
    }
    
    NSInteger index = [tabAnimated getFooterIndexWithIndex:section];
    if (index < 0) {
        return ((UIView * (*)(id, SEL, UITableView *, NSInteger))objc_msgSend)((id)oldDelegate, sel, tableView, section);
    }
    
    Class class = tableView.tabAnimated.footerClassArray[index];
    
    UIView *hfView;
    TABAnimatedProductOrigin origin = [class isSubclassOfClass:[UITableViewHeaderFooterView class]] ? TABAnimatedProductOriginTableHeaderFooterViewCell : TABAnimatedProductOriginTableHeaderFooterView;
    hfView = [tabAnimated.producter productWithControlView:tableView currentClass:class indexPath:nil origin:origin];
    
    return hfView;
}

#pragma mark - Extra Datasource

- (nullable NSString *)tab_tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    id oldDelegate = tabAnimated.oldDataSource;
    SEL sel = @selector(tableView:titleForHeaderInSection:);
    return ((NSString * (*)(id, SEL, UITableView *, NSInteger))objc_msgSend)((id)oldDelegate, sel, tableView, section);
}

- (nullable NSString *)tab_tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    id oldDelegate = tabAnimated.oldDataSource;
    SEL sel = @selector(tableView:titleForFooterInSection:);
    return ((NSString * (*)(id, SEL, UITableView *, NSInteger))objc_msgSend)((id)oldDelegate, sel, tableView, section);
}

- (BOOL)tab_tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) {
        return NO;
    }
    id oldDelegate = tabAnimated.oldDataSource;
    SEL sel = @selector(tableView:canEditRowAtIndexPath:);
    return ((BOOL (*)(id, SEL, UITableView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, tableView, indexPath);
}

- (BOOL)tab_tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) {
        return NO;
    }
    id oldDelegate = tabAnimated.oldDataSource;
    SEL sel = @selector(tableView:canMoveRowAtIndexPath:);
    return ((BOOL (*)(id, SEL, UITableView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, tableView, indexPath);
}

- (nullable NSArray<NSString *> *)tab_sectionIndexTitlesForTableView:(UITableView *)tableView {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) {
        return nil;
    }
    id oldDelegate = tabAnimated.oldDataSource;
    SEL sel = @selector(sectionIndexTitlesForTableView:);
    return ((NSArray<NSString *> * (*)(id, SEL, UITableView *))objc_msgSend)((id)oldDelegate, sel, tableView);
}

- (NSInteger)tab_tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    id oldDelegate = tabAnimated.oldDataSource;
    SEL sel = @selector(tableView:sectionForSectionIndexTitle:atIndex:);
    return ((NSInteger (*)(id, SEL, UITableView *, NSString *, NSInteger index))objc_msgSend)((id)oldDelegate, sel, tableView, title, index);
}

- (void)tab_tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    id oldDelegate = tabAnimated.oldDataSource;
    SEL sel = @selector(tableView:commitEditingStyle:forRowAtIndexPath:);
    ((void (*)(id, SEL, UITableView *, UITableViewCellEditingStyle, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, tableView, editingStyle, indexPath);
}

- (void)tab_tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    id oldDelegate = tabAnimated.oldDataSource;
    SEL sel = @selector(tableView:moveRowAtIndexPath:toIndexPath:);
    ((void (*)(id, SEL, UITableView *, NSIndexPath *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, tableView, sourceIndexPath, destinationIndexPath);
}

#pragma mark - Extra Delegate

// Display customization

- (void)tab_tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:willDisplayCell:forRowAtIndexPath:);
    ((void (*)(id, SEL, UITableView *, UITableViewCell *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, tableView, cell, indexPath);
}

- (void)tab_tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:willDisplayHeaderView:forSection:);
    ((void (*)(id, SEL, UITableView *, UIView *, NSInteger))objc_msgSend)((id)oldDelegate, sel, tableView, view, section);
}

- (void)tab_tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:willDisplayFooterView:forSection:);
    ((void (*)(id, SEL, UITableView *, UIView *, NSInteger))objc_msgSend)((id)oldDelegate, sel, tableView, view, section);
}

- (void)tab_tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:didEndDisplayingCell:forRowAtIndexPath:);
    ((void (*)(id, SEL, UITableView *, UITableViewCell *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, tableView, cell, indexPath);
}

- (void)tab_tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:didEndDisplayingHeaderView:forSection:);
    ((void (*)(id, SEL, UITableView *, UIView *, NSInteger))objc_msgSend)((id)oldDelegate, sel, tableView, view, section);
}

- (void)tab_tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:didEndDisplayingFooterView:forSection:);
    ((void (*)(id, SEL, UITableView *, UIView *, NSInteger))objc_msgSend)((id)oldDelegate, sel, tableView, view, section);
}

// Accessories (disclosures).

- (UITableViewCellAccessoryType)tab_tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return UITableViewCellAccessoryNone;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:accessoryTypeForRowWithIndexPath:);
    return ((UITableViewCellAccessoryType (*)(id, SEL, UITableView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, tableView, indexPath);
}

- (void)tab_tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:accessoryButtonTappedForRowWithIndexPath:);
    ((void (*)(id, SEL, UITableView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, tableView, indexPath);
}

- (BOOL)tab_tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return NO;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:shouldHighlightRowAtIndexPath:);
    return ((BOOL (*)(id, SEL, UITableView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, tableView, indexPath);
}

- (void)tab_tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:didHighlightRowAtIndexPath:);
    ((void (*)(id, SEL, UITableView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, tableView, indexPath);
}

- (void)tab_tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:didUnhighlightRowAtIndexPath:);
    ((void (*)(id, SEL, UITableView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, tableView, indexPath);
}

- (nullable NSIndexPath *)tab_tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return nil;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:willSelectRowAtIndexPath:);
    return ((NSIndexPath * (*)(id, SEL, UITableView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, tableView, indexPath);
}

- (nullable NSIndexPath *)tab_tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return nil;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:willDeselectRowAtIndexPath:);
    return ((NSIndexPath * (*)(id, SEL, UITableView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, tableView, indexPath);
}

- (void)tab_tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:didDeselectRowAtIndexPath:);
    ((void (*)(id, SEL, UITableView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, tableView, indexPath);
}

- (UITableViewCellEditingStyle)tab_tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return UITableViewCellEditingStyleNone;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:editingStyleForRowAtIndexPath:);
    return ((UITableViewCellEditingStyle (*)(id, SEL, UITableView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, tableView, indexPath);
}

- (nullable NSString *)tab_tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return nil;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:);
    return ((NSString * (*)(id, SEL, UITableView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, tableView, indexPath);
}

- (nullable NSArray<UITableViewRowAction *> *)tab_tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return nil;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:editActionsForRowAtIndexPath:);
    return ((NSArray<UITableViewRowAction *> * (*)(id, SEL, UITableView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, tableView, indexPath);
}

// Swipe actions
// These methods supersede -editActionsForRowAtIndexPath: if implemented
// return nil to get the default swipe actions
- (nullable UISwipeActionsConfiguration *)tab_tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath   API_AVAILABLE(ios(11.0)) {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return nil;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:leadingSwipeActionsConfigurationForRowAtIndexPath:);
    if (@available(iOS 11.0, *)) {
        return ((UISwipeActionsConfiguration * (*)(id, SEL, UITableView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, tableView, indexPath);
    }
    return nil;
}

- (nullable UISwipeActionsConfiguration *)tab_tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0))  {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return nil;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:trailingSwipeActionsConfigurationForRowAtIndexPath:);
    if (@available(iOS 11.0, *)) {
        return ((UISwipeActionsConfiguration * (*)(id, SEL, UITableView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, tableView, indexPath);
    }
    return nil;
}

// Controls whether the background is indented while editing.  If not implemented, the default is YES.  This is unrelated to the indentation level below.  This method only applies to grouped style table views.
- (BOOL)tab_tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return NO;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:shouldIndentWhileEditingRowAtIndexPath:);
    return ((BOOL (*)(id, SEL, UITableView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, tableView, indexPath);
}

// The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
- (void)tab_tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:willBeginEditingRowAtIndexPath:);
    ((void (*)(id, SEL, UITableView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, tableView, indexPath);
}

- (void)tab_tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(nullable NSIndexPath *)indexPath {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:didEndEditingRowAtIndexPath:);
    ((void (*)(id, SEL, UITableView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, tableView, indexPath);
}

// Moving/reordering

// Allows customization of the target row for a particular row as it is being moved/reordered
- (NSIndexPath *)tab_tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:);
    return ((NSIndexPath * (*)(id, SEL, UITableView *, NSIndexPath *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, tableView, sourceIndexPath, proposedDestinationIndexPath);
}

// Indentation

- (NSInteger)tab_tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return 0;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:indentationLevelForRowAtIndexPath:);
    return ((NSInteger (*)(id, SEL, UITableView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, tableView, indexPath);
}

// Copy/Paste.  All three methods must be implemented by the delegate.

- (BOOL)tab_tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return NO;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:shouldShowMenuForRowAtIndexPath:);
    return ((BOOL (*)(id, SEL, UITableView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, tableView, indexPath);
}

- (BOOL)tab_tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return NO;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:canPerformAction:forRowAtIndexPath:withSender:);
    return ((BOOL (*)(id, SEL, UITableView *, NSIndexPath *, id))objc_msgSend)((id)oldDelegate, sel, tableView, indexPath, sender);
}
- (void)tab_tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:performAction:forRowAtIndexPath:withSender:);
    ((void (*)(id, SEL, UITableView *, NSIndexPath *, id))objc_msgSend)((id)oldDelegate, sel, tableView, indexPath, sender);
}

// Focus

- (BOOL)tab_tableView:(UITableView *)tableView canFocusRowAtIndexPath:(NSIndexPath *)indexPath {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return NO;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:canFocusRowAtIndexPath:);
    return ((BOOL (*)(id, SEL, UITableView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, tableView, indexPath);
}

- (BOOL)tab_tableView:(UITableView *)tableView shouldUpdateFocusInContext:(UITableViewFocusUpdateContext *)context {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return NO;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:shouldUpdateFocusInContext:);
    return ((BOOL (*)(id, SEL, UITableView *, UITableViewFocusUpdateContext *))objc_msgSend)((id)oldDelegate, sel, tableView, context);
}

- (void)tab_tableView:(UITableView *)tableView didUpdateFocusInContext:(UITableViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:didUpdateFocusInContext:withAnimationCoordinator:);
    ((void (*)(id, SEL, UITableView *, UITableViewFocusUpdateContext *, UIFocusAnimationCoordinator *))objc_msgSend)((id)oldDelegate, sel, tableView, context, coordinator);
}

- (nullable NSIndexPath *)tab_indexPathForPreferredFocusedViewInTableView:(UITableView *)tableView {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return nil;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tab_indexPathForPreferredFocusedViewInTableView:);
    return ((NSIndexPath * (*)(id, SEL, UITableView *))objc_msgSend)((id)oldDelegate, sel, tableView);
}

- (BOOL)tab_tableView:(UITableView *)tableView shouldSpringLoadRowAtIndexPath:(NSIndexPath *)indexPath withContext:(id<UISpringLoadedInteractionContext>)context  API_AVAILABLE(ios(11.0))  {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return NO;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:shouldSpringLoadRowAtIndexPath:withContext:);
    return ((BOOL (*)(id, SEL, UITableView *, NSIndexPath *, id))objc_msgSend)((id)oldDelegate, sel, tableView, indexPath, context);
}

- (BOOL)tab_tableView:(UITableView *)tableView shouldBeginMultipleSelectionInteractionAtIndexPath:(NSIndexPath *)indexPath {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return NO;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:shouldBeginMultipleSelectionInteractionAtIndexPath:);
    return ((BOOL (*)(id, SEL, UITableView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, tableView, indexPath);
}

- (void)tab_tableView:(UITableView *)tableView didBeginMultipleSelectionInteractionAtIndexPath:(NSIndexPath *)indexPath {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:didBeginMultipleSelectionInteractionAtIndexPath:);
    ((void (*)(id, SEL, UITableView *, NSIndexPath *))objc_msgSend)((id)oldDelegate, sel, tableView, indexPath);
}

- (void)tab_tableViewDidEndMultipleSelectionInteraction:(UITableView *)tableView {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tab_tableViewDidEndMultipleSelectionInteraction:);
    ((void (*)(id, SEL, UITableView *))objc_msgSend)((id)oldDelegate, sel, tableView);
}

- (nullable UIContextMenuConfiguration *)tab_tableView:(UITableView *)tableView contextMenuConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath point:(CGPoint)point  API_AVAILABLE(ios(13.0)) {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return nil;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:contextMenuConfigurationForRowAtIndexPath:point:);
    return ((UIContextMenuConfiguration * (*)(id, SEL, UITableView *, NSIndexPath *, CGPoint))objc_msgSend)((id)oldDelegate, sel, tableView, indexPath, point);
}

- (nullable UITargetedPreview *)tab_tableView:(UITableView *)tableView previewForHighlightingContextMenuWithConfiguration:(UIContextMenuConfiguration *)configuration  API_AVAILABLE(ios(13.0)) {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return nil;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:previewForHighlightingContextMenuWithConfiguration:);
    return ((UITargetedPreview * (*)(id, SEL, UITableView *, UIContextMenuConfiguration *))objc_msgSend)((id)oldDelegate, sel, tableView, configuration);
}

- (nullable UITargetedPreview *)tab_tableView:(UITableView *)tableView previewForDismissingContextMenuWithConfiguration:(UIContextMenuConfiguration *)configuration  API_AVAILABLE(ios(13.0)) {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return nil;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:previewForDismissingContextMenuWithConfiguration:);
    return ((UITargetedPreview * (*)(id, SEL, UITableView *, UIContextMenuConfiguration *))objc_msgSend)((id)oldDelegate, sel, tableView, configuration);
}

- (void)tab_tableView:(UITableView *)tableView willPerformPreviewActionForMenuWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(id<UIContextMenuInteractionCommitAnimating>)animator API_AVAILABLE(ios(13.0)) {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:willPerformPreviewActionForMenuWithConfiguration:animator:);
    ((void (*)(id, SEL, UITableView *, UIContextMenuConfiguration *, id))objc_msgSend)((id)oldDelegate, sel, tableView, configuration, animator);
}

- (void)tab_tableView:(UITableView *)tableView willDisplayContextMenuWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(nullable id<UIContextMenuInteractionAnimating>)animator API_AVAILABLE(ios(13.0)) {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:willDisplayContextMenuWithConfiguration:animator:);
    ((void (*)(id, SEL, UITableView *, UIContextMenuConfiguration *, id))objc_msgSend)((id)oldDelegate, sel, tableView, configuration, animator);
}

- (void)tab_tableView:(UITableView *)tableView willEndContextMenuInteractionWithConfiguration:(UIContextMenuConfiguration *)configuration animator:(nullable id<UIContextMenuInteractionAnimating>)animator API_AVAILABLE(ios(13.0)) {
    TABTableAnimated *tabAnimated = tableView.tabAnimated;
    if (tabAnimated.isAnimating) return;
    id oldDelegate = tabAnimated.oldDelegate;
    SEL sel = @selector(tableView:willEndContextMenuInteractionWithConfiguration:animator:);
    ((void (*)(id, SEL, UITableView *, UIContextMenuConfiguration *, id))objc_msgSend)((id)oldDelegate, sel, tableView, configuration, animator);
}

@end
