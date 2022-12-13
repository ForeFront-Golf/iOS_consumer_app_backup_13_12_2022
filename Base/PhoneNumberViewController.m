//
//  PhoneNumberViewController.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-04-27.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "PhoneNumberViewController.h"

@interface PhoneNumberViewController ()

@end

@implementation PhoneNumberViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MainView setNavBarVisibility:YES];
    [MainView setNavBarButton:NBT_Back];
    [MainView setNavBarButton:NBT_EmptyRight];
}

- (IBAction)saveButtonPressed
{
    NSString *phoneNumber = [_textField.text trimWhitespace];
    if(phoneNumber.length == 14)
    {
        User *user = [User currentUser];
        [MainView setActivityIndicatorVisibility:true];
        NSString *url = [NSString stringWithFormat:@"%@/user/%@", kServerURL,user.user_id];
        [ServerClient put:url withParameters:@{@"phone_number":phoneNumber} withBlock:^(NSDictionary *results, NSError *error)
         {
             if(results)
             {
                 [User serializeFrom:results];
                 [user requestPin];
                 [Globals loggingInCompleted];
             }
             else
             {
                 [UIAlertController showWithTitle:@"Please enter a valid phone number"];
             }
             [MainView setActivityIndicatorVisibility:false];
         }];
    }
    else
    {
        [UIAlertController showWithTitle:@"Please enter a valid phone number"];
    }
}

@end
