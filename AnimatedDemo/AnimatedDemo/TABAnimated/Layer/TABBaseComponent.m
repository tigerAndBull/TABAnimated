//
//  TABBaseComponent.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/7/16.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABBaseComponent.h"

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
    return ^TABComponentLayer *(CGFloat offset) {
        self.layer.frame = CGRectMake(self.layer.frame.origin.x - offset, self.layer.frame.origin.y, self.layer.frame.size.width, self.layer.frame.size.height);
        return self.layer;
    };
}

- (TABBaseComponentFloatBlock)right {
    return ^TABComponentLayer *(CGFloat offset) {
        self.layer.frame = CGRectMake(self.layer.frame.origin.x + offset, self.layer.frame.origin.y, self.layer.frame.size.width, self.layer.frame.size.height);
        return self.layer;
    };
}

- (TABBaseComponentFloatBlock)up {
    return ^TABComponentLayer *(CGFloat offset) {
        self.layer.frame = CGRectMake(self.layer.frame.origin.x, self.layer.frame.origin.y - offset, self.layer.frame.size.width, self.layer.frame.size.height);
        return self.layer;
    };
}

- (TABBaseComponentFloatBlock)down {
    return ^TABComponentLayer *(CGFloat offset) {
        self.layer.frame = CGRectMake(self.layer.frame.origin.x, self.layer.frame.origin.y + offset, self.layer.frame.size.width, self.layer.frame.size.height);
        return self.layer;
    };
}

- (TABBaseComponentFloatBlock)width {
    return ^TABComponentLayer *(CGFloat offset) {
        
        if (offset <= 0) {
            return self.layer;
        }
        
        self.layer.frame = CGRectMake(self.layer.frame.origin.x, self.layer.frame.origin.y, offset, self.layer.frame.size.height);
        return self.layer;
    };
}

- (TABBaseComponentFloatBlock)height {
    return ^TABComponentLayer *(CGFloat offset) {
        
        if (offset <= 0) {
            return self.layer;
        }
        
        self.layer.tabViewHeight = offset;
        return self.layer;
    };
}

- (TABBaseComponentFloatBlock)radius {
    return ^TABComponentLayer *(CGFloat offset) {
        self.layer.cornerRadius = offset;
        return self.layer;
    };
}

- (TABBaseComponentFloatBlock)reducedWidth {
    return ^TABComponentLayer *(CGFloat offset) {
        self.layer.frame = CGRectMake(self.layer.frame.origin.x, self.layer.frame.origin.y, self.layer.frame.size.width - offset, self.layer.frame.size.height);
        return self.layer;
    };
}

- (TABBaseComponentFloatBlock)reducedHeight {
    return ^TABComponentLayer *(CGFloat offset) {
        self.layer.tabViewHeight = self.layer.frame.size.height - offset;
        return self.layer;
    };
}

- (TABBaseComponentFloatBlock)x {
    return ^TABComponentLayer *(CGFloat offset) {
        self.layer.frame = CGRectMake(offset, self.layer.frame.origin.y, self.layer.frame.size.width, self.layer.frame.size.height);
        return self.layer;
    };
}

- (TABBaseComponentFloatBlock)y {
    return ^TABComponentLayer *(CGFloat offset) {
        self.layer.frame = CGRectMake(self.layer.frame.origin.x, offset, self.layer.frame.size.width, self.layer.frame.size.height);
        return self.layer;
    };
}

- (TABBaseComponentIntegerBlock)line {
    return ^TABComponentLayer *(NSInteger value) {
        self.layer.numberOflines = value;
        return self.layer;
    };
}

- (TABBaseComponentFloatBlock)space {
    return ^TABComponentLayer *(CGFloat value) {
        self.layer.lineSpace = value;
        return self.layer;
    };
}

- (TABBaseComponentFloatBlock)lastLineScale {
    return ^TABComponentLayer *(CGFloat value) {
        self.layer.lastScale = value;
        return self.layer;
    };
}

- (TABBaseComponentVoidBlock)remove {
    return ^TABComponentLayer *(void) {
        self.layer.loadStyle = TABViewLoadAnimationRemove;
        return self.layer;
    };
}

- (TABBaseComponentStringBlock)placeholder {
    return ^TABComponentLayer *(NSString *string) {
        self.layer.contents = (id)[UIImage imageNamed:string].CGImage;
        return self.layer;
    };
}

- (TABBaseComponentVoidBlock)toLongAnimation {
    return ^TABComponentLayer *(void) {
        self.layer.loadStyle = TABViewLoadAnimationToLong;
        return self.layer;
    };
}

- (TABBaseComponentVoidBlock)toShortAnimation {
    return ^TABComponentLayer *(void) {
        self.layer.loadStyle = TABViewLoadAnimationToShort;
        return self.layer;
    };
}

- (TABBaseComponentVoidBlock)cancelAlignCenter {
    return ^TABComponentLayer *(void) {
        self.layer.isCancelAlignCenter = YES;
        return self.layer;
    };
}

- (TABBaseComponentColorBlock)color {
    return ^TABComponentLayer *(UIColor *color) {
        self.layer.backgroundColor = color.CGColor;
        return self.layer;
    };
}

- (TABBaseComponentIntegerBlock)dropIndex {
    return ^TABComponentLayer *(NSInteger value) {
        self.layer.dropAnimationIndex = value;
        return self.layer;
    };
}

- (TABBaseComponentIntegerBlock)dropFromIndex {
    return ^TABComponentLayer *(NSInteger value) {
        self.layer.dropAnimationFromIndex = value;
        return self.layer;
    };
}

- (TABBaseComponentVoidBlock)removeOnDrop {
    return ^TABComponentLayer *(void) {
        self.layer.removeOnDropAnimation = YES;
        return self.layer;
    };
}

- (TABBaseComponentFloatBlock)dropStayTime {
    return ^TABComponentLayer *(CGFloat value) {
        self.layer.dropAnimationStayTime = value;
        return self.layer;
    };
}

@end
