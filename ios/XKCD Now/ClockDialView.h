//
//  ClockDialView.h
//  XKCD Now
//
//  Created by Tjerk Anne Meesters on 15/3/14.
//  Copyright (c) 2014 Tjerk Anne Meesters. All rights reserved.
//

#import <UIKit/UIKit.h>

#define OUTER_DIAL_RADIUS 301
#define INNER_DIAL_RADIUS 295

typedef enum { InnerClockDial, OuterClockDial } ClockDialType;

@interface ClockDialView : UIView

- (id)initWithFrame:(CGRect)frame AndType:(ClockDialType)type;

- (void)rotate:(CGFloat)angle;

@end
