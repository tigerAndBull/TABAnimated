
#import "TABWeakDelegateManager.h"

@interface TABWeakDelegateManager() {
    NSPointerArray * _delegates;
    NSHashTable * _delegatesMap;
}

@end

@implementation TABWeakDelegateManager

- (instancetype)init {
    if (self = [super init]) {
        _delegatesMap = [NSHashTable weakObjectsHashTable];
        _delegates = [NSPointerArray weakObjectsPointerArray];
    }
    return self;
}

#pragma mark -

- (void)addDelegate:(id)delegate {
    if (delegate && ![_delegatesMap containsObject:delegate]) {
        [_delegatesMap addObject:delegate];
        [_delegates addPointer:(__bridge void * _Nullable)(delegate)];
    }
}

- (void)removeDelegate:(id)delegate {
    if (delegate && [_delegatesMap containsObject:delegate]) {
        for (NSInteger i = 0; i < _delegates.count; i ++) {
            if (delegate == [_delegates pointerAtIndex:i]) {
                [_delegates replacePointerAtIndex:i withPointer:NULL];
            }
        }
        [_delegatesMap removeObject:delegate];
    }
    [self delegatesCompact];
}

- (void)removeAllDelegates {
    _delegates = [NSPointerArray weakObjectsPointerArray];
    [_delegatesMap removeAllObjects];
}
 
- (NSArray *)getDelegates {
    [self delegatesCompact];
    return [_delegates.allObjects copy];
}

- (void)enumerateDelegatesUsingBlock:(void (^)(id delegate))block {
    for (NSInteger i = 0; i < _delegates.count; i ++) {
        id delegate = [_delegates pointerAtIndex:i];
        if (block && delegate) {
            block(delegate);
        }
    }
}

- (NSUInteger)count {
    [self delegatesCompact];
    return _delegates.count;
}

#pragma mark - private

- (void)delegatesCompact {
    [_delegates addPointer:NULL]; // 触发compact
    [_delegates compact];
}

@end
