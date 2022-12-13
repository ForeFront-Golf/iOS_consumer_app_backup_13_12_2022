//
//  LoginFacebookViewController.h
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-01-18.
//  Copyright © 2016 RhinoActive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginFacebookViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *facebookLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end
