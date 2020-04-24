//
//  TABComponentManager.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/7/16.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABComponentManager.h"

#import <UIKit/UIKit.h>

#import "TABAnimated.h"

#import "TABViewAnimated.h"
#import "TABBaseComponent.h"
#import "TABComponentLayer.h"
#import "TABAnimatedCacheManager.h"
#import "TABManagerMethod.h"

static const CGFloat kDefaultHeight = 16.f;
static const CGFloat kTagDefaultFontSize = 12.f;

static NSString * const kTagDefaultFontName = @"HiraKakuProN-W3";

@interface TABComponentManager()

@property (nonatomic, strong) NSMutableArray <TABBaseComponent *> *baseComponentArray;
@property (nonatomic, strong, readwrite) NSMutableArray <TABComponentLayer *> *componentLayerArray;
@property (nonatomic, strong, readwrite) NSMutableArray <TABComponentLayer *> *resultLayerArray;

@property (nonatomic, assign, readwrite) NSInteger dropAnimationCount;
@property (nonatomic, assign, readwrite) BOOL haveCachedWithDisk;

@property (nonatomic, weak) UIView *superView;
@property (nonatomic, weak, readwrite, nullable) TABSentryView *sentryView;

@end

@implementation TABComponentManager

#pragma mark - Init Method

+ (instancetype)initWithView:(UIView *)view
                   superView:(UIView *)superView
                 tabAnimated:(TABViewAnimated *)tabAnimated {
    TABComponentManager *manager = [self initWithView:view
                                            superView:superView];
    manager.animatedHeight = tabAnimated.animatedHeight;
    manager.animatedCornerRadius = tabAnimated.animatedCornerRadius;
    manager.cancelGlobalCornerRadius = tabAnimated.cancelGlobalCornerRadius;
    [manager setRadiusAndColorWithView:view
                             superView:superView
                           tabAnimated:tabAnimated];
    return manager;
}

+ (instancetype)initWithView:(UIView *)view
                   superView:(UIView *)superView {
    TABComponentManager *manager = [[TABComponentManager alloc] init];
    manager.superView = superView;
    if (view.frame.size.width > 0.) {
        if ([superView isKindOfClass:[UITableView class]]) {
            UITableView *tableView = (UITableView *)superView;
            if (view.frame.size.width != [UIScreen mainScreen].bounds.size.width) {
                manager.tabLayer.frame = CGRectMake(view.bounds.origin.x, view.bounds.origin.y, [UIScreen mainScreen].bounds.size.width, tableView.rowHeight);
            }else {
                manager.tabLayer.frame = view.bounds;
            }
        }else {
            manager.tabLayer.frame = view.bounds;
        }
    }else {
        manager.tabLayer.frame = CGRectMake(view.bounds.origin.x, view.bounds.origin.y, [UIScreen mainScreen].bounds.size.width, view.bounds.size.height);
    }
    
    [view.layer addSublayer:manager.tabLayer];
    
    if (view && superView) {
        // 添加哨兵视图
        [manager addSentryView:view
                     superView:superView];
    }
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        _resultLayerArray = @[].mutableCopy;
        _baseComponentArray = @[].mutableCopy;
        _componentLayerArray = @[].mutableCopy;
        
        _tabLayer = TABComponentLayer.new;
        _tabLayer.opaque = YES;
        _tabLayer.name = @"TABLayer";
        _tabLayer.position = CGPointMake(0, 0);
        _tabLayer.anchorPoint = CGPointMake(0, 0);
        _tabLayer.contentsScale = ([[UIScreen mainScreen] scale] > 3.0) ? [[UIScreen mainScreen] scale]:3.0;
    }
    return self;
}

- (void)reAddToView:(UIView *)view
          superView:(UIView *)superView {
    
    self.superView = superView;
    
    if (view.frame.size.width > 0.) {
        self.tabLayer.frame = view.bounds;
    }else {
        self.tabLayer.frame = CGRectMake(view.bounds.origin.x, view.bounds.origin.y, [UIScreen mainScreen].bounds.size.width, view.bounds.size.height);
    }
    [view.layer addSublayer:self.tabLayer];
    
    [self addSentryView:view
              superView:superView];
    
    [self setRadiusAndColorWithView:view
                          superView:superView
                        tabAnimated:superView.tabAnimated];
    [self updateComponentLayersWithArray:self.resultLayerArray];
}

