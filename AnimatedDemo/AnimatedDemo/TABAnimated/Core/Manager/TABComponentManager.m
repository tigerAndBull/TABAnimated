//
//  TABComponentManager.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/7/16.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABComponentManager.h"
#import "TABAnimated.h"
#import "TABViewAnimated.h"
#import "TABBaseComponent.h"
#import "TABComponentLayer.h"
#import <UIKit/UIKit.h>

static const CGFloat kDefaultHeight = 16.f;
static NSString * const kTagDefaultFontName = @"HiraKakuProN-W3";

@interface TABComponentManager()

@property (nonatomic, strong) NSMutableArray <TABBaseComponent *> *baseComponentArray;
@property (nonatomic, strong, readwrite) NSMutableArray <TABComponentLayer *> *componentLayerArray;
@property (nonatomic, strong, readwrite) NSMutableArray <TABComponentLayer *> *resultLayerArray;

@property (nonatomic, assign, readwrite) NSInteger dropAnimationCount;

@end

@implementation TABComponentManager

+ (instancetype)initWithView:(UIView *)view
                 tabAnimated:(TABViewAnimated *)tabAnimated {
    TABComponentManager *manager = [self initWithView:view];
    manager.animatedHeight = tabAnimated.animatedHeight;
    manager.animatedCornerRadius = tabAnimated.animatedCornerRadius;
    manager.cancelGlobalCornerRadius = tabAnimated.cancelGlobalCornerRadius;
    if (tabAnimated.animatedBackViewCornerRadius > 0) {
        manager.tabLayer.cornerRadius = tabAnimated.animatedBackViewCornerRadius;
    }else {
        if (view.layer.cornerRadius > 0.) {
            manager.tabLayer.cornerRadius = view.layer.cornerRadius;
        }else {
            if ([view isKindOfClass:[UITableViewCell class]]) {
                UITableViewCell *cell = (UITableViewCell *)view;
                if (cell.contentView.layer.cornerRadius > 0.) {
                    manager.tabLayer.cornerRadius = cell.contentView.layer.cornerRadius;
                }
            }else {
                if ([view isKindOfClass:[UICollectionViewCell class]]) {
                    UICollectionViewCell *cell = (UICollectionViewCell *)view;
                    if (cell.contentView.layer.cornerRadius > 0.) {
                        manager.tabLayer.cornerRadius = cell.contentView.layer.cornerRadius;
                    }
                }
            }
        }
    }
    manager.animatedBackgroundColor = tabAnimated.animatedBackgroundColor;
    manager.animatedColor = tabAnimated.animatedColor;
    return manager;
}

+ (instancetype)initWithView:(UIView *)view {
    TABComponentManager *manager = [[TABComponentManager alloc] init];
    if (view.frame.size.width > 0.) {
        manager.tabLayer.frame = view.bounds;
    }else {
        manager.tabLayer.frame = CGRectMake(view.bounds.origin.x, view.bounds.origin.y, [UIScreen mainScreen].bounds.size.width, view.bounds.size.height);
    }
    [view.layer addSublayer:manager.tabLayer];
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        
        _baseComponentArray = @[].mutableCopy;
        _resultLayerArray = @[].mutableCopy;
        _componentLayerArray = @[].mutableCopy;
        
        _tabLayer = CALayer.new;
        _tabLayer.name = @"TABLayer";
        _tabLayer.anchorPoint = CGPointMake(0, 0);
        _tabLayer.position = CGPointMake(0, 0);
        _tabLayer.opaque = YES;
        _tabLayer.contentsScale = ([[UIScreen mainScreen] scale] > 3.0) ? [[UIScreen mainScreen] scale]:3.0;
        _tabLayer.backgroundColor = [self.animatedBackgroundColor CGColor];
    }
    return self;
}

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
        
        // 定义一个指向个数可变的参数列表指针；
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

