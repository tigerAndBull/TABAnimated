//
//  TABComponentLayer+TABAnimated.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/7/6.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABComponentLayer+TABAnimated.h"

@implementation TABComponentLayer (TABAnimated)

- (TABComponentLayerBlock)x {
    return ^TABComponentLayer *(CGFloat offset) {
        self.frame = CGRectMake(offset, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        return self;
    };
}

- (TABComponentLayerBlock)y {
    return ^TABComponentLayer *(CGFloat offset) {
        self.frame = CGRectMake(self.frame.origin.x, offset, self.frame.size.width, self.frame.size.height);
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

- (TABComponentLayerBlock)width {
    return ^TABComponentLayer *(CGFloat offset) {
        
        if (offset <= 0) {
            return self;
        }
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, offset, self.frame.size.height);
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

- (TABComponentLayerBlock)radius {
    return ^TABComponentLayer *(CGFloat offset) {
        self.cornerRadius = offset;
        return self;
    };
}

- (TABComponentLayerBlock)reducedWidth {
    return ^TABComponentLayer *(CGFloat offset) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width - offset, self.frame.size.height);
        return self;
    };
}

- (TABComponentLayerBlock)reducedHeight {
    return ^TABComponentLayer *(CGFloat offset) {
        self.tabViewHeight = self.frame.size.height - offset;
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

- (TABComponentStringBlock)placeholder {
    return ^TABComponentLayer *(NSString *string) {
        self.contents = (id)[UIImage imageNamed:string].CGImage;
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