#pragma mark - Public Method

- (TABBaseComponentBlock _Nullable)animation {
    return ^TABBaseComponent *(NSInteger index) {
        if (index >= self.baseComponentArray.count) {
            NSAssert(NO, @"Array bound, please check it carefully.");
            return [TABBaseComponent initWithComponentLayer:TABComponentLayer.new];
        }
        return self.baseComponentArray[index];
    };
}

- (TABBaseComponentArrayBlock _Nullable)animations {
    return ^NSArray <TABBaseComponent *> *(NSInteger location, NSInteger length) {
        
        if (location + length > self.baseComponentArray.count) {
            NSAssert(NO, @"Array bound, please check it carefully.");
            return NSArray.new;
        }
        
        NSMutableArray <TABBaseComponent *> *tempArray = @[].mutableCopy;
        for (NSInteger i = location; i < location+length; i++) {
            TABBaseComponent *layer = self.baseComponentArray[i];
            [tempArray addObject:layer];
        }
        
        // 修改添加  需要查看数组内容  length == 0 && location == 0 是返回整个数组   xiaoxin
        if (length == 0 && location == 0) {
            tempArray = self.baseComponentArray.mutableCopy;
        }
        
        return tempArray.mutableCopy;
    };
}

- (TABBaseComponentArrayWithIndexsBlock)animationsWithIndexs {
    return ^NSArray <TABBaseComponent *> *(NSInteger index,...) {
        
        NSMutableArray <TABBaseComponent *> *resultArray = @[].mutableCopy;
        
        if (index >= self.baseComponentArray.count) {
            NSAssert(NO, @"Array bound, please check it carefully.");
            [resultArray addObject:[TABBaseComponent initWithComponentLayer:TABComponentLayer.new]];
        }else {
            if(index < 0) {
                NSAssert(NO, @"Input data contains a number < 0, please check it carefully.");
                [resultArray addObject:[TABBaseComponent initWithComponentLayer:TABComponentLayer.new]];
            }else {
                [resultArray addObject:self.baseComponentArray[index]];
            }
        }
        
        // 定义一个指向个数可变的参数列表指针
        va_list args;
        // 用于存放取出的参数
        NSInteger arg;
        // 初始化上面定义的va_list变量，这个宏的第二个参数是第一个可变参数的前一个参数，是一个固定的参数
        va_start(args, index);
        // 遍历全部参数 va_arg返回可变的参数(a_arg的第二个参数是你要返回的参数的类型)
        while ((arg = va_arg(args, NSInteger))) {
            
            if(arg >= 0) {
                
                if (arg > 1000) {
                    break;
                }
                
                if (arg >= self.baseComponentArray.count) {
                    NSAssert(NO, @"Array bound, please check it carefully.");
                    [resultArray addObject:[TABBaseComponent initWithComponentLayer:TABComponentLayer.new]];
                }else {
                    if(arg < 0) {
                        NSAssert(NO, @"Input data contains a number < 0, please check it carefully.");
                        [resultArray addObject:[TABBaseComponent initWithComponentLayer:TABComponentLayer.new]];
                    }else {
                        [resultArray addObject:self.baseComponentArray[arg]];
                    }
                }
            }
        }
        // 清空参数列表，并置参数指针args无效
        va_end(args);
        return resultArray.copy;
    };
}

#pragma mark -

- (void)addSentryView:(UIView *)view
            superView:(UIView *)superView {
    if (@available(iOS 13.0, *)) {
        TABSentryView *sentryView = TABSentryView.new;
        _sentryView = sentryView;
        // avoid retain cycle
        __weak typeof(self) weakSelf = self;
        __weak typeof(superView) weakSuperView = superView;
        self.sentryView.traitCollectionDidChangeBack = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            __strong typeof(weakSuperView) strongSuperView = weakSuperView;
            [strongSelf tab_traitCollectionDidChange:strongSuperView];
        };
        [view addSubview:sentryView];
    }
}

