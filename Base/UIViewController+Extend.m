//
//  UIViewController+Extend.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "UIViewController+Extend.h"

@implementation UIViewController (Extend)

- (BOOL)automaticallyAdjustsScrollViewInsets
{
    return false;
}

- (void)selectRowAtIndexPath:(NSIndexPath*)indexPath forTableView:(UITableView*)tableView
{
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    id <UITableViewDelegate> delegate = (id <UITableViewDelegate>)self;
    [delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (IBAction)backButtonPressed
{
    [self.navigationController popViewController];
}

- (IBAction)settingsButtonPressed
{
    [PKRevealController showLeftViewController];
}

- (bool)navButtonPressed:(NavButtonType)type
{    
    return false;
}

@end
