//
//  CALayer+Extend.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "CALayer+Extend.h"

@implementation CALayer (Extend)

- (void)setBorderCGColor:(UIColor*)color
{
    self.borderColor = color.CGColor;
}

- (void)setShadowCGColor:(UIColor*)color;
{
    self.shadowColor = color.CGColor;
}

- (CAShapeLayer*)addCircleAtLocation:(CGPoint)location withRadius:(CGFloat)radius andColor:(UIColor*)color
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:location radius:radius startAngle:0.0 endAngle:M_PI * 2.0 clockwise:YES];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor = nil;
    shapeLayer.lineWidth = 2.0;
    [self addSublayer:shapeLayer];
    return shapeLayer;
}

@end