- (void)installBaseComponentArray:(NSArray <TABComponentLayer *> *)array {
    self.componentLayerArray = array.mutableCopy;
    [self.baseComponentArray removeAllObjects];
    for (NSInteger i = 0; i < array.count; i++) {
        TABBaseComponent *component = [TABBaseComponent initWithComponentLayer:array[i]];
        [self.baseComponentArray addObject:component];
    }
}

- (void)updateComponentLayersWithArray:(NSMutableArray <TABComponentLayer *> *)componentLayerArray {
    for (int i = 0; i < componentLayerArray.count; i++) {
        TABComponentLayer *layer = componentLayerArray[i];
        layer.backgroundColor = self.animatedColor.CGColor;
        
        if (layer.placeholderName && layer.placeholderName.length > 0) {
            layer.contents = (id)[UIImage imageNamed:layer.placeholderName].CGImage;
        }
        
        // 设置伸缩动画
        if (layer.loadStyle != TABViewLoadAnimationWithOnlySkeleton) {
            [layer addAnimation:[self getAnimationWithLoadStyle:layer.loadStyle] forKey:TABAnimatedLocationAnimation];
        }
        
        if (self.dropAnimationCount < layer.dropAnimationIndex) {
            self.dropAnimationCount = layer.dropAnimationIndex;
        }
        
        [self.tabLayer addSublayer:layer];
        
        // 添加红色标记
#ifdef DEBUG
        if ([TABAnimated sharedAnimated].openAnimationTag) {
            BOOL isFromLines = (layer.numberOflines != 1) ? YES : NO;
            if (layer.tagIndex != TABViewAnimatedErrorCode) {
                [self addAnimatedTagWithComponentLayer:layer
                                                 index:layer.tagIndex
                                          isFromeLines:isFromLines];
            }
        }
#endif
    }
}

- (void)updateComponentLayers {
    
    [self.resultLayerArray removeAllObjects];
    
    for (NSInteger i = 0; i < self.baseComponentArray.count; i++) {
        
        TABBaseComponent *component = self.baseComponentArray[i];
        TABComponentLayer *layer = component.layer;
        
        if (layer.loadStyle == TABViewLoadAnimationRemove) {
            continue;
        }
        
        CGRect rect = [self resetFrame:layer
                                  rect:layer.frame];
        layer.frame = rect;
        
        CGFloat cornerRadius = layer.cornerRadius;
        NSInteger labelLines = layer.numberOflines;
        
        if (labelLines != 1) {
            [self addLayers:rect
               cornerRadius:cornerRadius
                      lines:labelLines
                      space:layer.lineSpace
                  lastScale:layer.lastScale
                  fromIndex:layer.dropAnimationFromIndex
               removeOnDrop:layer.removeOnDropAnimation
                  tabHeight:layer.tabViewHeight
                  loadStyle:layer.loadStyle
                      index:i];
        }else {
            
            layer.tagIndex = i;
            if (layer.contents) {
                layer.backgroundColor = UIColor.clearColor.CGColor;
            }else {
                if (layer.backgroundColor == nil) {
                    layer.backgroundColor = self.animatedColor.CGColor;
                }
            }
            
            // 设置动画
            if (layer.loadStyle != TABAnimationTypeOnlySkeleton) {
                [layer addAnimation:[self getAnimationWithLoadStyle:layer.loadStyle] forKey:TABAnimatedLocationAnimation];
            }
            
            BOOL isImageView = layer.fromImageView;
            if (!isImageView) {
                // 设置圆角
                if (cornerRadius == 0.) {
                    if (self.cancelGlobalCornerRadius) {
                        layer.cornerRadius = self.animatedCornerRadius;
                    }else {
                        if ([TABAnimated sharedAnimated].useGlobalCornerRadius) {
                            if ([TABAnimated sharedAnimated].animatedCornerRadius != 0.) {
                                layer.cornerRadius = [TABAnimated sharedAnimated].animatedCornerRadius;
                            }else {
                                layer.cornerRadius = layer.frame.size.height/2.0;
                            }
                        }
                    }
                }else {
                    layer.cornerRadius = cornerRadius;
                }
            }
            
            if (!layer.removeOnDropAnimation) {
                if (layer.dropAnimationIndex == -1) {
                    layer.dropAnimationIndex = self.resultLayerArray.count;
                }
                
                if (self.dropAnimationCount < layer.dropAnimationIndex) {
                    self.dropAnimationCount = layer.dropAnimationIndex;
                }
            }
            
            [self.tabLayer addSublayer:layer];
            [self.resultLayerArray addObject:layer];
        }
        
        // 添加红色标记
#ifdef DEBUG
        if ([TABAnimated sharedAnimated].openAnimationTag) {
            [self addAnimatedTagWithComponentLayer:layer
                                             index:i
                                      isFromeLines:NO];
        }
#endif
    }
}

