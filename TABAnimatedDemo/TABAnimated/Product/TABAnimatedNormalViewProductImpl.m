////
////  TABAnimatedNormalViewProductImpl.m
////  TABAnimatedDemo
////
////  Created by tigerAndBull on 2020/8/24.
////  Copyright © 2020 tigerAndBull. All rights reserved.
////
//
//#import "TABAnimatedNormalViewProductImpl.h"
//
//
//#import "TABAnimatedProductHelper.h"
//#import "TABAnimatedProduction.h"
//
//#import "TABViewAnimated.h"
//#import "UIView+TABControlModel.h"
//
//#import "TABAnimatedDarkModeInterface.h"
//#import "TABComponentLayer.h"
//#import "TABWeakDelegateManager.h"
//#import "TABAnimatedCacheManager.h"
//
//#import "UIView+TABAnimatedProduction.h"
//
//#import "TABAnimatedDarkModeManagerImpl.h"
//#import "TABAnimatedChainManagerImpl.h"
//#import "TABAnimationManagerImpl.h"
//
//@interface TABAnimatedNormalViewProductImpl() {
//    // self存在即存在
//    __unsafe_unretained UIView *_controlView;
//    // 进入加工流时，会取出targetView，结束时释放。加工流只会在持有targetView的controlView存在时执行。
//    __unsafe_unretained UIView *_targetView;
//}
//
//// 模式切换协议
//@property (nonatomic, strong) id <TABAnimatedDarkModeManagerInterface> darkModeManager;
//
//// 链式调整协议
//@property (nonatomic, strong) id <TABAnimatedChainManagerInterface> chainManager;
//
//// 动画管理协议
//@property (nonatomic, strong) id <TABAnimationManagerInterface> animationManager;
//
//@end
//
//@implementation TABAnimatedNormalViewProductImpl
//
//// 生产骨架元素
//- (void)productWithView:(nonnull UIView *)view
//            controlView:(nonnull UIView *)controlView
//           currentClass:(nonnull Class)currentClass
//              indexPath:(nullable NSIndexPath *)indexPath
//                 origin:(TABAnimatedProductOrigin)origin {
//
//    if (_controlView == nil) {
//        [self setControlView:controlView];
//    }
//
//    NSString *controlerClassName = controlView.tabAnimated.targetControllerClassName;
//    NSString *key = [TABAnimatedProductHelper getKeyWithControllerName:controlerClassName targetClass:currentClass];
//    TABAnimatedProduction *production = [[TABAnimatedCacheManager shareManager] getProductionWithKey:key];
//    if (production) {
//        TABAnimatedProduction *newProduction = production.copy;
//        [self _bindWithProduction:newProduction targetView:view];
//        return;
//    }
//
//    [self _prepareProductWithView:view currentClass:currentClass indexPath:indexPath origin:origin needSync:NO needReset:YES];
//
//}
//
//// 上拉加载更多生产流流
//- (void)pullLoadingProductWithView:(nonnull UIView *)view
//                       controlView:(nonnull UIView *)controlView
//                      currentClass:(nonnull Class)currentClass
//                         indexPath:(nullable NSIndexPath *)indexPath
//                            origin:(TABAnimatedProductOrigin)origin {
//
//}
//
//- (void)destory {
//
//}
//
//#pragma mark -
//
//- (void)_bindWithProduction:(TABAnimatedProduction *)production targetView:(UIView *)targetView {
//    [TABAnimatedProductHelper bindView:targetView production:production animatedHeight:_controlView.tabAnimated.animatedHeight];
//    [self.darkModeManager addNeedChangeView:targetView];
//    [_animationManager addAnimationWithTargetView:targetView];
//}
//
//- (void)_prepareProductWithView:(UIView *)view currentClass:(Class)currentClass indexPath:(nullable NSIndexPath *)indexPath origin:(TABAnimatedProductOrigin)origin needSync:(BOOL)needSync needReset:(BOOL)needReset {
//    TABAnimatedProduction *production = view.tabAnimatedProduction;
//    if (production == nil) {
//        production = [TABAnimatedProduction productWithState:TABAnimatedProductionCreate];
//        view.tabAnimatedProduction = production;
//    }
//    production.targetClass = currentClass;
//    production.currentSection = indexPath.section;
//    production.currentRow = indexPath.row;
//
//    [self _productBackgroundLayerWithView:view needReset:needReset];
//}
//
//- (__kindof UIView *)_reuseWithCurrentClass:(Class)currentClass
//                                  indexPath:(nullable NSIndexPath *)indexPath
//                                     origin:(TABAnimatedProductOrigin)origin
//                                  className:(NSString *)className
//                                 production:(TABAnimatedProduction *)production {
//    UIView *view = [self _createViewWithOrigin:origin controlView:_controlView indexPath:indexPath className:className currentClass:currentClass isNeedProduct:NO];
//    if (view.tabAnimatedProduction) return view;
//    [self _reuseProduction:production targetView:view];
//    return view;
//}
//
//- (__kindof UIView *)_createViewWithOrigin:(TABAnimatedProductOrigin)origin
//                               controlView:(UIView *)controlView
//                                 indexPath:(nullable NSIndexPath *)indexPath
//                                 className:(NSString *)className
//                              currentClass:(Class)currentClass
//                             isNeedProduct:(BOOL)isNeedProduct {
//
//    NSString *prefixString = isNeedProduct ? @"tab_" : @"tab_contain_";
//    NSString *identifier = [NSString stringWithFormat:@"%@%@", prefixString, className];
//    UIView *view;
//
//    switch (origin) {
//
//        case TABAnimatedProductOriginTableViewCell: {
//            view = [(UITableView *)controlView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
//            ((UITableViewCell *)view).selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//            break;
//
//        case TABAnimatedProductOriginCollectionViewCell: {
//            view = [(UICollectionView *)controlView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//        }
//            break;
//
//        case TABAnimatedProductOriginCollectionReuseableHeaderView: {
//            view = [(UICollectionView *)controlView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
//                                                                       withReuseIdentifier:identifier
//                                                                              forIndexPath:indexPath];
//        }
//            break;
//
//        case TABAnimatedProductOriginCollectionReuseableFooterView: {
//            view = [(UICollectionView *)controlView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
//                                                                       withReuseIdentifier:identifier
//                                                                              forIndexPath:indexPath];
//        }
//            break;
//
//        case TABAnimatedProductOriginTableHeaderFooterViewCell: {
//            view = [(UITableView *)controlView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
//            if (view == nil) {
//                view = [[currentClass alloc] initWithReuseIdentifier:identifier];
//            }
//        }
//            break;
//
//        default: {
//            view = NSClassFromString(className).new;
//        }
//            break;
//    }
//    return view;
//}
//
//- (void)_reuseProduction:(TABAnimatedProduction *)production targetView:(UIView *)targetView {
//    TABAnimatedProduction *newProduction = production.copy;
//    if (production.state != TABAnimatedProductionCreate) {
//        [self _bindWithProduction:newProduction targetView:targetView];
//    }else {
//        targetView.tabAnimatedProduction = newProduction;
//        [production.syncDelegateManager addDelegate:targetView];
//    }
//}
//
//- (void)_productBackgroundLayerWithView:(UIView *)view needReset:(BOOL)needReset {
//
//    UIView *flagView;
//    BOOL isCard = NO;
//
//    if ([view isKindOfClass:[UITableViewCell class]] || [view isKindOfClass:[UICollectionViewCell class]]) {
//        if (view.subviews.count >= 1 && view.subviews[0].layer.shadowOpacity > 0.) {
//            flagView = view.subviews[0];
//            isCard = YES;
//        }else if (view.subviews.count >= 2 && view.subviews[1].layer.shadowOpacity > 0.) {
//            flagView = view.subviews[1];
//            isCard = YES;
//        }
//    }else if (view.subviews.count >= 1 && view.subviews[0].layer.shadowOpacity > 0.) {
//        flagView = view.subviews[0];
//        isCard = YES;
//    }
//
//    if (flagView) {
//        flagView.hidden = YES;
//    }else {
//        flagView = view;
//    }
//
//    view.tabAnimatedProduction.backgroundLayer = [TABAnimatedProductHelper getBackgroundLayerWithView:flagView controlView:self->_controlView];
//
//    [self _productWithView:view needReset:needReset isCard:isCard];
//}
//
//- (void)_productWithView:(UIView *)view needReset:(BOOL)needReset isCard:(BOOL)isCard {
//
//    [TABAnimatedProductHelper fullDataAndStartNestAnimation:view isHidden:!needReset rootView:view];
//    view.hidden = YES;
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        // 生产流水
//        [self _productWithTargetView:self->_targetView isCard:isCard];
//        if (needReset) {
//            [TABAnimatedProductHelper resetData:self->_targetView];
//        }
//    });
//}
//
//- (void)_productWithTargetView:(UIView *)targetView isCard:(BOOL)isCard {
//    @autoreleasepool {
//        TABAnimatedProduction *production = targetView.tabAnimatedProduction;
//        NSString *controlerClassName = _controlView.tabAnimated.targetControllerClassName;
//        production.fileName = [TABAnimatedProductHelper getKeyWithControllerName:controlerClassName targetClass:production.targetClass];
//
//        NSMutableArray <TABComponentLayer *> *layerArray = @[].mutableCopy;
//        // 生产
//        [self _recurseProductLayerWithView:targetView array:layerArray production:production isCard:isCard];
//        // 加工
//        [self _chainAdjustWithArray:layerArray tabAnimated:_controlView.tabAnimated targetClass:production.targetClass];
//        // 绑定
//        production.state = TABAnimatedProductionBind;
//        production.layers = layerArray;
//        targetView.tabAnimatedProduction = production;
//        // 缓存
//        [[TABAnimatedCacheManager shareManager] cacheProduction:production];
//    }
//}
//
//@end
