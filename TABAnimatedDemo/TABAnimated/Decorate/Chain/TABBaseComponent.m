//
//  TABBaseComponent.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/7/16.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABBaseComponent.h"
#import "TABComponentLayer.h"
#import "TABComponentManager.h"

struct TABBaseComonentOperation {
    NSInteger leftEqualIndex:8;
    NSInteger rightEqualIndex:8;
    NSInteger topEqualIndex:8;
    NSInteger bottomEqualIndex:8;
} componentOperation;

@interface TABBaseComponent()

@property (nonatomic, strong, readwrite) TABComponentLayer *layer;
@property (nonatomic, weak) TABComponentManager *manager;

@end

@implementation TABBaseComponent

+ (instancetype)componentWithLayer:(TABComponentLayer *)layer manager:(nonnull TABComponentManager *)manager {
    return [[self alloc] initWithLayer:layer manager:manager];
}

- (instancetype)initWithLayer:(TABComponentLayer *)layer manager:(nonnull TABComponentManager *)manager {
    if(layer == nil) return nil;
    if(self = [super init]) {
        _layer = layer;
        _layer.adjustingFrame = layer.frame;
        _manager = manager;
        componentOperation.leftEqualIndex = -1;
        componentOperation.rightEqualIndex = -1;
        componentOperation.topEqualIndex = -1;
        componentOperation.bottomEqualIndex = -1;
    }
    return self;
}

#pragma mark - left

- (TABBaseComponentFloatBlock)left {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(CGFloat offset) {
        [weakSelf result_left:offset];
        return weakSelf;
    };
}

- (void)preview_left:(NSNumber *)number {
    [self result_left:[number floatValue]];
}

- (void)result_left:(CGFloat)offset {
    _layer.adjustingFrame = CGRectMake(_layer.adjustingFrame.origin.x - offset, _layer.adjustingFrame.origin.y, _layer.adjustingFrame.size.width, _layer.adjustingFrame.size.height);
}

#pragma mark - right

- (TABBaseComponentFloatBlock)right {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(CGFloat offset) {
        [weakSelf result_right:offset];
        return weakSelf;
    };
}

- (void)preview_right:(NSNumber *)number {
    [self result_right:[number floatValue]];
}

- (void)result_right:(CGFloat)offset {
    _layer.adjustingFrame = CGRectMake(_layer.adjustingFrame.origin.x + offset, _layer.adjustingFrame.origin.y, _layer.adjustingFrame.size.width, _layer.adjustingFrame.size.height);
}

#pragma mark - up

- (TABBaseComponentFloatBlock)up {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(CGFloat offset) {
        [weakSelf result_up:offset];
        return weakSelf;
    };
}

- (void)preview_up:(NSNumber *)number {
    [self result_up:[number floatValue]];
}

- (void)result_up:(CGFloat)offset {
    _layer.adjustingFrame = CGRectMake(_layer.adjustingFrame.origin.x, _layer.adjustingFrame.origin.y - offset, _layer.adjustingFrame.size.width, _layer.adjustingFrame.size.height);
}

#pragma mark - down

- (TABBaseComponentFloatBlock)down {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(CGFloat offset) {
        [weakSelf result_down:offset];
        return weakSelf;
    };
}

- (void)preview_down:(NSNumber *)number {
    [self result_down:[number floatValue]];
}

- (void)result_down:(CGFloat)offset {
    _layer.adjustingFrame = CGRectMake(_layer.adjustingFrame.origin.x, _layer.adjustingFrame.origin.y + offset, _layer.adjustingFrame.size.width, _layer.adjustingFrame.size.height);
}

#pragma mark - width

- (TABBaseComponentFloatBlock)width {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(CGFloat offset) {
        if (offset <= 0) {
            return weakSelf;
        }
        [weakSelf result_width:offset];
        return weakSelf;
    };
}

- (void)preview_width:(NSNumber *)number {
    [self result_width:[number floatValue]];
}

