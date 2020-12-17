//
//  TABComponentLayer.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/4/26.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABComponentLayer.h"
#import "TABAnimatedProductHelper.h"
#import "TABAnimated.h"
#import "TABComponentLayerSerializationInterface.h"

static NSString * const TABComponentLayerName = @"TABLayer";
static const CGFloat kDefaultHeight = 16.f;

@implementation TABComponentLayer

- (instancetype)init {
    if (self = [super init]) {
        self.name = TABComponentLayerName;
        self.anchorPoint = CGPointMake(0, 0);
        self.opaque = YES;
        self.contentsGravity = kCAGravityResizeAspect;
        _tagIndex = TABAnimatedIndexTag;
    }
    return self;
}

- (void)setBackgroundColor:(CGColorRef)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    for (TABComponentLayer *layer in _lineLayers) {
        layer.backgroundColor = backgroundColor;
    }
}

- (CGRect)resetFrameWithRect:(CGRect)rect animatedHeight:(CGFloat)animatedHeight {
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    if (_origin != TABComponentLayerOriginImageView) {
        if (animatedHeight > 0.) {
            height = animatedHeight;
        }else if (_origin == TABComponentLayerOriginLabel ||
                  _origin == TABComponentLayerOriginLinesLabel ||
                  _origin == TABComponentLayerOriginCenterLabel) {
            height = rect.size.height*[TABAnimated sharedAnimated].animatedHeightCoefficient;
            if (self.cornerRadius > 0) {
                CGFloat originScale = self.cornerRadius/rect.size.height;
                if (originScale == .5 && rect.size.width == rect.size.height) width = height;
                self.cornerRadius = height*originScale;
            }
        }
    }

    rect = CGRectMake(rect.origin.x, rect.origin.y, width, height);
    
    return rect;
}

- (void)addLayer:(TABComponentLayer *)layer viewWidth:(CGFloat)viewWidth animatedHeight:(CGFloat)animatedHeight {
    
    if (!CGRectEqualToRect(layer.adjustingFrame, CGRectZero)) {
        if (layer.origin != TABComponentLayerOriginCenterLabel) {
            layer.frame = layer.adjustingFrame;
        }else {
            CGRect frame = layer.adjustingFrame;
            CGRect rect = CGRectMake((viewWidth - frame.size.width)/2.0, frame.origin.y, frame.size.width, frame.size.height);
            layer.frame = rect;
        }
    }
    
    if (layer.numberOflines == 1) {
        [self addSublayer:layer];
    #ifdef DEBUG
           // 添加红色标记
           if ([TABAnimated sharedAnimated].openAnimationTag) {
               [TABAnimatedProductHelper addTagWithComponentLayer:layer isLines:layer.numberOflines == 1 ? NO : YES];
           }
    #endif
    }else {
        [self _addLinesLayer:layer animatedHeight:animatedHeight];
    }
}

- (void)_addLinesLayer:(TABComponentLayer *)layer animatedHeight:(CGFloat)animatedHeight {
    
    CGRect frame = layer.frame;
    NSInteger lines = layer.numberOflines;
    CGFloat space = layer.lineSpace;
    CGFloat lastScale = layer.lastScale;
    CGColorRef colorRef = layer.backgroundColor;
    CGFloat cornerRadius = layer.cornerRadius;
    TABViewLoadAnimationStyle loadStyle = layer.loadStyle;
    BOOL withoutAnimation = layer.withoutAnimation;
    NSInteger tagIndex = layer.tagIndex;
    TABComponentLayerOrigin origin = layer.origin;
    
    CGFloat textHeight;
    if (animatedHeight > 0.) {
        textHeight = animatedHeight;
    }else if (layer.isChangedHeight) {
        textHeight = frame.size.height;
    }else {
        textHeight = kDefaultHeight*[TABAnimated sharedAnimated].animatedHeightCoefficient;
    }
    
    if (lines == 0) {
        lines = (frame.size.height*1.0)/(textHeight+space);
        if (lines >= 0 && lines <= 1) {
            lines = 3;
        }
    }
    
    for (NSInteger i = 0; i < lines; i++) {
        
        CGRect rect;
        if (i != lines - 1) {
            rect = CGRectMake(frame.origin.x, frame.origin.y+i*(textHeight+space), frame.size.width, textHeight);
        }else {
            rect = CGRectMake(frame.origin.x, frame.origin.y+i*(textHeight+space), frame.size.width*lastScale, textHeight);
        }
        
        TABComponentLayer *sub = [[TABComponentLayer alloc]init];
        sub.frame = rect;
        sub.backgroundColor = colorRef;
        sub.cornerRadius = cornerRadius;
        sub.loadStyle = loadStyle;
        sub.withoutAnimation = withoutAnimation;
        sub.origin = origin;
        
        if (i == lines - 1) {
            sub.tagIndex = tagIndex;
#ifdef DEBUG
            // 添加红色标记
            if ([TABAnimated sharedAnimated].openAnimationTag)
                [TABAnimatedProductHelper addTagWithComponentLayer:sub isLines:YES];
#endif
        }else {
            sub.tagIndex = TABAnimatedIndexTag;
        }
        
        [self addSublayer:sub];
        [layer.lineLayers addObject:sub];
    }
}

#pragma mark -

- (CGFloat)lastScale {
    return (_lastScale == 0.) ? .5 : _lastScale;
}

