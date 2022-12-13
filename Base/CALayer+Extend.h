//
//  CALayer+Extend.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CALayer (Extend)

- (void)setBorderCGColor:(UIColor*)color;
- (void)setShadowCGColor:(UIColor*)color;
- (CAShapeLayer*)addCircleAtLocation:(CGPoint)location withRadius:(CGFloat)radius andColor:(UIColor*)color;

@end
