//
//  PKRevealController+Extend.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "PKRevealController+Extend.h"

@implementation PKRevealController (Extend)

+ (PKRevealController*)getController
{
    PKRevealController *controller = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).revealController;
    return controller;
}

+ (void)showLeftViewController
{
    PKRevealController *controller = [self getController];
    [controller showViewController:controller.leftViewController];
}

+ (void)showRightViewController
{
    PKRevealController *controller = [self getController];
    [controller showViewController:controller.rightViewController];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIViewController *controller = [UINavigationController getController].topViewController;
    if([controller isKindOfClass:[LoginViewController class]] ||
       [controller isKindOfClass:[LoginFacebookViewController class]] ||
       [controller isKindOfClass:[SignUpViewController class]] ||
       [controller isKindOfClass:[LoginViewController class]])
    {
        return NO;
    }
    return NO;
    return YES;
}

@end
