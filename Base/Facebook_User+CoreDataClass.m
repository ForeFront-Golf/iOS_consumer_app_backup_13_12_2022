//
//  Facebook_User+CoreDataClass.m
//  GolfConsumer
//
//  Created by Eddy Douridas on 2017-01-18.
//  Copyright © 2017 ddmappdesign. All rights reserved.
//

#import "Facebook_User+CoreDataClass.h"

@implementation Facebook_User

+ (NSString*)facebookToken
{
    NSString *token = [FBSDKAccessToken currentAccessToken].tokenString;
    return token;
}

+ (NSString*)getURLForObjectId:(NSNumber*)objectId
{
    NSString *objectIdString = objectId ? [NSString stringWithFormat:@"/%@",objectId] : @"";
    NSString *url = [NSString stringWithFormat:@"%@/fbuser%@", kServerURL, objectIdString];
    return url;
}

- (void)prepareForDeletion
{
    [super prepareForDeletion];
    
    for(Photo *photo in self.photos)
    {
        [[NSFileManager defaultManager] removeItemAtPath:[photo getPathForKey:kThumbnail] error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:[photo getPathForKey:kMedia] error:nil];
    }
}

@end
