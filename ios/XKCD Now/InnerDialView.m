//
//  InnerDialView.m
//  XKCD Now
//
//  Created by Tjerk Anne Meesters on 13/3/14.
//  Copyright (c) 2014 Tjerk Anne Meesters. All rights reserved.
//

#import "InnerDialView.h"

@implementation InnerDialView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // we use a path to cut out the inner dial
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    float radius = INNER_DIAL_RADIUS * rect.size.width / CGImageGetWidth(self.image);
    CGMutablePathRef path = CGPathCreateMutable();

    // clip inner dial
    CGPathAddArc(path, NULL, center.x, center.y, radius, 0, 2*M_PI, 0);
    CGContextAddPath(context, path);
    CGContextClip(context);

    // flip vertical
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, rect, self.image);
}

@end
