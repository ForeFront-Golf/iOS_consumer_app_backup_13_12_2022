//
//  Globals.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2016-12-07.
//  Copyright © 2016 ddmappdesign. All rights reserved.
//

#import "Globals.h"

static Globals *globals = nil;
static CGFloat keyboardHeight;
static NSMutableDictionary* tickTockTimes = nil;

///////////////////////////////////////////////////////////////////////////////
@implementation Globals

+ (Globals*)globals
{
    //synchronized for thread safety when initializing
    @synchronized(self)
    {
        if(globals == nil)
        {
            globals = [Globals new];
            [globals setup];
        }
    }
    return globals;
}

+ (CGFloat)keyboardHeight
{
    return keyboardHeight;
}

+ (void)tickForKey:(NSString *)key
{
    tickTockTimes[key] = [NSDate date];
}

+ (void)tockForKey:(NSString *)key
{
    NSTimeInterval timeInterval = -[tickTockTimes[key] timeIntervalSinceNow];
    NSLog(@"Processing time = %f for %@", timeInterval, key);
    [tickTockTimes removeObjectForKey:key];
}

- (void)setup
{
    tickTockTimes = @{}.mutableCopy;

    [UILabel appearanceWhenContainedInInstancesOfClasses:@[[UIButton class]]].numberOfLines = 0;
    [UILabel appearanceWhenContainedInInstancesOfClasses:@[[UIButton class]]].adjustsFontSizeToFitWidth = true;
    [UILabel appearanceWhenContainedInInstancesOfClasses:@[[UIButton class]]].textAlignment = NSTextAlignmentCenter;
    
    [CoreData coreData];
    [MainView view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLocationUpdate:) name:kUserLocationUpdated object:nil];

    
    
    if([User isLoggedIn])
    {
        [MainView setActivityIndicatorVisibility:true];
        NSString *url = [NSString stringWithFormat:@"%@/validate", kServerURL];
        [ServerClient get:url withBlock:^(NSDictionary *results, NSError *error)
         {
             if(results)
             {
                 [Globals loggingInCompleted];
             }
             else
             {
                 [Globals logout];
             }
             [MainView setActivityIndicatorVisibility:false];
         }];
    }
    else
    {
        [[UINavigationController getController] setViewControllers:@[[LoginFacebookViewController new]]];
    }
}

- (void)keyboardChanged:(NSNotification*)notification
{
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    keyboardHeight = screenBounds.size.height - keyboardFrame.origin.y;
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
{
    if(!error)
    {
        if(!result.isCancelled)
        {
            [MainView setActivityIndicatorVisibility:YES];
            NSString *url = [NSString stringWithFormat:@"%@/fb_login", kServerURL];
            NSDictionary *parameters = @{@"app_token":[Facebook_User facebookToken]};
            [ServerClient post:url withParameters:parameters withBlock:^(NSDictionary *results, NSError *error)
             {
                 if(results)
                 {
                     User *user = [User serializeFrom:results];
                     [User setCurrentUser:user withSessionId:results[@"Session"][@"session_id"]];
                     if(user.signup_complete.boolValue)
                     {
                         [Globals loggingInCompleted];
                     }
                     else
                     {
                         [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":@"email,picture.type(large)"}] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id fbResult, NSError *error)
                          {
                              user.email = fbResult[@"email"];
                              //can't get birthday
//                              NSDate *dobDate = [fbResult[@"birthday"] toDateWithFormat:@"MM/dd/yyyy"];
//                              user.dob = [dobDate toStringWithFormat:kDOBFormat];
                              //getting picture
                              NSString *pictureURL = [NSString stringWithFormat:@"%@",[fbResult[@"picture"][@"data"] objectForKey:@"url"]];
                              NSData  *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:pictureURL]];
                              [user sycnProfileImage:[UIImage imageWithData:data]];
                              [[UINavigationController getController] pushViewController:[SignUpViewController new]];
                          }];
                     }
                 }
                 else
                 {
                     [UIAlertController showWithTitle:@"Login Error" message:[error localizedDescription] actions:nil];
                 }
                 [MainView setActivityIndicatorVisibility:false];
             }];
        }
    }
    else
    {
        [UIAlertController showWithTitle:@"Login Error" message:[error localizedDescription] actions:nil];
    }
}

- (BOOL)loginButtonWillLogin:(FBSDKLoginButton *)loginButton
{   
    return YES;
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    [Globals logout];
}

//need to fix how login works, this is temp till more server function come online
+ (void)loggingInCompleted
{
    User *user = [User currentUser];
    [user loggingInCompleted];
    [OneSignal syncHashedEmail:user.email];
    [OneSignal sendTag:@"email" value:user.email];
    [OneSignal sendTag:@"consumer" value:@"true"];
    [OneSignal sendTag:@"user_id" value:user.user_id.stringValue];

    //We want user reinput the create process info if we get uncomplete login
    //Should be change if we want to modifiy the phone number in future
    if(!user.phone_number)
    {
        [User logout];
        [[UINavigationController getController] pushViewController:[LoginFacebookViewController new]];
    }
    else if(!user.phone_valid.boolValue)
    {
        [[UINavigationController getController] setViewControllers:@[[VerifyViewController new]]];
    }
    else if(!user.membership_complete)
    {
        [[UINavigationController getController] setViewControllers:@[[MembershipViewController new]]];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoggingInCompleted object:nil];
        [self setupViewControllers];
    }
    
    [LocationsManager manager].locationManager.allowsBackgroundLocationUpdates = true;
    [LocationsManager setDelegate:[self globals]];
    [LocationsManager requestLocation];
}

+ (void)setupViewControllers
{
    User *user = [User currentUser];
    [user leaveClub];
    [[UINavigationController getController] setViewControllers:@[[CoursesViewController new]]];
}

+ (void)logout
{
    
    //delete all order after logout
    Order *order = [Order currentOrder];
//    [order clearOrder];
    for(Order_Item *orderItem in order.items)
    {
        [orderItem deleteObject];
    }
    
    
    [User logout];
    
    [LocationsManager stopUpdatingLocation];
}

+ (void)postNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo
{
    dispatch_block_t block = ^
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:aName object:anObject userInfo:aUserInfo];
    };
    
    if([NSThread isMainThread])
    {
        block();
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

+ (void)openSettings
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

- (void)userLocationUpdate:(NSNotification *)note
{
    User *currentUser = [User currentUser];
    //This function will server-post the user information, so we need to make sure the account exist
    if(currentUser && currentUser.phone_valid.boolValue)
    {
        NSDictionary *locationData = [note userInfo];
        [currentUser syncUserLocationData:locationData];
    }
}

- (CGFloat)secondsUntilNextLocationUpdate
{
    User *user = [User currentUser];
    if(!user.knownClubStatus)
    {
        return kUnknownClubStatusUpdateFrequency;
    }
    else if(!user.club)
    {
        return kNotAtAClubUpdateFrequency;
    }
    else if([user hasOrderAtCurrentClub])
    {
        return kActiveOrderUpdateFrequency;
    }
    else
    {
        return kNoOrderUpdateFrequency;
    }
}

@end

