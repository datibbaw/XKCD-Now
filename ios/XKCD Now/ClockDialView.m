//
//  ClockDialView.m
//  XKCD Now
//
//  Created by Tjerk Anne Meesters on 15/3/14.
//  Copyright (c) 2014 Tjerk Anne Meesters. All rights reserved.
//

#import "ClockDialView.h"


@implementation ClockDialView

- (id)initWithFrame:(CGRect)frame AndType:(ClockDialType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        CGImageRef image = [self getDialImage];
        switch (type) {
            case InnerClockDial:
                [self.layer addSublayer:[self createInnerDial:image]];
                break;
            
            case OuterClockDial:
                [self.layer addSublayer:[self createOuterDial:image]];
                break;
        }
    }
    return self;
}

- (CALayer*)createOuterDial:(CGImageRef)image
{
    return [self createDialFromImage:image andMask:[self outerDialMaskFromImage:image]];
}

- (CALayer*)createInnerDial:(CGImageRef)image
{
    return [self createDialFromImage:image andMask:[self innerDialMaskFromImage:image]];
}

- (void)rotate:(CGFloat)angle
{
    self.transform = CGAffineTransformMakeRotation(angle);
}

- (CAShapeLayer*)innerDialMaskFromImage:(CGImageRef)image
{
    CAShapeLayer *mask = [CAShapeLayer layer];
    
    mask.path = [self pathFromImage:image andRadius:INNER_DIAL_RADIUS];
    
    return mask;
}

- (CALayer*)createDialFromImage:(CGImageRef)image andMask:(CAShapeLayer*)mask
{
    CALayer *layer = [CALayer layer];
    
    layer.bounds = self.bounds;
    layer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    layer.mask = mask;
    
    layer.contents = (__bridge id)(image);
    
    return layer;
}

- (CAShapeLayer*)outerDialMaskFromImage:(CGImageRef)image
{
    CAShapeLayer *mask = [CAShapeLayer layer];
    
    CGMutablePathRef path = CGPathCreateMutableCopy([self pathFromImage:image andRadius:OUTER_DIAL_RADIUS]);
    CGPathAddEllipseInRect(path, nil, self.bounds);
    
    mask.path = path;
    mask.fillRule = kCAFillRuleEvenOdd;
    
    return mask;
}

- (CGPathRef)pathFromImage:(CGImageRef)image andRadius:(float)radius
{
    float width = CGImageGetWidth(image);
    float inset = (float)(width - 2 * radius) / width * self.bounds.size.width / 2;
    
    return CGPathCreateWithEllipseInRect(CGRectInset(self.bounds, inset, inset), nil);
}

- (CGImageRef)getDialImage
{
    NSString* imageFileName = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"clockdial.png"];
    
    return CGImageCreateWithPNGDataProvider(CGDataProviderCreateWithFilename([imageFileName UTF8String]), NULL, YES, kCGRenderingIntentDefault);
}

@end