- (void)result_width:(CGFloat)offset {
    _layer.adjustingFrame = CGRectMake(_layer.adjustingFrame.origin.x, _layer.adjustingFrame.origin.y, offset, _layer.adjustingFrame.size.height);
}

#pragma mark - height

- (TABBaseComponentFloatBlock)height {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(CGFloat offset) {
        if (offset <= 0) {
            return weakSelf;
        }
        [weakSelf result_height:offset];
        return weakSelf;
    };
}

- (void)preview_height:(NSNumber *)number {
    [self result_height:[number floatValue]];
}

- (void)result_height:(CGFloat)offset {
    if (!_layer.isChangedHeight) {
        _layer.isChangedHeight = YES;
    }
    _layer.adjustingFrame = CGRectMake(_layer.adjustingFrame.origin.x, _layer.adjustingFrame.origin.y, _layer.adjustingFrame.size.width, offset);
}

#pragma mark - radius

- (TABBaseComponentFloatBlock)radius {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(CGFloat offset) {
        [weakSelf result_radius:offset];
        return weakSelf;
    };
}

- (void)preview_radius:(NSNumber *)number {
    [self result_radius:[number floatValue]];
}

- (void)result_radius:(CGFloat)offset {
    _layer.cornerRadius = offset;
}

#pragma mark - reducedWidth

- (TABBaseComponentFloatBlock)reducedWidth {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(CGFloat offset) {
        [weakSelf result_reducedWidth:offset];
        return weakSelf;
    };
}

- (void)preview_reducedWidth:(NSNumber *)number {
    [self result_reducedWidth:[number floatValue]];
}

- (void)result_reducedWidth:(CGFloat)offset {
    _layer.adjustingFrame = CGRectMake(_layer.adjustingFrame.origin.x, _layer.adjustingFrame.origin.y, _layer.adjustingFrame.size.width - offset, _layer.adjustingFrame.size.height);
}

#pragma mark - reducedHeight

- (TABBaseComponentFloatBlock)reducedHeight {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(CGFloat offset) {
        [weakSelf result_reducedHeight:offset];
        return weakSelf;
    };
}

- (void)preview_reducedHeight:(NSNumber *)number {
    [self result_reducedHeight:[number floatValue]];
}

- (void)result_reducedHeight:(CGFloat)offset {
    if (!_layer.isChangedHeight) {
        _layer.isChangedHeight = YES;
    }
    _layer.adjustingFrame = CGRectMake(_layer.adjustingFrame.origin.x, _layer.adjustingFrame.origin.y, _layer.adjustingFrame.size.width, _layer.adjustingFrame.size.height - offset);
}

#pragma mark - reducedRadius

- (TABBaseComponentFloatBlock)reducedRadius {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(CGFloat offset) {
        [weakSelf result_reducedRadius:offset];
        return weakSelf;
    };
}

- (void)preview_reducedRadius:(NSNumber *)number {
    [self result_reducedRadius:[number floatValue]];
}

- (void)result_reducedRadius:(CGFloat)offset {
    _layer.cornerRadius = _layer.cornerRadius - offset;
}

#pragma mark - x

- (TABBaseComponentFloatBlock)x {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(CGFloat offset) {
        [weakSelf result_x:offset];
        return weakSelf;
    };
}

- (void)preview_x:(NSNumber *)number {
    [self result_x:[number floatValue]];
}

- (void)result_x:(CGFloat)offset {
    _layer.adjustingFrame = CGRectMake(offset, _layer.adjustingFrame.origin.y, _layer.adjustingFrame.size.width, _layer.adjustingFrame.size.height);
}

#pragma mark - y

- (TABBaseComponentFloatBlock)y {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(CGFloat offset) {
        [weakSelf result_y:offset];
        return weakSelf;
    };
}

- (void)preview_y:(NSNumber *)number {
    [self result_y:[number floatValue]];
}

