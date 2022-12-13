//
//  User+CoreDataClass.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-01-17.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "User+CoreDataClass.h"

static User *currentUser = nil;

@implementation User

+ (void)setCurrentUser:(nullable User*)user withSessionId:(nullable NSString*)sessionId
{
    currentUser.current = false;
    currentUser.session_id = nil;
    
    currentUser = user;
    currentUser.current = true;
    currentUser.session_id = sessionId;
    
    [ServerClient setSessionId:user.session_id];
}

+ (User*)currentUser
{
    return currentUser;
}

+ (BOOL)isLoggedIn
{
    if([User currentUser])
    {
        return true;
    }
    
    User *user = [User fetchObjectForPredicate:[NSPredicate predicateWithFormat:@"current = true"]];
    if(user)
    {
        user.knownClubStatus = false;
        [self setCurrentUser:user withSessionId:user.session_id];
        return true;
    }
    
    [[FBSDKLoginManager new] logOut];
    return false;
}

+ (void)logout
{
    NSString *url = [NSString stringWithFormat:@"%@/user/%@/logout", kServerURL,[self currentUser].user_id];
    [ServerClient put:url withParameters:nil withBlock:^(NSDictionary *results, NSError *error)
     {
     }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoggingOut object:nil];
    
    [User setCurrentUser:nil withSessionId:nil];

    [FBSDKAccessToken setCurrentAccessToken:nil];
    [[FBSDKLoginManager new] logOut];
    
    [PKRevealController showRightViewController];
    
    [[UINavigationController getController] setViewControllers:@[[LoginFacebookViewController new]]];
    [MainView setActivityIndicatorVisibility:false];
}

- (void)loggingInCompleted
{
    self.club = nil;
    [self downloadMemberships];
    
//    [self.photo fetchDataForKey:kMedia withBlock:^
//     {
//         [[DDMFacebookManager manager] fetchFacebookPhotos];
//     }];
}

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    
    self.location = [Location createObject];
    self.location.latitude = @(kDefaultLatitude);
    self.location.longitude = @(kDefaultLongitude);
    self.location.created_at = @([[NSDate date] unixSeconds]);
}

- (void)setUser_id:(NSNumber *)user_id
{
    [self willChangeValueForKey:@"user_id"];
    [self setPrimitiveValue:user_id forKey:@"user_id"];
    [self didChangeValueForKey:@"user_id"];
    
    if(!self.photo && user_id)
    {
        self.photo = [Photo createObject];
        self.photo.photo_id = self.user_id.stringValue;
    }
}

- (void)setClub:(Club *)club
{
    if(!self.club && club)
    {
        [self syncOrdersWithBlock:^{}];
    }
    
    [self willChangeValueForKey:@"club"];
    [self setPrimitiveValue:club forKey:@"club"];
    [self didChangeValueForKey:@"club"];
}

- (NSString*)fullName
{
    NSString *fullname = [NSString stringWithFormat:@"%@ %@",self.first_name, self.last_name];
    return fullname;
}

- (void)sycnProfileImage:(UIImage*)image
{
    if(!image)
    {
        return;
    }
    
    UIImage *sizedImage = image;
    if(image.size.width > kImageSize.width)
    {
        sizedImage = [image resizeTo:kImageSize];
    }
    
    NSData *mediaData = UIImageJPEGRepresentation(sizedImage, kJPEGCompressionQuality);
    self.photo.created_at = [NSDate date];
    [self.photo saveData:mediaData forKey:kMedia];
    [self.photo uploadToS3ForKey:kMedia withBlock:^(BOOL succeeded)
    {
        if(succeeded)
        {
            self.profile_photo_url = [self.photo getAWSPathForKey:kMedia];
            NSString *url = [NSString stringWithFormat:@"%@/user/%@", kServerURL,self.user_id];
            [ServerClient put:url withParameters:@{@"profile_photo_url":self.profile_photo_url} withBlock:^(NSDictionary *results, NSError *error)
             {
                 if(results)
                 {
                     [self serializeFrom:results];
                 }
             }];
        }
    }];
}

