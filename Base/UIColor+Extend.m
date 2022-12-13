//
//  UIColor+Extend.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "UIColor+Extend.h"

@implementation UIColor (Extend)

+ (UIColor*)pYellow
{
    return [UIColor colorWithRed:242 / 255.f green:235 / 255.f blue:135 / 255.f alpha:1];
}

- (UIImage*)image
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
