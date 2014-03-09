//
//  ClockView.h
//  XKCD World Clock
//
//  Created by Tjerk Anne Meesters on 8/3/14.
//  Copyright (c) 2014 Tjerk Anne Meesters. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum { MODE_UNIVERSAL, MODE_LOCAL } timemode_t;

@interface ClockView : UIControl

-(void)setTimeMode:(timemode_t)mode;
-(int)getTimeDelta;

@property UIImage *clockImage;
@property BOOL isDragging;
@property float timeAngle;
@property float touchStartAngle;
@property float touchCurrentAngle;
@property timemode_t dialMode;

@end
