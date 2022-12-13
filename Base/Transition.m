//
//  Transition.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//
#import "Transition.h"

@implementation Transition

- (id)init
{
    if(self = [super init])
    {
        _duration = 0.3;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return _duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    UIView *fromView = fromVC.view;
    toView.frame = fromView.frame;
    UIViewController *backController = [UINavigationController backViewController];
    _isPushing = _isSetting || backController == fromVC;
    _isPushing = _isReversed ? !_isPushing : _isPushing;
    [self animateTransition:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView andCallComplete:true];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView andCallComplete:(BOOL)callComplete
{
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext] - kSnapshotTimeBuffer;
    [containerView insertSubview:toView belowSubview:fromView];
    if(self.isPushing)
    {
        [UIView animateWithDuration:duration delay:kSnapshotTimeBuffer options:0 animations:^
         {
             fromView.alpha = 0;
         }completion: ^(BOOL finished)
         {
             [containerView insertSubview:toView aboveSubview:fromView];
             fromView.alpha = 1;
             
             if(callComplete)
             {
                 [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
             }
         }];
    }
    else
    {
        [UIView animateWithDuration:duration delay:kSnapshotTimeBuffer options:0 animations:^
         {
             fromView.alpha = 0;
         }completion: ^(BOOL finished)
         {
             [fromView removeFromSuperview];
             fromView.alpha = 1;
             
             if(callComplete)
             {
                 [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
             }
         }];
    }
}

@end
