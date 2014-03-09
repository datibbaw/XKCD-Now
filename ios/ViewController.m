//
//  ViewController.m
//  XKCD World Clock
//
//  Created by Tjerk Anne Meesters on 7/3/14.
//  Copyright (c) 2014 Tjerk Anne Meesters. All rights reserved.
//

#import "ViewController.h"
#import "ClockView.h"

#define radians(degrees) (degrees * M_PI/180)

@interface ViewController ()
@property (weak, nonatomic) IBOutlet ClockView *clockView;
@property (weak, nonatomic) IBOutlet UILabel *deltaView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSwitch;
@end

@implementation ViewController
@synthesize deltaView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)onDeltaValueChange:(id)sender
{
    if (sender == [self clockView]) {
        int delta = [[self clockView] getTimeDelta];

        if (delta) {
            deltaView.text = [NSString stringWithFormat:@"%+03d:00", [[self clockView] getTimeDelta]];
        } else {
            deltaView.text = @"";
        }
    }
}

- (IBAction)onLocalTimeSwitchChange:(id)sender
{
    if (sender == [self modeSwitch]) {
        timemode_t mode;
        
        if ([[self modeSwitch] selectedSegmentIndex] == 0) {
            mode = MODE_LOCAL;
        } else {
            mode = MODE_UNIVERSAL;
        }

        [[self clockView] setTimeMode:mode];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
