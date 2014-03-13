//
//  ClockDialView.m
//  XKCD Now
//
//  Created by Tjerk Anne Meesters on 13/3/14.
//  Copyright (c) 2014 Tjerk Anne Meesters. All rights reserved.
//

#import "ClockDialView.h"

@implementation ClockDialView

- (id)initWithFrame:(CGRect)frame AndImage:(CGImageRef)image
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = image;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setAngle:(float)angle
{
    [self setTransform:CGAffineTransformMakeRotation(angle)];
}

@end