#pragma mark - Private

- (void)tab_traitCollectionDidChange:(UIView *)superView {
    
    if (@available(iOS 13.0, *)) {
        
        if (!superView) {
            return;
        }
        
        // avoid retain cycle
        __weak typeof(superView) weakSuperView = superView;
        self.animatedBackgroundColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            __strong typeof(weakSuperView) strongSuperView = weakSuperView;
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return strongSuperView.tabAnimated.darkAnimatedBackgroundColor;
            }else {
                return strongSuperView.tabAnimated.animatedBackgroundColor;
            }
        }];

        self.animatedColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            __strong typeof(weakSuperView) strongSuperView = weakSuperView;
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return strongSuperView.tabAnimated.darkAnimatedColor;
            }else {
                return strongSuperView.tabAnimated.animatedColor;
            }
        }];
        
        for (TABComponentLayer *layer in self.resultLayerArray) {
            layer.backgroundColor = self.animatedColor.CGColor;
            if (layer.contents && layer.placeholderName && layer.placeholderName.length > 0) {
                layer.contents = (id)[UIImage imageNamed:layer.placeholderName].CGImage;
            }
        }
        
        if ([TABManagerMethod canAddShimmer:superView]) {
            
            __block CGFloat brigtness = 0.;
            UIColor *baseColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
                if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                    brigtness = [TABAnimated sharedAnimated].shimmerBrightnessInDarkMode;
                    return [TABAnimated sharedAnimated].shimmerBackColorInDarkMode;
                }else {
                    brigtness = [TABAnimated sharedAnimated].shimmerBrightness;
                    return [TABAnimated sharedAnimated].shimmerBackColor;
                }
            }];
            
            for (TABComponentLayer *layer in self.resultLayerArray) {
                if (layer.colors && [layer animationForKey:TABAnimatedShimmerAnimation]) {
                    if (baseColor) {
                        layer.colors = @[
                        (id)baseColor.CGColor,
                        (id)[TABManagerMethod brightenedColor:baseColor
                                                   brightness:brigtness].CGColor,
                        (id)baseColor.CGColor
                        ];
                    }
                }
            }
        }
        
        if ([TABManagerMethod canAddDropAnimation:superView]) {
            
            UIColor *deepColor;
            if (@available(iOS 13.0, *)) {
                if (superView.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                    if (superView.tabAnimated.dropAnimationDeepColorInDarkMode) {
                        deepColor = superView.tabAnimated.dropAnimationDeepColorInDarkMode;
                    }else {
                        deepColor = [TABAnimated sharedAnimated].dropAnimationDeepColorInDarkMode;
                    }
                }else {
                    if (superView.tabAnimated.dropAnimationDeepColor) {
                        deepColor = superView.tabAnimated.dropAnimationDeepColor;
                    }else {
                        deepColor = [TABAnimated sharedAnimated].dropAnimationDeepColor;
                    }
                }
            } else {
                if (superView.tabAnimated.dropAnimationDeepColor) {
                    deepColor = superView.tabAnimated.dropAnimationDeepColor;
                }else {
                    deepColor = [TABAnimated sharedAnimated].dropAnimationDeepColor;
                }
            }
            
            for (TABComponentLayer *layer in self.resultLayerArray) {
                if ([layer animationForKey:TABAnimatedDropAnimation]) {
                    CAKeyframeAnimation *animation = [layer animationForKey:TABAnimatedDropAnimation].copy;
                    animation.values = @[
                                         (id)deepColor.CGColor,
                                         (id)layer.backgroundColor,
                                         (id)layer.backgroundColor,
                                         (id)deepColor.CGColor
                                         ];
                    [layer removeAnimationForKey:TABAnimatedDropAnimation];
                    [layer addAnimation:animation forKey:TABAnimatedDropAnimation];
                }
            }
        }
    }
}

