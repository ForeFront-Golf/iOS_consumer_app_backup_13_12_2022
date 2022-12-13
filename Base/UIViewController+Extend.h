//
//  UIViewController+Extend.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UIViewController (Extend)

- (void)selectRowAtIndexPath:(NSIndexPath*)indexPath forTableView:(UITableView*)tableView;

- (IBAction)backButtonPressed;
- (IBAction)settingsButtonPressed;
- (bool)navButtonPressed:(NavButtonType)type;

@end