- (void)result_y:(CGFloat)offset {
    _layer.adjustingFrame = CGRectMake(_layer.adjustingFrame.origin.x, offset, _layer.adjustingFrame.size.width, _layer.adjustingFrame.size.height);
}

#pragma mark - line

- (TABBaseComponentIntegerBlock)line {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(NSInteger value) {
        [weakSelf result_line:value];
        return weakSelf;
    };
}

- (void)preview_line:(NSNumber *)number {
    [self result_line:[number floatValue]];
}

- (void)result_line:(CGFloat)offset {
    _layer.numberOflines = offset;
}

#pragma mark - space

- (TABBaseComponentFloatBlock)space {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(CGFloat value) {
        [weakSelf result_space:value];
        return weakSelf;
    };
}

- (void)preview_space:(NSNumber *)number {
    [self result_space:[number floatValue]];
}

- (void)result_space:(CGFloat)offset {
    _layer.lineSpace = offset;
}

#pragma mark - lastLineScale

- (TABBaseComponentFloatBlock)lastLineScale {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(CGFloat value) {
        [weakSelf result_lastLineScale:value];
        return weakSelf;
    };
}

- (void)preview_lastLineScale:(NSNumber *)number {
    [self result_lastLineScale:[number floatValue]];
}

- (void)result_lastLineScale:(CGFloat)offset {
    _layer.lastScale = offset;
}

#pragma mark - remove

- (TABBaseComponentVoidBlock)remove {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(void) {
        [weakSelf result_remove];
        return weakSelf;
    };
}

- (void)preview_remove {
    [self result_remove];
}

- (void)result_remove {
    _layer.loadStyle = TABViewLoadAnimationRemove;
}

#pragma mark - placeholder

- (TABBaseComponentStringBlock)placeholder {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(NSString *string) {
        [weakSelf result_placeholder:string];
        return weakSelf;
    };
}

- (void)preview_placeholder:(NSString *)value {
    [self result_placeholder:value];
}

- (void)result_placeholder:(NSString *)value {
    _layer.placeholderName = value;
    _layer.contents = (id)[UIImage imageNamed:value].CGImage;
}

#pragma mark - cancelAlignCenter

- (TABBaseComponentVoidBlock)cancelAlignCenter {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(void) {
        [weakSelf result_cancelAlignCenter];
        return weakSelf;
    };
}

- (void)preview_cancelAlignCenter {
    [self result_cancelAlignCenter];
}

- (void)result_cancelAlignCenter {
    _layer.origin = TABComponentLayerOriginLabel;
    _layer.contentsGravity = kCAGravityResizeAspect;
}

#pragma mark - color

- (TABBaseComponentColorBlock)color {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(UIColor *color) {
        [weakSelf result_color:color];
        return weakSelf;
    };
}

- (void)preview_color:(UIColor *)color {
    [self result_color:color];
}

- (void)result_color:(UIColor *)color {
    _layer.backgroundColor = color.CGColor;
}

#pragma mark - withoutAnimation

- (TABBaseComponentVoidBlock)withoutAnimation {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(void) {
        weakSelf.layer.withoutAnimation = YES;
        return weakSelf;
    };
}

- (TABBaseComponentVoidBlock)removeContents {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(void) {
        weakSelf.layer.contents = nil;
        return weakSelf;
    };
}

#pragma mark - penetration

- (TABBaseComponentVoidBlock)penetrate {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(void) {
        if (weakSelf.layer.origin != TABComponentLayerOriginCreate) {
            [weakSelf result_penetrate];
        }else {
#ifdef DEBUG
            NSAssert(YES, @"The layer created by yourself can not penetrate.");
#endif
        }
        return weakSelf;
    };
}

- (void)result_penetrate {
    _layer.loadStyle = TABViewLoadAnimationPenetrate;
}

#pragma mark - Auto layout

- (TABBaseComponentCompareBlock)leftEqualTo {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(NSInteger index) {
        [weakSelf _leftEqualWithIndex:index offset:0];
        return weakSelf;
    };
}