- (void)setRadiusAndColorWithView:(UIView *)view
                        superView:(UIView *)superView
                      tabAnimated:(__kindof TABViewAnimated *)tabAnimated {
    
    if (@available(iOS 13.0, *)) {
        if (superView.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            self.animatedColor = tabAnimated.darkAnimatedColor;
            self.animatedBackgroundColor = tabAnimated.darkAnimatedBackgroundColor;
        }else {
            self.animatedColor = tabAnimated.animatedColor;
            self.animatedBackgroundColor = tabAnimated.animatedBackgroundColor;
        }
    }else {
        self.animatedColor = tabAnimated.animatedColor;
        self.animatedBackgroundColor = tabAnimated.animatedBackgroundColor;
    }
    
    if (tabAnimated.animatedBackViewCornerRadius > 0) {
        self.tabLayer.cornerRadius = tabAnimated.animatedBackViewCornerRadius;
    }else {
        if (view.layer.cornerRadius > 0.) {
            self.tabLayer.cornerRadius = view.layer.cornerRadius;
        }else {
            if ([view isKindOfClass:[UITableViewCell class]]) {
                UITableViewCell *cell = (UITableViewCell *)view;
                if (cell.contentView.layer.cornerRadius > 0.) {
                    self.tabLayer.cornerRadius = cell.contentView.layer.cornerRadius;
                }
            }else {
                if ([view isKindOfClass:[UICollectionViewCell class]]) {
                    UICollectionViewCell *cell = (UICollectionViewCell *)view;
                    if (cell.contentView.layer.cornerRadius > 0.) {
                        self.tabLayer.cornerRadius = cell.contentView.layer.cornerRadius;
                    }
                }
            }
        }
    }
}

- (void)addAnimatedTagWithComponentLayer:(TABComponentLayer *)layer
                                   index:(NSInteger)index
                            isFromeLines:(BOOL)isFromeLines {
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.string = [NSString stringWithFormat:@"%ld",(long)index];
    
    if (isFromeLines) {
        textLayer.frame = CGRectMake(0, 0, layer.frame.size.width, 20);
    }else {
        if (!layer.fromImageView) {
            textLayer.bounds = CGRectMake(layer.bounds.origin.x, layer.bounds.origin.y, layer.bounds.size.width, 20);
        }else {
            textLayer.frame = CGRectMake(0, layer.frame.size.height/2.0, layer.frame.size.width, 20);
        }
    }
    
    textLayer.contentsScale = ([[UIScreen mainScreen] scale] > 3.0) ? [[UIScreen mainScreen] scale]:3.0;
    textLayer.font = (__bridge CFTypeRef)(kTagDefaultFontName);
    textLayer.fontSize = kTagDefaultFontSize;
    textLayer.alignmentMode = kCAAlignmentRight;
    textLayer.foregroundColor = [UIColor redColor].CGColor;
    [layer addSublayer:textLayer];
}

