//
//  Transition.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static const CGFloat kSnapshotTimeBuffer = 0.1f;

@interface Transition : NSObject <UIViewControllerAnimatedTransitioning>               //default slide transition. Can set direcion and duration.

@property BOOL isSetting;
@property BOOL isPushing;
@property BOOL isReversed;
@property NSTimeInterval duration;
@property CGFloat xOffset;
@property CGFloat yOffset;

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)VCFromView toView:(UIView *)VCtoView andCallComplete:(BOOL)callComplete;

@end
