//
//  UINavigationController+Extend.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Transition;

@interface UINavigationController (Extend)

+ (UINavigationController*)getController;
+ (id)backViewController;

- (void)setViewControllers:(NSArray*)viewControllers;
- (void)setViewControllers:(NSArray*)viewControllers withTransition:(NSArray*)transitions;
- (void)pushViewController:(UIViewController *)viewController;
- (void)pushViewController:(UIViewController *)viewController withTransition:(Transition*)transition;
- (void)popViewController;

@end
