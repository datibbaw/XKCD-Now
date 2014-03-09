//
//  ClockView.m
//  XKCD World Clock
//
//  Created by Tjerk Anne Meesters on 8/3/14.
//  Copyright (c) 2014 Tjerk Anne Meesters. All rights reserved.
//

#import "ClockView.h"

#define INNER_DIAL_RADIUS 299

#define SECOND_DEGREE (M_PI * 2 / 86400)
#define HOUR_DEGREE (M_PI * 2 / 24)

@interface ClockView()
@property NSTimeZone* utc;
@property NSTimeZone* local;
@end

@implementation ClockView

- (void)baseInit
{
    self.clockImage = [UIImage imageNamed:@"clockdial.png"];
    self.utc = [NSTimeZone timeZoneForSecondsFromGMT:0];
    self.local = [NSTimeZone localTimeZone];

    self.isDragging = NO;

    [self setDialMode:MODE_UNIVERSAL];
    [self startTimer];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

-(void) startTimer {
    [NSTimer scheduledTimerWithTimeInterval:24
                                     target:self
                                   selector:@selector(onTimer:)
                                   userInfo:nil
                                    repeats:YES];
}

-(void)onTimer:(NSTimer *) timer
{
    [self setNeedsDisplay];
}

-(void)setTimeMode:(timemode_t)mode
{
    self.dialMode = mode;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSDate *now = [NSDate date];
    
    [self drawOuterDial:rect withContext:context andDate:now];
    [self drawInnerDial:rect withContext:context andDate:now];
}

- (CGPoint)getCenterPoint
{
    return CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

- (float)getOuterDialAngle:(NSDate*)date
{
    if (self.dialMode == MODE_UNIVERSAL) {
        return 0;
    } else {
        return M_PI - [self getAngleToDate:date FromDate:getMidnightFromDateAndZone(date, self.local)];
    }
}

- (float)getInnerDialAngle:(NSDate*)date
{
    if (self.dialMode == MODE_UNIVERSAL) {
        return [self getAngleToDate:date FromDate:getMidnightFromDateAndZone(date, self.utc)];
    } else {
        return M_PI - [self.local secondsFromGMT] * SECOND_DEGREE;
    }
}

- (void)drawOuterDial:(CGRect)rect withContext:(CGContextRef)context andDate:(NSDate*)date
{
    CGPoint centre = [self getCenterPoint];
    float angle =[self getOuterDialAngle:date];

    CGContextTranslateCTM(context, centre.x, centre.y);
    CGContextRotateCTM(context, angle);

    [self.clockImage drawInRect:(CGRect) { {
        -centre.x, -centre.y
    }, rect.size }];

    CGContextRotateCTM(context, -angle);
    CGContextTranslateCTM(context, -centre.x, -centre.y);
}

- (void)drawInnerDial:(CGRect)rect withContext:(CGContextRef)context andDate:(NSDate*)date
{
    CGPoint centre = [self getCenterPoint];
    float radius = INNER_DIAL_RADIUS * rect.size.width / self.clockImage.size.width;
    float angle = [self getInnerDialAngle:date];

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, centre.x, centre.y, radius, 0, 2*M_PI, 0);

    CGContextAddPath(context, path);
    CGContextClip(context);

    CGContextTranslateCTM(context, centre.x, centre.y);
    CGContextRotateCTM(context, angle);

    [self.clockImage drawInRect:(CGRect) { {
        -centre.x, -centre.y
    }, rect.size }];
}

- (float)getTouchAngle:(UITouch*)touch
{
    return AngleFromNorth([self getCenterPoint], [touch locationInView:self]);
}

- (float)getAngleToDate:(NSDate *)date FromDate:(NSDate*)start
{
    return [date timeIntervalSinceDate:start] * SECOND_DEGREE;
}

- (float)getTimezoneAngle
{
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    
    return [zone secondsFromGMT] * SECOND_DEGREE;
}

-(int)getTimeDelta
{
    if (self.isDragging) {
        return round((self.touchCurrentAngle - self.touchStartAngle) / HOUR_DEGREE);
    } else {
        return 0;
    }
}

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super beginTrackingWithTouch:touch withEvent:event];

    self.touchStartAngle = self.touchCurrentAngle = [self getTouchAngle:touch];
    self.isDragging = YES;
    
    return YES;
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super continueTrackingWithTouch:touch withEvent:event];

    float touchAngle = [self getTouchAngle:touch];
    
    // update ever 15 degrees
    if (fabsf(touchAngle - self.touchCurrentAngle) > 0.25) {
        self.touchCurrentAngle = touchAngle;
        [self setNeedsDisplay];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }

    return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super endTrackingWithTouch:touch withEvent:event];

    self.isDragging = NO;

    [self setNeedsDisplay];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

static inline float AngleFromNorth(CGPoint p1, CGPoint p2)
{
    CGPoint v = CGPointMake(p2.x-p1.x, p2.y-p1.y);
    
    float vmag = hypot(v.x, v.y);
    
    return atan2(v.y / vmag, v.x / vmag);
}

static NSDate* getMidnightFromDateAndZone(NSDate* date, NSTimeZone *zone)
{
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSCalendar *calendar = [NSCalendar currentCalendar];

    [calendar setTimeZone:zone];

    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    return [calendar dateFromComponents:components];
}

@end