- (void)addLayers:(CGRect)frame
     cornerRadius:(CGFloat)cornerRadius
            lines:(NSInteger)lines
            space:(CGFloat)space
        lastScale:(CGFloat)lastScale
        fromIndex:(NSInteger)fromIndex
     removeOnDrop:(BOOL)removeOnDrop
        tabHeight:(CGFloat)tabHeight
        loadStyle:(TABViewLoadAnimationStyle)loadStyle
            index:(NSInteger)index {
    
    CGFloat textHeight = kDefaultHeight*[TABAnimated sharedAnimated].animatedHeightCoefficient;
    
    if (self.animatedHeight > 0.) {
        textHeight = self.animatedHeight;
    }
    
    if (tabHeight > 0.) {
        textHeight = tabHeight;
    }
    
    if (lines == 0) {
        lines = (frame.size.height*1.0)/(textHeight+space);
        if (lines >= 0 && lines <= 1) {
            tabAnimatedLog(@"TABAnimated提醒 - 监测到多行文本高度为0，动画时将使用默认行数3");
            lines = 3;
        }
    }
    
    for (NSInteger i = 0; i < lines; i++) {
        
        CGRect rect;
        if (i != lines - 1) {
            rect = CGRectMake(frame.origin.x, frame.origin.y+i*(textHeight+space), frame.size.width, textHeight);
        }else {
            rect = CGRectMake(frame.origin.x, frame.origin.y+i*(textHeight+space), frame.size.width*lastScale, textHeight);
        }
        
        TABComponentLayer *layer = [[TABComponentLayer alloc]init];
        layer.anchorPoint = CGPointMake(0, 0);
        layer.position = CGPointMake(0, 0);
        layer.frame = rect;
        
        if (layer.contents) {
            layer.backgroundColor = UIColor.clearColor.CGColor;
        }else {
            if (layer.backgroundColor == nil) {
                layer.backgroundColor = self.animatedColor.CGColor;
            }
        }
        
        if (cornerRadius == 0.) {
            if (self.cancelGlobalCornerRadius) {
                layer.cornerRadius = self.animatedCornerRadius;
            }else {
                if ([TABAnimated sharedAnimated].useGlobalCornerRadius) {
                    if ([TABAnimated sharedAnimated].animatedCornerRadius != 0.) {
                        layer.cornerRadius = [TABAnimated sharedAnimated].animatedCornerRadius;
                    }else {
                        layer.cornerRadius = layer.frame.size.height/2.0;
                    }
                }
            }
        }else {
            layer.cornerRadius = cornerRadius;
        }
        
        if (i == lines - 1) {
            
            layer.tagIndex = index;
            
            if (loadStyle != TABViewLoadAnimationWithOnlySkeleton) {
                [layer addAnimation:[self getAnimationWithLoadStyle:loadStyle] forKey:TABAnimatedLocationAnimation];
            }
            
#ifdef DEBUG
            // 添加红色标记
            if ([TABAnimated sharedAnimated].openAnimationTag) {
                [self addAnimatedTagWithComponentLayer:layer
                                                 index:index
                                          isFromeLines:YES];
            }
#endif
        }else {
            layer.tagIndex = TABViewAnimatedErrorCode;
        }
        
        if (!removeOnDrop) {
            if (fromIndex != -1) {
                layer.dropAnimationIndex = fromIndex+i;
            }else {
                layer.dropAnimationIndex = self.resultLayerArray.count;
            }
            
            if (self.dropAnimationCount < layer.dropAnimationIndex) {
                self.dropAnimationCount = layer.dropAnimationIndex;
            }
        }
        
        [self.tabLayer addSublayer:layer];
        [self.resultLayerArray addObject:layer];
    }
}

- (CABasicAnimation *)getAnimationWithLoadStyle:(TABViewLoadAnimationStyle)loadStyle {
    CGFloat duration = [TABAnimated sharedAnimated].animatedDuration;
    CGFloat value = 0.;
    
    if (loadStyle == TABViewLoadAnimationToLong) {
        value = [TABAnimated sharedAnimated].longToValue;
    }else {
        value = [TABAnimated sharedAnimated].shortToValue;
    }
    
    return [TABAnimationMethod scaleXAnimationDuration:duration toValue:value];
}

- (CGRect)resetFrame:(TABComponentLayer *)layer
                rect:(CGRect)rect {
    
    BOOL isImageView = layer.fromImageView;
    
    CGFloat height = 0.;
    // 修改拿掉 isImageView 限制 开放 tabViewHeight  需要可以修改 imageView的高度 xiaoxin
    if (layer.tabViewHeight > 0.) {
        height = layer.tabViewHeight;
        rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, height);
    }else if (!isImageView) {
        if (self.animatedHeight > 0.) {
            height = self.animatedHeight;
        }else {
            if ([TABAnimated sharedAnimated].useGlobalAnimatedHeight) {
                height = [TABAnimated sharedAnimated].animatedHeight;
            }else {
                if (!isImageView) {
                    height = rect.size.height*[TABAnimated sharedAnimated].animatedHeightCoefficient;
                    if (layer.cornerRadius > 0) {
                        CGFloat originScale = layer.cornerRadius/rect.size.height;
                        if (originScale == .5 && rect.size.width == rect.size.height) {
                            rect = CGRectMake(rect.origin.x, rect.origin.y, height, height);
                        }
                        layer.cornerRadius = height*originScale;
                    }
                }
            }
        }
        rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, height);
    }
    
    BOOL isCenterLab = layer.fromCenterLabel;
    if (isCenterLab && !layer.isCancelAlignCenter) {
        rect = CGRectMake((self.tabLayer.frame.size.width - rect.size.width)/2.0, rect.origin.y, rect.size.width, rect.size.height);
    }
    
    return rect;
}