- (TABBaseComponentCompareBlock)rightEqualTo {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(NSInteger index) {
        [weakSelf _rightEqualWithIndex:index offset:0];
        return weakSelf;
    };
}

- (TABBaseComponentCompareBlock)topEqualTo {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(NSInteger index) {
        [weakSelf _topEqualWithIndex:index offset:0];
        return weakSelf;
    };
}

- (TABBaseComponentCompareBlock)bottomEqualTo {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(NSInteger index) {
        [weakSelf _bottomEqualWithIndex:index offset:0];
        return weakSelf;
    };
}

- (TABBaseComponentCompareBlock)widthEqualTo {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(NSInteger index) {
        [weakSelf _widthEqualWithIndex:index offset:0];
        return weakSelf;
    };
}

- (TABBaseComponentCompareBlock)heightEqualTo {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(NSInteger index) {
        [weakSelf _heightEqualWithIndex:index offset:0];
        return weakSelf;
    };
}


- (TABBaseComponentCompareBlock)leftEqualToRight {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(NSInteger index) {
        [weakSelf _leftEqualToRightWithIndex:index offset:0];
        return weakSelf;
    };
}

- (TABBaseComponentCompareBlock)rightEqualToLeft {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(NSInteger index) {
        [weakSelf _rightEqualToLeftWithIndex:index offset:0];
        return weakSelf;
    };
}

- (TABBaseComponentCompareBlock)topEqualToBottom {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(NSInteger index) {
        [weakSelf _topEqualToBottomWithIndex:index offset:0];
        return weakSelf;
    };
}

- (TABBaseComponentCompareBlock)bottomEqualToTop {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(NSInteger index) {
        [weakSelf _bottomEqualToTopWithIndex:index offset:0];
        return weakSelf;
    };
}

#pragma mark -

- (TABBaseComponentCompareWithOffsetBlock)leftEqualTo_offset {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(NSInteger index, CGFloat offset) {
        [weakSelf _leftEqualWithIndex:index offset:offset];
        return weakSelf;
    };
}

- (TABBaseComponentCompareWithOffsetBlock)rightEqualTo_offset {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(NSInteger index, CGFloat offset) {
        [weakSelf _rightEqualWithIndex:index offset:offset];
        return weakSelf;
    };
}

- (TABBaseComponentCompareWithOffsetBlock)topEqualTo_offset {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(NSInteger index, CGFloat offset) {
        [weakSelf _topEqualWithIndex:index offset:offset];
        return weakSelf;
    };
}

- (TABBaseComponentCompareWithOffsetBlock)bottomEqualTo_offset {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(NSInteger index, CGFloat offset) {
        [weakSelf _bottomEqualWithIndex:index offset:offset];
        return weakSelf;
    };
}

- (TABBaseComponentCompareWithOffsetBlock)widthEqualTo_offset {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(NSInteger index, CGFloat offset) {
        [weakSelf _widthEqualWithIndex:index offset:offset];
        return weakSelf;
    };
}

- (TABBaseComponentCompareWithOffsetBlock)heightEqualTo_offset {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(NSInteger index, CGFloat offset) {
        [weakSelf _heightEqualWithIndex:index offset:offset];
        return weakSelf;
    };
}

- (TABBaseComponentCompareWithOffsetBlock)leftEqualToRight_offset {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(NSInteger index, CGFloat offset) {
        [weakSelf _leftEqualToRightWithIndex:index offset:offset];
        return weakSelf;
    };
}

- (TABBaseComponentCompareWithOffsetBlock)rightEqualToLeft_offset {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(NSInteger index, CGFloat offset) {
        [weakSelf _rightEqualToLeftWithIndex:index offset:offset];
        return weakSelf;
    };
}

- (TABBaseComponentCompareWithOffsetBlock)topEqualToBottom_offset {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(NSInteger index, CGFloat offset) {
        [weakSelf _topEqualToBottomWithIndex:index offset:offset];
        return weakSelf;
    };
}

