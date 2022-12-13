//
//  TransitionSlide.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "TransitionSlide.h"

@implementation TransitionSlide

+ (instancetype)transitionWithDirection:(TransitionDirection)direction
{
    TransitionSlide *slide = [TransitionSlide new];
    slide.direction = direction;
    return slide;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView andCallComplete:(BOOL)callComplete
{
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext] - kSnapshotTimeBuffer;
    
    CGRect initialFrame = [transitionContext initialFrameForViewController:fromVC];
    CGRect offScreen1Frame = [self rectOffsetFromRect:initialFrame forDirection:_direction];
    CGRect offScreen2Frame = [self rectOffsetFromRect:initialFrame forDirection:(_direction + 4) % TD_Max];
    
    [containerView addSubview:toView];
    if(self.isPushing)
    {
        toView.frame = offScreen1Frame;
        [UIView animateWithDuration:duration delay:kSnapshotTimeBuffer options:0 animations:^
         {
             toView.frame = initialFrame;
             fromView.frame = offScreen2Frame;
         }completion: ^(BOOL finished)
         {
             if(callComplete)
             {
                 [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
             }
         }];
    }
    else
    {
        [containerView sendSubviewToBack:toView];
        toView.frame = offScreen2Frame;
        
        [UIView animateWithDuration:duration delay:kSnapshotTimeBuffer options:0 animations:^
         {
             toView.frame = initialFrame;
             fromView.frame = offScreen1Frame;
         }completion: ^(BOOL finished)
         {
             [fromView removeFromSuperview];
             if(callComplete)
             {
                 [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
             }
         }];
    }
}

- (CGRect)rectOffsetFromRect:(CGRect)rect forDirection:(TransitionDirection)direction
{
    CGRect offsetRect = rect;
    switch (direction)
    {
        case TD_Right:
        {
            offsetRect.origin.x += CGRectGetWidth(rect);
            break;
        }
        case TD_BottomRight:
        {
            offsetRect.origin.y += CGRectGetHeight(rect);
            offsetRect.origin.x += CGRectGetWidth(rect);
            break;
        }
        case TD_Bottom:
        {
            offsetRect.origin.y += CGRectGetHeight(rect);
            break;
        }
        case TD_BottomLeft:
        {
            offsetRect.origin.y += CGRectGetHeight(rect);
            offsetRect.origin.x -= CGRectGetWidth(rect);
            break;
        }
        case TD_Left:
        {
            offsetRect.origin.x -= CGRectGetWidth(rect);
            break;
        }
        case TD_TopLeft:
        {
            offsetRect.origin.y -= CGRectGetHeight(rect);
            offsetRect.origin.x -= CGRectGetWidth(rect);
            break;
        }
        case TD_Top:
        {
            offsetRect.origin.y -= CGRectGetHeight(rect);
            break;
        }
        case TD_TopRight:
        {
            offsetRect.origin.y -= CGRectGetHeight(rect);
            offsetRect.origin.x += CGRectGetWidth(rect);
            break;
        }
        default:
            break;
    }
    
    return offsetRect;
}

@end
