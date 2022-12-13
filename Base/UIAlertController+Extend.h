//
//  UIAlertController+Extend.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Extend)

+ (UIAlertController*)showWithTitle:(NSString*)title;
+ (UIAlertController*)showWithTitle:(NSString*)title message:(NSString*)message actions:(NSArray*)actions;
+ (UIAlertController*)showWithTitle:(NSString*)title message:(NSString*)message actions:(NSArray*)actions preferredStyle:(UIAlertControllerStyle)preferredStyle;
+ (UIAlertController*)createWithTitle:(NSString*)title message:(NSString*)message actions:(NSArray*)actions preferredStyle:(UIAlertControllerStyle)preferredStyle;

@end
