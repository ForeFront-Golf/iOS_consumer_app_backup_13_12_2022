//
//  DDMNavigationController.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "DDMNavigationController.h"

@implementation DDMNavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    if(self = [super initWithRootViewController:rootViewController])
    {
        self.delegate = self;
        _transitions = [NSMutableArray new];
    }
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    return _transitions.lastObject;
}

- (void)setViewControllers:(NSArray*)viewControllers withTransition:(NSArray*)transitions
{
    _transitions = transitions.mutableCopy;
    [transitions setValue:@true forKey:@"isSetting"];
    [self setViewControllers:viewControllers animated:YES];
}

- (void)pushViewController:(UIViewController *)viewController withTransition:(Transition*)transition
{
    [_transitions addObject:transition];
    [self pushViewController:viewController animated:YES];
}

- (void)popViewController
{
    [self popViewControllerAnimated:YES];
    [_transitions removeLastObject];
}

@end