- (TABBaseComponentCompareWithOffsetBlock)bottomEqualToTop_offset {
    __weak typeof(self) weakSelf = self;
    return ^TABBaseComponent *(NSInteger index, CGFloat offset) {
        [weakSelf _bottomEqualToTopWithIndex:index offset:offset];
        return weakSelf;
    };
}

#pragma mark -

- (void)_leftEqualWithIndex:(NSInteger)index offset:(CGFloat)offset {
    componentOperation.leftEqualIndex = index;
    [self _updateWidth];
    
    TABBaseComponent *comparedComponent = self.manager.animation(index);
    TABComponentLayer *comparedLayer = comparedComponent.layer;
    CGRect comparedFrame = comparedLayer.adjustingFrame;
    self.layer.adjustingFrame = CGRectMake(comparedFrame.origin.x + offset, self.layer.adjustingFrame.origin.y, self.layer.adjustingFrame.size.width, self.layer.adjustingFrame.size.height);
}

- (void)_leftEqualToRightWithIndex:(NSInteger)index offset:(CGFloat)offset {
    TABBaseComponent *comparedComponent = self.manager.animation(index);
    TABComponentLayer *comparedLayer = comparedComponent.layer;
    CGRect comparedFrame = comparedLayer.adjustingFrame;
    self.layer.adjustingFrame = CGRectMake(CGRectGetMaxX(comparedFrame) + offset, self.layer.adjustingFrame.origin.y, self.layer.adjustingFrame.size.width, self.layer.adjustingFrame.size.height);
}

- (void)_rightEqualWithIndex:(NSInteger)index offset:(CGFloat)offset {
    componentOperation.rightEqualIndex = index;
    [self _updateWidth];
    
    TABBaseComponent *comparedComponent = self.manager.animation(index);
    TABComponentLayer *comparedLayer = comparedComponent.layer;
    CGRect comparedFrame = comparedLayer.adjustingFrame;
    CGFloat layerWidth = self.layer.adjustingFrame.size.width;
    CGFloat comparedMaxX = CGRectGetMaxX(comparedFrame);
    self.layer.adjustingFrame = CGRectMake(comparedMaxX - layerWidth + offset, self.layer.frame.origin.y, layerWidth, self.layer.adjustingFrame.size.height);
}

- (void)_rightEqualToLeftWithIndex:(NSInteger)index offset:(CGFloat)offset {
    TABBaseComponent *comparedComponent = self.manager.animation(index);
    TABComponentLayer *comparedLayer = comparedComponent.layer;
    CGRect comparedFrame = comparedLayer.adjustingFrame;
    CGFloat layerWidth = self.layer.adjustingFrame.size.width;
    CGFloat comparedMinX = CGRectGetMinX(comparedFrame);
    self.layer.adjustingFrame = CGRectMake(comparedMinX - layerWidth + offset, self.layer.frame.origin.y, layerWidth, self.layer.adjustingFrame.size.height);
}

- (void)_topEqualWithIndex:(NSInteger)index offset:(CGFloat)offset {
    componentOperation.topEqualIndex = index;
    [self _updateHeight];
    
    TABBaseComponent *comparedComponent = self.manager.animation(index);
    TABComponentLayer *comparedLayer = comparedComponent.layer;
    CGRect comparedFrame = comparedLayer.adjustingFrame;
    self.layer.adjustingFrame = CGRectMake(self.layer.adjustingFrame.origin.x, comparedFrame.origin.y + offset, self.layer.adjustingFrame.size.width, self.layer.adjustingFrame.size.height);
}

- (void)_topEqualToBottomWithIndex:(NSInteger)index offset:(CGFloat)offset {
    TABBaseComponent *comparedComponent = self.manager.animation(index);
    TABComponentLayer *comparedLayer = comparedComponent.layer;
    CGRect comparedFrame = comparedLayer.adjustingFrame;
    self.layer.adjustingFrame = CGRectMake(self.layer.adjustingFrame.origin.x, CGRectGetMaxY(comparedFrame) + offset, self.layer.adjustingFrame.size.width, self.layer.adjustingFrame.size.height);
}