- (CGFloat)lineSpace {
    return (_lineSpace == 0.) ? 8. : _lineSpace;
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:[NSValue valueWithCGRect:self.frame] forKey:@"resultFrameValue"];
    [aCoder encodeObject:[UIColor colorWithCGColor:self.backgroundColor] forKey:@"backgroundColor"];
    [aCoder encodeFloat:self.cornerRadius forKey:@"cornerRadius"];
    
    [aCoder encodeInteger:_tagIndex forKey:@"tagIndex"];
    [aCoder encodeInteger:_loadStyle forKey:@"loadStyle"];
    [aCoder encodeInteger:_origin forKey:@"origin"];
    [aCoder encodeInteger:_numberOflines forKey:@"numberOflines"];
    [aCoder encodeFloat:_lineSpace forKey:@"lineSpace"];
    [aCoder encodeFloat:_lastScale forKey:@"lastScale"];
    
    [aCoder encodeBool:_withoutAnimation forKey:@"withoutAnimation"];
    [aCoder encodeObject:_placeholderName forKey:@"placeholderName"];
    
    if (self.serializationImpl) {
        [aCoder encodeObject:NSStringFromClass(self.serializationImpl.class) forKey:@"serializationImpl"];
        [self.serializationImpl tab_encodeWithCoder:aCoder layer:self];
    }
    
    [aCoder encodeCGPoint:self.startPoint forKey:@"startPoint"];
    [aCoder encodeCGPoint:self.endPoint forKey:@"endPoint"];
    [aCoder encodeObject:self.locations forKey:@"loactions"];
    NSMutableArray *colorObjectArray = @[].mutableCopy;
    for (id color in self.colors) {
        CGColorRef cgcolor = (__bridge CGColorRef)color;
        [colorObjectArray addObject:[UIColor colorWithCGColor:cgcolor]];
    }
    [aCoder encodeObject:colorObjectArray forKey:@"colors"];
    [aCoder encodeBool:self.masksToBounds forKey:@"masksToBounds"];
    
    [aCoder encodeBool:_isCard forKey:@"isCard"];
    [aCoder encodeCGRect:_originFrame forKey:@"originFrame"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        
        self.resultFrameValue = [aDecoder decodeObjectForKey:@"resultFrameValue"];
        self.frame = [self.resultFrameValue CGRectValue];
        self.originFrame = [aDecoder decodeCGRectForKey:@"originFrame"];
        self.backgroundColor = [(UIColor *)[aDecoder decodeObjectForKey:@"backgroundColor"] CGColor];
        self.cornerRadius = [aDecoder decodeFloatForKey:@"cornerRadius"];
        
        self.tagIndex = [aDecoder decodeIntegerForKey:@"tagIndex"];
        self.loadStyle = [aDecoder decodeIntegerForKey:@"loadStyle"];
        self.origin = [aDecoder decodeIntegerForKey:@"origin"];
        self.numberOflines = [aDecoder decodeIntegerForKey:@"numberOflines"];
        self.lineSpace = [aDecoder decodeFloatForKey:@"lineSpace"];
        self.lastScale = [aDecoder decodeFloatForKey:@"lastScale"];
        self.placeholderName = [aDecoder decodeObjectForKey:@"placeholderName"];
        self.withoutAnimation = [aDecoder decodeBoolForKey:@"withoutAnimation"];
        
        NSString *serializationImplClassString = [aDecoder decodeObjectForKey:@"serializationImpl"];
        if (serializationImplClassString && serializationImplClassString.length > 0) {
            Class serializationImplClass = NSClassFromString(serializationImplClassString);
            if (serializationImplClass) {
                self.serializationImpl = serializationImplClass.new;
            }
        }
        
        self.startPoint = [aDecoder decodeCGPointForKey:@"startPoint"];
        self.endPoint = [aDecoder decodeCGPointForKey:@"endPoint"];
        self.locations = [aDecoder decodeObjectForKey:@"locations"];

        NSArray *colorObjectArray = [aDecoder decodeObjectForKey:@"colors"];
        NSMutableArray *cgcolorArray = @[].mutableCopy;
        for (UIColor *color in colorObjectArray) {
            [cgcolorArray addObject:(id)(color.CGColor)];
        }
        self.colors = cgcolorArray;
        self.masksToBounds = [aDecoder decodeBoolForKey:@"masksToBounds"];
        self.isCard = [aDecoder decodeBoolForKey:@"isCard"];
    }
    
    if (self.serializationImpl) {
        self = [self.serializationImpl tab_initWithCoder:aDecoder layer:self];
    }
    
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    
    TABComponentLayer *layer = [[[self class] allocWithZone:zone] init];
    
    layer.loadStyle = self.loadStyle;
    layer.origin  = self.origin;
    layer.originFrame = self.originFrame;
    layer.numberOflines = self.numberOflines;
    layer.lineSpace = self.lineSpace;
    layer.lastScale = self.lastScale;
    layer.withoutAnimation = self.withoutAnimation;
    
    if (self.contents) layer.contents = self.contents;
    
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
    
    if (self.serializationImpl) {
        layer.serializationImpl = self.serializationImpl;
        [self.serializationImpl propertyBindWithNewLayer:layer oldLayer:self];
    }
    
    layer.startPoint = self.startPoint;
    layer.endPoint = self.endPoint;
    layer.locations = self.locations;
    layer.colors = self.colors;
    layer.masksToBounds = self.masksToBounds;
    layer.isCard = self.isCard;
    return layer;
}

- (NSMutableArray *)lineLayers {
    if (!_lineLayers) {
        _lineLayers = @[].mutableCopy;
    }
    return _lineLayers;
}

@end