- (void)installBaseComponent:(NSArray <TABComponentLayer *> *)array {
    self.componentLayerArray = array.mutableCopy;
    [self.baseComponentArray removeAllObjects];
    for (NSInteger i = 0; i < array.count; i++) {
        TABBaseComponent *component = [TABBaseComponent initWithComponentLayer:array[i]];
        [self.baseComponentArray addObject:component];
    }
}

- (void)updateComponentLayers {
    
    for (NSInteger i = 0; i < self.baseComponentArray.count; i++) {
        
        TABBaseComponent *component = self.baseComponentArray[i];
        TABComponentLayer *layer = component.layer;
        
        if (layer.loadStyle == TABViewLoadAnimationRemove) {
            continue;
        }
        
        CGRect rect = [self resetFrame:layer rect:layer.frame];
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
        
#ifdef DEBUG
        if ([TABAnimated sharedAnimated].openAnimationTag) {
            CATextLayer *lary = [CATextLayer layer];
            lary.string = [NSString stringWithFormat:@"%ld",(long)i];
            
            if (!layer.fromImageView) {
                lary.bounds = CGRectMake(layer.bounds.origin.x, layer.bounds.origin.y, layer.bounds.size.width, 20);
            }else {
                lary.frame = CGRectMake(0, layer.frame.size.height/2.0, layer.frame.size.width, 20);
            }
            lary.contentsScale = ([[UIScreen mainScreen] scale] > 3.0) ? [[UIScreen mainScreen] scale]:3.0;
            lary.font = (__bridge CFTypeRef)(kTagDefaultFontName);
            lary.fontSize = 12.f;
            lary.alignmentMode = kCAAlignmentRight;
            lary.foregroundColor = [UIColor redColor].CGColor;
            [layer addSublayer:lary];
        }
#else
        
#endif
    }
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
        layer.backgroundColor = self.animatedColor.CGColor;
        
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
            if (loadStyle != TABAnimationTypeOnlySkeleton) {
                [layer addAnimation:[self getAnimationWithLoadStyle:loadStyle] forKey:TABAnimatedLocationAnimation];
            }
            
#ifdef DEBUG
            if ([TABAnimated sharedAnimated].openAnimationTag) {
                CATextLayer *lary = [CATextLayer layer];
                lary.string = [NSString stringWithFormat:@"%ld",(long)index];
                lary.frame = CGRectMake(0, 0, rect.size.width, 20);
                lary.font = (__bridge CFTypeRef)(kTagDefaultFontName);
                lary.fontSize = 12.f;
                lary.alignmentMode = kCAAlignmentRight;
                lary.foregroundColor = [UIColor redColor].CGColor;
                lary.contentsScale = ([[UIScreen mainScreen] scale] > 3.0) ? [[UIScreen mainScreen] scale]:3.0;
                [layer addSublayer:lary];
            }
#else
            
#endif
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

#pragma mark - Private

- (void)removeSubLayers:(NSArray *)subLayers {
    
    NSArray <CALayer *> *removedLayers = [subLayers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return YES;
    }]];
    
    [removedLayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperlayer];
    }];
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
    
    rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    
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

#pragma mark - Getter / Setter

@synthesize animatedColor = _animatedColor;
- (UIColor *)animatedColor {
    if (_animatedColor) {
        return _animatedColor;
    }
    return [TABAnimated sharedAnimated].animatedColor;
}

- (void)setAnimatedColor:(UIColor *)animatedColor {
    _animatedColor = animatedColor;
}

@synthesize animatedBackgroundColor = _animatedBackgroundColor;
- (UIColor *)animatedBackgroundColor {
    if (_animatedBackgroundColor) {
        return _animatedBackgroundColor;
    }
    return [TABAnimated sharedAnimated].animatedBackgroundColor;
}

- (void)setAnimatedBackgroundColor:(UIColor *)animatedBackgroundColor {
    _animatedBackgroundColor = animatedBackgroundColor;
    if (animatedBackgroundColor) {
        self.tabLayer.backgroundColor = animatedBackgroundColor.CGColor;
    }
}

@end
