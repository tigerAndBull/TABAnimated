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

@property (nonatomic,strong,readwrite) TABComponentLayer *layer;

@end

@implementation TABBaseComponent

+ (instancetype)initWithComponentLayer:(TABComponentLayer *)layer {
    TABBaseComponent *component = TABBaseComponent.new;
    component.layer = layer;
    return component;
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
    self.layer.frame = CGRectMake(self.layer.frame.origin.x - offset, self.layer.frame.origin.y, self.layer.frame.size.width, self.layer.frame.size.height);
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
    self.layer.frame = CGRectMake(self.layer.frame.origin.x + offset, self.layer.frame.origin.y, self.layer.frame.size.width, self.layer.frame.size.height);
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
    self.layer.frame = CGRectMake(self.layer.frame.origin.x, self.layer.frame.origin.y - offset, self.layer.frame.size.width, self.layer.frame.size.height);
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
    self.layer.frame = CGRectMake(self.layer.frame.origin.x, self.layer.frame.origin.y + offset, self.layer.frame.size.width, self.layer.frame.size.height);
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
    self.layer.frame = CGRectMake(self.layer.frame.origin.x, self.layer.frame.origin.y, offset, self.layer.frame.size.height);
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
    self.layer.tabViewHeight = offset;
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
    self.layer.cornerRadius = offset;
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
    self.layer.frame = CGRectMake(self.layer.frame.origin.x, self.layer.frame.origin.y, self.layer.frame.size.width - offset, self.layer.frame.size.height);
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
    self.layer.tabViewHeight = self.layer.frame.size.height - offset;
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
    self.layer.cornerRadius = self.layer.cornerRadius - offset;
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
    self.layer.frame = CGRectMake(offset, self.layer.frame.origin.y, self.layer.frame.size.width, self.layer.frame.size.height);
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
    self.layer.frame = CGRectMake(self.layer.frame.origin.x, offset, self.layer.frame.size.width, self.layer.frame.size.height);
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
    self.layer.numberOflines = offset;
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
    self.layer.lineSpace = offset;
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
    self.layer.lastScale = offset;
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
    self.layer.loadStyle = TABViewLoadAnimationRemove;
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
    self.layer.contents = (id)[UIImage imageNamed:value].CGImage;
}

#pragma mark - toLongAnimation

- (TABBaseComponentVoidBlock)toLongAnimation {
    return ^TABBaseComponent *(void) {
        [self result_toLongAnimation];
        return self;
    };
}

- (void)preview_toLongAnimation {
    [self result_toLongAnimation];
}

- (void)result_toLongAnimation {
    self.layer.loadStyle = TABViewLoadAnimationToLong;
}

#pragma mark - toShortAnimation

- (TABBaseComponentVoidBlock)toShortAnimation {
    return ^TABBaseComponent *(void) {
        [self result_toShortAnimation];
        return self;
    };
}

- (void)preview_toShortAnimation {
    [self result_toShortAnimation];
}

- (void)result_toShortAnimation {
    self.layer.loadStyle = TABViewLoadAnimationToShort;
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
    self.layer.isCancelAlignCenter = YES;
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
    self.layer.backgroundColor = color.CGColor;
}

#pragma mark - dropIndex

- (TABBaseComponentIntegerBlock)dropIndex {
    return ^TABBaseComponent *(NSInteger value) {
        [self result_dropIndex:value];
        return self;
    };
}

- (void)preview_dropIndex:(NSNumber *)number {
    [self result_dropIndex:[number integerValue]];
}

- (void)result_dropIndex:(NSInteger)value {
    self.layer.dropAnimationIndex = value;
}

#pragma mark - dropFromIndex

- (TABBaseComponentIntegerBlock)dropFromIndex {
    return ^TABBaseComponent *(NSInteger value) {
        [self result_dropFromIndex:value];
        return self;
    };
}

- (void)preview_dropFromIndex:(NSNumber *)number {
    [self result_dropFromIndex:[number integerValue]];
}

- (void)result_dropFromIndex:(NSInteger)value {
    self.layer.dropAnimationFromIndex = value;
}

#pragma mark - removeOnDrop

- (TABBaseComponentVoidBlock)removeOnDrop {
    return ^TABBaseComponent *(void) {
        [self result_removeOnDrop];
        return self;
    };
}

- (void)preview_removeOnDrop {
    [self result_removeOnDrop];
}

- (void)result_removeOnDrop {
    self.layer.removeOnDropAnimation = YES;
}

#pragma mark - dropStayTime

- (TABBaseComponentFloatBlock)dropStayTime {
    return ^TABBaseComponent *(CGFloat value) {
        [self result_dropStayTime:value];
        return self;
    };
}

- (void)preview_dropStayTime:(NSNumber *)number {
    [self result_dropStayTime:[number floatValue]];
}

- (void)result_dropStayTime:(CGFloat)value {
    self.layer.dropAnimationStayTime = value;
}

@end
