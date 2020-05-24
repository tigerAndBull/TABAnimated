
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 非线程安全
@interface TABWeakDelegateManager : NSObject

- (void)addDelegate:(id)delegate;
- (void)removeDelegate:(id)delegate;
- (void)removeAllDelegates;

- (void)enumerateDelegatesUsingBlock:(void (^)(id delegate))block;
- (NSArray *)getDelegates;

@property (readonly) NSUInteger count;

@end

NS_ASSUME_NONNULL_END
