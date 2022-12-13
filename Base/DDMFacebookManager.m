//
//  ParseManager.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2015-02-27.
//  Copyright (c) 2015 DDMAppDesign. All rights reserved.
//

#import "DDMFacebookManager.h"

///////////////////////////////////////////////////////////////////////////////
@implementation DDMFacebookManager

+ (DDMFacebookManager*)manager
{
    static DDMFacebookManager *manager = nil;
    @synchronized(self)
    {
        if(manager == nil)
        {
            manager = [DDMFacebookManager new];
            [manager setup];
        }
    }
    return manager;
}

- (void)setup
{
}

- (void)fetchFacebookPhotos
{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me/albums" parameters:@{@"fields":@"name,cover_photo,photos{id,created_time,picture,source}"} HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, NSDictionary *fbAlbums, NSError *error)
     {
         User *user = [User currentUser];
         for(NSDictionary *fbAlbum in fbAlbums[@"data"])
         {
             NSString *albumName = fbAlbum[@"name"];
             if([albumName isEqualToString:@"Profile Pictures"])
             {
                 NSString *albumCoverPhotoId = fbAlbum[@"cover_photo"][@"id"];
                 for(NSDictionary *fbPhotoData in fbAlbum[@"photos"][@"data"])
                 {
                     Photo *fbPhoto = [Photo getObjectWithId:fbPhotoData[@"id"]];
                     fbPhoto.created_at = [fbPhotoData[@"created_time"] toDateWithFormat:@"yyyy'-'MM'-'dd'T'HH:mm:ssZ"];
                     fbPhoto.thumbURL = fbPhotoData[@"picture"];
                     fbPhoto.mediaURL = fbPhotoData[@"source"];
                     fbPhoto.facebook_user = user.facebook_user;
                     if([fbPhoto.photo_id isEqualToString:albumCoverPhotoId])
                     {
                         if(![user.photo hasDataForKey:kMedia] && ![fbPhoto hasDataForKey:kMedia])
                         {
                             [fbPhoto fetchDataForKey:kMedia withBlock:^
                              {
                                  UIImage *image = [fbPhoto getBestImage];
                                  [user sycnProfileImage:image];
                              }];
                         }
                     }
                 }
             }
         }
         
         [[NSNotificationCenter defaultCenter] postNotificationName:kFacebookPhotosSynced object:nil];
     }];
}

@end
