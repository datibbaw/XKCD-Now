//
//  ClockViewController.m
//  XKCD Now
//
//  Created by Tjerk Anne Meesters on 10/3/14.
//  Copyright (c) 2014 Tjerk Anne Meesters. All rights reserved.
//

#import "ClockViewController.h"
#import "ClockView.h"

@interface ClockViewController () {
    ClockView *clock;
}

@property UISegmentedControl *clockModeSwitch;

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

    UIView *view = [[UIView alloc] initWithFrame:frame];
    self.view = view;

    clock = [[ClockView alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(frame), CGRectGetWidth(frame))];

    [self.view addSubview:clock];
}

//- (UISegmentedControl*)createClockModeSwitch:(CGRect)frame
//{
//    UISegmentedControl *modeSwitch = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Local", @"Universal", nil]];
//
//    [modeSwitch addTarget:self action:@selector(onModeSwitchChange:) forControlEvents:UIControlEventValueChanged];
//
//    modeSwitch.frame = CGRectOffset(modeSwitch.frame, (frame.size.width - modeSwitch.frame.size.width) / 2, frame.size.width + 25);
//    modeSwitch.selectedSegmentIndex = 1;
//
//    return modeSwitch;
//}

//- (void)onModeSwitchChange:(UISegmentedControl*)sender
//{
//    switch (sender.selectedSegmentIndex) {
//        case 0:
//            [self setClockMode:LocalTime];
//            break;
//
//        case 1:
//        default:
//            [self setClockMode:UniversalTime];
//            break;
//    }
//}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [clock startUpdates];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)setClockMode:(ClockMode)mode
//{
//    switch (mode) {
//        case LocalTime:
//            [self.innerDial setAngle:M_PI - [self getTimeZoneAngle:self.local]];
//            break;
//
//        case UniversalTime:
//        default:
//            [self.outerDial setAngle:0.f];
//            break;
//    }
//
//    self.mode = mode;
//
//    [self updateDials];
//}

//- (void)updateDials
//{
//    NSDate *now = [NSDate date];
//
//    switch (self.mode) {
//        case LocalTime:
//            [self.outerDial setAngle:M_PI - [self getAngleToDate:now FromDate:getMidnightFromDateAndZone(now, self.local)]];
//            break;
//            
//        case UniversalTime:
//        default:
//            [self.innerDial setAngle:[self getAngleToDate:now FromDate:getMidnightFromDateAndZone(now, self.utc)]];
//    }
//}

@end
