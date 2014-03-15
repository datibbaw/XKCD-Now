//
//  ClockView.h
//  XKCD Now
//
//  Created by Tjerk Anne Meesters on 15/3/14.
//  Copyright (c) 2014 Tjerk Anne Meesters. All rights reserved.
//

#import <UIKit/UIKit.h>

#define OUTER_DIAL_RADIUS 301
#define INNER_DIAL_RADIUS 295

typedef enum { TimeModeUniversal, TimeModeLocal } TimeMode;

@interface ClockView : UIControl

@property TimeMode mode;

- (void)startUpdates;

@end
