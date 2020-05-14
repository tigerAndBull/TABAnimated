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
#import "TABComponentManager.h"

#import "TABViewAnimated.h"
#import "UIView+TABControlModel.h"

#import "TABAnimatedDarkModeInterface.h"
#import "TABComponentLayer.h"
#import "TABWeakDelegateManager.h"
#import "TABAnimatedCacheManager.h"

#import "UIView+TABAnimatedProduction.h"

#import "TABAnimatedDarkModeManagerInterface.h"
#import "TABAnimatedDarkModeManagerImpl.h"

static const char *kProductionQueue = "com.tigerAndBull.productionQueue";

@interface TABAnimatedProductImpl() {
    // self存在即存在
    __unsafe_unretained UIView *_controlView;
    // 进入加工流时，会取出targetView，结束时释放。加工流只会在持有targetView的controlView存在时执行。
    __unsafe_unretained UIView *_targetView;
}

@property (nonatomic, strong) NSMutableArray <UIView *> *targetViewArray;
@property (nonatomic, strong) NSMutableDictionary <NSString *, TABAnimatedProduction *> *productionPool;

@property (nonatomic, assign) BOOL productFinished;
@property (nonatomic, assign) NSInteger productIndex;

// 模式切换管理者
@property (nonatomic, strong) id <TABAnimatedDarkModeManagerInterface> darkModeManager;

@end

@implementation TABAnimatedProductImpl

- (instancetype)init {
    if (self = [super init]) {
        _darkModeManager = TABAnimatedDarkModeManagerImpl.new;
    }
    return self;
}

#pragma mark - TABAnimatedProductInterface

// 根据className，取cell状态
// 取完cell后
// 1. 池子没有production 取母cell production 生成、加工、装饰 需要实时同步
// 2. 池子有production 创建完状态，取子cell 需要等待同步 cell没有production，刚创建状态 取子cell，等待同步 绑定
// 3. 池子有production 加工完状态\绑定完状态， 取子cell，copy一份，绑定
- (__kindof UIView *)productWithControlView:(UIView *)controlView
                               currentClass:(Class)currentClass
                                  indexPath:(nullable NSIndexPath *)indexPath
                                     origin:(TABAnimatedProductOrigin)origin {
    
    if (_controlView == nil) {
        [self setControlView:controlView];
    }
    
    NSString *className = [TABAnimatedProductHelper getClassNameWithTargetClass:currentClass];
    UIView *view;
    
    // 执行缓存工作流
    NSString *key = [TABAnimatedProductHelper getKeyWithControllerName:controlView.tabAnimated.targetControllerClassName targetClass:currentClass];
    TABAnimatedProduction *production = [[TABAnimatedCacheManager shareManager] getProductionWithKey:key];
    if (production) {
        view = [self _createViewWithOrigin:origin controlView:controlView indexPath:indexPath className:className currentClass:currentClass isNeedProduct:NO];
        if (view.tabAnimatedProduction) return view;
        [TABAnimatedProductHelper bindView:view production:production];
        [self.darkModeManager addNeedChangeView:view];
        return view;
    }

    // 执行加工流
    // 同步数据到池子里
    // 给需要同步的cell同步数据
    production = [self.productionPool objectForKey:className];
    if (production == nil || _controlView.tabAnimated.isNest) {
        view = [self _createViewWithOrigin:origin controlView:controlView indexPath:indexPath className:className currentClass:currentClass isNeedProduct:YES];
        [self _productWithView:view currentClass:currentClass indexPath:indexPath origin:origin needSync:YES needReset:NO];
    }else {
        view = [self _createViewWithOrigin:origin controlView:controlView indexPath:indexPath className:className currentClass:currentClass isNeedProduct:NO];
        if (view.tabAnimatedProduction) return view;
        if (production.state == TABAnimatedProductionCreate) {
            TABAnimatedProduction *newProduction = production.copy;
            view.tabAnimatedProduction = newProduction;
            // 等待同步
            [production.syncDelegateManager addDelegate:view];
        }else {
            TABAnimatedProduction *newProduction = production.copy;
            [TABAnimatedProductHelper bindView:view production:newProduction];
            [self.darkModeManager addNeedChangeView:view];
        }
    }
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
    [self productWithView:view currentClass:currentClass indexPath:indexPath origin:origin];
}

