//
//  UICollectionView+Animated.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/10/12.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "UICollectionView+TABAnimated.h"
#import "UIView+TABAnimated.h"
#import "UIView+TABControlAnimation.m"
#import "TABViewAnimated.h"

#import "TABCollectionAnimated.h"

#import "TABAnimated.h"

#import <objc/runtime.h>

@implementation UICollectionView (TABAnimated)

+ (void)load {
    
    // Ensure that the exchange method executed only once.
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        Method originMethod = class_getInstanceMethod([self class], @selector(setDelegate:));
        Method newMethod = class_getInstanceMethod([self class], @selector(tab_setDelegate:));
        method_exchangeImplementations(originMethod, newMethod);
    });
}

- (void)tab_setDelegate:(id<UICollectionViewDelegate>)delegate {
    
    SEL oldSectionSelector = @selector(collectionView:numberOfItemsInSection:);
    SEL newSectionSelector = @selector(tab_collectionView:numberOfItemsInSection:);
    
    SEL old = @selector(collectionView:willDisplayCell:forItemAtIndexPath:);
    SEL new = @selector(tab_collectionView:willDisplayCell:forItemAtIndexPath:);
    
    SEL oldCell = @selector(collectionView:cellForItemAtIndexPath:);
    SEL newCell = @selector(tab_collectionView:cellForItemAtIndexPath:);
    
    SEL oldHeightSel = @selector(collectionView:layout:sizeForItemAtIndexPath:);
    SEL newHeightSel = @selector(tab_collectionView:layout:sizeForItemAtIndexPath:);
    
    SEL oldClickSel = @selector(collectionView:didSelectItemAtIndexPath:);
    SEL newClickSel = @selector(tab_collectionView:didSelectItemAtIndexPath:);
    
    if ([self respondsToSelector:newSectionSelector]) {
        [self exchangeCollectionDelegateMethod:oldSectionSelector withNewSel:newSectionSelector withCollectionDelegate:delegate];
        [self exchangeCollectionDelegateMethod:old withNewSel:new withCollectionDelegate:delegate];
        [self exchangeCollectionDelegateMethod:oldCell withNewSel:newCell withCollectionDelegate:delegate];
        [self exchangeCollectionDelegateMethod:oldHeightSel withNewSel:newHeightSel withCollectionDelegate:delegate];
        [self exchangeCollectionDelegateMethod:oldClickSel withNewSel:newClickSel withCollectionDelegate:delegate];
    }

    [self tab_setDelegate:delegate];
}

#pragma mark - TABCollectionViewDelegate

- (NSInteger)tab_collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if ([collectionView.tabAnimated currentSectionIsAnimating:collectionView
                                                      section:section]) {
        
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
    
    if ([collectionView.tabAnimated currentSectionIsAnimating:collectionView
                                                      section:indexPath.section]) {
        
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
    
    if ([collectionView.tabAnimated currentSectionIsAnimating:collectionView
                                                      section:indexPath.section]) {
        
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
        
        UICollectionViewCell *cell = (UICollectionViewCell *)collectionView.tabAnimated.cellClassArray[index].new;
        
        NSString *className = NSStringFromClass(collectionView.tabAnimated.cellClassArray[index]);
        if ([className containsString:@"."]) {
            NSRange range = [className rangeOfString:@"."];
            className = [className substringFromIndex:range.location+1];
            if (className != nil && className.length > 0) {
                className = NSStringFromClass(collectionView.tabAnimated.cellClassArray[index]);
            }
        }
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"tab_%@",className] forIndexPath:indexPath];
        NSString *nibPath = [[NSBundle mainBundle] pathForResource:className ofType:@"nib"];
        if (nibPath != nil && nibPath.length > 0) {
            NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:className owner:self options:nil];
            if (cellArray.count <= 0) {
                NSAssert(NO, @"No xib file of the cell name.");
            }
            cell = [cellArray objectAtIndex:0];
        }
        
        if (nil == cell.tabLayer) {
            [TABManagerMethod fullData:cell];
            cell.tabLayer = TABLayer.new;
            cell.tabLayer.frame = cell.bounds;
            cell.tabLayer.animatedHeight = collectionView.tabAnimated.animatedHeight;
            cell.tabLayer.animatedCornerRadius = collectionView.tabAnimated.animatedCornerRadius;
            cell.tabLayer.cancelGlobalCornerRadius = collectionView.tabAnimated.cancelGlobalCornerRadius;
            [cell.layer addSublayer:cell.tabLayer];
        }
        
        return cell;
    }
    return [self tab_collectionView:collectionView cellForItemAtIndexPath:indexPath];
}

- (void)tab_collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([collectionView.tabAnimated currentSectionIsAnimating:collectionView
                                                      section:indexPath.section]) {
        return;
    }
    [self tab_collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
}

- (void)tab_collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView.tabAnimated currentSectionIsAnimating:collectionView
                                                      section:indexPath.section] ||
        collectionView.tabAnimated.state == TABViewAnimationRunning) {
        return;
    }
    [self tab_collectionView:collectionView didSelectItemAtIndexPath:indexPath];
}

#pragma mark - Private Methods

- (void)exchangeCollectionDelegateMethod:(SEL)oldSelector
                              withNewSel:(SEL)newSelector
                  withCollectionDelegate:(id<UICollectionViewDelegate>)delegate {
    
    Method oldMethod = class_getInstanceMethod([delegate class], oldSelector);
    Method newMethod = class_getInstanceMethod([self class], newSelector);
    
    if ([self isKindOfClass:[delegate class]]) {
        // 如果你采用了将数据代理给予表格本身，这种愚蠢的做法暂不做处理，将无法使用动画库。
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

- (TABCollectionAnimated *)tabAnimated {
    return objc_getAssociatedObject(self, @selector(tabAnimated));
}

- (void)setTabAnimated:(TABCollectionAnimated *)tabAnimated {
    objc_setAssociatedObject(self, @selector(tabAnimated),tabAnimated, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
