//
//  TABAnimatedProductImpl.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/4/1.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "TABAnimatedProductImpl.h"
#import "TABAnimatedProductHelper.h"
#import "TABAnimatedProduction.h"

#import "TABViewAnimated.h"
#import "UIView+TABControlModel.h"

#import "TABAnimatedDarkModeInterface.h"
#import "TABComponentLayer.h"
#import "TABWeakDelegateManager.h"
#import "TABAnimatedCacheManager.h"

#import "UIView+TABAnimatedProduction.h"

#import "TABAnimatedDarkModeManagerImpl.h"
#import "TABAnimatedChainManagerImpl.h"
#import "TABAnimationManagerImpl.h"

#import "TABAnimated.h"
#import "UIView+TABAnimated.h"

@interface TABAnimatedProductImpl() {
    // 进入加工流时，会取出targetView，结束时释放。加工流只会在持有targetView的controlView存在时执行。
    __unsafe_unretained UIView *_targetView;
}

// self存在即存在
@property (nonatomic, weak) UIView *controlView;

// 加工等待队列
@property (nonatomic, strong) NSPointerArray *weakTargetViewArray;

// 正在生产的index，配合targetViewArray实现加工等待队列
@property (nonatomic, assign) NSInteger productIndex;
// 正在生成的子view的tagIndex
@property (nonatomic, assign) NSInteger targetTagIndex;

// 产品复用池
@property (nonatomic, strong) NSMutableDictionary <NSString *, TABAnimatedProduction *> *productionPool;

// 生产结束，将产品同步给等待中的view
@property (nonatomic, assign) BOOL productFinished;

// 暗黑模式管理者协议
@property (nonatomic, strong) id <TABAnimatedDarkModeManagerInterface> darkModeManager;

// 链式调整协议
@property (nonatomic, strong) id <TABAnimatedChainManagerInterface> chainManager;

// 动画管理协议
@property (nonatomic, strong) id <TABAnimationManagerInterface> animationManager;

@end

@implementation TABAnimatedProductImpl

- (instancetype)init {
    if (self = [super init]) {
        if ([TABAnimated sharedAnimated].darkModeType == TABAnimatedDarkModeBySystem) {
            _darkModeManager = TABAnimatedDarkModeManagerImpl.new;
        }
        _animationManager = TABAnimationManagerImpl.new;
        _weakTargetViewArray = [NSPointerArray weakObjectsPointerArray];
    }
    return self;
}

#pragma mark - TABAnimatedProductInterface

- (__kindof UIView *)productWithControlView:(UIView *)controlView
                               currentClass:(Class)currentClass
                                  indexPath:(nullable NSIndexPath *)indexPath
                                     origin:(TABAnimatedProductOrigin)origin {
    
    if (_controlView == nil) {
        [self setControlView:controlView];
    }
    
    NSString *className = tab_NSStringFromClass(currentClass);
    NSString *controllerClassName = controlView.tabAnimated.targetControllerClassName;
    UIView *view;
    
    NSString *key = [TABAnimatedProductHelper getKeyWithControllerName:controllerClassName targetClass:currentClass frame:controlView.frame];
    TABAnimatedProduction *production;
    
    if (!_controlView.tabAnimated.containNestAnimation) {
        production = [[TABAnimatedCacheManager shareManager] getProductionWithKey:key];
        if (production) {
            view = [self _reuseWithCurrentClass:currentClass indexPath:indexPath origin:origin className:className production:production];
            return view;
        }
    }

    production = [self.productionPool objectForKey:className];
    if (production == nil || _controlView.tabAnimated.containNestAnimation) {
        view = [self _createViewWithOrigin:origin controlView:controlView indexPath:indexPath className:className currentClass:currentClass isNeedProduct:YES];
        [self _prepareProductWithView:view currentClass:currentClass indexPath:indexPath origin:origin needSync:YES needReset:_controlView.tabAnimated.containNestAnimation];
        return view;
    }
    
    view = [self _reuseWithCurrentClass:currentClass indexPath:indexPath origin:origin className:className production:production];
    return view;
}