- (void)productWithView:(UIView *)view
           currentClass:(Class)currentClass
              indexPath:(nullable NSIndexPath *)indexPath
                 origin:(TABAnimatedProductOrigin)origin {
    [self _productWithView:view currentClass:currentClass indexPath:indexPath origin:origin needSync:NO needReset:YES];
}

// 同步
- (void)syncProductions {
    for (NSInteger i = 0; i < self.targetViewArray.count; i++) {
        UIView *view = self.targetViewArray[i];
        view.hidden = NO;
        [TABAnimatedProductHelper bindView:view production:view.tabAnimatedProduction];
        [self.darkModeManager addNeedChangeView:view];
        [self _syncProduction:view.tabAnimatedProduction];
    }
}

- (void)destory {
    [self.darkModeManager destroy];
    [self.targetViewArray removeAllObjects];
}

#pragma mark - Private

- (void)_productWithView:(UIView *)view
            currentClass:(Class)currentClass
               indexPath:(nullable NSIndexPath *)indexPath
                  origin:(TABAnimatedProductOrigin)origin
                needSync:(BOOL)needSync
               needReset:(BOOL)needReset {
    TABAnimatedProduction *production = view.tabAnimatedProduction;
    if (production == nil) {
        production = [TABAnimatedProduction productWithState:TABAnimatedProductionCreate];
        NSString *className = [TABAnimatedProductHelper getClassNameWithTargetClass:view.class];
        [self->_productionPool setObject:production forKey:className];
        view.tabAnimatedProduction = production;
    }
    production.targetClass = currentClass;
    production.currentSection = indexPath.section;
    production.currentRow = indexPath.row;
    production.backgroundLayer = [TABAnimatedProductHelper getBackgroundLayerWithView:view controlView:self->_controlView];
    [self _productWithView:view needSync:needSync needReset:needReset];
}

- (void)_productWithView:(UIView *)view needSync:(BOOL)needSync needReset:(BOOL)needReset {

    [self.targetViewArray addObject:view];
    [TABAnimatedProductHelper fullData:view];
    [self _startSearchNestView:view rootView:view];
    view.hidden = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.targetViewArray.count == 0) return;
        if (self.productIndex > self.targetViewArray.count-1) return;
        // 从等待队列中取出需要加工的view
        self->_targetView = self.targetViewArray[self.productIndex];
        // 生产流水
        [self _productWithTargetView:self->_targetView];
        self.productIndex++;
        
        if (needReset) {
            [TABAnimatedProductHelper resetData:self->_targetView];
        }else {
            [TABAnimatedProductHelper hiddenSubViews:self->_targetView];
        }
    });
}

- (void)_productWithTargetView:(UIView *)targetView {
    @autoreleasepool {
        TABAnimatedProduction *production = targetView.tabAnimatedProduction;
        production.fileName = [TABAnimatedProductHelper getKeyWithControllerName:_controlView.tabAnimated.targetControllerClassName targetClass:production.targetClass];
        
        NSMutableArray <TABComponentLayer *> *layerArray = @[].mutableCopy;
        // 生产
        [self _recurseProductLayerWithView:targetView array:layerArray production:production tagIndex:0];
        // 加工
        [self _processWithArray:layerArray tabAnimated:_controlView.tabAnimated targetClass:production.targetClass];
        // 绑定
        production.state = TABAnimatedProductionBind;
        production.layers = layerArray;
        targetView.tabAnimatedProduction = production;

        // 缓存
        [[TABAnimatedCacheManager shareManager] cacheProduction:production];
    }
}

- (void)setProductIndex:(NSInteger)productIndex {
    _productIndex = productIndex;
    if (productIndex >= self.targetViewArray.count) {
        self.productFinished = YES;
    }
}

