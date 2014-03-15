//
//  ClockView.m
//  XKCD Now
//
//  Created by Tjerk Anne Meesters on 15/3/14.
//  Copyright (c) 2014 Tjerk Anne Meesters. All rights reserved.
//

#import "ClockView.h"
#import "ClockDialView.h"
#import "KTOneFingerRotationGestureRecognizer.h"

#define DEGREES_PER_SECOND (M_PI / 43200)

@interface ClockView() {
    NSTimer *timer;

    NSDateFormatter *dateFormatter;
    UILabel *offset;

    ClockDialView *innerDial;
    ClockDialView *outerDial;
    
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
//    CGImageRef image = [self getDialImage];

//    innerDial = [self createInnerDial:image];
//    outerDial = [self createOuterDial:image];
//
//    [self.layer addSublayer:outerDial];
//    [self.layer addSublayer:innerDial];

    outerDial = [[ClockDialView alloc] initWithFrame:self.frame AndType:OuterClockDial];
    innerDial = [[ClockDialView alloc] initWithFrame:self.frame AndType:InnerClockDial];
    
    [self addSubview:outerDial];
    [self addSubview:innerDial];

//    [self addGestureRecognizer:[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)]];
    [self addGestureRecognizer:[[KTOneFingerRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)]];

//    [self setMode:TimeModeUniversal];

    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH:mm";

    offset = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 40, 15)];
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

    [innerDial rotate:getSecondsSinceMidnight(now, utc) * DEGREES_PER_SECOND];
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
            [outerDial rotate:0];
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
    [outerDial rotate:rotation];
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