- (void)syncUserLocationData:(NSDictionary*)locationData
{
    [self syncUserLocationData:locationData withBlock:^{}];
}

- (void)syncUserLocationData:(NSDictionary *)locationData withBlock:(void (^)(void))block
{
    if(!self.club){
        [MainView setActivityIndicatorVisibilityGreyBackground:true];
    }
    self.location.latitude = locationData[@"latitude"];
    self.location.longitude = locationData[@"longitude"];
    self.location.h_accuracy = locationData[@"horizontalAccuracy"];
    self.location.v_accuracy = locationData[@"verticalAccuracy"];
    self.location.created_at = @([[NSDate date] unixSeconds]);
    
    NSString *url = [NSString stringWithFormat:@"%@/user/%@/location", kServerURL,currentUser.user_id];
    NSDictionary *parameters = @{@"user_id":currentUser.user_id, @"lat":currentUser.location.latitude, @"lon":currentUser.location.longitude, @"h_accuracy":currentUser.location.h_accuracy, @"v_accuracy":currentUser.location.v_accuracy};
    [ServerClient post:url withParameters:parameters withBlock:^(NSDictionary *results, NSError *error)
     {
         if(results)
         {
             self.knownClubStatus = true;
             UINavigationController *navController = [UINavigationController getController];
             UIViewController *firstController = navController.viewControllers.firstObject;
             NSDictionary *clubData = results[@"Club"];
             BOOL didMoveToNewClub = self.club != [Club serializeFrom:clubData];
             self.club = [Club serializeFrom:clubData];
             if(self.phone_valid.boolValue && self.membership_complete)
             {
                 
                 if(self.club)
                 {
                     NSLog(@"test: %@",firstController);
                     if(!kIsSimulator && ![firstController isKindOfClass:[CourseViewController class]])
                     {
                         if(didMoveToNewClub)
                         {
                             
                             CourseViewController *controller = [CourseViewController new];
                             controller.club = self.club;
                             [navController performSelector:@selector(setViewControllers:) withObject:@[controller] afterDelay:0.5];
                         }
                         [LocationsManager requestLocation];
                     }
                 }
                 else
                 {
                     if(![firstController isKindOfClass:[CoursesViewController class]])
                     {
                         [navController performSelector:@selector(setViewControllers:) withObject:@[[CoursesViewController new]] afterDelay:0.5];
                     }
                 }
             }
         }
         block();
         [MainView setActivityIndicatorVisibilityGreyBackground:false];
     }];
}

- (void)syncOrdersWithBlock:(void (^)(void))block
{
    NSString *url = [NSString stringWithFormat:@"%@/user/%@/order", kServerURL, self.user_id];
    [ServerClient get:url withBlock:^(NSDictionary *results, NSError *error)
     {
         if(results)
         {
             for(NSDictionary *orderData in results[@"Order"])
             {
                 [Order serializeFrom:orderData];
             }
         }
         block();
     }];
}

- (void)requestPin
{
    NSString *url = [NSString stringWithFormat:@"%@/user/%@/sms_validate", kServerURL,currentUser.user_id];
    [ServerClient get:url withBlock:^(NSDictionary *results, NSError *error)
     {
     }];
}

- (bool)hasOrderAtCurrentClub
{
    if(!self.club)
    {
        return false;
    }
    
    NSSet *activeOrders = [self.orders filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"fulfilled = false && club = %@",self.club]];
    if(!activeOrders.count)
    {
        return false;
    }
    
    return true;
}

- (void)downloadMemberships
{
    NSString *url = [NSString stringWithFormat:@"%@/user/%@/membership", kServerURL, self.user_id];
    [ServerClient get:url withBlock:^(NSDictionary *results, NSError *error)
     {
         //Delete all and get new membership to avoid show deleted membership
         [[User currentUser] removeMemberships:[User currentUser].memberships];
         for(NSDictionary *membershipData in results[@"Membership"])
         {
             Membership *membership = [Membership serializeFrom:membershipData];
             if(membership)
             {
                 [[User currentUser] addMembershipsObject:membership];
             }
         }
     }];
}

- (void)leaveClub
{
    self.club = nil;
}

@end