- (void)productWithView:(nonnull UIView *)view
            controlView:(nonnull UIView *)controlView
           currentClass:(nonnull Class)currentClass
              indexPath:(nullable NSIndexPath *)indexPath
                 origin:(TABAnimatedProductOrigin)origin {
    
    if (_controlView == nil) {
        [self setControlView:controlView];
    }
    
    if (controlView.tabAnimated.viewHeight != 0) {
        controlView.tabAnimated.originViewHeight = view.frame.size.height;
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, controlView.tabAnimated.viewHeight);
    }
    
    NSString *controlerClassName = controlView.tabAnimated.targetControllerClassName;
    NSString *key = [TABAnimatedProductHelper getKeyWithControllerName:controlerClassName targetClass:currentClass frame:controlView.frame];
    TABAnimatedProduction *production = [[TABAnimatedCacheManager shareManager] getProductionWithKey:key];
    if (production) {
        TABAnimatedProduction *newProduction = production.copy;
        [self _bindWithProduction:newProduction targetView:view];
        _controlView.tabAnimated.state = TABViewAnimationRunning;
        return;
    }
    
    [self _prepareProductWithView:view currentClass:currentClass indexPath:indexPath origin:origin needSync:NO needReset:YES];
}

- (void)pullLoadingProductWithView:(nonnull UIView *)view
                       controlView:(nonnull UIView *)controlView
                      currentClass:(nonnull Class)currentClass
                         indexPath:(nullable NSIndexPath *)indexPath
                            origin:(TABAnimatedProductOrigin)origin {
    
    if (_controlView == nil) [self setControlView:controlView];
    
    NSString *controlerClassName = controlView.tabAnimated.targetControllerClassName;
    NSString *key = [TABAnimatedProductHelper getKeyWithControllerName:controlerClassName targetClass:currentClass frame:controlView.frame];
    TABAnimatedProduction *production = [[TABAnimatedCacheManager shareManager] getProductionWithKey:key];
    if (production) {
        TABAnimatedProduction *newProduction = production.copy;
        [self _bindWithProduction:newProduction targetView:view];
        return;
    }
    
    NSString *className = tab_NSStringFromClass(currentClass);
    production = [self.productionPool objectForKey:className];
    if (production == nil || _controlView.tabAnimated.containNestAnimation) {
        UIView *newView = currentClass.new;
        newView.frame = CGRectMake(0, 0, TABAnimatedProductHelperScreenWidth, ((TABFormAnimated *)controlView.tabAnimated).pullLoadingComponent.viewHeight);
        [view addSubview:newView];
        [self _prepareProductWithView:newView currentClass:currentClass indexPath:indexPath origin:origin needSync:YES needReset:NO];
        return;
    }
    
    [self _reuseProduction:production targetView:view];
}

- (void)syncProductions {
    for (NSInteger i = 0; i < self.weakTargetViewArray.count; i++) {
        UIView *view = [self.weakTargetViewArray pointerAtIndex:i];
        if (!view) return;
        view.hidden = NO;
        [self _bindWithProduction:view.tabAnimatedProduction targetView:view];
        [self _syncProduction:view.tabAnimatedProduction];
    }
    _controlView.tabAnimated.state = TABViewAnimationRunning;
    [self _recoveryProductStatus];
}

- (void)destory {
    [self _recoveryProductStatus];
    [self.darkModeManager destroy];
}

#pragma mark - Private

- (void)_recoveryProductStatus {
    _weakTargetViewArray = [NSPointerArray weakObjectsPointerArray];
    _productIndex = 0;
    _targetTagIndex = 0;
    _productFinished = NO;
}

- (void)_prepareProductWithView:(UIView *)view currentClass:(Class)currentClass indexPath:(nullable NSIndexPath *)indexPath origin:(TABAnimatedProductOrigin)origin needSync:(BOOL)needSync needReset:(BOOL)needReset {
    TABAnimatedProduction *production = view.tabAnimatedProduction;
    if (production == nil) {
        production = [TABAnimatedProduction productWithState:TABAnimatedProductionCreate];
        NSString *className = tab_NSStringFromClass(view.class);
        view.tabAnimatedProduction = production;
        if (needSync) {
            [self.productionPool setObject:production forKey:className];
        }
    }
    production.targetClass = currentClass;
    production.currentSection = indexPath.section;
    production.currentRow = indexPath.row;
    
    [self _productBackgroundLayerWithView:view needReset:needReset];
}

