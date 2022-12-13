//
//  LoginFacebookViewController.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-01-18.
//  Copyright © 2016 RhinoActive. All rights reserved.
//

#import "LoginFacebookViewController.h"

@implementation LoginFacebookViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Getting birthday and photo need facebook review, so I just delete it for now.
    _facebookLoginButton.permissions = @[@"public_profile", @"email"];
    _facebookLoginButton.delegate = [Globals globals];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MainView setNavBarVisibility:false];
    [MainView setNavBarButton:NBT_EmptyLeft];
    [MainView setNavBarButton:NBT_EmptyRight];
    [MainView setTitleButtonVisibility:false];
}

- (IBAction)loginButtonPressed
{
    [_facebookLoginButton sendActionsForControlEvents: UIControlEventTouchUpInside];
}

- (IBAction)emailLoginButtonPressed
{
    [self.navigationController pushViewController:[LoginViewController new]];
}

- (IBAction)privacyButtonPressed
{
    DocumentViewController *controller = [DocumentViewController new];
    controller.fileName = @"https://s3.amazonaws.com/forefront-userfiles-mobilehub-1269340312/public/legal/ForeOrderPrivacy.pdf";
    [[UINavigationController getController] pushViewController:controller];
    [PKRevealController showRightViewController];
}

- (IBAction)termsButtonPressed
{
    DocumentViewController *controller = [DocumentViewController new];
    controller.fileName = @"https://s3.amazonaws.com/forefront-userfiles-mobilehub-1269340312/public/legal/ForeOrderTerms.pdf";
    [[UINavigationController getController] pushViewController:controller];
    [PKRevealController showRightViewController];
}

@end
