//
//  UIImageView+Extend.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Extend)

- (void)setColor:(UIColor*)color;
- (void)animateToColor:(UIColor*)color withDuration:(NSTimeInterval)duration andDelay:(NSTimeInterval)delay;

@end
