//
//  UIScrollView+Extend.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "UIScrollView+Extend.h"

@implementation UIScrollView (Extend)

- (void)scrollToView:(UIView*)view
{
    NSInteger statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    UINavigationController *navigationController = [[self viewController] navigationController];
    NSInteger navigationBarHeight = navigationController.navigationBar.frame.size.height;
    
    if([navigationController isNavigationBarHidden])
    {
        navigationBarHeight = 0;
        statusBarHeight = 0;
    }
    
    NSInteger keyboardHeight = 0;
//    if([Globals globals].keyboardVisibility)
    {
        keyboardHeight = kKeyboardHeight;
    }
    
    CGPoint convertedPos = [view getPositionInView:self];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenCenterY = (screenRect.size.height - keyboardHeight - view.frame.size.height) * 0.8 - kScrollToViewHeightOffset;
    CGFloat contentOffsetY = MAX(-statusBarHeight - navigationBarHeight, convertedPos.y - screenCenterY);
    CGFloat contentOffsetMaxY = self.contentSize.height - screenRect.size.height;
    contentOffsetY = MIN(contentOffsetY, contentOffsetMaxY);
    [UIView animateWithDuration:.25 animations:^{
        [self setContentOffset:CGPointMake(0, contentOffsetY) animated:NO];     //doing it this way because setting animated = YES is not very smooth all the time.
    }];
}

- (void)scrollToView:(UIView*)view withHeightOffset:(CGFloat)offset
{
    NSInteger statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    UINavigationController *navigationController = [[self viewController] navigationController];
    NSInteger navigationBarHeight = navigationController.navigationBar.frame.size.height;
    if([navigationController isNavigationBarHidden])
    {
        navigationBarHeight = 0;
    }
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGPoint localPos = [view getPositionInView:self];
    [self scrollRectToVisible:CGRectMake(0, localPos.y - (statusBarHeight + navigationBarHeight + offset), 320, screenRect.size.height) animated:YES];
}

- (void)scrollToViewsBottom:(UIView*)view withHeightOffset:(CGFloat)offset
{
    NSInteger statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    UINavigationController *navigationController = [[self viewController] navigationController];
    NSInteger navigationBarHeight = navigationController.navigationBar.frame.size.height;
    if([navigationController isNavigationBarHidden])
    {
        navigationBarHeight = 0;
    }
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    CGPoint localPos = [view getPositionInView:self];
    
    CGFloat yOffset = (localPos.y + view.bounds.size.height) - (screenHeight - offset);
    yOffset = MAX(yOffset, -(statusBarHeight + navigationBarHeight));
    [UIView animateWithDuration:.25 animations:^{
        [self setContentOffset:CGPointMake(0, yOffset) animated:NO];     //doing it this way because setting animated = YES is not very smooth all the time.
    }];
}

@end
