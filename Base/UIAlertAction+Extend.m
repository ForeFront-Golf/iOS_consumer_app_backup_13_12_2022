//
//  UIAlertAction+Extend.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "UIAlertAction+Extend.h"

@implementation UIAlertAction (Extend)

+ (instancetype)initWithTitle:(NSString*)title
{
    return [self initWithTitle:title forTarget:nil andSelector:nil withObject:nil];
}

+ (instancetype)initWithTitle:(NSString*)title forTarget:(id)target andSelector:(SEL)selector
{
    return [self initWithTitle:title forTarget:target andSelector:selector withObject:nil];
}

+ (instancetype)initWithTitle:(NSString*)title forTarget:(id)target andSelector:(SEL)selector withObject:(id)object
{
    return [self initWithTitle:title forTarget:target andSelector:selector withObject1:object withObject2:nil];
}

+ (instancetype)initWithTitle:(NSString*)title forTarget:(id)target andSelector:(SEL)selector withObject1:(id)object1 withObject2:(id)object2
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    UIAlertActionStyle style = [title.lowercaseString isEqualToString:@"cancel"] ? UIAlertActionStyleCancel : UIAlertActionStyleDefault;
    return [UIAlertAction actionWithTitle:title style:style handler:^(UIAlertAction* action)
            {
                if(target)
                {
                    [target performSelector:selector withObject:object1 withObject:object2];
                }
            }];
    
#pragma clang diagnostic pop
}

@end
