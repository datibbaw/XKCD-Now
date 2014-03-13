//
//  ClockDialView.h
//  XKCD Now
//
//  Created by Tjerk Anne Meesters on 13/3/14.
//  Copyright (c) 2014 Tjerk Anne Meesters. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClockDialView : UIView

@property CGImageRef image;

- (id)initWithFrame:(CGRect)frame AndImage:(CGImageRef)image;
- (void)setAngle:(float)angle;

@end