- (__kindof UIView *)_reuseWithCurrentClass:(Class)currentClass
                                  indexPath:(nullable NSIndexPath *)indexPath
                                     origin:(TABAnimatedProductOrigin)origin
                                  className:(NSString *)className
                                 production:(TABAnimatedProduction *)production {
    UIView *view = [self _createViewWithOrigin:origin controlView:_controlView indexPath:indexPath className:className currentClass:currentClass isNeedProduct:NO];
    if (view.tabAnimatedProduction) return view;
    [self _reuseProduction:production targetView:view];
    return view;
}

- (__kindof UIView *)_createViewWithOrigin:(TABAnimatedProductOrigin)origin
                               controlView:(UIView *)controlView
                                 indexPath:(nullable NSIndexPath *)indexPath
                                 className:(NSString *)className
                              currentClass:(Class)currentClass
                             isNeedProduct:(BOOL)isNeedProduct {
    
    NSString *prefixString = isNeedProduct ? @"tab_" : @"tab_contain_";
    NSString *identifier = [NSString stringWithFormat:@"%@%@", prefixString, className];
    UIView *view;
    
    switch (origin) {
            
        case TABAnimatedProductOriginTableViewCell: {
            view = [(UITableView *)controlView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            ((UITableViewCell *)view).selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
            
        case TABAnimatedProductOriginCollectionViewCell: {
            view = [(UICollectionView *)controlView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        }
            break;
            
        case TABAnimatedProductOriginCollectionReuseableHeaderView: {
            view = [(UICollectionView *)controlView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                       withReuseIdentifier:identifier
                                                                              forIndexPath:indexPath];
        }
            break;
            
        case TABAnimatedProductOriginCollectionReuseableFooterView: {
            view = [(UICollectionView *)controlView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                       withReuseIdentifier:identifier
                                                                              forIndexPath:indexPath];
        }
            break;
            
        case TABAnimatedProductOriginTableHeaderFooterViewCell: {
            view = [(UITableView *)controlView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
            if (view == nil) {
                view = [[currentClass alloc] initWithReuseIdentifier:identifier];
            }
        }
            break;
            
        default: {
            view = NSClassFromString(className).new;
        }
            break;
    }
    return view;
}

- (void)_reuseProduction:(TABAnimatedProduction *)production targetView:(UIView *)targetView {
    TABAnimatedProduction *newProduction = production.copy;
    if (production.state != TABAnimatedProductionCreate) {
        [self _bindWithProduction:newProduction targetView:targetView];
    }else {
        targetView.tabAnimatedProduction = newProduction;
        [production.syncDelegateManager addDelegate:targetView];
    }
}

- (void)_productBackgroundLayerWithView:(UIView *)view needReset:(BOOL)needReset {
    
    UIView *flagView;
    BOOL isCard = NO;
    
    if ([view isKindOfClass:[UITableViewCell class]] || [view isKindOfClass:[UICollectionViewCell class]]) {
        if (view.subviews.count >= 1 && view.subviews[0].layer.shadowOpacity > 0.) {
            flagView = view.subviews[0];
            isCard = YES;
        }else if (view.subviews.count >= 2 && view.subviews[1].layer.shadowOpacity > 0.) {
            flagView = view.subviews[1];
            isCard = YES;
        }
    }else if (view.layer.shadowOpacity > 0.) {
        flagView = view;
        isCard = YES;
    }
    
    if (!flagView) {
        flagView = view;
    }
    
    view.tabAnimatedProduction.backgroundLayer = [TABAnimatedProductHelper getBackgroundLayerWithView:flagView controlView:self->_controlView];
    view.tabAnimatedProduction.backgroundLayer.isCard = isCard;
    
    [self _productWithView:view needReset:needReset isCard:isCard];
}

- (void)_productWithView:(UIView *)view needReset:(BOOL)needReset isCard:(BOOL)isCard {

    [self.weakTargetViewArray addPointer:(__bridge void * _Nullable)(view)];
    [TABAnimatedProductHelper fullDataAndStartNestAnimation:view isHidden:!needReset superView:view rootView:view];
    [view layoutSubviews];
    view.hidden = YES;
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (strongSelf.weakTargetViewArray.allObjects.count == 0) return;
        if (strongSelf.productIndex > strongSelf.weakTargetViewArray.allObjects.count - 1) return;
        
        strongSelf->_targetView = [strongSelf.weakTargetViewArray pointerAtIndex:strongSelf.productIndex];
        if (!strongSelf->_targetView) return;
        
        strongSelf->_targetTagIndex = 0;
        [strongSelf _productWithTargetView:strongSelf->_targetView isCard:isCard];
        
        if (needReset) {
            [TABAnimatedProductHelper resetData:strongSelf->_targetView];
        }
        strongSelf.productIndex++;
        
    });
}

- (void)_productWithTargetView:(UIView *)targetView isCard:(BOOL)isCard {
    @autoreleasepool {
        if (!_controlView) return;
        TABAnimatedProduction *production = targetView.tabAnimatedProduction;
        NSString *controlerClassName = _controlView.tabAnimated.targetControllerClassName;
        production.fileName = [TABAnimatedProductHelper getKeyWithControllerName:controlerClassName targetClass:production.targetClass frame:_controlView.frame];
        NSMutableArray <TABComponentLayer *> *layerArray = @[].mutableCopy;
        NSMutableDictionary <NSString *, TABComponentLayer *> *layerDict = @{}.mutableCopy;
        // producting
        [self _recurseProductLayerWithView:targetView array:layerArray dict:layerDict production:production isCard:isCard];
        // adjusting
        [self _chainAdjustWithBackgroundLayer:production.backgroundLayer layers:layerArray tabAnimated:_controlView.tabAnimated targetClass:production.targetClass];
        // binding
        production.state = TABAnimatedProductionBind;
        production.layers = layerArray;
        targetView.tabAnimatedProduction = production;
        // caching
        [[TABAnimatedCacheManager shareManager] cacheProduction:production];
        // caculating recommendHeight
        if (_controlView.tabAnimated.recommendHeightBlock) {
            _controlView.tabAnimated.recommendHeightBlock(targetView.class, [production recommendHeight]);
        }
    }
}

#pragma mark -

- (void)_recurseProductLayerWithView:(UIView *)view
                               array:(NSMutableArray <TABComponentLayer *> *)array
                               dict:(NSMutableDictionary *)dict
                          production:(TABAnimatedProduction *)production
                              isCard:(BOOL)isCard {
    [self _recurseProductLayerWithView:view rootView:view array:array dict:dict isCard:isCard];
}

- (void)_recurseProductLayerWithView:(UIView *)view
                            rootView:(UIView *)rootView
                               array:(NSMutableArray <TABComponentLayer *> *)array
                                dict:(NSMutableDictionary *)dict
                              isCard:(BOOL)isCard {
    
    NSArray *subViews = [view subviews];
    if ([subViews count] == 0) return;
    
    for (int i = 0; i < subViews.count;i++) {
        
        UIView *subV = subViews[i];
        if (subV.tabAnimated) continue;
        
        if ([self _withoutSubViewsWithView:view tabAnimated:_controlView.tabAnimated]) continue;
        
        BOOL stopRes = NO;
        if (subV.class == _controlView.tabAnimated.withoutSubViewsClass) {
            stopRes = YES;
        }else {
            [self _recurseProductLayerWithView:subV rootView:rootView array:array dict:dict isCard:isCard];
        }
        
        if ([self _cannotBeCreated:subV superView:view rootView:rootView]) continue;
        // 标记移除：会生成动画对象，但是会被设置为移除状态
        BOOL needRemove = [self _isNeedRemove:subV];
        // 生产
        TABComponentLayer *layer;
        if (stopRes || [TABAnimatedProductHelper canProduct:subV tabAnimated:_controlView.tabAnimated]) {
            UIColor *animatedColor = [_controlView.tabAnimated getCurrentAnimatedColorWithCollection:_controlView.traitCollection];
            layer = [self _createLayerWithView:subV needRemove:needRemove color:animatedColor isCard:isCard];
            layer.serializationImpl = _controlView.tabAnimated.serializationImpl;
            layer.tagIndex = self->_targetTagIndex;
            layer.tagName = subV.tab_name;
            [array addObject:layer];

            NSString *key = [NSString stringWithFormat:@"%ld", layer.tagIndex];
            dict[key] = layer;
            if (layer.tagName) {
                dict[layer.tagName] = layer;
            }
            
            _targetTagIndex++;
        }
    }
}

- (TABComponentLayer *)_createLayerWithView:(UIView *)view needRemove:(BOOL)needRemove color:(UIColor *)color isCard:(BOOL)isCard {
    
    TABComponentLayer *layer = TABComponentLayer.new;
    if (needRemove) {
        layer.loadStyle = TABViewLoadAnimationRemove;
        return layer;
    }
    
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *lab = (UILabel *)view;
        layer.numberOflines = lab.numberOfLines;
        if (lab.textAlignment == NSTextAlignmentCenter) {
            layer.origin = TABComponentLayerOriginCenterLabel;
        }else {
            layer.origin = TABComponentLayerOriginLabel;
        }
    }else {
        layer.numberOflines = 1;
        if ([view isKindOfClass:[UIImageView class]]) {
            layer.origin = TABComponentLayerOriginImageView;
        }else if([view isKindOfClass:[UIButton class]]) {
            layer.origin = TABComponentLayerOriginButton;
        }
    }
    
    CGRect rect;
    if (isCard) {
        rect = view.frame;
    }else {
        rect = [_targetView convertRect:view.frame fromView:view.superview];
    }
    layer.originFrame = rect;
    rect = [layer resetFrameWithRect:rect animatedHeight:_controlView.tabAnimated.animatedHeight];
    
    layer.frame = rect;
    
    if (layer.contents) {
        layer.backgroundColor = UIColor.clearColor.CGColor;
    }else if (layer.backgroundColor == nil) {
        layer.backgroundColor = color.CGColor;
    }
    
    CGFloat cornerRadius = view.layer.cornerRadius;
    if (cornerRadius == 0.) {
        if (_controlView.tabAnimated.cancelGlobalCornerRadius) {
            layer.cornerRadius = _controlView.tabAnimated.animatedCornerRadius;
        }else if ([TABAnimated sharedAnimated].useGlobalCornerRadius) {
            if ([TABAnimated sharedAnimated].animatedCornerRadius != 0.) {
                layer.cornerRadius = [TABAnimated sharedAnimated].animatedCornerRadius;
            }else {
                layer.cornerRadius = layer.frame.size.height / 2.0;
            }
        }
    }else {
        layer.cornerRadius = cornerRadius;
    }
    
    if (layer.origin == TABComponentLayerOriginButton) {
        [self _buttonLayerSyncProperties:(UIButton *)view layer:layer];
    }
    
    return layer;
}

- (void)_buttonLayerSyncProperties:(UIButton *)button layer:(TABComponentLayer *)layer {
    if(button.currentBackgroundImage) layer.contents = (id)(button.currentBackgroundImage.CGImage);
    if (layer.contents) {
        layer.masksToBounds = YES;
        layer.backgroundColor = UIColor.clearColor.CGColor;
        return;
    }
    for (CALayer *subLayer in button.layer.sublayers) {
        if ([subLayer isKindOfClass:[CAGradientLayer class]]) {
            CAGradientLayer *gLayer = (CAGradientLayer *)subLayer;
            layer.contents = gLayer.contents;
            layer.colors = gLayer.colors;
            layer.locations = gLayer.locations;
            layer.startPoint = gLayer.startPoint;
            layer.endPoint = gLayer.endPoint;
            layer.backgroundColor = UIColor.clearColor.CGColor;
            return;
        }
    }
}

#pragma mark -

- (BOOL)_withoutSubViewsWithView:(UIView *)view tabAnimated:(TABViewAnimated *)tabAnimated {
    if ([view isKindOfClass:[UITextField class]] && !tabAnimated.needToCreateTextFieldLayer) {
        return YES;
    }
    if ([view isKindOfClass:[UITextView class]]) {
        return YES;
    }
    return NO;
}

- (BOOL)_cannotBeCreated:(UIView *)view superView:(UIView *)superView rootView:(UIView *)rootView {
    
    if ([view isKindOfClass:[NSClassFromString(@"UITableViewCellContentView") class]] ||
        [view isKindOfClass:[NSClassFromString(@"UICollectionViewCellContentView") class]] ||
        [view isKindOfClass:[NSClassFromString(@"_UISystemBackgroundView") class]] ||
        [view isKindOfClass:[NSClassFromString(@"_UITableViewHeaderFooterViewBackground") class]] ||
        [view isKindOfClass:[NSClassFromString(@"_UIScrollViewScrollIndicator") class]]) {
        return YES;
    }
    
    // 过滤和目标view一样大小的view, 同时需要排除_UITableViewHeaderFooterContentView
    // 和历史版本有关，这个只能向下兼容
    if ((CGRectEqualToRect(view.bounds, rootView.bounds)
         || view.bounds.size.width > rootView.bounds.size.width
         || view.bounds.size.height > rootView.bounds.size.height)
         && ![view isKindOfClass:[NSClassFromString(@"_UITableViewHeaderFooterContentView") class]]
        && ![view isKindOfClass:[UILabel class]]
        && ![view isKindOfClass:[UIButton class]]
        && ![view isKindOfClass:[UIImageView class]]) {
        return YES;
    }
    
    // 移除UITableView/UICollectionView的滚动条
    if ([superView isKindOfClass:[UIScrollView class]]) {
        if (((view.frame.size.height < 3.) || (view.frame.size.width < 3.)) &&
            view.alpha == 0.) {
            return YES;
        }
    }
    
    return NO;
}

/// 标记移除函数
/// @param view 目标view
- (BOOL)_isNeedRemove:(UIView *)view {
    
    BOOL needRemove = NO;
    // 标记移除
    if ([view isKindOfClass:[NSClassFromString(@"_UITableViewCellSeparatorView") class]]  ||
        [view isKindOfClass:[NSClassFromString(@"_UITableViewHeaderFooterContentView") class]]) {
        needRemove = YES;
    }
    
    // 通过过滤条件标记移除移除
    if (_controlView.tabAnimated.filterSubViewSize.width > 0) {
        if (view.frame.size.width <= _controlView.tabAnimated.filterSubViewSize.width) {
            needRemove = YES;
        }
    }
    
    if (_controlView.tabAnimated.filterSubViewSize.height > 0) {
        if (view.frame.size.height <= _controlView.tabAnimated.filterSubViewSize.height) {
            needRemove = YES;
        }
    }
    
    return needRemove;
}

- (void)_chainAdjustWithBackgroundLayer:(TABComponentLayer *)backgroundLayer
                                 layers:(NSMutableArray <TABComponentLayer *> *)layers
                            tabAnimated:(TABViewAnimated *)tabAnimated
                            targetClass:(Class)targetClass {
    UIColor *animatedColor = [tabAnimated getCurrentAnimatedColorWithCollection:_controlView.traitCollection];
    if (tabAnimated.adjustBlock) {
        [self.chainManager chainAdjustWithBackgroundLayer:backgroundLayer layers:layers adjustBlock:tabAnimated.adjustBlock animatedColor:animatedColor];
    }
    if (tabAnimated.adjustWithClassBlock) {
        [self.chainManager chainAdjustWithBackgroundLayer:backgroundLayer layers:layers adjustWithClassBlock:tabAnimated.adjustWithClassBlock targetClass:targetClass animatedColor:animatedColor];
    }
}

- (void)_syncProduction:(TABAnimatedProduction *)production {
    @autoreleasepool {
        NSArray <UIView *> *array = [production.syncDelegateManager getDelegates];
        for (UIView *view in array) {
            TABAnimatedProduction *newProduction = view.tabAnimatedProduction;
            newProduction.backgroundLayer = production.backgroundLayer.copy;
            for (TABComponentLayer *layer in production.layers) {
                [newProduction.layers addObject:layer.copy];
            }
            [self _bindWithProduction:newProduction targetView:view];
        }
    }
}

- (void)_bindWithProduction:(TABAnimatedProduction *)production targetView:(UIView *)targetView {
    [TABAnimatedProductHelper bindView:targetView production:production animatedHeight:_controlView.tabAnimated.animatedHeight];
    [self.darkModeManager addNeedChangeView:targetView];
    [_animationManager addAnimationWithTargetView:targetView];
}

#pragma mark - Getter / Setter

- (void)setProductIndex:(NSInteger)productIndex {
    _productIndex = productIndex;
    if (productIndex >= self.weakTargetViewArray.allObjects.count) {
        self.productFinished = YES;
    }
}

- (void)setProductFinished:(BOOL)productFinished {
    _productFinished = productFinished;
    if (productFinished) {
        [self syncProductions];
    }
}

- (void)setControlView:(UIView *)controlView {
    _controlView = controlView;
    [_animationManager setControlView:controlView];
    if (_darkModeManager) {
        [_darkModeManager setControlView:controlView];
        [_darkModeManager addDarkModelSentryView];
    }
}

- (NSMutableDictionary *)productionPool {
    if (!_productionPool) {
        _productionPool = @{}.mutableCopy;
    }
    return _productionPool;
}

- (id <TABAnimatedChainManagerInterface>)chainManager {
    if (!_chainManager) {
        _chainManager = TABAnimatedChainManagerImpl.new;
    }
    return _chainManager;
}

@end
