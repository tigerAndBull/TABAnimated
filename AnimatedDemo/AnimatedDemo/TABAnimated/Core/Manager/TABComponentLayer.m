//
//  TABComponentLayer.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/4/26.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABComponentLayer.h"

extern const NSInteger TABViewAnimatedErrorCode;

@implementation TABComponentLayer

- (instancetype)init {
    if (self = [super init]) {
        self.name = @"TABLayer";
        self.anchorPoint = CGPointMake(0, 0);
        self.position = CGPointMake(0, 0);
        self.opaque = YES;
        self.contentsGravity = kCAGravityResizeAspect;
        
        self.tagIndex = TABViewAnimatedErrorCode;
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

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (id)copyWithZone:(NSZone *)zone {
    TABComponentLayer *layer = [[[self class] allocWithZone:zone] init];
    
    layer.loadStyle = self.loadStyle;
    layer.fromImageView = self.fromImageView;
    layer.fromCenterLabel = self.fromCenterLabel;
    layer.isCancelAlignCenter = self.isCancelAlignCenter;
    layer.tabViewHeight = self.tabViewHeight;
    layer.numberOflines = self.numberOflines;
    layer.lineSpace = self.lineSpace;
    layer.lastScale = self.lastScale;
    
    layer.dropAnimationIndex = self.dropAnimationIndex;
    layer.dropAnimationFromIndex = self.dropAnimationFromIndex;
    layer.removeOnDropAnimation = self.removeOnDropAnimation;
    layer.dropAnimationStayTime = self.dropAnimationStayTime;
    
    if (self.contents) {
        layer.contents = self.contents;
    }
    layer.placeholderName = self.placeholderName;
    
    layer.tagIndex = self.tagIndex;
    
    layer.frame = self.frame;
    layer.resultFrameValue = [NSValue valueWithCGRect:self.frame];
    layer.backgroundColor = self.backgroundColor;
    layer.shadowOffset = self.shadowOffset;
    layer.shadowColor = self.shadowColor;
    layer.shadowRadius = self.shadowRadius;
    layer.shadowOpacity = self.shadowOpacity;
    layer.cornerRadius = self.cornerRadius;
    layer.anchorPoint = self.anchorPoint;
    layer.position = self.position;
    layer.opaque = self.opaque;
    layer.contentsScale = self.contentsScale;
    
    return layer;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[NSValue valueWithCGRect:self.frame] forKey:@"resultFrameValue"];
    [aCoder encodeObject:[UIColor colorWithCGColor:self.backgroundColor] forKey:@"backgroundColor"];
    [aCoder encodeFloat:self.cornerRadius forKey:@"cornerRadius"];
    
    [aCoder encodeInteger:_tagIndex forKey:@"tagIndex"];
    [aCoder encodeInteger:_loadStyle forKey:@"loadStyle"];
    [aCoder encodeBool:_fromImageView forKey:@"fromImageView"];
    [aCoder encodeBool:_fromCenterLabel forKey:@"fromCenterLabel"];
    [aCoder encodeBool:_isCancelAlignCenter forKey:@"isCancelAlignCenter"];
    [aCoder encodeFloat:_tabViewHeight forKey:@"tabViewHeight"];
    [aCoder encodeInteger:_numberOflines forKey:@"numberOflines"];
    [aCoder encodeFloat:_lineSpace forKey:@"lineSpace"];
    [aCoder encodeFloat:_lastScale forKey:@"lastScale"];
    
    [aCoder encodeInteger:_dropAnimationIndex forKey:@"dropAnimationIndex"];
    [aCoder encodeInteger:_dropAnimationFromIndex forKey:@"dropAnimationFromIndex"];
    [aCoder encodeBool:_removeOnDropAnimation forKey:@"removeOnDropAnimation"];
    [aCoder encodeFloat:_dropAnimationStayTime forKey:@"dropAnimationStayTime"];
    
    [aCoder encodeObject:_placeholderName forKey:@"placeholderName"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = @"TABLayer";
        self.anchorPoint = CGPointMake(0, 0);
        self.position = CGPointMake(0, 0);
        self.opaque = YES;
        self.contentsGravity = kCAGravityResizeAspect;
        
        self.resultFrameValue = [aDecoder decodeObjectForKey:@"resultFrameValue"];
        self.frame = [self.resultFrameValue CGRectValue];
        self.backgroundColor = [(UIColor *)[aDecoder decodeObjectForKey:@"backgroundColor"] CGColor];
        self.cornerRadius = [aDecoder decodeFloatForKey:@"cornerRadius"];
        
        self.tagIndex = [aDecoder decodeIntegerForKey:@"tagIndex"];
        self.loadStyle = [aDecoder decodeIntegerForKey:@"loadStyle"];
        self.fromImageView = [aDecoder decodeBoolForKey:@"fromImageView"];
        self.fromCenterLabel = [aDecoder decodeBoolForKey:@"fromCenterLabel"];
        self.isCancelAlignCenter = [aDecoder decodeBoolForKey:@"isCancelAlignCenter"];
        self.tabViewHeight = [aDecoder decodeFloatForKey:@"tabViewHeight"];
        self.numberOflines = [aDecoder decodeIntegerForKey:@"numberOflines"];
        self.lineSpace = [aDecoder decodeFloatForKey:@"lineSpace"];
        self.lastScale = [aDecoder decodeFloatForKey:@"lastScale"];
        
        self.dropAnimationIndex = [aDecoder decodeIntegerForKey:@"dropAnimationIndex"];
        self.dropAnimationFromIndex = [aDecoder decodeIntegerForKey:@"dropAnimationFromIndex"];
        self.removeOnDropAnimation = [aDecoder decodeBoolForKey:@"removeOnDropAnimation"];
        self.dropAnimationStayTime = [aDecoder decodeFloatForKey:@"dropAnimationStayTime"];
        
        self.placeholderName = [aDecoder decodeObjectForKey:@"placeholderName"];
    }
    return self;
}

@end