- (void)_bottomEqualWithIndex:(NSInteger)index offset:(CGFloat)offset {
    componentOperation.bottomEqualIndex = index;
    [self _updateHeight];
    
    TABBaseComponent *comparedComponent = self.manager.animation(index);
    TABComponentLayer *comparedLayer = comparedComponent.layer;
    CGRect comparedFrame = comparedLayer.adjustingFrame;
    CGFloat comparedMaxY = CGRectGetMaxY(comparedFrame);
    CGFloat layerHeight = self.layer.adjustingFrame.size.height;
    self.layer.adjustingFrame = CGRectMake(self.layer.adjustingFrame.origin.x, comparedMaxY - layerHeight + offset, self.layer.adjustingFrame.size.width, layerHeight);
}

- (void)_bottomEqualToTopWithIndex:(NSInteger)index offset:(CGFloat)offset {
    TABBaseComponent *comparedComponent = self.manager.animation(index);
    TABComponentLayer *comparedLayer = comparedComponent.layer;
    CGRect comparedFrame = comparedLayer.adjustingFrame;
    CGFloat comparedMinY = CGRectGetMinY(comparedFrame);
    CGFloat layerHeight = self.layer.adjustingFrame.size.height;
    self.layer.adjustingFrame = CGRectMake(self.layer.adjustingFrame.origin.x, comparedMinY - layerHeight + offset, self.layer.adjustingFrame.size.width, layerHeight);
}

- (void)_widthEqualWithIndex:(NSInteger)index offset:(CGFloat)offset {
    TABBaseComponent *comparedComponent = self.manager.animation(index);
    TABComponentLayer *comparedLayer = comparedComponent.layer;
    CGRect comparedFrame = comparedLayer.adjustingFrame;
    self.layer.adjustingFrame = CGRectMake(self.layer.adjustingFrame.origin.x, self.layer.adjustingFrame.origin.y, comparedFrame.size.width + offset, self.layer.adjustingFrame.size.height);
}

- (void)_heightEqualWithIndex:(NSInteger)index offset:(CGFloat)offset {
    TABBaseComponent *comparedComponent = self.manager.animation(index);
    TABComponentLayer *comparedLayer = comparedComponent.layer;
    CGRect comparedFrame = comparedLayer.adjustingFrame;
    self.layer.adjustingFrame = CGRectMake(self.layer.adjustingFrame.origin.x, self.layer.adjustingFrame.origin.y, self.layer.adjustingFrame.size.width, comparedFrame.size.height + offset);
}

- (void)_updateWidth {
    if(componentOperation.leftEqualIndex != -1 &&
       componentOperation.rightEqualIndex != -1 &&
       componentOperation.leftEqualIndex == componentOperation.rightEqualIndex) {
        TABBaseComponent *comparedComponent = self.manager.animation(componentOperation.leftEqualIndex);
        TABComponentLayer *comparedLayer = comparedComponent.layer;
        self.layer.adjustingFrame = CGRectMake(self.layer.adjustingFrame.origin.x, self.layer.adjustingFrame.origin.y, comparedLayer.adjustingFrame.size.width, self.layer.adjustingFrame.size.width);
    }
}

- (void)_updateHeight {
    if(componentOperation.topEqualIndex != -1 &&
       componentOperation.bottomEqualIndex != -1 &&
       componentOperation.topEqualIndex == componentOperation.bottomEqualIndex) {
        TABBaseComponent *comparedComponent = self.manager.animation(componentOperation.topEqualIndex);
        TABComponentLayer *comparedLayer = comparedComponent.layer;
        self.layer.adjustingFrame = CGRectMake(self.layer.adjustingFrame.origin.x, self.layer.adjustingFrame.origin.y, self.layer.adjustingFrame.size.width, comparedLayer.adjustingFrame.size.height);
        
    }
}

@end
