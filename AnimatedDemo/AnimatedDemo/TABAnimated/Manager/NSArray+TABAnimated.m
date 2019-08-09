//
//  NSArray+TABAnimated.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/5/1.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "NSArray+TABAnimated.h"
#import "TABBaseComponent.h"

@implementation NSArray (TABAnimated)

- (TABAnimatedArrayFloatBlock)up {
    return ^NSArray <TABBaseComponent *> *(CGFloat offset) {
        for (TABBaseComponent *component in self) {
            component.up(offset);
        }
        return self;
    };
}

- (TABAnimatedArrayFloatBlock)down {
    return ^NSArray <TABBaseComponent *> *(CGFloat offset) {
        for (TABBaseComponent *component in self) {
            component.down(offset);
        }
        return self;
    };
}

- (TABAnimatedArrayFloatBlock)left {
    return ^NSArray <TABBaseComponent *> *(CGFloat offset) {
        for (TABBaseComponent *component in self) {
            component.left(offset);
        }
        return self;
    };
}

- (TABAnimatedArrayFloatBlock)right {
    return ^NSArray <TABBaseComponent *> *(CGFloat offset) {
        for (TABBaseComponent *component in self) {
            component.right(offset);
        }
        return self;
    };
}

- (TABAnimatedArrayFloatBlock)width {
    return ^NSArray <TABBaseComponent *> *(CGFloat offset) {
        for (TABBaseComponent *component in self) {
            component.width(offset);
        }
        return self;
    };
}

- (TABAnimatedArrayFloatBlock)height {
    return ^NSArray <TABBaseComponent *> *(CGFloat offset) {
        for (TABBaseComponent *component in self) {
            component.height(offset);
        }
        return self;
    };
}

- (TABAnimatedArrayFloatBlock)reducedWidth {
    return ^NSArray <TABBaseComponent *> *(CGFloat offset) {
        for (TABBaseComponent *component in self) {
            component.reducedWidth(offset);
        }
        return self;
    };
}

- (TABAnimatedArrayFloatBlock)reducedHeight {
    return ^NSArray <TABBaseComponent *> *(CGFloat offset) {
        for (TABBaseComponent *component in self) {
            component.reducedHeight(offset);
        }
        return self;
    };
}

- (TABAnimatedArrayFloatBlock)radius {
    return ^NSArray <TABBaseComponent *> *(CGFloat offset) {
        for (TABBaseComponent *component in self) {
            component.radius(offset);
        }
        return self;
    };
}

- (TABAnimatedArrayIntBlock)line {
    return ^NSArray <TABBaseComponent *> *(NSInteger value) {
        for (TABBaseComponent *component in self) {
            component.line(value);
        }
        return self;
    };
}

- (TABAnimatedArrayFloatBlock)space {
    return ^NSArray <TABBaseComponent *> *(CGFloat offset) {
        for (TABBaseComponent *component in self) {
            component.space(offset);
        }
        return self;
    };
}

- (TABAnimatedArrayBlock)remove {
    return ^NSArray <TABBaseComponent *> *(void) {
        for (TABBaseComponent *component in self) {
            component.remove();
        }
        return self;
    };
}

- (TABAnimatedArrayStringBlock)placeholder {
    return ^NSArray <TABBaseComponent *> *(NSString *string) {
        for (TABBaseComponent *component in self) {
            component.placeholder(string);
        }
        return self;
    };
}

- (TABAnimatedArrayFloatBlock)x {
    return ^NSArray <TABBaseComponent *> *(CGFloat offset) {
        for (TABBaseComponent *component in self) {
            component.x(offset);
        }
        return self;
    };
}

- (TABAnimatedArrayFloatBlock)y {
    return ^NSArray <TABBaseComponent *> *(CGFloat offset) {
        for (TABBaseComponent *component in self) {
            component.y(offset);
        }
        return self;
    };
}

#pragma mark - Drop Animation

- (TABAnimatedArrayIntBlock)dropIndex {
    return ^NSArray <TABBaseComponent *> *(NSInteger value) {
        for (TABBaseComponent *component in self) {
            component.dropIndex(value);
        }
        return self;
    };
}

- (TABAnimatedArrayIntBlock)dropFromIndex {
    return ^NSArray <TABBaseComponent *> *(NSInteger value) {
        for (TABBaseComponent *component in self) {
            component.dropFromIndex(value);
        }
        return self;
    };
}

- (TABAnimatedArrayBlock)removeOnDrop {
    return ^NSArray <TABBaseComponent *> *(void) {
        for (TABBaseComponent *component in self) {
            component.removeOnDrop();
        }
        return self;
    };
}

- (TABAnimatedArrayFloatBlock)dropStayTime {
    return ^NSArray <TABBaseComponent *> *(CGFloat offset) {
        for (TABBaseComponent *component in self) {
            component.dropStayTime(offset);
        }
        return self;
    };
}

@end
