//
//  ClockView.m
//  XKCD Now
//
//  Created by Tjerk Anne Meesters on 15/3/14.
//  Copyright (c) 2014 Tjerk Anne Meesters. All rights reserved.
//

#import "ClockView.h"

#define DEGREES_PER_SECOND (M_PI / 43200)

@interface ClockView() {
    NSTimer *timer;

    NSDateFormatter *dateFormatter;
    UILabel *offset;
  
    CALayer *innerDial;
    CALayer *outerDial;
    
    TimeMode _mode;
}
@end

@implementation ClockView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    CGImageRef image = [self getDialImage];

    innerDial = [self createInnerDial:image];
    outerDial = [self createOuterDial:image];

    [self.layer addSublayer:outerDial];
    [self.layer addSublayer:innerDial];
    
    [self addGestureRecognizer:[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)]];
    
    [self setMode:TimeModeUniversal];

    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";

    offset = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 40, 15)];
//    offset.text = @"HH:mm";
    offset.adjustsFontSizeToFitWidth = YES;

    [self addSubview:offset];
}

- (void)startUpdates
{
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(updateDials) userInfo:nil repeats:YES];
}

- (void)stopUpdates
{
    [timer invalidate];
    timer = nil;
}

- (void)updateDials
{
    NSDate *now = [NSDate date];
    NSTimeZone *utc = [NSTimeZone timeZoneForSecondsFromGMT:0];

    innerDial.transform = CATransform3DMakeRotation(getSecondsSinceMidnight(now, utc) * DEGREES_PER_SECOND, 0, 0, 1);
}

- (TimeMode)mode
{
    return _mode;
}

- (void)setMode:(TimeMode)mode
{
    _mode = mode;

    switch (mode) {
        case TimeModeLocal:
            
            break;
            
        case TimeModeUniversal:
            outerDial.transform = CATransform3DMakeRotation(0, 0, 0, 1);
            break;
    }

    [self updateDials];
}

- (void)handleRotation:(UIRotationGestureRecognizer*)sender
{
    if (sender.rotation > 0) {
        sender.rotation = 0;
    } else if (sender.rotation < -M_PI) {
        sender.rotation = -M_PI;
    }

    if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled) {
        [self updateOffset:0];
    } else {
        [self updateOffset:sender.rotation];
    }
}

- (void)updateOffset:(CGFloat)rotation
{
    if (rotation) {
        NSDate *date = [[NSDate date] dateByAddingTimeInterval:-rotation / DEGREES_PER_SECOND];
        
        offset.text = [dateFormatter stringFromDate:date];
    } else {
        offset.text = @"";
    }
    outerDial.transform = CATransform3DMakeRotation(rotation, 0, 0, 1);
}

- (CALayer*)createOuterDial:(CGImageRef)image
{
    return [self createDialFromImage:image andMask:[self outerDialMaskFromImage:image]];
}

- (CALayer*)createInnerDial:(CGImageRef)image
{
    return [self createDialFromImage:image andMask:[self innerDialMaskFromImage:image]];
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

static NSTimeInterval getSecondsSinceMidnight(NSDate* date, NSTimeZone *timeZone)
{
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSCalendar *calendar = [NSCalendar currentCalendar];

    [calendar setTimeZone:timeZone];

    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];

    return [date timeIntervalSinceDate:[calendar dateFromComponents:components]];
}

@end
