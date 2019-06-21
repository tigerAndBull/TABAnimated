//
//  TABComponentLayer.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/4/26.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABComponentLayer.h"

@implementation TABComponentLayer

- (instancetype)init {
    if (self = [super init]) {
        self.name = @"TABLayer";
        self.anchorPoint = CGPointMake(0, 0);
        self.position = CGPointMake(0, 0);
        self.opaque = YES;
        self.opacity = 1.0;
        
        self.dropAnimationStayTime = 0.2;
        
        self.lastScale = 0.5;
        self.dropAnimationFromIndex = -1;
        self.dropAnimationIndex = -1;
        self.removeOnDropAnimation = NO;
    }
    return self;
}

- (CGFloat)lineSpace {
    if (_lineSpace == 0.) {
        return 8.;
    }
    return _lineSpace;
}

- (TABComponentLayerBlock)up {
    return ^TABComponentLayer *(CGFloat offset) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - offset, self.frame.size.width, self.frame.size.height);
        return self;
    };
}

- (TABComponentLayerBlock)down {
    return ^TABComponentLayer *(CGFloat offset) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + offset, self.frame.size.width, self.frame.size.height);
        return self;
    };
}

- (TABComponentLayerBlock)left {
    return ^TABComponentLayer *(CGFloat offset) {
        self.frame = CGRectMake(self.frame.origin.x - offset, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        return self;
    };
}

- (TABComponentLayerBlock)right {
    return ^TABComponentLayer *(CGFloat offset) {
        self.frame = CGRectMake(self.frame.origin.x + offset, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        return self;
    };
}

- (TABComponentLayerBlock)width {
    return ^TABComponentLayer *(CGFloat offset) {
        
        if (offset <= 0) {
            return self;
        }
        
        self.tabViewWidth = offset;
        return self;
    };
}

- (TABComponentLayerBlock)height {
    return ^TABComponentLayer *(CGFloat offset) {
        
        if (offset <= 0) {
            return self;
        }
        
        self.tabViewHeight = offset;
        return self;
    };
}

- (TABComponentLayerBlock)reducedWidth {
    return ^TABComponentLayer *(CGFloat offset) {
        self.tabViewWidth = self.frame.size.width - offset;
        return self;
    };
}

- (TABComponentLayerBlock)reducedHeight {
    return ^TABComponentLayer *(CGFloat offset) {
        self.tabViewHeight = self.frame.size.height - offset;
        return self;
    };
}

- (TABComponentLayerBlock)radius {
    return ^TABComponentLayer *(CGFloat offset) {
        self.cornerRadius = offset;
        return self;
    };
}

- (TABComponentLayerLinesBlock)line {
    return ^TABComponentLayer *(NSInteger value) {
        self.numberOflines = value;
        return self;
    };
}

- (TABComponentLayerBlock)space {
    return ^TABComponentLayer *(CGFloat value) {
        self.lineSpace = value;
        return self;
    };
}

- (TABComponentLayerBlock)lastLineScale {
    return ^TABComponentLayer *(CGFloat value) {
        self.lastScale = value;
        return self;
    };
}

- (TABLoadStyleBlock)remove {
    return ^TABComponentLayer *(void) {
        self.loadStyle = TABViewLoadAnimationRemove;
        return self;
    };
}

- (TABLoadStyleBlock)toLongAnimation {
    return ^TABComponentLayer *(void) {
        self.loadStyle = TABViewLoadAnimationToLong;
        return self;
    };
}

- (TABLoadStyleBlock)toShortAnimation {
    return ^TABComponentLayer *(void) {
        self.loadStyle = TABViewLoadAnimationToShort;
        return self;
    };
}

- (TABLoadStyleBlock)cancelAlignCenter {
    return ^TABComponentLayer *(void) {
        self.isCancelAlignCenter = YES;
        return self;
    };
}

- (TABComponentLayerLinesBlock)dropIndex {
    return ^TABComponentLayer *(NSInteger value) {
        self.dropAnimationIndex = value;
        return self;
    };
}

- (TABComponentLayerLinesBlock)dropFromIndex {
    return ^TABComponentLayer *(NSInteger value) {
        self.dropAnimationFromIndex = value;
        return self;
    };
}

- (TABLoadStyleBlock)removeOnDrop {
    return ^TABComponentLayer *(void) {
        self.removeOnDropAnimation = YES;
        return self;
    };
}

- (TABComponentLayerBlock)dropStayTime {
    return ^TABComponentLayer *(CGFloat value) {
        self.dropAnimationStayTime = value;
        return self;
    };
}

@end
