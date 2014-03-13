//
//  ClockViewController.m
//  XKCD Now
//
//  Created by Tjerk Anne Meesters on 10/3/14.
//  Copyright (c) 2014 Tjerk Anne Meesters. All rights reserved.
//

#import "ClockViewController.h"
#import "InnerDialView.h"
#import "OuterDialView.h"

#define SECOND_DEGREE (M_PI * 2 / 86400)

@interface ClockViewController ()

@property InnerDialView *innerDial;
@property OuterDialView *outerDial;
@property UISegmentedControl *clockModeSwitch;

@property NSTimeZone* utc;
@property NSTimeZone* local;

@property ClockMode mode;

@end

@implementation ClockViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] applicationFrame];

    [self createRootView:frame];
    [self createDialViews:frame];

    self.clockModeSwitch = [self createClockModeSwitch:frame];

    [self.view addSubview:self.outerDial];
    [self.view addSubview:self.innerDial];
    [self.view addSubview:self.clockModeSwitch];
}

- (UISegmentedControl*)createClockModeSwitch:(CGRect)frame
{
    UISegmentedControl *modeSwitch = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Local", @"Universal", nil]];

    [modeSwitch addTarget:self action:@selector(onModeSwitchChange:) forControlEvents:UIControlEventValueChanged];

    modeSwitch.frame = CGRectOffset(modeSwitch.frame, (frame.size.width - modeSwitch.frame.size.width) / 2, frame.size.width + 25);
    modeSwitch.selectedSegmentIndex = 1;

    return modeSwitch;
}

- (void)onModeSwitchChange:(UISegmentedControl*)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self setClockMode:LocalTime];
            break;

        case 1:
        default:
            [self setClockMode:UniversalTime];
            break;
    }
}

// the root controller will be white
- (void)createRootView:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];

    self.view = view;
}

- (void)createDialViews:(CGRect)frame
{
    float dialHeight = frame.size.width;

    CGRect bounds = CGRectMake(frame.origin.x, frame.origin.y, dialHeight, dialHeight);
    CGImageRef image = [[UIImage imageNamed:@"clockdial.png"] CGImage];

    self.innerDial = [[InnerDialView alloc] initWithFrame:bounds AndImage:image];
    self.outerDial = [[OuterDialView alloc] initWithFrame:bounds AndImage:image];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.utc = [NSTimeZone timeZoneForSecondsFromGMT:0];
    self.local = [NSTimeZone localTimeZone];

    [self setClockMode:UniversalTime];
    [self startTimer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) startTimer
{
    [NSTimer scheduledTimerWithTimeInterval:5
                                     target:self
                                   selector:@selector(onTimer:)
                                   userInfo:nil
                                    repeats:YES];
}

-(void)onTimer:(NSTimer *) timer
{
    [self updateDials];
}

- (void)setClockMode:(ClockMode)mode
{
    switch (mode) {
        case LocalTime:
            [self.innerDial setAngle:M_PI - [self getTimeZoneAngle:self.local]];
            break;

        case UniversalTime:
        default:
            [self.outerDial setAngle:0.f];
            break;
    }

    self.mode = mode;

    [self updateDials];
}

- (void)updateDials
{
    NSDate *now = [NSDate date];

    switch (self.mode) {
        case LocalTime:
            [self.outerDial setAngle:M_PI - [self getAngleToDate:now FromDate:getMidnightFromDateAndZone(now, self.local)]];
            break;
            
        case UniversalTime:
        default:
            [self.innerDial setAngle:[self getAngleToDate:now FromDate:getMidnightFromDateAndZone(now, self.utc)]];
    }
}

- (float)getAngleToDate:(NSDate *)date FromDate:(NSDate*)start
{
    return [date timeIntervalSinceDate:start] * SECOND_DEGREE;
}

- (float)getTimeZoneAngle:(NSTimeZone*)timeZone
{
    return [timeZone secondsFromGMT] * SECOND_DEGREE;
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
