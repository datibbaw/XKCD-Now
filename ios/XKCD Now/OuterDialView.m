//
//  OuterDialView.m
//  XKCD Now
//
//  Created by Tjerk Anne Meesters on 13/3/14.
//  Copyright (c) 2014 Tjerk Anne Meesters. All rights reserved.
//

#import "OuterDialView.h"

@implementation OuterDialView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // we use a path to cut out the inner dial
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    float radius = OUTER_DIAL_RADIUS * rect.size.width / CGImageGetWidth(self.image);
    CGMutablePathRef path = CGPathCreateMutable();
    
    // clip outer dial
    CGPathAddArc(path, NULL, center.x, center.y, radius, 0, 2*M_PI, 0);
    CGPathAddEllipseInRect(path, NULL, self.bounds);
    CGContextAddPath(context, path);
    CGContextEOClip(context);

    // flip vertical
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    CGContextDrawImage(context, rect, self.image);
}

@end