- (void)setProductFinished:(BOOL)productFinished {
    _productFinished = productFinished;
    if (productFinished) {
        [self syncProductions];
    }
}

#pragma mark -

- (__kindof UIView *)_createViewWithOrigin:(TABAnimatedProductOrigin)origin
                               controlView:(UIView *)controlView
                                 indexPath:(nullable NSIndexPath *)indexPath
                                 className:(NSString *)className
                              currentClass:(Class)currentClass
                             isNeedProduct:(BOOL)isNeedProduct {
    
    NSString *prefixString;
    if (isNeedProduct) {
        prefixString = @"tab_";
    }else {
        prefixString = @"tab_contain_";
    }
    
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

- (void)_recurseProductLayerWithView:(UIView *)view
                               array:(NSMutableArray <TABComponentLayer *> *)array
                          production:(TABAnimatedProduction *)production
                            tagIndex:(NSInteger)tagIndex {
    
    UIView *flagView;
    
    if ([view isKindOfClass:[UITableViewCell class]] ||
        [view isKindOfClass:[UICollectionViewCell class]]) {
        if (view.subviews.count >= 2 && view.subviews[1].layer.shadowOpacity > 0.) {
            flagView = view.subviews[1];
        }else if (view.subviews[0].subviews.count != 0 &&
                  view.subviews[0].subviews[0].layer.shadowOpacity > 0.) {
            flagView = view.subviews[0].subviews[0];
        }
    }else if (view.subviews[0].layer.shadowOpacity > 0.) {
        flagView = view.subviews[0];
    }
    
    if (flagView) {
        flagView.hidden = YES;
        production.backgroundLayer = [TABAnimatedProductHelper getBackgroundLayerWithView:flagView controlView:self->_controlView];
    }else {
        flagView = view;
    }
    
    [self _recurseProductLayerWithView:view flagView:view array:array tagIndex:tagIndex];
}

- (void)_recurseProductLayerWithView:(UIView *)view
                            flagView:(UIView *)flagView
                               array:(NSMutableArray <TABComponentLayer *> *)array
                            tagIndex:(NSInteger)tagIndex {
    
    NSArray *subViews;
    subViews = [view subviews];
    if ([subViews count] == 0) return;
    
    for (int i = 0; i < subViews.count;i++) {
        
        UIView *subV = subViews[i];
        
        [self _recurseProductLayerWithView:subV flagView:flagView array:array tagIndex:0];
        
        if ([subV.superview isKindOfClass:[UITableViewCell class]] ||
            [subV.superview isKindOfClass:[UICollectionViewCell class]] ||
            [subV.superview isKindOfClass:[UITableViewHeaderFooterView class]]) {
            // 此处排除cell中的contentView，不生成动画对象
            if (i == 0) {
                continue;
            }
        }
        
        // 移除UITableView/UICollectionView的滚动条
        if ([view isKindOfClass:[UIScrollView class]]) {
            if (((subV.frame.size.height < 3.) || (subV.frame.size.width < 3.)) &&
                subV.alpha == 0.) {
                continue;
            }
        }
        
        // 标记移除：会生成动画对象，但是会被设置为移除状态
        BOOL needRemove = [self _isNeedRemove:subV];
        // 生产
        TABComponentLayer *layer;
        if ([TABAnimatedProductHelper canProduct:subV]) {

            UIColor *animatedColor = [_controlView.tabAnimated getCurrentAnimatedColorWithCollection:_controlView.traitCollection];
            layer = [self _createLayerWithView:subV flagView:flagView needRemove:needRemove color:animatedColor];
            layer.tagIndex = tagIndex;
            [array addObject:layer];
            
            tagIndex++;
        }
    }
}

- (void)_processWithArray:(NSMutableArray <TABComponentLayer *> *)array
              tabAnimated:(TABViewAnimated *)tabAnimated
              targetClass:(Class)targetClass {
    TABComponentManager *manager = [TABComponentManager managerWithLayers:array];
    if (tabAnimated.adjustBlock) {
        tabAnimated.adjustBlock(manager);
    }
    if (targetClass && tabAnimated.adjustWithClassBlock) {
        tabAnimated.adjustWithClassBlock(manager, targetClass);
    }
}

- (void)_syncProduction:(TABAnimatedProduction *)production {
    @autoreleasepool {
        NSArray <UIView *> *array = [production.syncDelegateManager getDelegates];
        dispatch_queue_t queue = dispatch_queue_create(kProductionQueue, DISPATCH_QUEUE_CONCURRENT);
        for (UIView *view in array) {
            dispatch_async(queue, ^{
                TABAnimatedProduction *newProduction = view.tabAnimatedProduction;
                newProduction.backgroundLayer = production.backgroundLayer.copy;
                for (TABComponentLayer *layer in production.layers) {
                    [newProduction.layers addObject:layer.copy];
                }
                // 绑定
                dispatch_async(dispatch_get_main_queue(), ^{
                    [TABAnimatedProductHelper bindView:view production:newProduction];
                    [self.darkModeManager addNeedChangeView:view];
                });
            });
        }
    }
}

- (TABComponentLayer *)_createLayerWithView:(UIView *)view flagView:(UIView *)flagView needRemove:(BOOL)needRemove color:(UIColor *)color {
    
    TABComponentLayer *layer = TABComponentLayer.new;
    if (needRemove) {
        layer.loadStyle = TABViewLoadAnimationRemove;
        return layer;
    }
    
    // 类型
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *lab = (UILabel *)view;
        layer.numberOflines = lab.numberOfLines;
        if (lab.textAlignment == NSTextAlignmentCenter) {
            layer.origin = TABComponentLayerOriginCenterLabel;
            layer.contentsGravity = kCAGravityCenter;
        }
    }else {
        layer.numberOflines = 1;
        if ([view isKindOfClass:[UIImageView class]]) {
            layer.origin = TABComponentLayerOriginImageView;
        }else if([view isKindOfClass:[UIButton class]]) {
            layer.origin = TABComponentLayerOriginButton;
        }
    }
    
    // 坐标转换
    CGRect rect = [flagView convertRect:view.frame fromView:view.superview];
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
                layer.cornerRadius = layer.frame.size.height/2.0;
            }
        }
    }else {
        layer.cornerRadius = cornerRadius;
    }
    return layer;
}

