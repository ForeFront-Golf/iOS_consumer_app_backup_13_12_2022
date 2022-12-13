//
//  VerifyViewController.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-03-23.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "VerifyViewController.h"

@interface VerifyViewController ()

@end

@implementation VerifyViewController

- (void)viewDidLoad{
    if (@available(iOS 11.0, *)) {
        [_scrollView setContentInsetAdjustmentBehavior: UIScrollViewContentInsetAdjustmentNever];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MainView setNavBarVisibility:YES];
//    [MainView setNavBarButton:NBT_Settings];
    [MainView setNavBarButton:NBT_EmptyLeft];
    [MainView setNavBarButton:NBT_EmptyRight];
}

- (IBAction)verifyButtonPressed
{
    NSString *pin = [_textField.text trimWhitespace];
    if(pin.length > 0)
    {
        User *user = [User currentUser];
        [MainView setActivityIndicatorVisibility:true];
        NSString *url = [NSString stringWithFormat:@"%@/user/%@/sms_validate", kServerURL, user.user_id];
        [ServerClient post:url withParameters:@{@"pin":pin} withBlock:^(NSDictionary *results, NSError *error)
         {
             if(results)
             {
                 NSString *sessionId = results[@"Session"][@"session_id"];
                 [User setCurrentUser:user withSessionId:sessionId];
                 user.phone_valid = @true;
                 [Globals loggingInCompleted];
             }
             else
             {
                 [UIAlertController showWithTitle:@"The PIN entered is not valid for this user"];
             }
             [MainView setActivityIndicatorVisibility:false];
         }];
    }
    else
    {
        [UIAlertController showWithTitle:@"Please enter a valid PIN"];
    }
}

- (IBAction)resendButtonPressed
{
    [[User currentUser] requestPin];
}

@end
