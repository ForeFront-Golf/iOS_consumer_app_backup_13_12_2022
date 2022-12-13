//
//  UIAlertAction+Extend.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertAction (Extend)

+ (instancetype)initWithTitle:(NSString*)title;
+ (instancetype)initWithTitle:(NSString*)title forTarget:(id)target andSelector:(SEL)selector;
+ (instancetype)initWithTitle:(NSString*)title forTarget:(id)target andSelector:(SEL)selector withObject:(id)object;
+ (instancetype)initWithTitle:(NSString*)title forTarget:(id)target andSelector:(SEL)selector withObject1:(id)object1 withObject2:(id)object2;

@end
