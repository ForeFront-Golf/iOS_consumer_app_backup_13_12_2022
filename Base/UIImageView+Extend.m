//
//  UIImageView+Extend.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "UIImageView+Extend.h"

@implementation UIImageView (Extend)

- (void)setColor:(UIColor*)color
{
    self.image = [self.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.tintColor = color;
}

- (void)animateToColor:(UIColor *)color withDuration:(NSTimeInterval)duration andDelay:(NSTimeInterval)delay
{
    [UIView animateWithDuration:duration
                          delay:delay
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{[self setColor:color];}
                     completion:NULL];
}

@end
