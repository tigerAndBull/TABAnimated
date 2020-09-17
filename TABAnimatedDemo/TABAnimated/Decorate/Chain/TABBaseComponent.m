//
//  TABBaseComponent.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/7/16.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABBaseComponent.h"
#import "TABComponentLayer.h"

@interface TABBaseComponent()

@property (nonatomic, strong, readwrite) TABComponentLayer *layer;

@end

@implementation TABBaseComponent

+ (instancetype)componentWithLayer:(TABComponentLayer *)layer {
    return [[self alloc] initWithLayer:layer];
}

- (instancetype)initWithLayer:(TABComponentLayer *)layer {
    if(layer == nil) return nil;
    if(self = [super init]) {
        _layer = layer;
        _layer.adjustingFrame = layer.frame;
    }
    return self;
}

#pragma mark - left

- (TABBaseComponentFloatBlock)left {
    return ^TABBaseComponent *(CGFloat offset) {
        [self result_left:offset];
        return self;
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
    return ^TABBaseComponent *(CGFloat offset) {
        [self result_right:offset];
        return self;
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
    return ^TABBaseComponent *(CGFloat offset) {
        [self result_up:offset];
        return self;
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
    return ^TABBaseComponent *(CGFloat offset) {
        [self result_down:offset];
        return self;
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
    return ^TABBaseComponent *(CGFloat offset) {
        if (offset <= 0) {
            return self;
        }
        [self result_width:offset];
        return self;
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
    return ^TABBaseComponent *(CGFloat offset) {
        if (offset <= 0) {
            return self;
        }
        [self result_height:offset];
        return self;
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
    return ^TABBaseComponent *(CGFloat offset) {
        [self result_radius:offset];
        return self;
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
    return ^TABBaseComponent *(CGFloat offset) {
        [self result_reducedWidth:offset];
        return self;
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
    return ^TABBaseComponent *(CGFloat offset) {
        [self result_reducedHeight:offset];
        return self;
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
    return ^TABBaseComponent *(CGFloat offset) {
        [self result_reducedRadius:offset];
        return self;
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
    return ^TABBaseComponent *(CGFloat offset) {
        [self result_x:offset];
        return self;
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
    return ^TABBaseComponent *(CGFloat offset) {
        [self result_y:offset];
        return self;
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
    return ^TABBaseComponent *(NSInteger value) {
        [self result_line:value];
        return self;
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
    return ^TABBaseComponent *(CGFloat value) {
        [self result_space:value];
        return self;
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
    return ^TABBaseComponent *(CGFloat value) {
        [self result_lastLineScale:value];
        return self;
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
    return ^TABBaseComponent *(void) {
        [self result_remove];
        return self;
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
    return ^TABBaseComponent *(NSString *string) {
        [self result_placeholder:string];
        return self;
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
    return ^TABBaseComponent *(void) {
        [self result_cancelAlignCenter];
        return self;
    };
}

- (void)preview_cancelAlignCenter {
    [self result_cancelAlignCenter];
}

- (void)result_cancelAlignCenter {
    _layer.origin = TABComponentLayerOriginLabel;
}

#pragma mark - color

- (TABBaseComponentColorBlock)color {
    return ^TABBaseComponent *(UIColor *color) {
        [self result_color:color];
        return self;
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
        return self;
    };
}

@end
