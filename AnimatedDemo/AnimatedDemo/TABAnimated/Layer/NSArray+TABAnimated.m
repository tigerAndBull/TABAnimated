//
//  NSArray+TABAnimated.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/5/1.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "NSArray+TABAnimated.h"

@implementation NSArray (TABAnimated)

- (TABAnimatedArrayFloatBlock)up {
    return ^NSArray <TABComponentLayer *> *(CGFloat offset) {
        for (TABComponentLayer *layer in self) {
            layer.frame = CGRectMake(layer.frame.origin.x, layer.frame.origin.y - offset, layer.frame.size.width, layer.frame.size.height);
        }
        return self;
    };
}

- (TABAnimatedArrayFloatBlock)down {
    return ^NSArray <TABComponentLayer *> *(CGFloat offset) {
        for (TABComponentLayer *layer in self) {
            layer.frame = CGRectMake(layer.frame.origin.x, layer.frame.origin.y + offset, layer.frame.size.width, layer.frame.size.height);
        }
        return self;
    };
}

- (TABAnimatedArrayFloatBlock)left {
    return ^NSArray <TABComponentLayer *> *(CGFloat offset) {
        for (TABComponentLayer *layer in self) {
            layer.frame = CGRectMake(layer.frame.origin.x - offset, layer.frame.origin.y, layer.frame.size.width, layer.frame.size.height);
        }
        return self;
    };

}

- (TABAnimatedArrayFloatBlock)right {
    return ^NSArray <TABComponentLayer *> *(CGFloat offset) {
        for (TABComponentLayer *layer in self) {
            layer.frame = CGRectMake(layer.frame.origin.x + offset, layer.frame.origin.y, layer.frame.size.width, layer.frame.size.height);
        }
        return self;
    };
}

- (TABAnimatedArrayFloatBlock)width {
    return ^NSArray <TABComponentLayer *> *(CGFloat offset) {
        for (TABComponentLayer *layer in self) {
            layer.tabViewWidth = offset;
        }
        return self;
    };
}

- (TABAnimatedArrayFloatBlock)height {
    return ^NSArray <TABComponentLayer *> *(CGFloat offset) {
        for (TABComponentLayer *layer in self) {
            layer.tabViewHeight = offset;
        }
        return self;
    };
}

- (TABAnimatedArrayFloatBlock)reducedWidth {
    return ^NSArray <TABComponentLayer *> *(CGFloat offset) {
        for (TABComponentLayer *layer in self) {
            layer.tabViewWidth = layer.frame.size.width - offset;
        }
        return self;
    };
}

- (TABAnimatedArrayFloatBlock)reducedHeight {
    return ^NSArray <TABComponentLayer *> *(CGFloat offset) {
        for (TABComponentLayer *layer in self) {
            layer.tabViewHeight = layer.frame.size.height - offset;
        }
        return self;
    };
}

- (TABAnimatedArrayFloatBlock)radius {
    return ^NSArray <TABComponentLayer *> *(CGFloat offset) {
        for (TABComponentLayer *layer in self) {
            layer.cornerRadius = offset;
        }
        return self;
    };
}

- (TABAnimatedArrayIntBlock)line {
    return ^NSArray <TABComponentLayer *> *(NSInteger value) {
        for (TABComponentLayer *layer in self) {
            layer.numberOflines = value;
        }
        return self;
    };
}

- (TABAnimatedArrayFloatBlock)space {
    return ^NSArray <TABComponentLayer *> *(CGFloat offset) {
        for (TABComponentLayer *layer in self) {
            layer.lineSpace = offset;
        }
        return self;
    };
}

- (TABAnimatedArrayBlock)remove {
    return ^NSArray <TABComponentLayer *> *(void) {
        for (TABComponentLayer *layer in self) {
            layer.loadStyle = TABViewLoadAnimationRemove;
        }
        return self;
    };
}

#pragma mark - Drop Animation

- (TABAnimatedArrayIntBlock)dropIndex {
    return ^NSArray <TABComponentLayer *> *(NSInteger value) {
        for (TABComponentLayer *layer in self) {
            layer.dropAnimationIndex = value;
        }
        return self;
    };
}

- (TABAnimatedArrayIntBlock)dropFromIndex {
    return ^NSArray <TABComponentLayer *> *(NSInteger value) {
        for (TABComponentLayer *layer in self) {
            layer.dropAnimationFromIndex = value;
        }
        return self;
    };
}

- (TABAnimatedArrayBlock)removeOnDrop {
    return ^NSArray <TABComponentLayer *> *(void) {
        for (TABComponentLayer *layer in self) {
            layer.removeOnDropAnimation = YES;
        }
        return self;
    };
}

- (TABAnimatedArrayFloatBlock)dropStayTime {
    return ^NSArray <TABComponentLayer *> *(CGFloat offset) {
        for (TABComponentLayer *layer in self) {
            layer.dropAnimationStayTime = offset;
        }
        return self;
    };
}

@end
