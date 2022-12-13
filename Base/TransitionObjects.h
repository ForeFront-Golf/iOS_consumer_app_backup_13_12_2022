//
//  TransitionObjects.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "Transition.h"

@interface TransitionObjects : Transition

- (void)animateFadeTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView andCallComplete:(BOOL)callComplete;
- (NSDictionary*)getTransitionDataForContext:(id<UIViewControllerContextTransitioning>)transitionContext;

@end