#pragma mark - NSSecureCoding / NSCopying

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (id)copyWithZone:(NSZone *)zone {
    
    TABComponentManager *manager = [[[self class] allocWithZone:zone] init];
    manager.fileName = self.fileName;
    
    manager.resultLayerArray = @[].mutableCopy;
    for (TABComponentLayer *layer in self.resultLayerArray) {
        [manager.resultLayerArray addObject:layer.copy];
    }
    
    manager.animatedColor = self.animatedColor;
    manager.animatedBackgroundColor = self.animatedBackgroundColor;
    manager.animatedHeight = self.animatedHeight;
    manager.animatedCornerRadius = self.animatedCornerRadius;
    manager.cancelGlobalCornerRadius = self.cancelGlobalCornerRadius;
    manager.dropAnimationCount = self.dropAnimationCount;
    manager.entireIndexArray = self.entireIndexArray.mutableCopy;
    manager.version = self.version;
    manager.needChangeRowStatus = self.needChangeRowStatus;

    return manager;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_fileName forKey:@"fileName"];
    [aCoder encodeObject:_resultLayerArray forKey:@"resultLayerArray"];
    
    [aCoder encodeObject:_animatedColor forKey:@"animatedColor"];
    [aCoder encodeObject:_animatedBackgroundColor forKey:@"animatedBackgroundColor"];
    [aCoder encodeFloat:_animatedHeight forKey:@"animatedHeight"];
    [aCoder encodeFloat:_animatedCornerRadius forKey:@"animatedCornerRadius"];
    [aCoder encodeBool:_cancelGlobalCornerRadius forKey:@"cancelGlobalCornerRadius"];
    
    [aCoder encodeInteger:_dropAnimationCount forKey:@"dropAnimationCount"];
    [aCoder encodeObject:_entireIndexArray forKey:@"entireIndexArray"];
    
    [aCoder encodeObject:_version forKey:@"version"];
    [aCoder encodeBool:_needChangeRowStatus forKey:@"needChangeRowStatus"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.fileName = [aDecoder decodeObjectForKey:@"fileName"];
        self.resultLayerArray = [aDecoder decodeObjectForKey:@"resultLayerArray"];
        
        self.animatedColor = [aDecoder decodeObjectForKey:@"animatedColor"];
        self.animatedBackgroundColor = [aDecoder decodeObjectForKey:@"animatedBackgroundColor"];
        self.animatedHeight = [aDecoder decodeFloatForKey:@"animatedHeight"];
        self.animatedCornerRadius = [aDecoder decodeFloatForKey:@"animatedCornerRadius"];
        self.cancelGlobalCornerRadius = [aDecoder decodeBoolForKey:@"cancelGlobalCornerRadius"];
        
        self.dropAnimationCount = [aDecoder decodeIntegerForKey:@"dropAnimationCount"];
        self.entireIndexArray = [aDecoder decodeObjectForKey:@"entireIndexArray"];
        
        self.version = [aDecoder decodeObjectForKey:@"version"];
        self.needChangeRowStatus = [aDecoder decodeBoolForKey:@"needChangeRowStatus"];
    }
    return self;
}

#pragma mark - Getter / Setter

- (BOOL)needUpdate {
    if (self.version && self.version.length > 0 &&
        [TABAnimated sharedAnimated].cacheManager.currentSystemVersion &&
        [TABAnimated sharedAnimated].cacheManager.currentSystemVersion.length > 0) {
        if ([self.version isEqualToString:[TABAnimated sharedAnimated].cacheManager.currentSystemVersion]) {
            return NO;
        }
        return YES;
    }
    return YES;
}

- (NSInteger)currentRow {
    _needChangeRowStatus = YES;
    return _currentRow;
}

- (void)setAnimatedBackgroundColor:(UIColor *)animatedBackgroundColor {
    _animatedBackgroundColor = animatedBackgroundColor;
    if (_tabLayer && animatedBackgroundColor) {
        _tabLayer.backgroundColor = animatedBackgroundColor.CGColor;
    }
}

@end