- (BOOL)_isNeedRemove:(UIView *)view {
    
    BOOL needRemove = NO;
    // 分割线需要标记移除
    if ([view isKindOfClass:[NSClassFromString(@"_UITableViewCellSeparatorView") class]] ||
        [view isKindOfClass:[NSClassFromString(@"_UITableViewHeaderFooterContentView") class]] ||
        [view isKindOfClass:[NSClassFromString(@"_UITableViewHeaderFooterViewBackground") class]]) {
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

- (void)_startSearchNestView:(UIView *)view rootView:(UIView *)rootView {
    
    NSArray *subViews = [view subviews];
    if ([subViews count] == 0) return;
    
    for (int i = 0; i < subViews.count;i++) {
        
        UIView *subV = subViews[i];
        [self _startSearchNestView:subV rootView:rootView];
        
        if (subV.tabAnimated && ![subV isEqual:_controlView]) {
            // 嵌套处理，先保留
            // 获取index，存储下来
            if (_controlView.tabAnimated.targetControllerClassName) {
                subV.tabAnimated.targetControllerClassName = _controlView.tabAnimated.targetControllerClassName;
            }
            [subV tab_startAnimation];
        }
    }
}

#pragma mark - Getter / Setter

- (void)setControlView:(UIView *)controlView {
    _controlView = controlView;
    [_darkModeManager setControlView:controlView];
    [_darkModeManager addDarkModelSentryView];
}

- (NSMutableArray *)targetViewArray {
    if (!_targetViewArray) {
        _targetViewArray = @[].mutableCopy;
    }
    return _targetViewArray;
}

- (NSMutableDictionary *)productionPool {
    if (!_productionPool) {
        _productionPool = @{}.mutableCopy;
    }
    return _productionPool;
}

@end
