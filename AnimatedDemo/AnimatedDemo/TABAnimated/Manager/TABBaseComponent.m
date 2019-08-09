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

- (TABBaseComponentFloatBlock)left {
    return ^TABBaseComponent *(CGFloat offset) {
        self.layer.frame = CGRectMake(self.layer.frame.origin.x - offset, self.layer.frame.origin.y, self.layer.frame.size.width, self.layer.frame.size.height);
        return self;
    };
}

- (TABBaseComponentFloatBlock)right {
    return ^TABBaseComponent *(CGFloat offset) {
        self.layer.frame = CGRectMake(self.layer.frame.origin.x + offset, self.layer.frame.origin.y, self.layer.frame.size.width, self.layer.frame.size.height);
        return self;
    };
}

- (TABBaseComponentFloatBlock)up {
    return ^TABBaseComponent *(CGFloat offset) {
        self.layer.frame = CGRectMake(self.layer.frame.origin.x, self.layer.frame.origin.y - offset, self.layer.frame.size.width, self.layer.frame.size.height);
        return self;
    };
}

- (TABBaseComponentFloatBlock)down {
    return ^TABBaseComponent *(CGFloat offset) {
        self.layer.frame = CGRectMake(self.layer.frame.origin.x, self.layer.frame.origin.y + offset, self.layer.frame.size.width, self.layer.frame.size.height);
        return self;
    };
}

- (TABBaseComponentFloatBlock)width {
    return ^TABBaseComponent *(CGFloat offset) {
        
        if (offset <= 0) {
            return self;
        }
        
        self.layer.frame = CGRectMake(self.layer.frame.origin.x, self.layer.frame.origin.y, offset, self.layer.frame.size.height);
        return self;
    };
}

- (TABBaseComponentFloatBlock)height {
    return ^TABBaseComponent *(CGFloat offset) {
        
        if (offset <= 0) {
            return self;
        }
        
        self.layer.tabViewHeight = offset;
        return self;
    };
}

- (TABBaseComponentFloatBlock)radius {
    return ^TABBaseComponent *(CGFloat offset) {
        self.layer.cornerRadius = offset;
        return self;
    };
}

- (TABBaseComponentFloatBlock)reducedWidth {
    return ^TABBaseComponent *(CGFloat offset) {
        self.layer.frame = CGRectMake(self.layer.frame.origin.x, self.layer.frame.origin.y, self.layer.frame.size.width - offset, self.layer.frame.size.height);
        return self;
    };
}

- (TABBaseComponentFloatBlock)reducedHeight {
    return ^TABBaseComponent *(CGFloat offset) {
        self.layer.tabViewHeight = self.layer.frame.size.height - offset;
        return self;
    };
}

- (TABBaseComponentFloatBlock)reducedRadius {
    return ^TABBaseComponent *(CGFloat offset) {
        self.layer.cornerRadius = self.layer.cornerRadius - offset;
        return self;
    };
}

- (TABBaseComponentFloatBlock)x {
    return ^TABBaseComponent *(CGFloat offset) {
        self.layer.frame = CGRectMake(offset, self.layer.frame.origin.y, self.layer.frame.size.width, self.layer.frame.size.height);
        return self;
    };
}

- (TABBaseComponentFloatBlock)y {
    return ^TABBaseComponent *(CGFloat offset) {
        self.layer.frame = CGRectMake(self.layer.frame.origin.x, offset, self.layer.frame.size.width, self.layer.frame.size.height);
        return self;
    };
}

- (TABBaseComponentIntegerBlock)line {
    return ^TABBaseComponent *(NSInteger value) {
        self.layer.numberOflines = value;
        return self;
    };
}

- (TABBaseComponentFloatBlock)space {
    return ^TABBaseComponent *(CGFloat value) {
        self.layer.lineSpace = value;
        return self;
    };
}

- (TABBaseComponentFloatBlock)lastLineScale {
    return ^TABBaseComponent *(CGFloat value) {
        self.layer.lastScale = value;
        return self;
    };
}

- (TABBaseComponentVoidBlock)remove {
    return ^TABBaseComponent *(void) {
        self.layer.loadStyle = TABViewLoadAnimationRemove;
        return self;
    };
}

- (TABBaseComponentStringBlock)placeholder {
    return ^TABBaseComponent *(NSString *string) {
        self.layer.contents = (id)[UIImage imageNamed:string].CGImage;
        return self;
    };
}

- (TABBaseComponentVoidBlock)toLongAnimation {
    return ^TABBaseComponent *(void) {
        self.layer.loadStyle = TABViewLoadAnimationToLong;
        return self;
    };
}

- (TABBaseComponentVoidBlock)toShortAnimation {
    return ^TABBaseComponent *(void) {
        self.layer.loadStyle = TABViewLoadAnimationToShort;
        return self;
    };
}

- (TABBaseComponentVoidBlock)cancelAlignCenter {
    return ^TABBaseComponent *(void) {
        self.layer.isCancelAlignCenter = YES;
        return self;
    };
}

- (TABBaseComponentColorBlock)color {
    return ^TABBaseComponent *(UIColor *color) {
        self.layer.backgroundColor = color.CGColor;
        return self;
    };
}

- (TABBaseComponentIntegerBlock)dropIndex {
    return ^TABBaseComponent *(NSInteger value) {
        self.layer.dropAnimationIndex = value;
        return self;
    };
}

- (TABBaseComponentIntegerBlock)dropFromIndex {
    return ^TABBaseComponent *(NSInteger value) {
        self.layer.dropAnimationFromIndex = value;
        return self;
    };
}

- (TABBaseComponentVoidBlock)removeOnDrop {
    return ^TABBaseComponent *(void) {
        self.layer.removeOnDropAnimation = YES;
        return self;
    };
}

- (TABBaseComponentFloatBlock)dropStayTime {
    return ^TABBaseComponent *(CGFloat value) {
        self.layer.dropAnimationStayTime = value;
        return self;
    };
}

@end
