//
//  NSArray+TABAnimated.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/5/1.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "NSArray+TABAnimatedChain.h"
#import "TABBaseComponent.h"

@implementation NSArray (TABAnimatedChain)

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

- (TABAnimatedArrayFloatBlock)reducedRadius {
    return ^NSArray <TABBaseComponent *> *(CGFloat offset) {
        for (TABBaseComponent *component in self) {
            component.reducedRadius(offset);
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

- (TABAnimatedArrayColorBlock)color {
    return ^NSArray <TABBaseComponent *> *(UIColor *color) {
        for (TABBaseComponent *component in self) {
            component.color(color);
        }
        return self;
    };
}

- (TABAnimatedArrayBlock)withoutAnimation {
    return ^NSArray <TABBaseComponent *> *(void) {
        for (TABBaseComponent *component in self) {
            component.withoutAnimation();
        }
        return self;
    };
}

/// 穿透组件
/// 在骨架屏期间暴露出该组件
- (TABAnimatedArrayBlock)penetrate {
    return ^NSArray <TABBaseComponent *> *(void) {
        for (TABBaseComponent *component in self) {
            component.penetrate();
        }
        return self;
    };
}

#pragma mark -

/// 居左
/// 需要一个参数：对应元素的index
- (TABComponentArrayCompareBlock)leftEqualTo {
    return ^NSArray <TABBaseComponent *> *(NSInteger index) {
        for (TABBaseComponent *component in self) {
            component.leftEqualTo(index);
        }
        return self;
    };
}

/// 居右
/// 需要一个参数：对应元素的index
- (TABComponentArrayCompareBlock)rightEqualTo {
    return ^NSArray <TABBaseComponent *> *(NSInteger index) {
        for (TABBaseComponent *component in self) {
            component.rightEqualTo(index);
        }
        return self;
    };
}

/// 居上
/// 需要一个参数：对应元素的index
- (TABComponentArrayCompareBlock)topEqualTo {
    return ^NSArray <TABBaseComponent *> *(NSInteger index) {
        for (TABBaseComponent *component in self) {
            component.topEqualTo(index);
        }
        return self;
    };
}

/// 居下
/// 需要一个参数：对应元素的index
- (TABComponentArrayCompareBlock)bottomEqualTo {
    return ^NSArray <TABBaseComponent *> *(NSInteger index) {
        for (TABBaseComponent *component in self) {
            component.bottomEqualTo(index);
        }
        return self;
    };
}

- (TABComponentArrayCompareBlock)widthEqualTo {
    return ^NSArray <TABBaseComponent *> *(NSInteger index) {
        for (TABBaseComponent *component in self) {
            component.widthEqualTo(index);
        }
        return self;
    };
}

- (TABComponentArrayCompareBlock)heightEqualTo {
    return ^NSArray <TABBaseComponent *> *(NSInteger index) {
        for (TABBaseComponent *component in self) {
            component.heightEqualTo(index);
        }
        return self;
    };
}

- (TABComponentArrayCompareBlock)leftEqualToRight {
    return ^NSArray <TABBaseComponent *> *(NSInteger index) {
        for (TABBaseComponent *component in self) {
            component.leftEqualToRight(index);
        }
        return self;
    };
}

- (TABComponentArrayCompareBlock)rightEqualToLeft {
    return ^NSArray <TABBaseComponent *> *(NSInteger index) {
        for (TABBaseComponent *component in self) {
            component.rightEqualToLeft(index);
        }
        return self;
    };
}

- (TABComponentArrayCompareBlock)topEqualToBottom {
    return ^NSArray <TABBaseComponent *> *(NSInteger index) {
        for (TABBaseComponent *component in self) {
            component.topEqualToBottom(index);
        }
        return self;
    };
}

- (TABComponentArrayCompareBlock)bottomEqualToTop {
    return ^NSArray <TABBaseComponent *> *(NSInteger index) {
        for (TABBaseComponent *component in self) {
            component.bottomEqualToTop(index);
        }
        return self;
    };
}

#pragma mark -

/// 居左
/// 参数1：对应元素的index
/// 参数2： 偏移量
- (TABComponentArrayCompareWithOffsetBlock)leftEqualTo_offset {
    return ^NSArray <TABBaseComponent *> *(NSInteger index, CGFloat offset) {
        for (TABBaseComponent *component in self) {
            component.leftEqualTo_offset(index, offset);
        }
        return self;
    };
}

/// 居右
/// 参数1：对应元素的index
/// 参数2： 偏移量
- (TABComponentArrayCompareWithOffsetBlock)rightEqualTo_offset {
    return ^NSArray <TABBaseComponent *> *(NSInteger index, CGFloat offset) {
        for (TABBaseComponent *component in self) {
            component.rightEqualTo_offset(index, offset);
        }
        return self;
    };
}

/// 居上
/// 参数1：对应元素的index
/// 参数2： 偏移量
- (TABComponentArrayCompareWithOffsetBlock)topEqualTo_offset {
    return ^NSArray <TABBaseComponent *> *(NSInteger index, CGFloat offset) {
        for (TABBaseComponent *component in self) {
            component.topEqualTo_offset(index, offset);
        }
        return self;
    };
}

/// 居下
/// 参数1：对应元素的index
/// 参数2： 偏移量
- (TABComponentArrayCompareWithOffsetBlock)bottomEqualTo_offset {
    return ^NSArray <TABBaseComponent *> *(NSInteger index, CGFloat offset) {
        for (TABBaseComponent *component in self) {
            component.bottomEqualTo_offset(index, offset);
        }
        return self;
    };
}

- (TABComponentArrayCompareWithOffsetBlock)widthEqualTo_offset {
    return ^NSArray <TABBaseComponent *> *(NSInteger index, CGFloat offset) {
        for (TABBaseComponent *component in self) {
            component.widthEqualTo_offset(index, offset);
        }
        return self;
    };
}

- (TABComponentArrayCompareWithOffsetBlock)heightEqualTo_offset {
    return ^NSArray <TABBaseComponent *> *(NSInteger index, CGFloat offset) {
        for (TABBaseComponent *component in self) {
            component.heightEqualTo_offset(index, offset);
        }
        return self;
    };
}

- (TABComponentArrayCompareWithOffsetBlock)leftEqualToRight_offset {
    return ^NSArray <TABBaseComponent *> *(NSInteger index, CGFloat offset) {
        for (TABBaseComponent *component in self) {
            component.leftEqualToRight_offset(index, offset);
        }
        return self;
    };
}

- (TABComponentArrayCompareWithOffsetBlock)rightEqualToLeft_offset {
    return ^NSArray <TABBaseComponent *> *(NSInteger index, CGFloat offset) {
        for (TABBaseComponent *component in self) {
            component.rightEqualToLeft_offset(index, offset);
        }
        return self;
    };
}

- (TABComponentArrayCompareWithOffsetBlock)topEqualToBottom_offset {
    return ^NSArray <TABBaseComponent *> *(NSInteger index, CGFloat offset) {
        for (TABBaseComponent *component in self) {
            component.topEqualToBottom_offset(index, offset);
        }
        return self;
    };
}

- (TABComponentArrayCompareWithOffsetBlock)bottomEqualToTop_offset {
    return ^NSArray <TABBaseComponent *> *(NSInteger index, CGFloat offset) {
        for (TABBaseComponent *component in self) {
            component.bottomEqualToTop_offset(index, offset);
        }
        return self;
    };
}

@end
