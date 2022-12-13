//
//  UINavigationController+Extend.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "UINavigationController+Extend.h"

@implementation UINavigationController (Extend)

+ (UINavigationController*)getController
{    
    UINavigationController *navigationController = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).navigationController;
    return navigationController;
}

+ (id)backViewController
{
    NSArray *viewControllers = [self getController].viewControllers;
    if (viewControllers.count > 1)
    {
        return viewControllers[viewControllers.count - 2];
    }
    else
    {
        return nil;
    }
}

- (void)setViewControllers:(NSArray*)viewControllers
{
    if(viewControllers.count > 0)
    {
        NSMutableArray *transitions = @[].mutableCopy;
        for(int i = 0; i < viewControllers.count; i++)
        {
            [transitions addObject:[Transition new]];
        }
        [self setViewControllers:viewControllers withTransition:transitions];
    }
    else
    {
        if(viewControllers.count > 0)
        {
            return;
        }
    }
}

- (void)setViewControllers:(NSArray*)viewControllers withTransition:(NSArray*)transitions
{
    [self setViewControllers:viewControllers animated:YES];
}

- (void)pushViewController:(UIViewController *)viewController
{
    [self pushViewController:viewController withTransition:[Transition new]];
}

- (void)pushViewController:(UIViewController *)viewController withTransition:(Transition*)transition
{
    [self pushViewController:viewController animated:YES];
}

- (void)popViewController
{
    [self popViewControllerAnimated:YES];
}

@end
