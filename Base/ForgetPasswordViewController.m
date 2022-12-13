//
//  ForgetPasswordViewController.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-05-19.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "ForgetPasswordViewController.h"

@interface ForgetPasswordViewController ()

@end

@implementation ForgetPasswordViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MainView setNavBarVisibility:YES];
    [MainView setNavBarButton:NBT_Back];
    [MainView setNavBarButton:NBT_EmptyRight];
}

- (IBAction)sendButtonPressed
{
    NSString *email = [_emailTextfField.text trimWhitespace];
    if([email isValidEmailAddress])
    {
        [MainView setActivityIndicatorVisibility:true];
        NSString *url = [NSString stringWithFormat:@"%@/user/password", kServerURL];
        [ServerClient put:url withParameters:@{@"email":email} withBlock:^(NSDictionary *results, NSError *error)
         {
             if(!error)
             {
                 UIAlertAction *action = [UIAlertAction initWithTitle:@"OK" forTarget:self.navigationController andSelector:@selector(popViewController) withObject:nil];
                 [UIAlertController showWithTitle:@"Instructions for resetting your password have been emailed to you." message:nil actions:@[action]];
             }
             else
             {
                 [UIAlertController showWithTitle:@"Unable to reset password" message:@"You may only request to reset your password 3 times per 72 hours." actions:nil];
             }
             [MainView setActivityIndicatorVisibility:false];
         }];
    }
    else
    {
        [UIAlertController showWithTitle:@"Please enter a valid email address."];
    }
}

@end
