//
//  TransitionObjects.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "TransitionObjects.h"

@implementation TransitionObjects

- (id)init
{
    if(self = [super init])
    {
        self.duration = 0.4;
    }
    return self;
}

- (void)animateFadeTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView andCallComplete:(BOOL)callComplete
{
    [super animateTransition:transitionContext fromVC:fromVC toVC:toVC fromView:fromView toView:toView andCallComplete:callComplete];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)VCFromView toView:(UIView *)VCToView andCallComplete:(BOOL)callComplete
{    
    NSDictionary *transitionData = [self getTransitionDataForContext:transitionContext];
    NSArray *fromViews = transitionData[@"fromViews"];
    NSArray *toViews = transitionData[@"toViews"];
    UIView *parentFromView = transitionData[@"parentFromView"];
    UIView *parentToView = transitionData[@"parentToView"];
    UIView *containerView = transitionData[@"containerView"];
    if(!parentFromView)
    {
        parentFromView = fromVC.view;
    }
    if(!parentToView)
    {
        parentToView = toVC.view;
    }
    if(!containerView)
    {
        containerView = [transitionContext containerView];
    }
    
    NSMutableArray *endingCornerRadius = [NSMutableArray new];
    NSMutableArray *snapshots = [NSMutableArray new];
    for(int i = 0; i < fromViews.count; i++)
    {
        UIView *fromView = fromViews[i];
        UIView *toView = toViews[i];
        fromView.hidden = false;
        UIImageView *snapshotFromView = [[UIImageView alloc] initWithImage:[fromView getScreenshotAfterUpdate:NO]];
        UIView *snapshotToView = [toView snapshotViewAfterScreenUpdates:YES];
        CGRect startingFrame = [fromView getFrameInView:parentFromView];
        if(parentFromView == fromVC.view)
        {
            startingFrame.origin.x += self.xOffset;
            startingFrame.origin.y += self.yOffset;
        }        
        snapshotFromView.frame = snapshotToView.frame = startingFrame;
        snapshotFromView.layer.masksToBounds = snapshotToView.layer.masksToBounds = YES;
        snapshotFromView.layer.cornerRadius = snapshotToView.layer.cornerRadius = fromView.layer.cornerRadius;
        [containerView addSubview:snapshotFromView];
        [containerView addSubview:snapshotToView];
        if(snapshotFromView && snapshotToView)
        {
            [snapshots addObject:snapshotFromView];
            [snapshots addObject:snapshotToView];
            [endingCornerRadius addObject:@(toView.layer.cornerRadius)];
            [endingCornerRadius addObject:@(toView.layer.cornerRadius)];
        }
        
        snapshotToView.alpha = 0;
    }
    
    [fromViews setValue:@true forKey:@"hidden"];
    [self performSelector:@selector(hideViews:) withObject:toViews afterDelay:0.0];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    for(int i = 0; i < snapshots.count; i++)
    {
        UIView *snapshot = snapshots[i];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
        animation.duration = duration;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.toValue = endingCornerRadius[i];
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = NO;
        [snapshot.layer addAnimation:animation forKey:@"setCornerRadius:"];
    }
    
    [UIView animateWithDuration:duration delay:0 options:0 animations:^
     {
         for(NSInteger index = 0; index < snapshots.count; index += 2)
         {
             UIView *snapshotFromView = snapshots[index];
             UIView *snapshotToView = snapshots[index + 1];
             UIView *toView = toViews[index / 2];
             toView.hidden = false;
             CGRect endingFrame = [toView getFrameInView:parentToView];
             snapshotFromView.frame = snapshotToView.frame = endingFrame;
             snapshotToView.alpha = 1;
         }
     } completion:^(BOOL finished)
     {
         [fromViews setValue:@false forKey:@"hidden"];
         [toViews setValue:@false forKey:@"hidden"];
         [snapshots makeObjectsPerformSelector:@selector(removeFromSuperview)];
         
         if(callComplete)
         {
             [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
         }
     }];
}

- (void)hideViews:(NSArray*)views
{
    [views setValue:@(true) forKey:@"hidden"];
}

- (NSDictionary*)getTransitionDataForContext:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *mainVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *otherVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if(self.isPushing)
    {
        mainVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        otherVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    }
    
    NSDictionary *mainViewData = [self getMainViewTransitionDataFromMainVC:mainVC andOtherVC:otherVC];
    NSDictionary *otherViewData = [self getOtherViewTransitionDataFromMainVC:mainVC andOtherVC:otherVC];
    
    if(!mainViewData.count)
    {
        return nil;
    }
    
    NSMutableDictionary *data = @{}.mutableCopy;
    if(self.isPushing)
    {
        data[@"fromViews"] = otherViewData[@"views"];
        data[@"toViews"] = mainViewData[@"views"];
        UIView *parentFromView = otherViewData[@"parentView"];
        UIView *parentToView = mainViewData[@"parentView"];
        UIView *containerView = mainViewData[@"containerView"];
        if(parentToView)
        {
            data[@"parentFromView"] = parentFromView;
        }
        if(parentToView)
        {
            data[@"parentToView"] = parentToView;
        }
        if(containerView)
        {
            data[@"containerView"] = containerView;
        }
    }
    else
    {
        data[@"fromViews"] = mainViewData[@"views"];
        data[@"toViews"] = otherViewData[@"views"];
        UIView *parentFromView = mainViewData[@"parentView"];
        UIView *parentToView = otherViewData[@"parentView"];
        UIView *containerView = mainViewData[@"containerView"];
        if(parentToView)
        {
            data[@"parentFromView"] = parentFromView;
        }
        if(parentToView)
        {
            data[@"parentToView"] = parentToView;
        }
        if(containerView)
        {
            data[@"containerView"] = containerView;
        }
    }
    return data;
}

- (NSDictionary*)getMainViewTransitionDataFromMainVC:(UIViewController*)mainVC andOtherVC:(UIViewController*)otherVC
{
    return nil;
}

- (NSDictionary*)getOtherViewTransitionDataFromMainVC:(UIViewController*)mainVC andOtherVC:(UIViewController*)otherVC
{
    return nil;
}

@end
