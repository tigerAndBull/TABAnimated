//
//  UITableView+Animated.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "UITableView+TABAnimated.h"

#import "TABViewAnimated.h"
#import "TABAnimated.h"
#import "TABTableAnimated.h"

#import <objc/runtime.h>

@implementation UITableView (TABAnimated)

struct {
    unsigned int sectionAnimatedCountDelegate:1;
} tableViewAnimatedDelegateRespondTo;

+ (void)load {
    
    // Ensure that the exchange method executed only once.
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        // Gets the viewDidLoad method to the class,whose type is a pointer to a objc_method structure.
        Method originMethod = class_getInstanceMethod([self class], @selector(setDelegate:));
        // Get the method you created.
        Method newMethod = class_getInstanceMethod([self class], @selector(tab_setDelegate:));
        method_exchangeImplementations(originMethod, newMethod);
    });
}

- (void)tab_setDelegate:(id<UITableViewDelegate>)delegate {
    
    SEL oldSelector = @selector(tableView:numberOfRowsInSection:);
    SEL newSelector = @selector(tab_tableView:numberOfRowsInSection:);
    
    SEL old = @selector(tableView:willDisplayCell:forRowAtIndexPath:);
    SEL new = @selector(tab_tableView:willDisplayCell:forRowAtIndexPath:);
    
    SEL oldCell = @selector(tableView:cellForRowAtIndexPath:);
    SEL newCell = @selector(tab_tableView:cellForRowAtIndexPath:);
    
    SEL oldHeightDelegate = @selector(tableView:heightForRowAtIndexPath:);
    SEL newHeightDelegate = @selector(tab_tableView:heightForRowAtIndexPath:);
    
    SEL oldClickDelegate = @selector(tableView:heightForRowAtIndexPath:);
    SEL newClickDelegate = @selector(tab_tableView:heightForRowAtIndexPath:);
    
    if ([self respondsToSelector:newSelector]) {
        [self exchangeTableDelegateMethod:oldSelector withNewSel:newSelector withTableDelegate:delegate];
        [self exchangeTableDelegateMethod:old withNewSel:new withTableDelegate:delegate];
        [self exchangeTableDelegateMethod:oldCell withNewSel:newCell withTableDelegate:delegate];
        [self exchangeTableDelegateMethod:oldHeightDelegate withNewSel:newHeightDelegate withTableDelegate:delegate];
        [self exchangeTableDelegateMethod:oldClickDelegate withNewSel:newClickDelegate withTableDelegate:delegate];
    }

    [self tab_setDelegate:delegate];
}

#pragma mark - TABTableViewDataSource

- (NSInteger)tab_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // If the animation running, return animatedCount.
    if (tableView.tabAnimated.isAnimating) {
        
        if (tableView.animatedDelegate &&
            [tableView.animatedDelegate respondsToSelector:@selector(tab_tableView:numberOfAnimatedRowsInSection:)]) {
            return [tableView.animatedDelegate tab_tableView:tableView numberOfAnimatedRowsInSection:section];
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
    
    if (tableView.tabAnimated.state == TABViewAnimationStart) {
        
        NSAssert(tableView.tabAnimated, @"TABAnimated模版模式强制提醒 - tabAnimated未初始化");
        
        NSInteger index = indexPath.section;
        if (indexPath.section > (tableView.tabAnimated.cellClassArray.count - 1)) {
            index = tableView.tabAnimated.cellClassArray.count - 1;
            tabAnimatedLog(@"TABAnimated模版模式提醒 - section的数量和模版类的数量不一致，超出的section，将使用最后一个模版类加载");
        }
        
        return [tableView.tabAnimated.cellHeightArray[index] floatValue];
    }
    return [self tab_tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tab_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tabAnimated.state == TABViewAnimationStart) {
        
        if (tableView.tabAnimated.cellClassArray.count == 0) {
            NSAssert(NO,@"TABAnimated - plese alloc your animatedObject");
        }
        
        NSInteger index = indexPath.section;
        if (indexPath.section > (tableView.tabAnimated.cellClassArray.count - 1)) {
            index = tableView.tabAnimated.cellClassArray.count - 1;
            tabAnimatedLog(@"TABAnimated - section的数量和模版类的数量不一致，超出的section，将使用最后一个模版类加载");
        }
        
        UITableViewCell *cell = (UITableViewCell *)tableView.tabAnimated.cellClassArray[index].new;
        NSString *nibPath = [[NSBundle mainBundle] pathForResource:NSStringFromClass(tableView.tabAnimated.cellClassArray[index]) ofType:@"nib"];
        if (nibPath != nil && nibPath.length > 0) {
            NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(tableView.tabAnimated.cellClassArray[index]) owner:self options:nil];
            if (cellArray.count <= 0) {
                NSAssert(NO, @"No xib file of the cell name.");
            }
            cell = [cellArray objectAtIndex:0];
        }
        return cell;
    }
    return [self tab_tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tab_tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tabAnimated.state == TABViewAnimationStart) {
        return;
    }
    [self tab_tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

- (void)tab_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tabAnimated.state == TABViewAnimationStart ||
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
- (void)exchangeTableDelegateMethod:(SEL)oldSelector
                         withNewSel:(SEL)newSelector
                  withTableDelegate:(id<UITableViewDelegate>)delegate {
    
    Method oldMethod = class_getInstanceMethod([delegate class], oldSelector);
    Method newMethod = class_getInstanceMethod([self class], newSelector);
    
    if ([self isKindOfClass:[delegate class]]) {
        // 如果你采用了将数据代理给予表格本身，这种愚蠢的做法暂不做处理，将无法使用动画库。
        // method_exchangeImplementations(oldMethod, newMethod);
        NSAssert(NO, @"Why do you do `self.delegate = self` such a silly thing?");
    }else {
        
        if (oldMethod == nil) {
            return;
        }
        
        // 代理对象添加newMethod，指向oldImp
        BOOL isVictory = class_addMethod([delegate class], newSelector, class_getMethodImplementation([delegate class], oldSelector), method_getTypeEncoding(oldMethod));
        if (isVictory) {
            // 添加成功后，将oldMethod指向当前类的新的
            class_replaceMethod([delegate class], oldSelector, class_getMethodImplementation([self class], newSelector), method_getTypeEncoding(newMethod));
        }
    }
}

- (id<UITableViewAnimatedDelegate>)animatedDelegate {
    id<UITableViewAnimatedDelegate> delegate = objc_getAssociatedObject(self, @selector(animatedDelegate));
    return delegate;
}

- (void)setAnimatedDelegate:(id<UITableViewAnimatedDelegate>)animatedDelegate {
    
    if (self.animatedDelegate != animatedDelegate) {
        
        objc_setAssociatedObject(self, @selector(animatedDelegate), animatedDelegate, OBJC_ASSOCIATION_ASSIGN);
        
        tableViewAnimatedDelegateRespondTo.sectionAnimatedCountDelegate = [animatedDelegate respondsToSelector:@selector(tab_tableView:numberOfAnimatedRowsInSection:)];
    }
}

- (TABTableAnimated *)tabAnimated {
    return objc_getAssociatedObject(self, @selector(tabAnimated));
}

- (void)setTabAnimated:(TABTableAnimated *)tabAnimated {
    objc_setAssociatedObject(self, @selector(tabAnimated),tabAnimated, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
