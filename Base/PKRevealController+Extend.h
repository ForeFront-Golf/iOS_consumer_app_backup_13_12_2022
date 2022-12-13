//
//  PKRevealController+Extend.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import <PKRevealController/PKRevealController.h>

@interface PKRevealController (Extend)

+ (PKRevealController*)getController;
+ (void)showLeftViewController;
+ (void)showRightViewController;

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;

@end
